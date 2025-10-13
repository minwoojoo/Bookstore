package com.bookstore.bookstore.dto.customer;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 회원가입 요청 DTO
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SignupRequest {
    
    @NotBlank(message = "아이디는 필수입니다")
    @Size(min = 4, max = 20, message = "아이디는 4~20자여야 합니다")
    @Pattern(regexp = "^[a-zA-Z0-9]+$", message = "아이디는 영문자와 숫자만 사용 가능합니다")
    private String userId;
    
    @NotBlank(message = "비밀번호는 필수입니다")
    @Size(min = 8, max = 20, message = "비밀번호는 8~20자여야 합니다")
    @Pattern(regexp = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]+$", 
             message = "비밀번호는 영문, 숫자, 특수문자를 포함해야 합니다")
    private String password;
    
    @NotBlank(message = "비밀번호 확인은 필수입니다")
    private String passwordConfirm;
    
    @NotBlank(message = "이름은 필수입니다")
    @Size(min = 2, max = 50, message = "이름은 2~50자여야 합니다")
    private String name;
    
    @NotBlank(message = "이메일은 필수입니다")
    @Email(message = "올바른 이메일 형식이 아닙니다")
    private String email;
    
    @NotBlank(message = "연락처는 필수입니다")
    @Pattern(regexp = "^01(?:0|1|[6-9])-(?:\\d{3}|\\d{4})-\\d{4}$", 
             message = "올바른 휴대폰 번호 형식이 아닙니다 (예: 010-1234-5678)")
    private String phone;
    
    @NotBlank(message = "우편번호는 필수입니다")
    @Pattern(regexp = "^\\d{5}$", 
             message = "올바른 우편번호 형식이 아닙니다 (5자리 숫자)")
    private String postCode;
    
    @NotBlank(message = "기본 주소는 필수입니다")
    @Size(min = 5, max = 200, message = "주소는 5~200자여야 합니다")
    private String addressBasic;
    
    @Size(max = 200, message = "상세 주소는 200자 이내여야 합니다")
    private String addressDetail;
    
    @Size(max = 50, message = "주소 별칭은 50자 이내여야 합니다")
    private String addressName; // 예: "집", "회사"
    
    /**
     * 비밀번호 일치 여부 확인
     */
    public boolean isPasswordMatching() {
        return password != null && password.equals(passwordConfirm);
    }
    
    /**
     * 전체 주소 반환 (기본 + 상세)
     */
    public String getFullAddress() {
        if (addressDetail != null && !addressDetail.trim().isEmpty()) {
            return addressBasic + " " + addressDetail;
        }
        return addressBasic;
    }
}
