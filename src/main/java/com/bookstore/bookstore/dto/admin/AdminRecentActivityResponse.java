package com.bookstore.bookstore.dto.admin;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * 관리자 대시보드 최근 활동 응답 DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AdminRecentActivityResponse {
    
    /**
     * 활동 타입 (ORDER, MEMBER, STOCK)
     */
    private String activityType;
    
    /**
     * 활동 메시지
     */
    private String message;
    
    /**
     * 활동 시간
     */
    private LocalDateTime activityTime;
    
    /**
     * 관련 ID (주문 ID, 회원 ID, 도서 ID 등)
     */
    private Long relatedId;
    
    /**
     * 우선순위 (높을수록 중요)
     */
    private Integer priority;
}
