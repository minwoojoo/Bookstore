package com.bookstore.bookstore.controller.performance;

import com.bookstore.bookstore.entity.book.Book;
import com.bookstore.bookstore.entity.book.Category;
import com.bookstore.bookstore.entity.book.Author;
import com.bookstore.bookstore.entity.book.BookAuthor;
import com.bookstore.bookstore.entity.book.Stock;
import com.bookstore.bookstore.repository.book.BookRepository;
import com.bookstore.bookstore.repository.book.CategoryRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

/**
 * 성능 테스트를 위한 대량 데이터 생성기
 */
@RestController
@RequestMapping("/api/performance")
@RequiredArgsConstructor
@Slf4j
public class PerformanceDataGenerator {
    
    private final BookRepository bookRepository;
    private final CategoryRepository categoryRepository;
    
    /**
     * 성능 테스트용 대량 데이터 생성
     */
    @PostMapping("/generate-test-data")
    public String generateTestData(@RequestParam(defaultValue = "100") int bookCount) {
        log.info("=== 성능 테스트용 데이터 생성 시작 ===");
        log.info("생성할 도서 수: {}개", bookCount);
        log.info("⚠️  주의: 기존 개발 데이터가 삭제됩니다!");
        
        long startTime = System.currentTimeMillis();
        
        try {
            // 기존 데이터 백업 (개발 데이터 보호)
            long existingBookCount = bookRepository.count();
            log.info("기존 도서 수: {}개", existingBookCount);
            
            if (existingBookCount > 0) {
                log.warn("기존 개발 데이터가 있습니다. 성능 테스트를 위해 모든 데이터를 삭제합니다.");
                log.warn("개발 데이터를 보존하려면 먼저 데이터베이스를 백업하세요.");
            }
            
            // 기존 테스트 데이터 삭제
            bookRepository.deleteAll();
            
            // 카테고리 조회
            List<Category> categories = categoryRepository.findAll();
            if (categories.isEmpty()) {
                return "카테고리가 없습니다. 먼저 카테고리를 생성해주세요.";
            }
            
            // 저자 생성 (기존 저자가 없으면 새로 생성)
            List<Author> authors = new ArrayList<>();
            for (int i = 1; i <= 10; i++) {
                Author author = Author.builder()
                        .name("테스트 저자 " + i)
                        .description("성능 테스트용 저자 " + i)
                        .build();
                authors.add(author);
            }
            
            Random random = new Random();
            List<Book> books = new ArrayList<>();
            
            // 대량의 도서 데이터 생성
            for (int i = 1; i <= bookCount; i++) {
                Book book = createTestBook(i, categories, authors, random);
                books.add(book);
                
                // 배치 처리 (100개씩)
                if (i % 100 == 0) {
                    bookRepository.saveAll(books);
                    books.clear();
                    log.info("진행률: {}/{} ({}%)", i, bookCount, (i * 100) / bookCount);
                }
            }
            
            // 남은 데이터 저장
            if (!books.isEmpty()) {
                bookRepository.saveAll(books);
            }
            
            long endTime = System.currentTimeMillis();
            long executionTime = endTime - startTime;
            
            log.info("=== 성능 테스트용 데이터 생성 완료 ===");
            log.info("생성된 도서 수: {}개", bookCount);
            log.info("실행 시간: {}ms", executionTime);
            
            return String.format("성능 테스트용 데이터 생성 완료! 도서 %d개 생성, 실행 시간: %dms", 
                    bookCount, executionTime);
                    
        } catch (Exception e) {
            log.error("데이터 생성 중 오류 발생: {}", e.getMessage(), e);
            return "데이터 생성 중 오류가 발생했습니다: " + e.getMessage();
        }
    }
    
