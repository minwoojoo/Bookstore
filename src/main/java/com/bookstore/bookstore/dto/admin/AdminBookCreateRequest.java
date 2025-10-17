package com.bookstore.bookstore.dto.admin;

import lombok.Data;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import jakarta.validation.constraints.*;
import java.math.BigDecimal;

/**
 * 관리자 상품 등록 요청 DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AdminBookCreateRequest {
    
    // 기본 정보
    @NotBlank(message = "ISBN은 필수입니다")
    @Size(max = 20, message = "ISBN은 20자 이하여야 합니다")
    private String isbn;
    
    @NotBlank(message = "책 제목은 필수입니다")
    @Size(max = 500, message = "책 제목은 500자 이하여야 합니다")
    private String title;
    
    @NotBlank(message = "출판사는 필수입니다")
    @Size(max = 200, message = "출판사는 200자 이하여야 합니다")
    private String publisher;
    
    // 저자 정보 (쉼표로 구분된 문자열)
    @NotBlank(message = "저자는 필수입니다")
    private String authors;
    
    // 가격 및 판매 정보
    @NotNull(message = "가격은 필수입니다")
    @DecimalMin(value = "0.0", message = "가격은 0 이상이어야 합니다")
    private BigDecimal price;
    
    @Min(value = 0, message = "판매지수는 0 이상이어야 합니다")
    private Integer salesCount;
    
    @Min(value = 0, message = "월간 판매량은 0 이상이어야 합니다")
    private Integer monthlySales;
    
    // 물리적 정보
    @Min(value = 1, message = "페이지 수는 1 이상이어야 합니다")
    private Integer pageCount;
    
    @Min(value = 1, message = "가로는 1 이상이어야 합니다")
    private Integer width;
    
    @Min(value = 1, message = "세로는 1 이상이어야 합니다")
    private Integer height;
    
    // 미디어 정보
    @Size(max = 500, message = "썸네일 URL은 500자 이하여야 합니다")
    private String thumbnailUrl;
    
    @Size(max = 500, message = "미리보기 URL은 500자 이하여야 합니다")
    private String previewUrl;
    
    // 설명 및 상태
    @Size(max = 10000, message = "상세 설명은 10000자 이하여야 합니다")
    private String description;
    
    @DecimalMin(value = "0.0", message = "평점은 0 이상이어야 합니다")
    @DecimalMax(value = "5.0", message = "평점은 5 이하여야 합니다")
    private BigDecimal ratingAvg;
    
    @NotBlank(message = "책 상태는 필수입니다")
    private String bookStatus;
    
    // 카테고리
    @NotNull(message = "카테고리는 필수입니다")
    private Long categoryId;
    
    // 재고 정보
    @Min(value = 0, message = "재고 수량은 0 이상이어야 합니다")
    private Integer stockQuantity;
    
    // 크기 정보를 문자열로 변환하는 헬퍼 메서드
    public String getSizeInfo() {
        if (width != null && height != null) {
            return width + " x " + height + " mm";
        }
        return "";
    }
}
