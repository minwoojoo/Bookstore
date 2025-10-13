package com.bookstore.bookstore.repository.order;

import com.bookstore.bookstore.entity.order.Cart;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface CartRepository extends JpaRepository<Cart, Long> {
    
    /**
     * 회원의 장바구니 조회 (장바구니 아이템 포함)
     * Note: bookAuthors는 lazy loading으로 나중에 조회
     */
    @Query("SELECT DISTINCT c FROM Cart c " +
           "LEFT JOIN FETCH c.cartItems ci " +
           "LEFT JOIN FETCH ci.book b " +
           "WHERE c.member.memberId = :memberId")
    Optional<Cart> findByMemberIdWithItems(@Param("memberId") Long memberId);
    
    /**
     * 회원의 장바구니 존재 여부 확인
     */
    boolean existsByMemberMemberId(Long memberId);
}

