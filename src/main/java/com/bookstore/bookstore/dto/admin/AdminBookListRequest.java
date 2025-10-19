package com.bookstore.bookstore.dto.admin;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Builder.Default;

import java.time.LocalDate;

/**
 * 관리자 상품 목록 조회 요청 DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AdminBookListRequest {
    
    // 페이징
    @Builder.Default
    private int page = 0;
    @Builder.Default
    private int size = 30;
    
    // 검색 조건
    private String bookTitle;           // 책 이름
    private String publisher;           // 출판사
    private String author;              // 저자
    private Integer minStock;           // 최소 재고 수량
    private Integer maxStock;           // 최대 재고 수량
    private String saleStatus;          // 판매상태 (판매중, 절판, 일시품절, 입고예정)
    private LocalDate startDate;        // 등록일 시작
    private LocalDate endDate;          // 등록일 종료
    
    // 정렬 조건
    @Builder.Default
    private String sortBy = "bookId";   // 정렬 기준 (bookTitle, price, createdAt)
    @Builder.Default
    private String sortDirection = "desc"; // 정렬 방향 (asc, desc)
    
    /**
     * 정렬 조건을 Spring Data JPA Sort 형식으로 변환
     */
    public String getSortProperty() {
        if (sortBy == null) {
            return "bookId";
        }
        switch (sortBy) {
            case "bookTitle":
                return "title";
            case "price":
                return "price";
            case "createdAt":
                return "registrationDate";
            default:
                return "bookId";
        }
    }
    
    /**
     * 정렬 방향을 Spring Data JPA Direction으로 변환
     */
    public boolean isAscending() {
        return "asc".equalsIgnoreCase(sortDirection);
    }
}
