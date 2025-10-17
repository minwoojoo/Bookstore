package com.bookstore.bookstore.dto.admin;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;

/**
 * 관리자 도서 재고 관리 요청 DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AdminBookStockRequest {
    private Integer adjustment;    // 재고 조정량 (양수: 증가, 음수: 감소)
    private Integer newStock;      // 새로운 재고 수량
}
