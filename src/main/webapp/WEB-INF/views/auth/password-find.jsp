<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>비밀번호 찾기 - 온라인 서점</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f5f5f5; }
        .container { max-width: 500px; margin: 80px auto; padding: 40px; background: white; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { text-align: center; color: #333; margin-bottom: 10px; }
        .subtitle { text-align: center; color: #777; margin-bottom: 30px; font-size: 14px; }
        .step-indicator { display: flex; justify-content: space-between; margin-bottom: 30px; }
        .step { flex: 1; text-align: center; padding: 10px; color: #999; font-size: 13px; position: relative; }
        .step.active { color: #4CAF50; font-weight: bold; }
        .step.completed { color: #4CAF50; }
        .step::after { content: '→'; position: absolute; right: -10px; top: 10px; }
        .step:last-child::after { content: ''; }
        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 5px; color: #555; font-weight: 500; }
        input[type="text"], input[type="email"], input[type="password"] { 
            width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px; 
        }
        input:focus { outline: none; border-color: #4CAF50; }
        input:disabled, input:read-only { background: #f5f5f5; cursor: not-allowed; }
        .btn { width: 100%; padding: 14px; background: #4CAF50; color: white; border: none; border-radius: 4px; font-size: 16px; cursor: pointer; }
        .btn:hover { background: #45a049; }
        .btn:disabled { background: #ccc; cursor: not-allowed; }
        .btn-secondary { background: #2196F3; margin-top: 10px; }
        .btn-secondary:hover { background: #0b7dda; }
        .check-result { margin-top: 8px; font-size: 13px; padding: 8px; border-radius: 4px; }
        .check-result.success { color: #4CAF50; background: #e8f5e9; }
        .check-result.fail { color: #f44336; background: #ffebee; }
        .link-group { text-align: center; margin-top: 20px; }
        .link-group a { color: #4CAF50; text-decoration: none; margin: 0 10px; }
        .link-group a:hover { text-decoration: underline; }
        .section { display: none; }
        .section.active { display: block; }
    </style>
</head>
<body>
    <div class="container">
        <h1>비밀번호 찾기</h1>
        <p class="subtitle">가입하신 이메일로 인증하여 비밀번호를 재설정하세요</p>
        
        <!-- 진행 단계 표시 -->
        <div class="step-indicator">
            <div class="step active" id="step1">1. 정보 입력</div>
            <div class="step" id="step2">2. 이메일 인증</div>
            <div class="step" id="step3">3. 비밀번호 변경</div>
        </div>
        
        <!-- 1단계: 이름과 이메일 입력 -->
        <div id="section1" class="section active">
            <div class="form-group">
                <label for="name">이름</label>
                <input type="text" id="name" placeholder="가입 시 입력한 이름" required>
            </div>
            
            <div class="form-group">
                <label for="email">이메일</label>
                <input type="email" id="email" placeholder="가입 시 사용한 이메일" required>
            </div>
            
            <button type="button" class="btn" onclick="sendResetCode()">인증번호 발송</button>
            <div id="sendResult" class="check-result"></div>
        </div>
        
        <!-- 2단계: 인증번호 입력 -->
        <div id="section2" class="section">
            <div class="form-group">
                <label for="name2">이름</label>
                <input type="text" id="name2" readonly>
            </div>
            
            <div class="form-group">
                <label for="email2">이메일</label>
                <input type="email" id="email2" readonly>
            </div>
            
            <div class="form-group">
                <label for="verificationCode">인증번호</label>
                <div style="display: flex; gap: 10px;">
                    <input type="text" id="verificationCode" placeholder="6자리 인증번호" maxlength="6" style="flex: 1;">
                    <button type="button" class="btn" style="width: auto; padding: 12px 20px;" onclick="verifyResetCode()">
                        확인
                    </button>
                </div>
                <div id="verifyResult" class="check-result"></div>
            </div>
            
            <button type="button" class="btn-secondary btn" onclick="resendCode()">인증번호 재발송</button>
        </div>
        
        <!-- 3단계: 새 비밀번호 입력 -->
        <div id="section3" class="section">
            <div class="form-group">
                <label for="newPassword">새 비밀번호</label>
                <input type="password" id="newPassword" placeholder="8~20자 영문, 숫자, 특수문자" required>
                <div id="passwordCheck" class="check-result"></div>
            </div>
            
            <div class="form-group">
                <label for="newPasswordConfirm">비밀번호 확인</label>
                <input type="password" id="newPasswordConfirm" placeholder="비밀번호 재입력" required>
                <div id="passwordConfirmCheck" class="check-result"></div>
            </div>
            
            <button type="button" class="btn" onclick="resetPassword()">비밀번호 변경</button>
            <div id="resetResult" class="check-result"></div>
        </div>
        
        <div class="link-group">
            <a href="/auth/login">로그인</a> |
            <a href="/auth/signup">회원가입</a>
        </div>
    </div>
    
    <script>
        let currentEmail = '';
        let currentName = '';
        let verifiedForReset = false;
        
        /**
         * 비밀번호 재설정 인증번호 발송
         */
        async function sendResetCode() {
            const name = document.getElementById('name').value.trim();
            const email = document.getElementById('email').value.trim();
            const resultDiv = document.getElementById('sendResult');
            
            if (!name) {
                resultDiv.textContent = '이름을 입력해주세요.';
                resultDiv.className = 'check-result fail';
                return;
            }
            
            if (!email) {
                resultDiv.textContent = '이메일을 입력해주세요.';
                resultDiv.className = 'check-result fail';
                return;
            }
            
            // 이메일 형식 검사
            const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!regex.test(email)) {
                resultDiv.textContent = '올바른 이메일 형식이 아닙니다.';
                resultDiv.className = 'check-result fail';
                return;
            }
            
            try {
                const response = await fetch('/api/auth/send-password-reset?name=' + encodeURIComponent(name) + '&email=' + encodeURIComponent(email), {
                    method: 'POST'
                });
                const data = await response.json();
                
                if (data.success) {
                    resultDiv.textContent = '✓ ' + data.message;
                    resultDiv.className = 'check-result success';
                    
                    // 정보 저장
                    currentName = name;
                    currentEmail = email;
                    
                    // 2단계로 이동
                    setTimeout(() => {
                        goToStep(2);
                    }, 1000);
                } else {
                    resultDiv.textContent = '✗ ' + data.message;
                    resultDiv.className = 'check-result fail';
                }
            } catch (error) {
                console.error('인증번호 발송 오류:', error);
                resultDiv.textContent = '인증번호 발송 중 오류가 발생했습니다.';
                resultDiv.className = 'check-result fail';
            }
        }
        
        /**
         * 인증번호 재발송
         */
        function resendCode() {
            document.getElementById('name').value = currentName;
            document.getElementById('email').value = currentEmail;
            goToStep(1);
        }
        
        /**
         * 인증번호 검증
         */
        async function verifyResetCode() {
            const code = document.getElementById('verificationCode').value.trim();
            const resultDiv = document.getElementById('verifyResult');
            
            if (!code) {
                resultDiv.textContent = '인증번호를 입력해주세요.';
                resultDiv.className = 'check-result fail';
                return;
            }
            
            if (code.length !== 6) {
                resultDiv.textContent = '인증번호는 6자리입니다.';
                resultDiv.className = 'check-result fail';
                return;
            }
            
            try {
                const response = await fetch('/api/auth/verify-password-reset?email=' + encodeURIComponent(currentEmail) + '&code=' + encodeURIComponent(code), {
                    method: 'POST'
                });
                const data = await response.json();
                
                if (data.success) {
                    resultDiv.textContent = '✓ ' + data.message;
                    resultDiv.className = 'check-result success';
                    verifiedForReset = true;
                    
                    // 3단계로 이동
                    setTimeout(() => {
                        goToStep(3);
                    }, 1000);
                } else {
                    resultDiv.textContent = '✗ ' + data.message;
                    resultDiv.className = 'check-result fail';
                    verifiedForReset = false;
                }
            } catch (error) {
                console.error('인증번호 검증 오류:', error);
                resultDiv.textContent = '인증번호 검증 중 오류가 발생했습니다.';
                resultDiv.className = 'check-result fail';
                verifiedForReset = false;
            }
        }
        
        /**
         * 비밀번호 재설정
         */
        async function resetPassword() {
            const newPassword = document.getElementById('newPassword').value;
            const newPasswordConfirm = document.getElementById('newPasswordConfirm').value;
            const resultDiv = document.getElementById('resetResult');
            
            if (!verifiedForReset) {
                resultDiv.textContent = '이메일 인증을 먼저 완료해주세요.';
                resultDiv.className = 'check-result fail';
                return;
            }
            
            if (!validatePassword()) {
                resultDiv.textContent = '비밀번호 형식이 올바르지 않습니다.';
                resultDiv.className = 'check-result fail';
                return;
            }
            
            if (!validatePasswordConfirm()) {
                resultDiv.textContent = '비밀번호가 일치하지 않습니다.';
                resultDiv.className = 'check-result fail';
                return;
            }
            
            try {
                const response = await fetch('/api/auth/reset-password', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        email: currentEmail,
                        newPassword: newPassword
                    })
                });
                const data = await response.json();
                
                if (data.success) {
                    resultDiv.textContent = '✓ ' + data.message;
                    resultDiv.className = 'check-result success';
                    
                    // 로그인 페이지로 이동
                    setTimeout(() => {
                        window.location.href = '/auth/login?message=' + encodeURIComponent('비밀번호가 변경되었습니다. 새 비밀번호로 로그인해주세요.');
                    }, 1500);
                } else {
                    resultDiv.textContent = '✗ ' + data.message;
                    resultDiv.className = 'check-result fail';
                }
            } catch (error) {
                console.error('비밀번호 변경 오류:', error);
                resultDiv.textContent = '비밀번호 변경 중 오류가 발생했습니다.';
                resultDiv.className = 'check-result fail';
            }
        }
        
        /**
         * 단계 이동
         */
        function goToStep(step) {
            // 모든 섹션 숨기기
            document.querySelectorAll('.section').forEach(s => s.classList.remove('active'));
            document.querySelectorAll('.step').forEach(s => s.classList.remove('active', 'completed'));
            
            // 현재 단계 표시
            document.getElementById('section' + step).classList.add('active');
            document.getElementById('step' + step).classList.add('active');
            
            // 이전 단계 완료 표시
            for (let i = 1; i < step; i++) {
                document.getElementById('step' + i).classList.add('completed');
            }
            
            // 2단계로 이동 시 정보 복사
            if (step === 2) {
                document.getElementById('name2').value = currentName;
                document.getElementById('email2').value = currentEmail;
            }
        }
        
        /**
         * 비밀번호 유효성 검사
         */
        function validatePassword() {
            const password = document.getElementById('newPassword').value;
            const resultDiv = document.getElementById('passwordCheck');
            
            if (!password) {
                resultDiv.textContent = '';
                resultDiv.className = 'check-result';
                return false;
            }
            
            const errors = [];
            
            if (password.length < 8 || password.length > 20) {
                errors.push('8~20자');
            }
            
            if (!/[A-Za-z]/.test(password)) {
                errors.push('영문');
            }
            
            if (!/\d/.test(password)) {
                errors.push('숫자');
            }
            
            if (!/[@$!%*#?&]/.test(password)) {
                errors.push('특수문자(@$!%*#?&)');
            }
            
            if (errors.length > 0) {
                resultDiv.textContent = '✗ 다음 조건을 만족해야 합니다: ' + errors.join(', ');
                resultDiv.className = 'check-result fail';
                return false;
            } else {
                resultDiv.textContent = '✓ 안전한 비밀번호입니다.';
                resultDiv.className = 'check-result success';
                return true;
            }
        }
        
        /**
         * 비밀번호 확인 검사
         */
        function validatePasswordConfirm() {
            const password = document.getElementById('newPassword').value;
            const passwordConfirm = document.getElementById('newPasswordConfirm').value;
            const resultDiv = document.getElementById('passwordConfirmCheck');
            
            if (!passwordConfirm) {
                resultDiv.textContent = '';
                resultDiv.className = 'check-result';
                return false;
            }
            
            if (password !== passwordConfirm) {
                resultDiv.textContent = '✗ 비밀번호가 일치하지 않습니다.';
                resultDiv.className = 'check-result fail';
                return false;
            } else {
                resultDiv.textContent = '✓ 비밀번호가 일치합니다.';
                resultDiv.className = 'check-result success';
                return true;
            }
        }
        
        // 비밀번호 입력 시 실시간 검사
        document.getElementById('newPassword').addEventListener('input', validatePassword);
        document.getElementById('newPassword').addEventListener('blur', validatePassword);
        
        // 비밀번호 확인 입력 시 실시간 검사
        document.getElementById('newPasswordConfirm').addEventListener('input', validatePasswordConfirm);
        document.getElementById('newPasswordConfirm').addEventListener('blur', validatePasswordConfirm);
    </script>
</body>
</html>

