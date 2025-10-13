package com.bookstore.bookstore.repository.order;

import com.bookstore.bookstore.entity.order.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {
    
    /**
     * 회원별 주문 목록 조회 (최신순)
     */
    @Query("SELECT o FROM Order o WHERE o.memberId = :memberId ORDER BY o.orderId DESC")
    List<Order> findByMemberIdOrderByOrderDateDesc(@Param("memberId") Long memberId);
    
    /**
     * 회원별 주문 목록 조회 (Member 엔티티 관계 사용, 최신순)
     */
    @Query("SELECT o FROM Order o WHERE o.member.memberId = :memberId ORDER BY o.orderDate DESC")
    List<Order> findByMemberMemberIdOrderByOrderDateDesc(@Param("memberId") Long memberId);
    
    /**
     * 회원별 주문 상세 조회 (권한 확인)
     */
    @Query("SELECT o FROM Order o WHERE o.orderId = :orderId AND o.member.memberId = :memberId")
    Optional<Order> findByIdAndMemberMemberId(@Param("orderId") Long orderId, @Param("memberId") Long memberId);
}
