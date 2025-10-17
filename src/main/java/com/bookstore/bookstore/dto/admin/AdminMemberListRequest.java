package com.bookstore.bookstore.dto.admin;

import lombok.Data;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder.Default;

import java.time.LocalDate;

/**
 * 관리자 회원 목록 조회 요청 DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AdminMemberListRequest {
    
    // 페이징
    @Builder.Default
    private int page = 0;
    @Builder.Default
    private int size = 30;
    
    // 검색 조건
    private String memberId;            // 회원 ID
    private String memberStatus;        // 회원 상태 (활성, 비활성, 휴면, 탈퇴)
    private String email;               // 이메일
    private LocalDate startDate;        // 가입일 시작
    private LocalDate endDate;          // 가입일 종료
    private String memberGrade;         // 회원 등급
    private String memberName;          // 회원 이름
    
    // 정렬 조건
    @Builder.Default
    private String sortBy = "memberId"; // 정렬 기준 (memberId, memberName, createdAt)
    @Builder.Default
    private String sortDirection = "asc"; // 정렬 방향 (asc, desc)
    
    /**
     * 정렬 조건을 Spring Data JPA Sort 형식으로 변환
     */
    public String getSortProperty() {
        switch (sortBy) {
            case "memberId":
                return "memberId";
            case "memberName":
                return "name";
            case "registrationDate":
                return "registrationDate";
            default:
                return "memberId";
        }
    }
    
    /**
     * 정렬 방향을 Spring Data JPA Direction으로 변환
     */
    public boolean isAscending() {
        return "asc".equalsIgnoreCase(sortDirection);
    }
}
