package com.bookstore.bookstore.dto.performance;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 성능 테스트용 도서 DTO
 * 순환 참조 없이 깔끔한 JSON 응답을 위한 DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class BookPerformanceDto {
    private Long bookId;
    private String isbn;
    private String title;
    private String description;
    private Integer width;
    private Integer height;
    private Integer pageCount;
    private String thumbnailUrl;
    private String previewUrl;
    private BigDecimal ratingAvg;
    private String bookStatus;
    private LocalDateTime registrationDate;
    private BigDecimal price;
    private String publisher;
    private Integer salesCount;
    private Integer monthlySales;
    private LocalDateTime lastSalesUpdate;
    
    // 카테고리 정보 (순환 참조 없이)
    private CategoryInfo category;
    
    // 저자 정보 (순환 참조 없이)
    private List<AuthorInfo> authors;
    
    // 재고 정보
    private StockInfo stock;
    
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class CategoryInfo {
        private Long categoryId;
        private String categoryName;
        private Integer level;
        private Long parentId;
        private String parentName;
    }
    
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class AuthorInfo {
        private Long authorId;
        private String name;
        private String description;
        private Integer authorOrder;
    }
    
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class StockInfo {
        private Long stockId;
        private Integer quantity;
        private LocalDateTime lastUpdated;
    }
}
