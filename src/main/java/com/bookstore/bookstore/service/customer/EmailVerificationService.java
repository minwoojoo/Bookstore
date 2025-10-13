package com.bookstore.bookstore.service.customer;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 이메일 인증번호 관리 서비스
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class EmailVerificationService {

    private final EmailService emailService;
    
    // 인증번호 저장소 (이메일 -> 인증정보)
    private final Map<String, VerificationInfo> verificationStore = new ConcurrentHashMap<>();
    
    /**
     * 인증번호 생성 및 이메일 발송 (회원가입용)
     * 
     * @param email 수신자 이메일
     * @return 성공 여부
     */
    public boolean sendVerificationCode(String email) {
        try {
            // 6자리 인증번호 생성
            String code = generateVerificationCode();
            
            // 인증정보 저장 (5분 유효)
            VerificationInfo info = new VerificationInfo(code, LocalDateTime.now().plusMinutes(5));
            verificationStore.put(email, info);
            
            // 이메일 발송
            emailService.sendEmailVerification(email, code);
            
            log.info("이메일 인증번호 발송 완료: email={}, code={}, expiresAt={}", 
                     email, code, info.expiresAt);
            return true;
            
        } catch (Exception e) {
            log.error("이메일 인증번호 발송 실패: email={}, error={}", email, e.getMessage(), e);
            return false;
        }
    }
    
    /**
     * 비밀번호 재설정 인증번호 발송
     * 
     * @param email 수신자 이메일
     * @param userId 사용자 아이디 또는 이름
     * @return 성공 여부
     */
    public boolean sendPasswordResetCode(String email, String userId) {
        try {
            // 6자리 인증번호 생성
            String code = generateVerificationCode();
            
            // 인증정보 저장 (5분 유효)
            VerificationInfo info = new VerificationInfo(code, LocalDateTime.now().plusMinutes(5));
            verificationStore.put(email, info);
            
            // 이메일 발송
            emailService.sendPasswordResetEmail(email, userId, code);
            
            log.info("비밀번호 재설정 인증번호 발송 완료: email={}, code={}, expiresAt={}", 
                     email, code, info.expiresAt);
            return true;
            
        } catch (Exception e) {
            log.error("비밀번호 재설정 인증번호 발송 실패: email={}, error={}", email, e.getMessage(), e);
            return false;
        }
    }
    
    /**
     * 인증번호 검증
     * 
     * @param email 이메일
     * @param code 인증번호
     * @return 검증 성공 여부
     */
    public boolean verifyCode(String email, String code) {
        VerificationInfo info = verificationStore.get(email);
        
        if (info == null) {
            log.warn("인증번호 검증 실패: 발송된 인증번호 없음 - email={}", email);
            return false;
        }
        
        // 만료 시간 확인
        if (LocalDateTime.now().isAfter(info.expiresAt)) {
            log.warn("인증번호 검증 실패: 만료됨 - email={}, expiresAt={}", email, info.expiresAt);
            verificationStore.remove(email);
            return false;
        }
        
        // 인증번호 확인
        if (!info.code.equals(code)) {
            log.warn("인증번호 검증 실패: 코드 불일치 - email={}", email);
            return false;
        }
        
        // 검증 성공 - 인증정보 삭제
        verificationStore.remove(email);
        log.info("인증번호 검증 성공: email={}", email);
        return true;
    }
    
    /**
     * 6자리 랜덤 인증번호 생성
     */
    private String generateVerificationCode() {
        SecureRandom random = new SecureRandom();
        int code = 100000 + random.nextInt(900000); // 100000 ~ 999999
        return String.valueOf(code);
    }
    
    /**
     * 인증 정보 내부 클래스
     */
    private static class VerificationInfo {
        String code;
        LocalDateTime expiresAt;
        
        VerificationInfo(String code, LocalDateTime expiresAt) {
            this.code = code;
            this.expiresAt = expiresAt;
        }
    }
}

