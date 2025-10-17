package com.bookstore.bookstore.controller.performance;

import com.bookstore.bookstore.entity.book.Book;
import com.bookstore.bookstore.repository.book.BookRepository;
import com.bookstore.bookstore.dto.performance.BookPerformanceDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;

/**
 * 성능 테스트용 컨트롤러
 * JMeter를 통한 N+1 문제 해결 효과 측정
 */
@RestController
@RequestMapping("/api/performance")
@RequiredArgsConstructor
@Slf4j
public class PerformanceTestController {
    
    private final BookRepository bookRepository;
    
    /**
     * N+1 문제가 발생하는 방식으로 도서 목록 조회
     * - 기본 JPA 메서드 사용 (연관 엔티티 지연 로딩)
     */
    @GetMapping("/books/n-plus-1")
    public List<BookPerformanceDto> getBooksWithNPlus1Problem() {
        log.info("=== N+1 문제 발생 방식 테스트 시작 ===");
        long startTime = System.currentTimeMillis();
        
        // 기본 JPA 메서드 사용 (N+1 문제 발생)
        // findAll()은 연관 엔티티를 지연 로딩으로 가져옴
        List<Book> books = bookRepository.findAll();
        
        // 연관 엔티티 접근 시 추가 쿼리 발생 (N+1 문제)
        for (Book book : books) {
            // 각 도서마다 별도 쿼리 실행 (N+1 문제 발생)
            book.getBookAuthors().size();
            for (var bookAuthor : book.getBookAuthors()) {
                // 각 저자마다 별도 쿼리 실행 (N+1 문제 발생)
                bookAuthor.getAuthor().getName();
            }
            // 카테고리 접근 시 별도 쿼리 실행
            book.getCategory().getCategoryName();
            // 재고 정보 접근 시 별도 쿼리 실행
            if (book.getStock() != null) {
                book.getStock().getQuantity();
            }
        }
        
        long endTime = System.currentTimeMillis();
        long executionTime = endTime - startTime;
        
        log.info("N+1 문제 발생 방식 - 실행 시간: {}ms, 도서 수: {}", executionTime, books.size());
        log.info("=== N+1 문제 발생 방식 테스트 완료 ===");
        
        // DTO로 변환하여 반환
        return convertToPerformanceDto(books);
    }
    
    /**
     * LEFT JOIN FETCH를 사용한 최적화된 방식으로 도서 목록 조회
     * - 한 번의 쿼리로 모든 연관 엔티티 조회
     */
    @GetMapping("/books/optimized")
    public List<BookPerformanceDto> getBooksOptimized() {
        log.info("=== LEFT JOIN FETCH 최적화 방식 테스트 시작 ===");
        long startTime = System.currentTimeMillis();
        
        // LEFT JOIN FETCH를 사용한 최적화된 쿼리
        List<Book> books = bookRepository.findAllWithAuthors();
        
        // 추가 쿼리 없이 연관 엔티티 접근 가능
        for (Book book : books) {
            book.getBookAuthors().size();
            for (var bookAuthor : book.getBookAuthors()) {
                bookAuthor.getAuthor().getName();
            }
            book.getCategory().getCategoryName();
            if (book.getStock() != null) {
                book.getStock().getQuantity();
            }
        }
        
        long endTime = System.currentTimeMillis();
        long executionTime = endTime - startTime;
        
        log.info("LEFT JOIN FETCH 최적화 방식 - 실행 시간: {}ms, 도서 수: {}", executionTime, books.size());
        log.info("=== LEFT JOIN FETCH 최적화 방식 테스트 완료 ===");
        
        // DTO로 변환하여 반환
        return convertToPerformanceDto(books);
    }
    
    /**
     * 카테고리별 도서 조회 - N+1 문제 발생
     */
    @GetMapping("/books/category/{categoryId}/n-plus-1")
    public List<BookPerformanceDto> getBooksByCategoryWithNPlus1(@PathVariable Long categoryId) {
        log.info("=== 카테고리별 N+1 문제 발생 방식 테스트 시작 ===");
        
        long startTime = System.currentTimeMillis();
        
        // 기본 쿼리 사용 (N+1 문제 발생)
        // findBooksByCategoryIdNPlus1는 연관 엔티티를 지연 로딩으로 가져옴
        List<Book> books = bookRepository.findBooksByCategoryIdNPlus1(categoryId);
        
        log.info("카테고리 ID: {}, 도서 수: {}개", categoryId, books.size());
        
        // DTO 변환 과정에서 연관 엔티티 접근 시 N+1 문제 발생
        // 이 시점에서 각 도서마다 별도 쿼리가 실행됩니다
        List<BookPerformanceDto> result = convertToPerformanceDtoWithNPlus1(books);
        
        long endTime = System.currentTimeMillis();
        long executionTime = endTime - startTime;
        
        log.info("카테고리별 N+1 문제 발생 방식 - 실행 시간: {}ms, 도서 수: {}", 
                executionTime, books.size());
        log.info("=== 카테고리별 N+1 문제 발생 방식 테스트 완료 ===");
        
        return result;
    }
    
