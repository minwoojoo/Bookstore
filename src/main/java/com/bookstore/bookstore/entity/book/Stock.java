package com.bookstore.bookstore.entity.book;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

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
    
    @Column(name = "last_updated")
    private LocalDateTime lastUpdated;
    
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
        this.lastUpdated = LocalDateTime.now();
    }
    
    // 재고 증가 메서드
    public void increaseStock(int quantity) {
        this.quantity += quantity;
        this.lastUpdated = LocalDateTime.now();
    }
    
    // getStockId() 메서드 (bookId를 stockId로 사용)
    public Long getStockId() {
        return this.bookId;
    }
    
    // getLastUpdated() 메서드
    public LocalDateTime getLastUpdated() {
        return this.lastUpdated;
    }
}

