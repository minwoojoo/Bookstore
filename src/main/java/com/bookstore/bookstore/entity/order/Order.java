package com.bookstore.bookstore.entity.order;

import com.bookstore.bookstore.entity.customer.Member;
import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "`order`")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Order {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "order_id")
    private Long orderId;
    
    @Column(name = "member_id", nullable = false)
    private Long memberId;
    
    @Column(name = "total_amount", nullable = false)
    private Integer totalAmount;
    
    @Column(name = "discount_amount")
    private Integer discountAmount;
    
    @Column(name = "final_payment_amount", nullable = false)
    private Integer finalPaymentAmount;
    
    @Column(name = "order_status", length = 50, nullable = false)
    private String orderStatus;
    
    @Column(name = "recipient_name", length = 100, nullable = false)
    private String recipientName;
    
    @Column(name = "recipient_phone", length = 50, nullable = false)
    private String recipientPhone;
    
    @Column(name = "delivery_address", length = 1000, nullable = false)
    private String deliveryAddress;
    
    @Column(name = "memo", length = 500)
    private String memo;
    
    @Column(name = "order_date", nullable = false)
    private LocalDateTime orderDate;
    
    // 회원과의 관계
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "member_id", nullable = false, insertable = false, updatable = false)
    private Member member;
    
    // 주문 상품과의 관계
    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL)
    @Builder.Default
    private List<OrderItem> orderItems = new ArrayList<>();
    
    // 결제와의 관계
    @OneToOne(mappedBy = "order", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Payment payment;
    
    // 주문 상태 이력과의 관계
    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL)
    @Builder.Default
    private List<OrderStatusHistory> statusHistories = new ArrayList<>();
}

