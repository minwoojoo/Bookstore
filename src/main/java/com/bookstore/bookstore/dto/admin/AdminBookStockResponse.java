package com.bookstore.bookstore.dto.admin;

import lombok.Builder;
import lombok.Getter;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 관리자 도서 재고 관리 응답 DTO
 */
@Getter
@Builder
public class AdminBookStockResponse {
    private Long bookId;
    private String title;
    private String isbn;
    private String publisher;
    private List<String> authors;
    private BigDecimal price;
    private Integer stock;
    private String saleStatus;
    private String thumbnailUrl;
    private List<StockHistoryItem> stockHistory;
    
    @Getter
    @Builder
    public static class StockHistoryItem {
        private Integer beforeQuantity;
        private Integer afterQuantity;
        private Integer adjustment;
        private LocalDateTime updatedAt;
    }
}
