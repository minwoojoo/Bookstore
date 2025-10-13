package com.bookstore.bookstore.security;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {
    private final CustomUserDetailsService customUserDetailsService;
    private final CustomAuthenticationSuccessHandler customAuthenticationSuccessHandler;

    /**
     * 비밀번호 암호화를 위한 BCypt 인코더
     */
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    /**
     * AuthenticationManager를 빈으로 등록
     */
    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }

    /**
     * Spring Security 필터 체인 설정
     */
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            
            // 요청 권한 설정
            .authorizeHttpRequests(auth -> auth
                // 정적 리소스는 인증 불필요
                .requestMatchers(
                    "/css/**",
                    "/js/**",
                    "/images/**",
                    "/favicon.ico"
                ).permitAll()
                
                // 인증 없이 접근 가능한 페이지
                .requestMatchers(
                    "/",                      // 홈 페이지
                    "/auth/login",            // 로그인 페이지
                    "/auth/signup",           // 회원가입 페이지
                    "/auth/find-password",    // 비밀번호 찾기
                    "/books/**"               // 도서 목록, 상세, 카테고리, 검색 (로그인 불필요)
                ).permitAll()
                
                // 인증 없이 접근 가능한 API
                .requestMatchers(
                    "/api/auth/signup",
                    "/api/auth/check",
                    "/api/auth/check-userid",
                    "/api/auth/check-email",
                    "/api/auth/send-verification",
                    "/api/auth/verify-email",
                    "/api/auth/send-password-reset",
                    "/api/auth/verify-password-reset",
                    "/api/auth/reset-password",
                    "/api/books/**",
                    "/api/categories/**"
                ).permitAll()
                
                // 관리자 전용 페이지/API (인증 + ADMIN 역할 필요)
                .requestMatchers(
                    "/admin/**",
                    "/api/admin/**"
                ).hasRole("ADMIN")
                
                // 로그인 필요 페이지 (인증 필요)
                .requestMatchers(
                    "/mypage/**",
                    "/cart/**",
                    "/order/**"
                ).authenticated()
                
                // 로그인 필요 API (인증 필요)
                .requestMatchers(
                    "/api/mypage/**",
                    "/api/cart/**",
                    "/api/order/**"
                ).authenticated()
                
                // 나머지 요청은 모두 허용
                .anyRequest().permitAll()
            )
            
            // 폼 로그인 설정
            .formLogin(form -> form
                .loginPage("/auth/login")
                .loginProcessingUrl("/auth/login")
                .usernameParameter("userId")
                .passwordParameter("password")
                .successHandler(customAuthenticationSuccessHandler)
                .failureUrl("/auth/login?error=true")
                .permitAll()
            )
            
            // 로그아웃 설정
            .logout(logout -> logout
                .logoutUrl("/auth/logout")
                .logoutSuccessUrl("/")
                .invalidateHttpSession(true)
                .deleteCookies("JSESSIONID")
                .permitAll()
            );

        return http.build();
    }
       
}