    /**
     * 카테고리별 도서 조회 - 최적화된 방식
     */
    @GetMapping("/books/category/{categoryId}/optimized")
    public List<BookPerformanceDto> getBooksByCategoryOptimized(@PathVariable Long categoryId) {
        log.info("=== 카테고리별 LEFT JOIN FETCH 최적화 방식 테스트 시작 ===");
        
        long startTime = System.currentTimeMillis();
        
        // LEFT JOIN FETCH를 사용한 최적화된 쿼리
        // 한 번의 쿼리로 모든 연관 엔티티를 가져옴
        List<Book> books = bookRepository.findByCategoryCategoryId(categoryId);
        
        log.info("카테고리 ID: {}, 도서 수: {}개", categoryId, books.size());
        
        // DTO 변환 과정에서 추가 쿼리 없이 연관 엔티티 접근 가능
        List<BookPerformanceDto> result = convertToPerformanceDto(books);
        
        long endTime = System.currentTimeMillis();
        long executionTime = endTime - startTime;
        
        log.info("카테고리별 LEFT JOIN FETCH 최적화 방식 - 실행 시간: {}ms, 도서 수: {}", 
                executionTime, books.size());
        log.info("=== 카테고리별 LEFT JOIN FETCH 최적화 방식 테스트 완료 ===");
        
        return result;
    }
    
    /**
     * 검색 기능 - N+1 문제 발생
     */
    @GetMapping("/books/search/n-plus-1")
    public List<BookPerformanceDto> searchBooksWithNPlus1(@RequestParam String keyword) {
        log.info("=== 검색 N+1 문제 발생 방식 테스트 시작 ===");
        long startTime = System.currentTimeMillis();
        
        // 기본 쿼리 사용 (N+1 문제 발생)
        // 연관 엔티티를 fetch하지 않아서 N+1 문제가 발생합니다
        List<Book> books = bookRepository.searchBooksNPlus1(keyword);
        
        long endTime = System.currentTimeMillis();
        long executionTime = endTime - startTime;
        
        log.info("검색 N+1 문제 발생 방식 - 실행 시간: {}ms, 도서 수: {}", executionTime, books.size());
        log.info("=== 검색 N+1 문제 발생 방식 테스트 완료 ===");
        
        // DTO로 변환하여 반환 (N+1 문제 발생)
        return convertToPerformanceDtoWithNPlus1(books);
    }
    
    /**
     * 검색 기능 - 최적화된 방식
     */
    @GetMapping("/books/search/optimized")
    public List<BookPerformanceDto> searchBooksOptimized(@RequestParam String keyword) {
        log.info("=== 검색 LEFT JOIN FETCH 최적화 방식 테스트 시작 ===");
        long startTime = System.currentTimeMillis();
        
        // LEFT JOIN FETCH를 사용한 최적화된 쿼리
        List<Book> books = bookRepository.searchBooks(keyword);
        
        // 추가 쿼리 없이 연관 엔티티 접근 가능
        for (Book book : books) {
            book.getBookAuthors().size();
            for (var bookAuthor : book.getBookAuthors()) {
                bookAuthor.getAuthor().getName();
            }
            book.getCategory().getCategoryName();
            // 재고 정보 접근
            if (book.getStock() != null) {
                book.getStock().getQuantity();
            }
        }
        
        long endTime = System.currentTimeMillis();
        long executionTime = endTime - startTime;
        
        log.info("검색 LEFT JOIN FETCH 최적화 방식 - 실행 시간: {}ms, 도서 수: {}", executionTime, books.size());
        log.info("=== 검색 LEFT JOIN FETCH 최적화 방식 테스트 완료 ===");
        
        // DTO로 변환하여 반환 (JSON 직렬화 오류 방지)
        return convertToPerformanceDto(books);
    }
    
    
    
