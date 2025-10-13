package com.bookstore.bookstore.service.book;

import com.bookstore.bookstore.dto.book.BookListResponse;
import com.bookstore.bookstore.dto.book.BookDetailResponse;
import com.bookstore.bookstore.dto.book.CategoryResponse;
import com.bookstore.bookstore.entity.book.Book;
import com.bookstore.bookstore.entity.book.Category;
import com.bookstore.bookstore.repository.book.BookRepository;
import com.bookstore.bookstore.repository.book.CategoryRepository;
import com.bookstore.bookstore.service.review.ReviewService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class BookService {
    
    private final BookRepository bookRepository;
    private final CategoryRepository categoryRepository;
    private final ReviewService reviewService;
    
    /**
     * Level 2 카테고리 목록 조회 (대분류)
     * 등록된 도서가 있는 카테고리만 조회 (건강/취미, 경제/경영, 소설/시/희곡)
     */
    public List<CategoryResponse> getLevel2Categories() {
        List<Category> categories = categoryRepository.findLevel2CategoriesWithBooks();
        log.info("Level 2 카테고리 조회 완료: {} 개", categories.size());
        return categories.stream()
                .map(CategoryResponse::fromWithoutChildren)
                .toList();
    }
    
    /**
     * 특정 부모 카테고리의 하위 카테고리 조회 (Level 3)
     */
    public List<CategoryResponse> getLevel3Categories(Long parentId) {
        List<Category> categories = categoryRepository.findLevel3CategoriesByParent(parentId);
        log.info("Level 3 카테고리 조회 완료: parentId={}, {} 개", parentId, categories.size());
        return categories.stream()
                .map(CategoryResponse::fromWithoutChildren)
                .toList();
    }
    
    /**
     * 특정 카테고리의 책 목록 조회
     */
    public List<BookListResponse> getBooksByCategory(Long categoryId) {
        List<Book> books = bookRepository.findByCategoryCategoryId(categoryId);
        log.info("카테고리별 책 조회 완료: categoryId={}, {} 권", categoryId, books.size());
        return BookListResponse.fromList(books);
    }
    
    /**
     * 특정 카테고리의 책 목록 조회 (페이징)
     */
    public List<BookListResponse> getBooksByCategory(Long categoryId, int page, int size) {
        List<Book> books = bookRepository.findByCategoryCategoryId(categoryId);
        
        // 페이징 처리
        int startIndex = page * size;
        int endIndex = Math.min(startIndex + size, books.size());
        
        if (startIndex >= books.size()) {
            return List.of();
        }
        
        List<Book> pagedBooks = books.subList(startIndex, endIndex);
        log.info("카테고리별 책 조회 완료 (페이징): categoryId={}, page={}, size={}, {} 권", 
                categoryId, page, size, pagedBooks.size());
        return BookListResponse.fromList(pagedBooks);
    }
    
    /**
     * 특정 카테고리의 책 목록 조회 (페이징, 평균평점 포함)
     */
    public List<BookListResponse> getBooksByCategoryWithRatings(Long categoryId, int page, int size) {
        List<Book> books = bookRepository.findByCategoryCategoryId(categoryId);
        
        // 페이징 처리
        int startIndex = page * size;
        int endIndex = Math.min(startIndex + size, books.size());
        
        if (startIndex >= books.size()) {
            return List.of();
        }
        
        List<Book> pagedBooks = books.subList(startIndex, endIndex);
        
        // 각 도서의 평균평점 조회
        Map<Long, Double> averageRatings = new HashMap<>();
        try {
            averageRatings = pagedBooks.stream()
                    .filter(book -> book != null && book.getBookId() != null)
                    .collect(Collectors.toMap(
                        Book::getBookId,
                        book -> {
                            try {
                                Double rating = reviewService.getAverageRating(book.getBookId());
                                return rating != null ? rating : 0.0;
                            } catch (Exception e) {
                                log.warn("평균평점 조회 실패: bookId={}, error={}", book.getBookId(), e.getMessage());
                                return 0.0;
                            }
                        },
                        (existing, replacement) -> {
                            log.warn("중복 키 발견! 기존값: {}, 새값: {}", existing, replacement);
                            return existing; // 기존 값 유지
                        }
                    ));
        } catch (Exception e) {
            log.error("평균평점 맵 생성 실패: {}", e.getMessage(), e);
            // 빈 맵으로 계속 진행
        }
        
        log.info("카테고리별 책 조회 완료 (페이징, 평균평점 포함): categoryId={}, page={}, size={}, {} 권", 
                categoryId, page, size, pagedBooks.size());
        return BookListResponse.fromListWithRatings(pagedBooks, averageRatings);
    }
    
    /**
     * 카테고리 정보 조회
     */
    public CategoryResponse getCategory(Long categoryId) {
        Category category = categoryRepository.findById(categoryId)
                .orElseThrow(() -> new IllegalArgumentException("카테고리를 찾을 수 없습니다: " + categoryId));
        return CategoryResponse.fromWithoutChildren(category);
    }
    
    /**
     * 전체 책 목록 조회 (저자 정보 포함)
     */
    public List<BookListResponse> getAllBooks() {
        List<Book> books = bookRepository.findAllWithAuthors();
        log.info("전체 책 조회 완료: {} 권", books.size());
        return BookListResponse.fromList(books);
    }
    
    /**
     * 전체 책 목록 조회 (페이징)
     */
    public List<BookListResponse> getAllBooks(int page, int size) {
        List<Book> books = bookRepository.findAllWithAuthors();
        
        // 페이징 처리
        int startIndex = page * size;
        int endIndex = Math.min(startIndex + size, books.size());
        
        if (startIndex >= books.size()) {
            return List.of();
        }
        
        List<Book> pagedBooks = books.subList(startIndex, endIndex);
        log.info("전체 책 조회 완료 (페이징): page={}, size={}, {} 권", page, size, pagedBooks.size());
        return BookListResponse.fromList(pagedBooks);
    }
    
    /**
     * 전체 책 목록 조회 (페이징, 평균평점 포함)
     */
    public List<BookListResponse> getAllBooksWithRatings(int page, int size) {
        List<Book> books = bookRepository.findAllWithAuthors();
        
        // 페이징 처리
        int startIndex = page * size;
        int endIndex = Math.min(startIndex + size, books.size());
        
        if (startIndex >= books.size()) {
            return List.of();
        }
        
        List<Book> pagedBooks = books.subList(startIndex, endIndex);
        
        // 각 도서의 평균평점 조회
        Map<Long, Double> averageRatings = new HashMap<>();
        try {
            averageRatings = pagedBooks.stream()
                    .filter(book -> book != null && book.getBookId() != null)
                    .collect(Collectors.toMap(
                        Book::getBookId,
                        book -> {
                            try {
                                Double rating = reviewService.getAverageRating(book.getBookId());
                                return rating != null ? rating : 0.0;
                            } catch (Exception e) {
                                log.warn("평균평점 조회 실패: bookId={}, error={}", book.getBookId(), e.getMessage());
                                return 0.0;
                            }
                        },
                        (existing, replacement) -> {
                            log.warn("중복 키 발견! 기존값: {}, 새값: {}", existing, replacement);
                            return existing; // 기존 값 유지
                        }
                    ));
        } catch (Exception e) {
            log.error("평균평점 맵 생성 실패: {}", e.getMessage(), e);
            // 빈 맵으로 계속 진행
        }
        
        log.info("전체 책 조회 완료 (페이징, 평균평점 포함): page={}, size={}, {} 권", page, size, pagedBooks.size());
        return BookListResponse.fromListWithRatings(pagedBooks, averageRatings);
    }
    
    /**
     * 키워드로 책 검색 (제목, 출판사, 저자명)
     */
    public List<BookListResponse> searchBooks(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return List.of();
        }
        
        List<Book> books = bookRepository.searchBooks(keyword.trim());
        log.info("책 검색 완료: keyword={}, {} 권", keyword, books.size());
        return BookListResponse.fromList(books);
    }
    
    /**
     * 키워드로 책 검색 (페이징)
     */
    public List<BookListResponse> searchBooks(String keyword, int page, int size) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return List.of();
        }
        
        List<Book> books = bookRepository.searchBooks(keyword.trim());
        
        // 페이징 처리
        int startIndex = page * size;
        int endIndex = Math.min(startIndex + size, books.size());
        
        if (startIndex >= books.size()) {
            return List.of();
        }
        
        List<Book> pagedBooks = books.subList(startIndex, endIndex);
        log.info("책 검색 완료 (페이징): keyword={}, page={}, size={}, {} 권", 
                keyword, page, size, pagedBooks.size());
        return BookListResponse.fromList(pagedBooks);
    }
    
    /**
     * 키워드로 책 검색 (페이징, 평균평점 포함)
     */
    public List<BookListResponse> searchBooksWithRatings(String keyword, int page, int size) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return List.of();
        }
        
        List<Book> books = bookRepository.searchBooks(keyword.trim());
        
        // 페이징 처리
        int startIndex = page * size;
        int endIndex = Math.min(startIndex + size, books.size());
        
        if (startIndex >= books.size()) {
            return List.of();
        }
        
        List<Book> pagedBooks = books.subList(startIndex, endIndex);
        
        // 각 도서의 평균평점 조회
        Map<Long, Double> averageRatings = new HashMap<>();
        try {
            averageRatings = pagedBooks.stream()
                    .filter(book -> book != null && book.getBookId() != null)
                    .collect(Collectors.toMap(
                        Book::getBookId,
                        book -> {
                            try {
                                Double rating = reviewService.getAverageRating(book.getBookId());
                                return rating != null ? rating : 0.0;
                            } catch (Exception e) {
                                log.warn("평균평점 조회 실패: bookId={}, error={}", book.getBookId(), e.getMessage());
                                return 0.0;
                            }
                        },
                        (existing, replacement) -> {
                            log.warn("중복 키 발견! 기존값: {}, 새값: {}", existing, replacement);
                            return existing; // 기존 값 유지
                        }
                    ));
        } catch (Exception e) {
            log.error("평균평점 맵 생성 실패: {}", e.getMessage(), e);
            // 빈 맵으로 계속 진행
        }
        
        log.info("책 검색 완료 (페이징, 평균평점 포함): keyword={}, page={}, size={}, {} 권", 
                keyword, page, size, pagedBooks.size());
        return BookListResponse.fromListWithRatings(pagedBooks, averageRatings);
    }
    
    /**
     * 전체 책 수 조회
     */
    public long getTotalBookCount() {
        return bookRepository.count();
    }
    
    /**
     * 책 ID로 책 정보 조회 (바로 구매용)
     */
    public BookListResponse getBookById(Long bookId) {
        Book book = bookRepository.findById(bookId)
                .orElseThrow(() -> new IllegalArgumentException("도서를 찾을 수 없습니다: " + bookId));
        
        // 평균 평점 조회
        Double averageRating = reviewService.getAverageRating(bookId);
        
        log.info("책 정보 조회 완료: bookId={}, title={}", bookId, book.getTitle());
        
        return BookListResponse.from(book, averageRating);
    }
    
    /**
     * 카테고리별 책 수 조회
     */
    public long getBookCountByCategory(Long categoryId) {
        return bookRepository.countByCategoryCategoryId(categoryId);
    }
    
    /**
     * 검색 결과 책 수 조회
     */
    public long getSearchResultCount(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return 0;
        }
        return bookRepository.searchBooks(keyword.trim()).size();
    }
    
    /**
     * 월간 베스트셀러 조회 (상위 10개)
     */
    public List<BookListResponse> getMonthlyBestsellers(int limit) {
        List<Book> books = bookRepository.findMonthlyBestsellers();
        
        // 상위 limit개만 반환
        if (books.size() > limit) {
            books = books.subList(0, limit);
        }
        
        log.info("월간 베스트셀러 조회 완료: {} 권", books.size());
        return BookListResponse.fromList(books);
    }
    
    /**
     * 월간 베스트셀러 조회 (평균평점 포함)
     */
    public List<BookListResponse> getMonthlyBestsellersWithRatings(int limit) {
        List<Book> books = bookRepository.findMonthlyBestsellers();
        log.info("조회된 베스트셀러 도서 수: {}", books.size());
        
        // null 체크 및 로깅
        for (int i = 0; i < books.size(); i++) {
            Book book = books.get(i);
            if (book == null) {
                log.warn("베스트셀러 리스트에서 null Book 발견: index={}", i);
            } else if (book.getBookId() == null) {
                log.warn("Book의 bookId가 null: index={}, book={}", i, book);
            }
        }
        
        // 상위 limit개만 반환
        if (books.size() > limit) {
            books = books.subList(0, limit);
        }
        
        // 각 도서의 평균평점 조회
        Map<Long, Double> averageRatings = new HashMap<>();
        try {
            // 중복 키 확인을 위한 로깅
            List<Long> bookIds = books.stream()
                    .filter(book -> book != null && book.getBookId() != null)
                    .map(Book::getBookId)
                    .collect(Collectors.toList());
            
            log.info("처리할 bookId 목록: {}", bookIds);
            
            // 중복 확인
            Set<Long> uniqueBookIds = new HashSet<>(bookIds);
            if (bookIds.size() != uniqueBookIds.size()) {
                log.warn("중복된 bookId 발견! 전체: {}, 고유: {}", bookIds.size(), uniqueBookIds.size());
            }
            
            averageRatings = books.stream()
                    .filter(book -> book != null && book.getBookId() != null)
                    .collect(Collectors.toMap(
                        Book::getBookId,
                        book -> {
                            try {
                                log.debug("평균평점 조회 시작: bookId={}", book.getBookId());
                                Double rating = reviewService.getAverageRating(book.getBookId());
                                log.debug("평균평점 조회 결과: bookId={}, rating={}", book.getBookId(), rating);
                                return rating != null ? rating : 0.0;
                            } catch (Exception e) {
                                log.warn("평균평점 조회 실패: bookId={}, error={}", book.getBookId(), e.getMessage());
                                return 0.0;
                            }
                        },
                        (existing, replacement) -> {
                            log.warn("중복 키 발견! 기존값: {}, 새값: {}", existing, replacement);
                            return existing; // 기존 값 유지
                        }
                    ));
            
            log.info("평균평점 맵 생성 완료: {}", averageRatings);
        } catch (Exception e) {
            log.error("평균평점 맵 생성 실패: {}", e.getMessage(), e);
            // 빈 맵으로 계속 진행
        }
        
        log.info("월간 베스트셀러 조회 완료 (평균평점 포함): {} 권", books.size());
        return BookListResponse.fromListWithRatings(books, averageRatings);
    }
    
    /**
     * 도서 상세 정보 조회
     */
    public BookDetailResponse getBookDetail(Long bookId) {
        Book book = bookRepository.findByIdWithDetails(bookId);
        if (book == null) {
            throw new IllegalArgumentException("도서를 찾을 수 없습니다: " + bookId);
        }
        log.info("도서 상세 조회 완료: bookId={}, title={}", bookId, book.getTitle());
        return BookDetailResponse.from(book);
    }
    
    /**
     * 전체 도서 카테고리 정보 조회
     */
    public CategoryResponse getAllBooksCategory() {
        return CategoryResponse.builder()
                .categoryId(0L)
                .categoryName("전체 도서")
                .level(1)
                .build();
    }
    
    /**
     * 검색 결과 카테고리 정보 조회
     */
    public CategoryResponse getSearchResultCategory() {
        return CategoryResponse.builder()
                .categoryId(0L)
                .categoryName("검색 결과")
                .level(1)
                .build();
    }
}

