package com.bookstore.bookstore.entity.order;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "order_status_history")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OrderStatusHistory {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "history_id")
    private Long historyId;
    
    @Column(name = "order_id", nullable = false)
    private Long orderId;
    
    @Column(name = "admin_id")
    private Long adminId;
    
    @Column(name = "status_code", length = 50, nullable = false)
    private String statusCode;
    
    @Column(name = "changed_date", nullable = false)
    private LocalDateTime changedDate;
    
    @Column(name = "reason", length = 500)
    private String reason;
    
    // 주문과의 관계
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "order_id", nullable = false, insertable = false, updatable = false)
    private Order order;
    
    @PrePersist
    public void prePersist() {
        if (this.changedDate == null) {
            this.changedDate = LocalDateTime.now();
        }
    }
}