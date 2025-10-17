package com.bookstore.bookstore.dto.admin;

import lombok.Data;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 관리자 상품 상세 조회 응답 DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AdminBookDetailResponse {
    
    private Long bookId;
    private String isbn;
    private String title;
    private String publisher;
    private List<String> authors;           // 저자 목록
    private BigDecimal price;
    private Integer stock;                  // 재고 수량
    private String saleStatus;              // 판매상태
    private String thumbnailUrl;
    private String previewUrl;              // 미리보기 PDF URL
    private String description;             // 상세 설명
    private String bookSize;                // 책 크기
    private Double averageRating;           // 평균 평점
    private Integer reviewCount;            // 리뷰 수
    private Integer salesCount;             // 판매 수량
    private String categoryName;            // 카테고리명
    private String createdAt;        // 등록일 (포맷된 문자열)
    private String updatedAt;        // 수정일 (포맷된 문자열)
    
    // 통계 정보
    private Long totalOrders;               // 총 주문 수
    private BigDecimal totalSales;          // 총 판매액
    private Integer monthlySales;           // 월간 판매량
}
