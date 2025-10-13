package com.bookstore.bookstore.config.init;

import com.bookstore.bookstore.entity.customer.Admin;
import com.bookstore.bookstore.repository.admin.AdminRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

/**
 * 관리자 초기 데이터 설정
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class AdminInitializer implements CommandLineRunner {
    
    private final AdminRepository adminRepository;
    private final PasswordEncoder passwordEncoder;
    
    @Override
    public void run(String... args) throws Exception {
        log.info("관리자 초기 데이터 설정 시작");
        
        // 기본 관리자 계정이 이미 존재하는지 확인
        if (adminRepository.existsByLoginId("admin")) {
            log.info("기본 관리자 계정이 이미 존재합니다.");
            return;
        }
        
        // 비밀번호 해시화
        String hashedPassword = passwordEncoder.encode("admin1234!");
        log.info("관리자 비밀번호 해시화 완료");
        
        // 기본 관리자 계정 생성
        Admin admin = Admin.builder()
                .loginId("admin")
                .password(hashedPassword)
                .name("시스템 관리자")
                .role("ADMIN")
                .isActive(true)
                .createdDate(LocalDateTime.now())
                .lastLoginDate(null)
                .build();
        
        adminRepository.save(admin);
        
        log.info("기본 관리자 계정 생성 완료: loginId=admin, name=시스템 관리자");
        log.info("관리자 초기 데이터 설정 완료");
    }
}
