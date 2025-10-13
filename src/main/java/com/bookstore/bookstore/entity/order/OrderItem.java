package com.bookstore.bookstore.entity.order;

import com.bookstore.bookstore.entity.book.Book;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "order_item")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OrderItem {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "order_item_id")
    private Long orderItemId;
    
    @Column(name = "order_id", nullable = false)
    private Long orderId;
    
    @Column(name = "book_id", nullable = false)
    private Long bookId;
    
    @Column(name = "quantity", nullable = false)
    private Integer quantity;
    
    @Column(name = "price", nullable = false)
    private Integer price;
    
    // 주문과의 관계
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "order_id", nullable = false, insertable = false, updatable = false)
    private Order order;
    
    // 책과의 관계 (ERD 설계에 따라 book_id로 참조)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "book_id", nullable = false, insertable = false, updatable = false)
    private Book book;
    
    // 소계 계산
    public Integer getSubtotal() {
        return price * quantity;
    }
}

