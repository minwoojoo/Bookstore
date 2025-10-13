package com.bookstore.bookstore.entity.order;

import com.bookstore.bookstore.entity.book.Book;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "cart_item")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CartItem {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "cart_item_id")
    private Long cartItemId;
    
    @Column(name = "isbn", length = 20)
    private String isbn;
    
    @Column(name = "quantity", nullable = false)
    private Integer quantity;
    
    @Column(name = "added_date")
    private LocalDateTime addedDate;
    
    // 장바구니와의 관계
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cart_id", nullable = false)
    private Cart cart;
    
    // 책과의 관계
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "book_id", nullable = false)
    private Book book;
    
    @PrePersist
    public void prePersist() {
        this.addedDate = LocalDateTime.now();
    }
    
    // 수량 증가
    public void increaseQuantity(int amount) {
        this.quantity += amount;
    }
    
    // 수량 감소
    public void decreaseQuantity(int amount) {
        if (this.quantity <= amount) {
            this.quantity = 0;
        } else {
            this.quantity -= amount;
        }
    }
}

