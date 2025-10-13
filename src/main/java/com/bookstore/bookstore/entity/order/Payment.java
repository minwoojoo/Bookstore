package com.bookstore.bookstore.entity.order;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "payment")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Payment {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "payment_id")
    private Long paymentId;
    
    @Column(name = "order_id", nullable = false)
    private Long orderId;
    
    @Column(name = "payment_method", length = 50, nullable = false)
    private String paymentMethod;
    
    @Column(name = "payment_date")
    private LocalDateTime paymentDate;
    
    @Column(name = "transaction_id", length = 200)
    private String transactionId;
    
    @Column(name = "amount", nullable = false)
    private Integer amount;
    
    @Column(name = "status", length = 50, nullable = false)
    private String status;
    
    // 주문과의 관계 (1:1)
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "order_id", nullable = false, insertable = false, updatable = false)
    private Order order;
    
    @PrePersist
    public void prePersist() {
        if (this.status == null) {
            this.status = "PENDING";
        }
    }
}

