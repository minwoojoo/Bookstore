package com.bookstore.bookstore.entity.book;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "stock")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Stock {
    
    @Id
    @Column(name = "book_id")
    private Long bookId;
    
    @Column(name = "quantity", nullable = false)
    private Integer quantity;
    
    // 책과의 관계 (1:1)
    @OneToOne(fetch = FetchType.LAZY)
    @MapsId
    @JoinColumn(name = "book_id")
    private Book book;
    
    // 재고 감소 메서드
    public void decreaseStock(int quantity) {
        if (this.quantity < quantity) {
            throw new IllegalStateException("재고가 부족합니다.");
        }
        this.quantity -= quantity;
    }
    
    // 재고 증가 메서드
    public void increaseStock(int quantity) {
        this.quantity += quantity;
    }
}

