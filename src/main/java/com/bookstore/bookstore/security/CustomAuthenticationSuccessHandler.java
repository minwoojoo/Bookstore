package com.bookstore.bookstore.security;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;
import org.springframework.web.util.UriComponentsBuilder;

import java.io.IOException;

/**
 * 로그인 성공 후 처리 핸들러
 * 원래 접근하려던 페이지로 리다이렉트
 */
@Slf4j
@Component
public class CustomAuthenticationSuccessHandler extends SavedRequestAwareAuthenticationSuccessHandler {
    
    @Override
    public void onAuthenticationSuccess(
            HttpServletRequest request, 
            HttpServletResponse response, 
            Authentication authentication
    ) throws ServletException, IOException {
        
        log.info("로그인 성공: 사용자 = {}", authentication.getName());
        
        // 폼에서 전달된 redirectUrl 파라미터 확인
        String redirectUrl = request.getParameter("redirectUrl");
        
        if (redirectUrl != null && !redirectUrl.isEmpty()) {
            // 폼에서 전달된 redirectUrl이 있으면 해당 URL로 리다이렉트
            log.info("폼에서 전달된 리다이렉트 URL로 이동: {}", redirectUrl);
            response.sendRedirect(redirectUrl);
            return;
        }
        
        // SavedRequestAwareAuthenticationSuccessHandler의 기본 동작 사용
        // 이는 Spring Security가 저장한 원래 요청 URL로 리다이렉트합니다
        super.onAuthenticationSuccess(request, response, authentication);
    }
}
