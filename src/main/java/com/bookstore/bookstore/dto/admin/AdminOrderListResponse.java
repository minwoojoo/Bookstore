package com.bookstore.bookstore.dto.admin;

import lombok.Data;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 관리자 주문 목록 조회 응답 DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AdminOrderListResponse {
    
    private Long orderId;
    private Long memberId;
    private String memberName;              // 주문자 이름
    private String memberEmail;             // 주문자 이메일
    private BigDecimal totalAmount;         // 주문 금액
    private BigDecimal discountAmount;      // 할인 금액
    private BigDecimal finalPaymentAmount;  // 최종 결제 금액
    private String orderStatus;             // 주문 상태
    private String recipientName;           // 수령인 이름
    private String recipientPhone;          // 수령인 연락처
    private String deliveryAddress;         // 배송 주소
    private String memo;                    // 배송 메모
    private String orderDate;        // 주문일 (포맷된 문자열)
    private String updatedAt;        // 수정일 (포맷된 문자열)
    
    // 주문 아이템 정보
    private List<OrderItemInfo> orderItems;
    
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class OrderItemInfo {
        private Long orderItemId;
        private Long bookId;
        private String bookTitle;
        private String bookAuthor;
        private String publisher;
        private String thumbnailUrl;
        private Integer quantity;
        private BigDecimal price;
        private BigDecimal totalPrice;
    }
}
