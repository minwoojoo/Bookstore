package com.bookstore.bookstore.dto.admin;

import lombok.Data;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 관리자 주문 상세 조회 응답 DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AdminOrderDetailResponse {
    
    private Long orderId;
    private Long memberId;
    private String memberName;              // 주문자 이름
    private String memberEmail;             // 주문자 이메일
    private String memberPhone;             // 주문자 연락처
    private BigDecimal totalAmount;         // 주문 금액
    private BigDecimal discountAmount;      // 할인 금액
    private BigDecimal finalPaymentAmount;  // 최종 결제 금액
    private String orderStatus;             // 주문 상태
    private String recipientName;           // 수령인 이름
    private String recipientPhone;          // 수령인 연락처
    private String deliveryAddress;         // 배송 주소
    private String memo;                    // 배송 메모
    private LocalDateTime orderDate;        // 주문일
    private LocalDateTime updatedAt;        // 수정일
    
    // 결제 정보
    private PaymentInfo payment;
    
    // 주문 아이템 정보
    private List<OrderItemDetail> orderItems;
    
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class PaymentInfo {
        private Long paymentId;
        private String paymentKey;          // 토스페이먼츠 결제키
        private BigDecimal amount;          // 결제 금액
        private String paymentMethod;       // 결제 수단
        private String paymentStatus;       // 결제 상태
        private LocalDateTime paymentDate;  // 결제일
    }
    
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class OrderItemDetail {
        private Long orderItemId;
        private Long bookId;
        private String bookTitle;
        private String bookAuthor;
        private String publisher;
        private String thumbnailUrl;
        private Integer quantity;
        private BigDecimal price;
        private BigDecimal totalPrice;
        private String isbn;
        private String categoryName;
    }
}
