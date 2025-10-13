package com.bookstore.bookstore.controller.customer;

import com.bookstore.bookstore.dto.customer.MemberResponse;
import com.bookstore.bookstore.dto.customer.MemberAddressResponse;
import com.bookstore.bookstore.security.CustomUserDetails;
import com.bookstore.bookstore.service.customer.MemberService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 회원 정보 관리 REST API 컨트롤러
 */
@Slf4j
@RestController
@RequestMapping("/api/mypage")
@RequiredArgsConstructor
public class MemberController {
    
    private final MemberService memberService;
    
    /**
     * 마이페이지 - 사용자 정보 조회 API
     * GET /api/mypage/info
     */
    @GetMapping("/info")
    public ResponseEntity<?> getMyInfo(@AuthenticationPrincipal CustomUserDetails userDetails) {
        if (userDetails == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of(
                "success", false,
                "message", "로그인이 필요합니다."
            ));
        }
        
        try {
            MemberResponse member = memberService.getMemberInfo(userDetails.getMemberId());
            return ResponseEntity.ok(member);
        } catch (Exception e) {
            log.error("사용자 정보 조회 실패: {}", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of(
                "success", false,
                "message", "정보를 불러올 수 없습니다."
            ));
        }
    }
    
    /**
     * 마이페이지 - 사용자 정보 수정 API
     * PUT /api/mypage/update
     */
    @PutMapping("/update")
    public ResponseEntity<?> updateMyInfo(
        @AuthenticationPrincipal CustomUserDetails userDetails,
        @RequestBody Map<String, String> request
    ) {
        if (userDetails == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of(
                "success", false,
                "message", "로그인이 필요합니다."
            ));
        }
        
        String name = request.get("name");
        String email = request.get("email");
        String phone = request.get("phone");
        
        log.info("사용자 정보 수정 요청: memberId={}, name={}, email={}, phone={}", 
                 userDetails.getMemberId(), name, email, phone);
        
        try {
            memberService.updateMemberInfo(userDetails.getMemberId(), name, email, phone);
            
            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "정보가 수정되었습니다."
            ));
        } catch (IllegalArgumentException e) {
            log.error("사용자 정보 수정 실패: {}", e.getMessage());
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", e.getMessage()
            ));
        }
    }
    
    /**
     * 주소 추가 API
     * POST /api/mypage/address
     */
    @PostMapping("/address")
    public ResponseEntity<?> addAddress(
            @RequestBody Map<String, String> addressData,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        
        log.info("주소 추가 API 호출됨: addressData = {}, userDetails = {}", addressData, userDetails);
        
        if (userDetails == null) {
            log.warn("인증되지 않은 사용자의 주소 추가 시도");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of(
                "success", false,
                "message", "로그인이 필요합니다."
            ));
        }
        
        try {
            log.info("주소 추가 서비스 호출: memberId = {}", userDetails.getMemberId());
            Long addressId = memberService.addAddress(
                userDetails.getMemberId(),
                addressData.get("addressName"),
                addressData.get("postCode"),
                addressData.get("addressBasic"),
                addressData.get("addressDetail")
            );
            
            log.info("주소 추가 성공: addressId = {}", addressId);
            return ResponseEntity.ok(Map.of(
                "success", true,
                "addressId", addressId,
                "message", "주소가 추가되었습니다."
            ));
        } catch (Exception e) {
            log.error("주소 추가 실패: {}", e.getMessage(), e);
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", e.getMessage()
            ));
        }
    }
    
    /**
     * 주소 수정 API
     * PUT /api/mypage/address/{addressId}
     */
    @PutMapping("/address/{addressId}")
    public ResponseEntity<?> updateAddress(
            @PathVariable Long addressId,
            @RequestBody Map<String, String> addressData,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        
        if (userDetails == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of(
                "success", false,
                "message", "로그인이 필요합니다."
            ));
        }
        
        try {
            memberService.updateAddress(
                userDetails.getMemberId(),
                addressId,
                addressData.get("addressName"),
                addressData.get("postCode"),
                addressData.get("addressBasic"),
                addressData.get("addressDetail")
            );
            
            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "주소가 수정되었습니다."
            ));
        } catch (Exception e) {
            log.error("주소 수정 실패: {}", e.getMessage());
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", e.getMessage()
            ));
        }
    }
    
    /**
     * 주소 삭제 API
     * DELETE /api/mypage/address/{addressId}
     */
    @DeleteMapping("/address/{addressId}")
    public ResponseEntity<?> deleteAddress(
            @PathVariable Long addressId,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        
        if (userDetails == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of(
                "success", false,
                "message", "로그인이 필요합니다."
            ));
        }
        
        try {
            memberService.deleteAddress(userDetails.getMemberId(), addressId);
            
            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "주소가 삭제되었습니다."
            ));
        } catch (Exception e) {
            log.error("주소 삭제 실패: {}", e.getMessage());
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", e.getMessage()
            ));
        }
    }
}

