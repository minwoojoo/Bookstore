package com.bookstore.bookstore.repository.admin;

import com.bookstore.bookstore.entity.order.OrderItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * 관리자 주문 아이템 리포지토리
 */
@Repository
public interface AdminOrderItemRepository extends JpaRepository<OrderItem, Long> {
    
    /**
     * 주문 ID로 주문 아이템 목록 조회 (책 정보 포함)
     */
    @Query("SELECT oi FROM OrderItem oi " +
           "LEFT JOIN FETCH oi.book b " +
           "LEFT JOIN FETCH b.bookAuthors ba " +
           "LEFT JOIN FETCH ba.author " +
           "WHERE oi.order.orderId = :orderId")
    List<OrderItem> findByOrderId(@Param("orderId") Long orderId);
}
