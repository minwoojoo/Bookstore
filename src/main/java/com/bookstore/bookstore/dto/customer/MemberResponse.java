package com.bookstore.bookstore.dto.customer;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 회원 정보 응답 DTO
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MemberResponse {
    
    private Long memberId;
    private String userId;
    private String name;
    private String email;
    private String phone;
    private String memberGrade;
    private String status;
    private LocalDateTime registrationDate;
    private LocalDateTime lastLogin;
    private List<MemberAddressResponse> addresses;
}
