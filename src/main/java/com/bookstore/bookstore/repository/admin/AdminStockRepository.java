package com.bookstore.bookstore.repository.admin;

import com.bookstore.bookstore.entity.book.Stock;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * 관리자 재고 관리 리포지토리
 */
@Repository
public interface AdminStockRepository extends JpaRepository<Stock, Long> {
    
    /**
     * 도서 ID로 재고 조회
     */
    Optional<Stock> findByBookId(Long bookId);
    
    /**
     * 재고 변경 이력 조회 (최근 10개)
     */
    @Query("SELECT s FROM Stock s WHERE s.bookId = :bookId ORDER BY s.lastUpdated DESC")
    List<Stock> findStockHistoryByBookId(@Param("bookId") Long bookId);
}
