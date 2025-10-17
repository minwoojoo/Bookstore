package com.bookstore.bookstore.repository.admin;

import com.bookstore.bookstore.dto.admin.AdminOrderListRequest;
import com.bookstore.bookstore.entity.order.Order;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.List;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 관리자 주문 관리 리포지토리
 */
@Repository
public interface AdminOrderRepository extends JpaRepository<Order, Long> {
    
    /**
     * 필터 조건에 따른 주문 목록 조회 (기본 정보만)
     */
    @Query("SELECT DISTINCT o FROM Order o " +
           "LEFT JOIN FETCH o.member m " +
           "WHERE (:memberName IS NULL OR LOWER(m.name) LIKE LOWER(CONCAT('%', :memberName, '%'))) " +
           "AND (:bookTitle IS NULL OR EXISTS (SELECT 1 FROM OrderItem oi2 JOIN oi2.book b2 WHERE oi2.order = o AND LOWER(b2.title) LIKE LOWER(CONCAT('%', :bookTitle, '%')))) " +
           "AND (:publisher IS NULL OR EXISTS (SELECT 1 FROM OrderItem oi3 JOIN oi3.book b3 WHERE oi3.order = o AND LOWER(b3.publisher) LIKE LOWER(CONCAT('%', :publisher, '%')))) " +
           "AND (:author IS NULL OR EXISTS (SELECT 1 FROM OrderItem oi4 JOIN oi4.book b4 JOIN b4.bookAuthors ba4 JOIN ba4.author a4 WHERE oi4.order = o AND LOWER(a4.name) LIKE LOWER(CONCAT('%', :author, '%')))) " +
           "AND (:saleStatus IS NULL OR EXISTS (SELECT 1 FROM OrderItem oi5 JOIN oi5.book b5 WHERE oi5.order = o AND b5.bookStatus = :saleStatus)) " +
           "AND (:startDate IS NULL OR o.orderDate >= :startDate) " +
           "AND (:endDate IS NULL OR o.orderDate <= :endDate) " +
           "AND (:memberId IS NULL OR o.memberId = :memberId)")
    Page<Order> findOrdersWithFilters(
            @Param("memberName") String memberName,
            @Param("bookTitle") String bookTitle,
            @Param("publisher") String publisher,
            @Param("author") String author,
            @Param("saleStatus") String saleStatus,
            @Param("startDate") LocalDateTime startDate,
            @Param("endDate") LocalDateTime endDate,
            @Param("memberId") Long memberId,
            Pageable pageable);
    
    /**
     * AdminOrderListRequest를 사용한 주문 목록 조회
     */
    default Page<Order> findOrdersWithFilters(AdminOrderListRequest request, Pageable pageable) {
        // LocalDate를 LocalDateTime으로 변환
        LocalDateTime startDate = request.getStartDate() != null ? 
            request.getStartDate().atStartOfDay() : null;
        LocalDateTime endDate = request.getEndDate() != null ? 
            request.getEndDate().plusDays(1).atStartOfDay() : null;
            
        return findOrdersWithFilters(
                request.getMemberName(),
                request.getBookTitle(),
                request.getPublisher(),
                request.getAuthor(),
                request.getSaleStatus(),
                startDate,
                endDate,
                request.getMemberId(),
                pageable
        );
    }
    
    /**
     * 주문 상세 조회 (연관 엔티티 포함)
     */
    @Query("SELECT o FROM Order o " +
           "LEFT JOIN FETCH o.member m " +
           "LEFT JOIN FETCH o.orderItems oi " +
           "LEFT JOIN FETCH oi.book b " +
           "LEFT JOIN FETCH b.category " +
           "LEFT JOIN FETCH o.payment p " +
           "WHERE o.orderId = :orderId")
    Optional<Order> findByIdWithDetails(@Param("orderId") Long orderId);
    
    /**
     * 주문 상태별 주문 수 조회
     */
    @Query("SELECT o.orderStatus, COUNT(o) FROM Order o GROUP BY o.orderStatus")
    Object[][] countByOrderStatus();
    
    /**
     * 월별 주문 수 조회
     */
    @Query("SELECT FUNCTION('YEAR', o.orderDate), FUNCTION('MONTH', o.orderDate), COUNT(o) " +
           "FROM Order o " +
           "WHERE o.orderDate >= :startDate " +
           "GROUP BY FUNCTION('YEAR', o.orderDate), FUNCTION('MONTH', o.orderDate) " +
           "ORDER BY FUNCTION('YEAR', o.orderDate), FUNCTION('MONTH', o.orderDate)")
    Object[][] countByMonth(@Param("startDate") LocalDateTime startDate);
    
    /**
     * 월별 주문 금액 조회
     */
    @Query("SELECT FUNCTION('YEAR', o.orderDate), FUNCTION('MONTH', o.orderDate), SUM(o.finalPaymentAmount) " +
           "FROM Order o " +
           "WHERE o.orderDate >= :startDate " +
           "GROUP BY FUNCTION('YEAR', o.orderDate), FUNCTION('MONTH', o.orderDate) " +
           "ORDER BY FUNCTION('YEAR', o.orderDate), FUNCTION('MONTH', o.orderDate)")
    Object[][] sumAmountByMonth(@Param("startDate") LocalDateTime startDate);
    
    /**
     * 회원별 주문 통계
     */
    @Query("SELECT o.memberId, m.name, COUNT(o), SUM(o.finalPaymentAmount) " +
           "FROM Order o LEFT JOIN o.member m " +
           "WHERE o.orderDate >= :startDate " +
           "GROUP BY o.memberId, m.name " +
           "ORDER BY SUM(o.finalPaymentAmount) DESC")
    Object[][] getMemberOrderStats(@Param("startDate") LocalDateTime startDate);
    
    /**
     * 총 매출액 조회
     */
    @Query("SELECT SUM(o.finalPaymentAmount) FROM Order o")
    BigDecimal getTotalSales();
    
    /**
     * 특정 날짜의 주문 수 조회
     */
    @Query("SELECT COUNT(o) FROM Order o WHERE o.orderDate >= :startDate AND o.orderDate < :endDate")
    Long countByOrderDate(@Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);
    
    /**
     * 특정 날짜의 매출액 조회
     */
    @Query("SELECT SUM(o.finalPaymentAmount) FROM Order o WHERE o.orderDate >= :startDate AND o.orderDate < :endDate")
    BigDecimal getSalesByDate(@Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);
    
    /**
     * 특정 기간의 주문 수 조회
     */
    @Query("SELECT COUNT(o) FROM Order o WHERE o.orderDate >= :startDate AND o.orderDate <= :endDate")
    Long countByOrderDateBetween(@Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);
    
    /**
     * 특정 기간의 매출액 조회
     */
    @Query("SELECT SUM(o.finalPaymentAmount) FROM Order o WHERE o.orderDate >= :startDate AND o.orderDate <= :endDate")
    BigDecimal getSalesByDateBetween(@Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);
    
    /**
     * 최근 주문 조회 (최대 5개)
     */
    List<Order> findTop5ByOrderByOrderDateDesc();
}
