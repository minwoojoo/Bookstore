package com.bookstore.bookstore.controller.customer;

import com.bookstore.bookstore.dto.customer.MemberResponse;
import com.bookstore.bookstore.dto.customer.SignupRequest;
import com.bookstore.bookstore.enums.customer.CheckField;
import com.bookstore.bookstore.security.CustomUserDetails;
import com.bookstore.bookstore.service.customer.AuthService;
import com.bookstore.bookstore.service.customer.EmailVerificationService;
import com.bookstore.bookstore.service.customer.MemberService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * 인증 관련 REST API 컨트롤러
 * JSON 응답을 반환하는 API 엔드포인트
 */
@Slf4j
@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {
    
    private final AuthService authService;
    private final EmailVerificationService emailVerificationService;
    private final MemberService memberService;
    
    /**
     * 중복 확인 API (통합)
     * GET /api/auth/check?field=USER_ID&value=testuser
     * GET /api/auth/check?field=EMAIL&value=test@email.com
     */
    @GetMapping("/check")
    public ResponseEntity<?> check(
        @RequestParam("value") String value,
        @RequestParam(value = "field", required = false) CheckField field
    ) {
        // 기본값은 USER_ID
        CheckField target = field != null ? field : CheckField.USER_ID;
        boolean duplicate = isDuplicate(target, value);
        
        log.info("중복 확인: field={}, value={}, duplicate={}", target, value, duplicate);
        
        return ResponseEntity.ok(Map.of(
            "success", true,
            "field", target.asKey(),
            "duplicate", duplicate,
            "available", !duplicate,
            "message", duplicate ? 
                String.format("이미 사용 중인 %s입니다.", target.asKey()) : 
                String.format("사용 가능한 %s입니다.", target.asKey())
        ));
    }
    
    /**
     * 중복 확인 내부 로직
     */
    private boolean isDuplicate(CheckField target, String value) {
        return switch (target) {
            case USER_ID -> !authService.isUserIdAvailable(value);
            case EMAIL -> !authService.isEmailAvailable(value);
        };
    }
    
    /**
     * 회원가입 API
     * POST /api/auth/signup
     */
    @PostMapping("/signup")
    public ResponseEntity<?> signup(@Valid @RequestBody SignupRequest request, BindingResult bindingResult) {
        log.info("API 회원가입 요청: userId = {}", request.getUserId());
        
        // 유효성 검사 실패
        if (bindingResult.hasErrors()) {
            Map<String, String> errors = new HashMap<>();
            bindingResult.getFieldErrors().forEach(error -> 
                errors.put(error.getField(), error.getDefaultMessage())
            );
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", "입력값이 올바르지 않습니다.",
                "errors", errors
            ));
        }
        
        try {
            MemberResponse member = authService.signup(request);
            log.info("API 회원가입 성공: memberId = {}", member.getMemberId());
            
            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "회원가입이 완료되었습니다.",
                "data", member
            ));
            
        } catch (IllegalArgumentException e) {
            log.error("API 회원가입 실패: {}", e.getMessage());
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", e.getMessage()
            ));
        }
    }
    
    /**
     * 현재 로그인한 사용자 정보 조회 API
     * GET /api/auth/me
     */
    @GetMapping("/me")
    public ResponseEntity<?> getCurrentMember(@AuthenticationPrincipal CustomUserDetails userDetails) {
        if (userDetails == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of(
                "success", false,
                "message", "로그인이 필요합니다."
            ));
        }
        
        MemberResponse member = memberService.getMemberInfo(userDetails.getMemberId());
        return ResponseEntity.ok(Map.of(
            "success", true,
            "data", member
        ));
    }
    
    /**
     * 아이디 중복 확인 API (레거시 호환용)
     * GET /api/auth/check-userid?userId=test123
     * @deprecated /api/auth/check 사용 권장
     */
    @Deprecated
    @GetMapping("/check-userid")
    public ResponseEntity<?> checkUserId(@RequestParam String userId) {
        boolean available = authService.isUserIdAvailable(userId);
        return ResponseEntity.ok(Map.of(
            "success", true,
            "available", available,
            "duplicate", !available,
            "message", available ? "사용 가능한 아이디입니다." : "이미 사용 중인 아이디입니다."
        ));
    }
    
    /**
     * 이메일 중복 확인 API (레거시 호환용)
     * GET /api/auth/check-email?email=test@example.com
     * @deprecated /api/auth/check 사용 권장
     */
    @Deprecated
    @GetMapping("/check-email")
    public ResponseEntity<?> checkEmail(@RequestParam String email) {
        boolean available = authService.isEmailAvailable(email);
        return ResponseEntity.ok(Map.of(
            "success", true,
            "available", available,
            "duplicate", !available,
            "message", available ? "사용 가능한 이메일입니다." : "이미 사용 중인 이메일입니다."
        ));
    }
    
    /**
     * 이메일 인증번호 발송 API
     * POST /api/auth/send-verification
     * 
     * 회원가입: 모든 중복 이메일 체크
     * 마이페이지: 자신의 현재 이메일 제외하고 중복 체크
     */
    @PostMapping("/send-verification")
    public ResponseEntity<?> sendVerificationCode(
        @RequestBody Map<String, String> request,
        @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        String email = request.get("email");
        log.info("이메일 인증번호 발송 요청: email={}, 로그인 여부={}", email, userDetails != null);
        
        if (email == null || email.trim().isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", "이메일을 입력해주세요."
            ));
        }
        
        // 1. 이메일 중복 확인
        if (userDetails != null) {
            // 로그인한 사용자 (마이페이지): 자신의 현재 이메일 제외하고 중복 체크
            MemberResponse currentMember = memberService.getMemberInfo(userDetails.getMemberId());
            
            // 입력한 이메일이 자신의 현재 이메일이 아닌 경우에만 중복 체크
            if (!email.equals(currentMember.getEmail()) && !authService.isEmailAvailable(email)) {
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "이미 다른 사용자가 사용 중인 이메일입니다."
                ));
            }
        } else {
            // 비로그인 사용자 (회원가입): 모든 중복 이메일 체크
            if (!authService.isEmailAvailable(email)) {
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "이미 사용 중인 이메일입니다."
                ));
            }
        }
        
        // 2. 인증번호 발송
        boolean sent = emailVerificationService.sendVerificationCode(email);
        
        if (sent) {
            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "인증번호가 이메일로 발송되었습니다. (유효시간: 5분)"
            ));
        } else {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of(
                "success", false,
                "message", "이메일 발송에 실패했습니다. 잠시 후 다시 시도해주세요."
            ));
        }
    }
    
    /**
     * 이메일 인증번호 검증 API
     * POST /api/auth/verify-email
     */
    @PostMapping("/verify-email")
    public ResponseEntity<?> verifyEmail(@RequestBody Map<String, String> request) {
        String email = request.get("email");
        String code = request.get("code");
        
        log.info("이메일 인증번호 검증 요청: email={}, code={}", email, code);
        
        if (email == null || email.trim().isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", "이메일을 입력해주세요."
            ));
        }
        
        if (code == null || code.trim().isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", "인증 코드를 입력해주세요."
            ));
        }
        
        boolean verified = emailVerificationService.verifyCode(email, code);
        
        if (verified) {
            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "이메일 인증이 완료되었습니다."
            ));
        } else {
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", "인증번호가 일치하지 않거나 만료되었습니다."
            ));
        }
    }
    
    /**
     * 비밀번호 재설정 인증번호 발송 API
     * POST /api/auth/send-password-reset?name=홍길동&email=test@email.com
     */
    @PostMapping("/send-password-reset")
    public ResponseEntity<?> sendPasswordReset(
        @RequestParam String name,
        @RequestParam String email
    ) {
        log.info("비밀번호 재설정 인증번호 발송 요청: name={}, email={}", name, email);
        
        try {
            // 1. 이름과 이메일로 회원 조회
            authService.findMemberByNameAndEmail(name, email);
            
            // 2. 인증번호 발송
            boolean sent = emailVerificationService.sendPasswordResetCode(email, name);
            
            if (sent) {
                return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "인증번호가 이메일로 발송되었습니다. (유효시간: 5분)"
                ));
            } else {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of(
                    "success", false,
                    "message", "이메일 발송에 실패했습니다. 잠시 후 다시 시도해주세요."
                ));
            }
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", e.getMessage()
            ));
        }
    }
    
    /**
     * 비밀번호 재설정 인증번호 검증 API
     * POST /api/auth/verify-password-reset?email=test@email.com&code=123456
     */
    @PostMapping("/verify-password-reset")
    public ResponseEntity<?> verifyPasswordReset(
        @RequestParam String email,
        @RequestParam String code
    ) {
        log.info("비밀번호 재설정 인증번호 검증 요청: email={}, code={}", email, code);
        
        boolean verified = emailVerificationService.verifyCode(email, code);
        
        if (verified) {
            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "인증번호가 확인되었습니다. 새 비밀번호를 입력해주세요."
            ));
        } else {
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", "인증번호가 일치하지 않거나 만료되었습니다."
            ));
        }
    }
    
    /**
     * 비밀번호 재설정 API
     * POST /api/auth/reset-password
     */
    @PostMapping("/reset-password")
    public ResponseEntity<?> resetPassword(@RequestBody Map<String, String> request) {
        String email = request.get("email");
        String newPassword = request.get("newPassword");
        
        log.info("비밀번호 재설정 요청: email={}", email);
        
        if (email == null || newPassword == null) {
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", "이메일과 새 비밀번호를 입력해주세요."
            ));
        }
        
        try {
            authService.resetPassword(email, newPassword);
            
            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "비밀번호가 성공적으로 변경되었습니다."
            ));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", e.getMessage()
            ));
        }
    }
    
}