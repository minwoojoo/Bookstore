package com.bookstore.bookstore.dto.admin;

import lombok.Data;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 관리자 회원 상세 조회 응답 DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AdminMemberDetailResponse {
    
    private Long memberId;
    private String memberName;              // 회원 이름
    private String email;                   // 이메일
    private String phone;                   // 연락처
    private String memberStatus;            // 회원 상태 (활성, 비활성, 휴면, 탈퇴)
    private String memberGrade;             // 회원 등급
    private LocalDateTime createdAt;        // 가입일
    private LocalDateTime lastLoginAt;      // 최종 접속일
    private LocalDateTime updatedAt;        // 수정일
    
    // 주소 정보
    private List<AddressInfo> addresses;
    
    // 통계 정보
    private Long totalOrders;               // 총 주문 수
    private Long totalAmount;               // 총 주문 금액
    private Long totalReviews;              // 총 리뷰 수
    private Double averageRating;           // 평균 리뷰 평점
    
    // 최근 활동
    private LocalDateTime lastOrderDate;    // 최근 주문일
    private LocalDateTime lastReviewDate;   // 최근 리뷰 작성일
    
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class AddressInfo {
        private Long addressId;
        private String postCode;
        private String addressName;
        private String addressBasic;
        private String addressDetail;
        private String fullAddress;
        private Boolean isDefault;
    }
}