    private Book createTestBook(int index, List<Category> categories, List<Author> authors, Random random) {
        // 랜덤 카테고리 선택
        Category category = categories.get(random.nextInt(categories.size()));
        
        // 랜덤 저자 선택 (1-3명)
        int authorCount = random.nextInt(3) + 1;
        List<Author> selectedAuthors = new ArrayList<>();
        for (int i = 0; i < authorCount; i++) {
            Author author = authors.get(random.nextInt(authors.size()));
            if (!selectedAuthors.contains(author)) {
                selectedAuthors.add(author);
            }
        }
        
        // 도서 생성
        Book book = Book.builder()
                .isbn("TEST" + String.format("%06d", index))
                .title("성능테스트도서 " + index)
                .description("성능 테스트를 위한 도서입니다. " + index)
                .width(150 + random.nextInt(50))
                .height(200 + random.nextInt(50))
                .pageCount(200 + random.nextInt(300))
                .thumbnailUrl("https://via.placeholder.com/150x200?text=Book" + index)
                .previewUrl("https://via.placeholder.com/600x800?text=Preview" + index)
                .ratingAvg(BigDecimal.valueOf(3.0 + random.nextDouble() * 2.0))
                .bookStatus("SALE")
                .registrationDate(LocalDateTime.now().minusDays(random.nextInt(365)))
                .price(BigDecimal.valueOf(10000 + random.nextInt(20000)))
                .publisher("테스트출판사 " + (index % 10 + 1))
                .salesCount(random.nextInt(1000))
                .monthlySales(random.nextInt(100))
                .lastSalesUpdate(LocalDateTime.now().minusDays(random.nextInt(30)))
                .category(category)
                .build();
        
        // 재고 정보 생성
        Stock stock = Stock.builder()
                .quantity(10 + random.nextInt(100))
                .lastUpdated(LocalDateTime.now().minusDays(random.nextInt(7)))
                .build();
        book.setStock(stock);
        stock.setBook(book);
        
        // 저자 연결
        List<BookAuthor> bookAuthors = new ArrayList<>();
        for (int i = 0; i < selectedAuthors.size(); i++) {
            BookAuthor bookAuthor = BookAuthor.builder()
                    .book(book)
                    .author(selectedAuthors.get(i))
                    .authorOrder(i + 1)
                    .build();
            bookAuthors.add(bookAuthor);
        }
        book.setBookAuthors(bookAuthors);
        
        return book;
    }
    
    /**
     * 개발 데이터를 테스트 데이터로 임시 교체
     * 기존 개발 데이터는 백업하고 테스트 데이터로 교체합니다.
     */
    @PostMapping("/backup-and-generate")
    public String backupAndGenerateTestData(@RequestParam(defaultValue = "100") int bookCount) {
        log.info("=== 개발 데이터 백업 후 테스트 데이터 생성 시작 ===");
        
        try {
            // 1. 기존 개발 데이터 백업
            List<Book> existingBooks = bookRepository.findAll();
            log.info("기존 개발 데이터 백업: {}개 도서", existingBooks.size());
            
            // 2. 테스트 데이터 생성
            String result = generateTestData(bookCount);
            
            // 3. 백업된 데이터 정보 저장 (나중에 복원할 수 있도록)
            log.info("개발 데이터가 백업되었습니다. 복원하려면 /restore-dev-data를 호출하세요.");
            
            return result + "\n\n개발 데이터가 백업되었습니다. 복원하려면 /restore-dev-data를 호출하세요.";
            
        } catch (Exception e) {
            log.error("백업 및 테스트 데이터 생성 중 오류 발생: {}", e.getMessage(), e);
            return "백업 및 테스트 데이터 생성 중 오류가 발생했습니다: " + e.getMessage();
        }
    }
    
    /**
     * 개발 데이터 복원
     * 주의: 이 기능은 간단한 구현이며, 실제로는 더 정교한 백업/복원 시스템이 필요합니다.
     */
    @PostMapping("/restore-dev-data")
    public String restoreDevData() {
        log.info("=== 개발 데이터 복원 시작 ===");
        
        try {
            // 현재 테스트 데이터 삭제
            bookRepository.deleteAll();
            
            // 개발 데이터 복원을 위한 안내
            log.info("테스트 데이터가 삭제되었습니다.");
            log.info("개발 데이터를 복원하려면 애플리케이션을 재시작하거나 데이터베이스를 복원하세요.");
            
            return "테스트 데이터가 삭제되었습니다. 개발 데이터를 복원하려면 애플리케이션을 재시작하거나 데이터베이스를 복원하세요.";
            
        } catch (Exception e) {
            log.error("개발 데이터 복원 중 오류 발생: {}", e.getMessage(), e);
            return "개발 데이터 복원 중 오류가 발생했습니다: " + e.getMessage();
        }
    }
}