    /**
     * 전체 도서 조회 성능 비교 엔드포인트
     */
    @GetMapping("/compare/all")
    public Map<String, Object> compareAllBooksPerformance() {
        Map<String, Object> result = new HashMap<>();
        
        log.info("=== 전체 도서 조회 성능 비교 테스트 시작 ===");
        
        // N+1 문제 방식 테스트
        long n1StartTime = System.currentTimeMillis();
        List<BookPerformanceDto> n1Result = getBooksWithNPlus1Problem();
        long n1EndTime = System.currentTimeMillis();
        long n1ExecutionTime = n1EndTime - n1StartTime;
        
        // 잠시 대기 (캐시 효과 방지)
        try {
            Thread.sleep(100);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        
        // 최적화 방식 테스트
        long optStartTime = System.currentTimeMillis();
        List<BookPerformanceDto> optResult = getBooksOptimized();
        long optEndTime = System.currentTimeMillis();
        long optExecutionTime = optEndTime - optStartTime;
        
        // 결과 비교
        result.put("testType", "전체 도서 조회");
        result.put("bookCount", n1Result.size());
        
        Map<String, Object> n1Stats = new HashMap<>();
        n1Stats.put("executionTime", n1ExecutionTime);
        n1Stats.put("avgTimePerBook", n1Result.size() > 0 ? n1ExecutionTime / n1Result.size() : 0);
        result.put("n1Problem", n1Stats);
        
        Map<String, Object> optStats = new HashMap<>();
        optStats.put("executionTime", optExecutionTime);
        optStats.put("avgTimePerBook", optResult.size() > 0 ? optExecutionTime / optResult.size() : 0);
        result.put("optimized", optStats);
        
        // 성능 개선율 계산
        double timeImprovement = n1ExecutionTime > 0 ? 
            ((double)(n1ExecutionTime - optExecutionTime) / n1ExecutionTime) * 100 : 0;
        
        Map<String, Object> improvement = new HashMap<>();
        improvement.put("timeImprovement", String.format("%.1f%%", timeImprovement));
        result.put("improvement", improvement);
        
        log.info("=== 전체 도서 조회 성능 비교 결과 ===");
        log.info("N+1 방식: {}ms", n1ExecutionTime);
        log.info("최적화 방식: {}ms", optExecutionTime);
        log.info("성능 개선: {}% (시간)", String.format("%.1f", timeImprovement));
        
        return result;
    }
    
    /**
     * 카테고리별 도서 조회 성능 비교 엔드포인트
     */
    @GetMapping("/compare/{categoryId}")
    public Map<String, Object> comparePerformance(@PathVariable Long categoryId) {
        Map<String, Object> result = new HashMap<>();
        
        log.info("=== 성능 비교 테스트 시작 (카테고리: {}) ===", categoryId);
        
        // N+1 문제 방식 테스트
        long n1StartTime = System.currentTimeMillis();
        List<BookPerformanceDto> n1Result = getBooksByCategoryWithNPlus1(categoryId);
        long n1EndTime = System.currentTimeMillis();
        long n1ExecutionTime = n1EndTime - n1StartTime;
        
        // 잠시 대기 (캐시 효과 방지)
        try {
            Thread.sleep(100);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        
        // 최적화 방식 테스트
        long optStartTime = System.currentTimeMillis();
        List<BookPerformanceDto> optResult = getBooksByCategoryOptimized(categoryId);
        long optEndTime = System.currentTimeMillis();
        long optExecutionTime = optEndTime - optStartTime;
        
        // 결과 비교
        result.put("categoryId", categoryId);
        result.put("bookCount", n1Result.size());
        
        Map<String, Object> n1Stats = new HashMap<>();
        n1Stats.put("executionTime", n1ExecutionTime);
        n1Stats.put("avgTimePerBook", n1Result.size() > 0 ? n1ExecutionTime / n1Result.size() : 0);
        result.put("n1Problem", n1Stats);
        
        Map<String, Object> optStats = new HashMap<>();
        optStats.put("executionTime", optExecutionTime);
        optStats.put("avgTimePerBook", optResult.size() > 0 ? optExecutionTime / optResult.size() : 0);
        result.put("optimized", optStats);
        
        // 성능 개선율 계산
        double timeImprovement = n1ExecutionTime > 0 ? 
            ((double)(n1ExecutionTime - optExecutionTime) / n1ExecutionTime) * 100 : 0;
        
        Map<String, Object> improvement = new HashMap<>();
        improvement.put("timeImprovement", String.format("%.1f%%", timeImprovement));
        result.put("improvement", improvement);
        
        log.info("=== 성능 비교 결과 ===");
        log.info("N+1 방식: {}ms", n1ExecutionTime);
        log.info("최적화 방식: {}ms", optExecutionTime);
        log.info("성능 개선: {}% (시간)", String.format("%.1f", timeImprovement));
        
        return result;
    }
    
    /**
     * 검색 기능 성능 비교 엔드포인트
     */
    @GetMapping("/compare/search")
    public Map<String, Object> compareSearchPerformance(@RequestParam String keyword) {
        Map<String, Object> result = new HashMap<>();
        
        log.info("=== 검색 기능 성능 비교 테스트 시작 (키워드: {}) ===", keyword);
        
        // N+1 문제 방식 테스트
        long n1StartTime = System.currentTimeMillis();
        List<BookPerformanceDto> n1Result = searchBooksWithNPlus1(keyword);
        long n1EndTime = System.currentTimeMillis();
        long n1ExecutionTime = n1EndTime - n1StartTime;
        
        // 잠시 대기 (캐시 효과 방지)
        try {
            Thread.sleep(100);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        
        // 최적화 방식 테스트
        long optStartTime = System.currentTimeMillis();
        List<BookPerformanceDto> optResult = searchBooksOptimized(keyword);
        long optEndTime = System.currentTimeMillis();
        long optExecutionTime = optEndTime - optStartTime;
        
        // 결과 비교
        result.put("testType", "검색 기능");
        result.put("keyword", keyword);
        result.put("bookCount", n1Result.size());
        
        Map<String, Object> n1Stats = new HashMap<>();
        n1Stats.put("executionTime", n1ExecutionTime);
        n1Stats.put("avgTimePerBook", n1Result.size() > 0 ? n1ExecutionTime / n1Result.size() : 0);
        result.put("n1Problem", n1Stats);
        
        Map<String, Object> optStats = new HashMap<>();
        optStats.put("executionTime", optExecutionTime);
        optStats.put("avgTimePerBook", optResult.size() > 0 ? optExecutionTime / optResult.size() : 0);
        result.put("optimized", optStats);
        
        // 성능 개선율 계산
        double timeImprovement = n1ExecutionTime > 0 ? 
            ((double)(n1ExecutionTime - optExecutionTime) / n1ExecutionTime) * 100 : 0;
        
        Map<String, Object> improvement = new HashMap<>();
        improvement.put("timeImprovement", String.format("%.1f%%", timeImprovement));
        result.put("improvement", improvement);
        
        log.info("=== 검색 기능 성능 비교 결과 ===");
        log.info("N+1 방식: {}ms", n1ExecutionTime);
        log.info("최적화 방식: {}ms", optExecutionTime);
        log.info("성능 개선: {}% (시간)", String.format("%.1f", timeImprovement));
        
        return result;
    }
    
    /**
     * Book 엔티티를 BookPerformanceDto로 변환
     */
    private List<BookPerformanceDto> convertToPerformanceDto(List<Book> books) {
        return books.stream()
                .map(this::convertToPerformanceDto)
                .toList();
    }
    
    /**
     * Book 엔티티를 BookPerformanceDto로 변환 (N+1 문제 발생용)
     * 연관 엔티티에 접근할 때 추가 쿼리가 발생합니다.
     */
    private List<BookPerformanceDto> convertToPerformanceDtoWithNPlus1(List<Book> books) {
        return books.stream()
                .map(this::convertToPerformanceDtoWithNPlus1)
                .toList();
    }
    
    /**
     * 단일 Book 엔티티를 BookPerformanceDto로 변환 (N+1 문제 발생용)
     */
    private BookPerformanceDto convertToPerformanceDtoWithNPlus1(Book book) {
        try {
            // 카테고리 정보 (N+1 문제 발생 - 별도 쿼리 실행)
            BookPerformanceDto.CategoryInfo categoryInfo = null;
            if (book.getCategory() != null) {
                var category = book.getCategory();
                categoryInfo = BookPerformanceDto.CategoryInfo.builder()
                        .categoryId(category.getCategoryId())
                        .categoryName(category.getCategoryName())
                        .level(category.getLevel())
                        .parentId(category.getParent() != null ? category.getParent().getCategoryId() : null)
                        .parentName(category.getParent() != null ? category.getParent().getCategoryName() : null)
                        .build();
            }
            
            // 저자 정보 (N+1 문제 발생 - 각 도서마다 별도 쿼리 실행)
            List<BookPerformanceDto.AuthorInfo> authors = book.getBookAuthors().stream()
                    .map(ba -> {
                        var author = ba.getAuthor();
                        return BookPerformanceDto.AuthorInfo.builder()
                                .authorId(author.getAuthorId())
                                .name(author.getName())
                                .description(author.getDescription())
                                .authorOrder(ba.getAuthorOrder())
                                .build();
                    })
                    .toList();
            
            // 재고 정보 (N+1 문제 발생 - 별도 쿼리 실행)
            BookPerformanceDto.StockInfo stockInfo = null;
            if (book.getStock() != null) {
                var stock = book.getStock();
                stockInfo = BookPerformanceDto.StockInfo.builder()
                        .stockId(stock.getStockId())
                        .quantity(stock.getQuantity())
                        .lastUpdated(stock.getLastUpdated())
                        .build();
            }
            
            return BookPerformanceDto.builder()
                    .bookId(book.getBookId())
                    .isbn(book.getIsbn())
                    .title(book.getTitle())
                    .description(book.getDescription())
                    .width(book.getWidth())
                    .height(book.getHeight())
                    .pageCount(book.getPageCount())
                    .thumbnailUrl(book.getThumbnailUrl())
                    .previewUrl(book.getPreviewUrl())
                    .ratingAvg(book.getRatingAvg())
                    .bookStatus(book.getBookStatus())
                    .registrationDate(book.getRegistrationDate())
                    .price(book.getPrice())
                    .publisher(book.getPublisher())
                    .salesCount(book.getSalesCount())
                    .monthlySales(book.getMonthlySales())
                    .lastSalesUpdate(book.getLastSalesUpdate())
                    .category(categoryInfo)
                    .authors(authors)
                    .stock(stockInfo)
                    .build();
        } catch (Exception e) {
            // 에러 발생 시 기본 정보만 포함한 DTO 반환
            log.error("DTO 변환 중 오류 발생: {}", e.getMessage());
            return BookPerformanceDto.builder()
                    .bookId(book.getBookId())
                    .title(book.getTitle())
                    .price(book.getPrice())
                    .build();
        }
    }
    
    /**
     * 단일 Book 엔티티를 BookPerformanceDto로 변환
     */
    private BookPerformanceDto convertToPerformanceDto(Book book) {
        try {
            // 카테고리 정보
            BookPerformanceDto.CategoryInfo categoryInfo = null;
            if (book.getCategory() != null) {
                var category = book.getCategory();
                categoryInfo = BookPerformanceDto.CategoryInfo.builder()
                        .categoryId(category.getCategoryId())
                        .categoryName(category.getCategoryName())
                        .level(category.getLevel())
                        .parentId(category.getParent() != null ? category.getParent().getCategoryId() : null)
                        .parentName(category.getParent() != null ? category.getParent().getCategoryName() : null)
                        .build();
            }
            
            // 저자 정보
            List<BookPerformanceDto.AuthorInfo> authors = book.getBookAuthors().stream()
                    .map(ba -> {
                        var author = ba.getAuthor();
                        return BookPerformanceDto.AuthorInfo.builder()
                                .authorId(author.getAuthorId())
                                .name(author.getName())
                                .description(author.getDescription())
                                .authorOrder(ba.getAuthorOrder())
                                .build();
                    })
                    .toList();
            
            // 재고 정보
            BookPerformanceDto.StockInfo stockInfo = null;
            if (book.getStock() != null) {
                var stock = book.getStock();
                stockInfo = BookPerformanceDto.StockInfo.builder()
                        .stockId(stock.getStockId())
                        .quantity(stock.getQuantity())
                        .lastUpdated(stock.getLastUpdated())
                        .build();
            }
            
            return BookPerformanceDto.builder()
                    .bookId(book.getBookId())
                    .isbn(book.getIsbn())
                    .title(book.getTitle())
                    .description(book.getDescription())
                    .width(book.getWidth())
                    .height(book.getHeight())
                    .pageCount(book.getPageCount())
                    .thumbnailUrl(book.getThumbnailUrl())
                    .previewUrl(book.getPreviewUrl())
                    .ratingAvg(book.getRatingAvg())
                    .bookStatus(book.getBookStatus())
                    .registrationDate(book.getRegistrationDate())
                    .price(book.getPrice())
                    .publisher(book.getPublisher())
                    .salesCount(book.getSalesCount())
                    .monthlySales(book.getMonthlySales())
                    .lastSalesUpdate(book.getLastSalesUpdate())
                    .category(categoryInfo)
                    .authors(authors)
                    .stock(stockInfo)
                    .build();
        } catch (Exception e) {
            // 에러 발생 시 기본 정보만 포함한 DTO 반환
            System.err.println("DTO 변환 중 오류 발생: " + e.getMessage());
            return BookPerformanceDto.builder()
                    .bookId(book.getBookId())
                    .title(book.getTitle())
                    .price(book.getPrice())
                    .build();
        }
    }
}
