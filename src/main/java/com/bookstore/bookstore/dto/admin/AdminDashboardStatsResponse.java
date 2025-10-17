package com.bookstore.bookstore.dto.admin;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * 관리자 대시보드 통계 응답 DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AdminDashboardStatsResponse {
    
    /**
     * 총 도서 수
     */
    private Long totalBooks;
    
    /**
     * 총 주문 수
     */
    private Long totalOrders;
    
    /**
     * 총 회원 수
     */
    private Long totalMembers;
    
    /**
     * 총 매출액
     */
    private BigDecimal totalSales;
    
    /**
     * 오늘 주문 수
     */
    private Long todayOrders;
    
    /**
     * 오늘 매출액
     */
    private BigDecimal todaySales;
    
    /**
     * 이번 달 주문 수
     */
    private Long monthlyOrders;
    
    /**
     * 이번 달 매출액
     */
    private BigDecimal monthlySales;
    
    /**
     * 판매중인 도서 수
     */
    private Long activeBooks;
    
    /**
     * 재고 부족 도서 수 (재고 10개 이하)
     */
    private Long lowStockBooks;
    
    /**
     * 활성 회원 수 (최근 30일 내 활동)
     */
    private Long activeMembers;
}
