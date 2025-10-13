package com.bookstore.bookstore.repository.order;

import com.bookstore.bookstore.entity.order.CartItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface CartItemRepository extends JpaRepository<CartItem, Long> {
    
    /**
     * 장바구니에서 특정 책이 있는지 확인
     */
    @Query("SELECT ci FROM CartItem ci " +
           "WHERE ci.cart.cartId = :cartId AND ci.book.bookId = :bookId")
    Optional<CartItem> findByCartIdAndBookId(@Param("cartId") Long cartId, @Param("bookId") Long bookId);
    
    /**
     * 장바구니 아이템 삭제
     */
    void deleteByCartItemIdIn(Iterable<Long> cartItemIds);
}

