package com.bookstore.bookstore.security;

import com.bookstore.bookstore.entity.customer.Member;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.Collections;

/**
 * Spring Security의 UserDetails 구현
 * 인증된 사용자 정보를 담는 객체
 */
@Getter
@RequiredArgsConstructor
public class CustomUserDetails implements UserDetails {
    
    private final Member member;
    
    /**
     * 사용자의 권한 목록 반환
     * 예: ROLE_USER, ROLE_ADMIN
     */
    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        // Member의 memberGrade를 권한으로 변환
        // "BRONZE" -> "ROLE_USER"
        return Collections.singletonList(
            new SimpleGrantedAuthority("ROLE_USER")
        );
    }
    
    /**
     * 사용자의 비밀번호 반환
     */
    @Override
    public String getPassword() {
        return member.getPassword();
    }
    
    /**
     * 사용자의 아이디 반환
     */
    @Override
    public String getUsername() {
        return member.getUserId();
    }
    
    /**
     * 계정 만료 여부
     * true: 만료 안됨
     */
    @Override
    public boolean isAccountNonExpired() {
        return true;
    }
    
    /**
     * 계정 잠금 여부
     * true: 잠금 안됨
     */
    @Override
    public boolean isAccountNonLocked() {
        return true;
    }
    
    /**
     * 비밀번호 만료 여부
     * true: 만료 안됨
     */
    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }
    
    /**
     * 계정 활성화 여부
     * true: 활성화됨
     */
    @Override
    public boolean isEnabled() {
        // Member의 status 필드 확인
        return "ACTIVE".equals(member.getStatus());
    }
    
    /**
     * Member 엔티티 반환 (비즈니스 로직에서 사용)
     */
    public Member getMember() {
        return member;
    }
    
    /**
     * Member ID 반환
     */
    public Long getMemberId() {
        return member.getMemberId();
    }
    
    /**
     * Member 이름 반환
     */
    public String getName() {
        return member.getName();
    }
}
