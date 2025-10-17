package com.bookstore.bookstore.config.init;

import com.bookstore.bookstore.entity.book.Book;
import com.bookstore.bookstore.entity.book.Stock;
import com.bookstore.bookstore.repository.book.BookRepository;
import com.bookstore.bookstore.repository.book.StockRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 재고 데이터 초기화
 * 모든 도서의 재고를 50으로 설정
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class StockInitializer implements CommandLineRunner {

    private final BookRepository bookRepository;
    private final StockRepository stockRepository;

    @Override
    @Transactional
    public void run(String... args) throws Exception {
        log.info("=== 재고 데이터 초기화 시작 ===");
        
        try {
            // 모든 도서 조회
            List<Book> books = bookRepository.findAll();
            log.info("총 도서 수: {}권", books.size());
            
            if (books.isEmpty()) {
                log.warn("도서가 없습니다. 재고 초기화를 건너뜁니다.");
                return;
            }
            
            int updatedCount = 0;
            int createdCount = 0;
            
            for (Book book : books) {
                Stock existingStock = book.getStock();
                
                if (existingStock != null) {
                    // 기존 재고가 있는 경우 수량만 업데이트
                    existingStock.setQuantity(50);
                    existingStock.setLastUpdated(LocalDateTime.now());
                    stockRepository.save(existingStock);
                    updatedCount++;
                    log.debug("도서 ID {} 재고 업데이트: {} -> 50", book.getBookId(), existingStock.getQuantity());
                } else {
                    // 재고가 없는 경우 새로 생성
                    Stock newStock = Stock.builder()
                            .book(book)
                            .quantity(50)
                            .lastUpdated(LocalDateTime.now())
                            .build();
                    
                    stockRepository.save(newStock);
                    book.setStock(newStock);
                    bookRepository.save(book);
                    createdCount++;
                    log.debug("도서 ID {} 재고 생성: 50", book.getBookId());
                }
            }
            
            log.info("=== 재고 데이터 초기화 완료 ===");
            log.info("업데이트된 재고: {}개", updatedCount);
            log.info("새로 생성된 재고: {}개", createdCount);
            log.info("총 처리된 도서: {}권", updatedCount + createdCount);
            
        } catch (Exception e) {
            log.error("재고 데이터 초기화 중 오류 발생: {}", e.getMessage(), e);
            throw e;
        }
    }
}
