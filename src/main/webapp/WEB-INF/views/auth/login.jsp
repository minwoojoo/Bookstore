<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인 - 온라인 서점</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f5f5f5; }
        .container { max-width: 400px; margin: 100px auto; padding: 40px; background: white; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { text-align: center; color: #333; margin-bottom: 30px; }
        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 5px; color: #555; font-weight: 500; }
        input[type="text"], input[type="password"] { 
            width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px; 
        }
        input:focus { outline: none; border-color: #4CAF50; }
        .error { color: #f44336; font-size: 14px; margin-bottom: 15px; text-align: center; padding: 10px; background: #ffebee; border-radius: 4px; }
        .success { color: #4CAF50; font-size: 14px; margin-bottom: 15px; text-align: center; padding: 10px; background: #e8f5e9; border-radius: 4px; }
        .remember-me { display: flex; align-items: center; margin-bottom: 20px; }
        .remember-me input { width: auto; margin-right: 8px; }
        .btn { width: 100%; padding: 14px; background: #4CAF50; color: white; border: none; border-radius: 4px; font-size: 16px; cursor: pointer; }
        .btn:hover { background: #45a049; }
        .link-group { text-align: center; margin-top: 20px; }
        .link-group a { color: #4CAF50; text-decoration: none; margin: 0 10px; }
        .link-group a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="container">
        <h1>로그인</h1>
        
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>
        
        <c:if test="${not empty message}">
            <div class="success">${message}</div>
        </c:if>
        
        <form action="/auth/login" method="post">
            <!-- 리다이렉트 URL을 hidden input으로 전달 -->
            <c:if test="${not empty redirectUrl}">
                <input type="hidden" name="redirectUrl" value="${redirectUrl}">
            </c:if>
            
            <div class="form-group">
                <label for="userId">아이디</label>
                <input type="text" id="userId" name="userId" required 
                       placeholder="아이디를 입력하세요" autofocus>
            </div>
            
            <div class="form-group">
                <label for="password">비밀번호</label>
                <input type="password" id="password" name="password" required 
                       placeholder="비밀번호를 입력하세요">
            </div>
            
            <div class="remember-me">
                <input type="checkbox" id="rememberUserId" name="rememberUserId">
                <label for="rememberUserId" style="margin: 0; font-weight: normal;">아이디 기억하기</label>
            </div>
            
            <button type="submit" class="btn">로그인</button>
        </form>
        
        <script>
            /**
             * 쿠키 저장
             */
            function setCookie(name, value, days) {
                let expires = "";
                if (days) {
                    const date = new Date();
                    date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
                    expires = "; expires=" + date.toUTCString();
                }
                document.cookie = name + "=" + (value || "") + expires + "; path=/";
            }
            
            /**
             * 쿠키 가져오기
             */
            function getCookie(name) {
                const nameEQ = name + "=";
                const ca = document.cookie.split(';');
                for (let i = 0; i < ca.length; i++) {
                    let c = ca[i];
                    while (c.charAt(0) === ' ') c = c.substring(1, c.length);
                    if (c.indexOf(nameEQ) === 0) return c.substring(nameEQ.length, c.length);
                }
                return null;
            }
            
            /**
             * 쿠키 삭제
             */
            function deleteCookie(name) {
                document.cookie = name + '=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';
            }
            
            /**
             * 페이지 로드 시 저장된 아이디 불러오기
             */
            window.addEventListener('DOMContentLoaded', function() {
                const savedUserId = getCookie('savedUserId');
                const userIdInput = document.getElementById('userId');
                const rememberCheckbox = document.getElementById('rememberUserId');
                
                if (savedUserId) {
                    userIdInput.value = savedUserId;
                    rememberCheckbox.checked = true;
                }
            });
            
            /**
             * 폼 제출 시 아이디 저장/삭제
             */
            document.querySelector('form').addEventListener('submit', function(e) {
                const userId = document.getElementById('userId').value;
                const rememberChecked = document.getElementById('rememberUserId').checked;
                
                if (rememberChecked) {
                    // 아이디를 30일 동안 저장
                    setCookie('savedUserId', userId, 30);
                } else {
                    // 저장된 아이디 삭제
                    deleteCookie('savedUserId');
                }
            });
        </script>
        
        <div class="link-group">
            <a href="/auth/signup">회원가입</a> |
            <a href="/auth/find-password">비밀번호 찾기</a>
        </div>
    </div>
</body>
</html>
