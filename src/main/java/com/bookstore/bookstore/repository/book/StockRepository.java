package com.bookstore.bookstore.repository.book;

import com.bookstore.bookstore.entity.book.Stock;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * 재고 리포지토리
 */
@Repository
public interface StockRepository extends JpaRepository<Stock, Long> {
    
    /**
     * 도서 ID로 재고 조회
     */
    Stock findByBookId(Long bookId);
    
    /**
     * 도서 ID로 재고 존재 여부 확인
     */
    boolean existsByBookId(Long bookId);
}
