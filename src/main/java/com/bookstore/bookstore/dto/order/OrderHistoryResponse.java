package com.bookstore.bookstore.dto.order;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrderHistoryResponse {
    private Long orderId;
    private LocalDateTime orderDate;
    private String orderStatus;
    private Integer totalAmount;
    private String recipientName;
    private String recipientPhone;
    private String deliveryAddress;
    private String memo;
    private List<OrderItemResponse> orderItems;
    
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class OrderItemResponse {
        private Long orderItemId;
        private Long bookId;
        private String bookTitle;
        private String bookAuthor;
        private String publisher;
        private String thumbnailUrl;
        private Integer quantity;
        private Integer price;
        private Integer totalPrice;
    }
}
