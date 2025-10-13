package com.bookstore.bookstore.dto.admin;

import lombok.Data;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.time.LocalDateTime;

/**
 * 관리자 회원 목록 조회 응답 DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AdminMemberListResponse {
    
    private Long memberId;
    private String memberName;              // 회원 이름
    private String email;                   // 이메일
    private String phone;                   // 연락처
    private String memberStatus;            // 회원 상태
    private String memberGrade;             // 회원 등급
    private LocalDateTime createdAt;        // 가입일
    private LocalDateTime lastLoginAt;      // 최종 접속일
    
    // 통계 정보
    private Long totalOrders;               // 총 주문 수
    private Long totalAmount;               // 총 주문 금액
    private Long totalReviews;              // 총 리뷰 수
}
