package com.bookstore.bookstore.dto.customer;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 회원 주소 정보 응답 DTO
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MemberAddressResponse {
    
    private Long addressId;
    private String postCode;
    private String addressName;
    private String addressBasic;
    private String addressDetail;
    
    /**
     * 전체 주소 반환
     */
    public String getFullAddress() {
        StringBuilder sb = new StringBuilder();
        if (addressBasic != null) {
            sb.append(addressBasic);
        }
        if (addressDetail != null && !addressDetail.isEmpty()) {
            if (sb.length() > 0) {
                sb.append(" ");
            }
            sb.append(addressDetail);
        }
        return sb.toString();
    }
}

