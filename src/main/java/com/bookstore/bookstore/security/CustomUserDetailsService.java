package com.bookstore.bookstore.security;

import com.bookstore.bookstore.entity.customer.Member;
import com.bookstore.bookstore.repository.customer.MemberRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Spring Security의 UserDetailsService 구현
 * 사용자 정보를 데이터베이스에서 조회하는 서비스
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {
    
    private final MemberRepository memberRepository;
    
    /**
     * 사용자 ID로 사용자 정보를 조회
     * Spring Security가 로그인 시 자동으로 호출
     * 
     * @param userId 사용자가 입력한 아이디
     * @return UserDetails 구현체
     * @throws UsernameNotFoundException 사용자를 찾을 수 없을 때
     */
    @Override
    @Transactional(readOnly = true)
    public UserDetails loadUserByUsername(String userId) throws UsernameNotFoundException {
        log.info("로그인 시도: userId = {}", userId);
        
        // 데이터베이스에서 사용자 조회
        Member member = memberRepository.findByUserId(userId)
            .orElseThrow(() -> {
                log.warn("사용자를 찾을 수 없음: userId = {}", userId);
                return new UsernameNotFoundException("사용자를 찾을 수 없습니다: " + userId);
            });
        
        // 계정 상태 확인
        if (!"ACTIVE".equals(member.getStatus())) {
            log.warn("비활성화된 계정: userId = {}", userId);
            throw new UsernameNotFoundException("비활성화된 계정입니다: " + userId);
        }
        
        log.info("사용자 조회 성공: userId = {}, name = {}", userId, member.getName());
        
        // CustomUserDetails로 감싸서 반환
        return new CustomUserDetails(member);
    }
}
