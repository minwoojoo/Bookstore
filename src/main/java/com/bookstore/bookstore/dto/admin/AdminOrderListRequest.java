package com.bookstore.bookstore.dto.admin;

import lombok.Data;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder.Default;

import java.time.LocalDate;

/**
 * 관리자 주문 목록 조회 요청 DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AdminOrderListRequest {
    
    // 페이징
    @Builder.Default
    private int page = 0;
    @Builder.Default
    private int size = 30;
    
    // 검색 조건
    private String memberName;          // 주문자 이름
    private String bookTitle;           // 책 이름
    private String publisher;           // 출판사
    private String author;              // 저자
    private String saleStatus;          // 판매상태
    private LocalDate startDate;        // 등록일 시작
    private LocalDate endDate;          // 등록일 종료
    private Long memberId;              // 회원 ID (회원별 주문 조회용)
    
    // 정렬 조건
    @Builder.Default
    private String sortBy = "orderDate"; // 정렬 기준 (orderDate, memberId, totalAmount, orderStatus)
    @Builder.Default
    private String sortDirection = "desc"; // 정렬 방향 (asc, desc)
    
    /**
     * 정렬 조건을 Spring Data JPA Sort 형식으로 변환
     */
    public String getSortProperty() {
        switch (sortBy) {
            case "orderDate":
                return "orderDate";
            case "memberId":
                return "memberId";
            case "totalAmount":
                return "totalAmount";
            case "orderStatus":
                return "orderStatus";
            default:
                return "orderDate";
        }
    }
    
    /**
     * 정렬 방향을 Spring Data JPA Direction으로 변환
     */
    public boolean isAscending() {
        return "asc".equalsIgnoreCase(sortDirection);
    }
}
