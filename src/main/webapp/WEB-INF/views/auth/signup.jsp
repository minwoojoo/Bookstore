<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입 - 온라인 서점</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f5f5f5; }
        .container { max-width: 500px; margin: 50px auto; padding: 30px; background: white; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { text-align: center; color: #333; margin-bottom: 30px; }
        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 5px; color: #555; font-weight: 500; }
        input[type="text"], input[type="password"], input[type="email"] { 
            width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px; 
        }
        input:focus { outline: none; border-color: #4CAF50; }
        .error { color: #f44336; font-size: 12px; margin-top: 5px; }
        .btn { width: 100%; padding: 14px; background: #4CAF50; color: white; border: none; border-radius: 4px; font-size: 16px; cursor: pointer; }
        .btn:hover { background: #45a049; }
        .link-group { text-align: center; margin-top: 20px; }
        .link-group a { color: #4CAF50; text-decoration: none; }
        .link-group a:hover { text-decoration: underline; }
        .check-btn { 
            padding: 8px 15px; 
            background: #2196F3; 
            color: white; 
            border: none; 
            border-radius: 4px; 
            cursor: pointer; 
            font-size: 13px;
        }
        .check-btn:hover { background: #1976D2; }
        .check-result { 
            font-size: 12px; 
            margin-top: 5px; 
            padding: 5px 10px; 
            border-radius: 3px; 
        }
        .check-result.success { color: #4CAF50; background: #E8F5E9; }
        .check-result.fail { color: #f44336; background: #FFEBEE; }
    </style>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</head>
<body>
    <div class="container">
        <h1>회원가입</h1>
        
        <c:if test="${not empty error}">
            <div class="error" style="text-align: center; margin-bottom: 20px;">
                ${error}
            </div>
        </c:if>
        
        <form action="/auth/signup" method="post">
            <div class="form-group">
                <label for="userId">아이디 *</label>
                <div style="display: flex; gap: 10px;">
                    <input type="text" id="userId" name="userId" required 
                           placeholder="4~20자 영문, 숫자" value="${signupRequest.userId}"
                           style="flex: 1;" onblur="checkUserId()">
                    <button type="button" class="check-btn" onclick="checkUserId()">중복 확인</button>
                </div>
                <div id="userIdCheck" class="check-result"></div>
                <span class="error">${errors.userId}</span>
            </div>
            
            <div class="form-group">
                <label for="password">비밀번호 *</label>
                <input type="password" id="password" name="password" required 
                       placeholder="8~20자 영문, 숫자, 특수문자">
                <div id="passwordCheck" class="check-result"></div>
                <span class="error">${errors.password}</span>
            </div>
            
            <div class="form-group">
                <label for="passwordConfirm">비밀번호 확인 *</label>
                <input type="password" id="passwordConfirm" name="passwordConfirm" required>
                <div id="passwordConfirmCheck" class="check-result"></div>
                <span class="error">${errors.passwordConfirm}</span>
            </div>
            
            <div class="form-group">
                <label for="name">이름 *</label>
                <input type="text" id="name" name="name" required value="${signupRequest.name}">
                <span class="error">${errors.name}</span>
            </div>
            
            <div class="form-group">
                <label for="email">이메일 *</label>
                <div style="display: flex; gap: 10px;">
                    <input type="email" id="email" name="email" required 
                           placeholder="example@email.com" value="${signupRequest.email}"
                           style="flex: 1;">
                    <button type="button" class="check-btn" onclick="sendVerificationCode()" id="sendVerifyBtn">
                        이메일 인증
                    </button>
                </div>
                <div id="emailCheck" class="check-result"></div>
                <span class="error">${errors.email}</span>
            </div>
            
            <div class="form-group" id="verificationCodeGroup" style="display: none;">
                <label for="verificationCode">인증번호</label>
                <div style="display: flex; gap: 10px;">
                    <input type="text" id="verificationCode" 
                           placeholder="6자리 인증번호 입력" 
                           maxlength="6"
                           style="flex: 1;">
                    <button type="button" class="check-btn" onclick="verifyEmailCode()">
                        인증 확인
                    </button>
                </div>
                <div id="verificationResult" class="check-result"></div>
            </div>
            
            <div class="form-group">
                <label for="phone">연락처 *</label>
                <input type="text" id="phone" name="phone" required
                       placeholder="010-1234-5678" value="${signupRequest.phone}"
                       maxlength="13">
                <span class="error">${errors.phone}</span>
            </div>
            
            <div class="form-group">
                <label for="postCode">우편번호 *</label>
                <div style="display: flex; gap: 10px;">
                    <input type="text" id="postCode" name="postCode" required
                           placeholder="12345" value="${signupRequest.postCode}" 
                           readonly style="flex: 1;">
                    <button type="button" onclick="searchAddress()" 
                            style="padding: 12px 20px; background: #2196F3; color: white; border: none; border-radius: 4px; cursor: pointer; white-space: nowrap;">
                        우편번호 찾기
                    </button>
                </div>
                <span class="error">${errors.postCode}</span>
            </div>
            
            <div class="form-group">
                <label for="addressBasic">기본 주소 *</label>
                <input type="text" id="addressBasic" name="addressBasic" required
                       placeholder="도로명 주소" value="${signupRequest.addressBasic}" 
                       readonly>
                <span class="error">${errors.addressBasic}</span>
            </div>
            
            <div class="form-group">
                <label for="addressDetail">상세 주소</label>
                <input type="text" id="addressDetail" name="addressDetail"
                       placeholder="아파트, 동/호수 등" value="${signupRequest.addressDetail}">
                <span class="error">${errors.addressDetail}</span>
            </div>
            
            <div class="form-group">
                <label for="addressName">주소 별칭</label>
                <input type="text" id="addressName" name="addressName"
                       placeholder="예: 집, 회사" value="${signupRequest.addressName}">
                <span class="error">${errors.addressName}</span>
            </div>
            
            <button type="submit" class="btn">회원가입</button>
        </form>
        
        <div class="link-group">
            이미 계정이 있으신가요? <a href="/auth/login">로그인</a>
        </div>
    </div>
    
    <script>
        let userIdChecked = false;
        let emailVerified = false;  // 이메일 인증 완료 여부
        
        /**
         * 다음 우편번호 API 호출
         */
        function searchAddress() {
            new daum.Postcode({
                oncomplete: function(data) {
                    // 우편번호와 주소 정보를 입력폼에 넣기
                    document.getElementById('postCode').value = data.zonecode;
                    
                    // 도로명 주소 우선, 없으면 지번 주소
                    const address = data.roadAddress || data.jibunAddress;
                    document.getElementById('addressBasic').value = address;
                    
                    // 상세주소 입력란으로 포커스 이동
                    document.getElementById('addressDetail').focus();
                }
            }).open();
        }
        
        /**
         * 아이디 중복 확인
         */
        async function checkUserId() {
            const userId = document.getElementById('userId').value.trim();
            const resultDiv = document.getElementById('userIdCheck');
            
            if (!userId) {
                resultDiv.textContent = '';
                resultDiv.className = 'check-result';
                userIdChecked = false;
                return;
            }
            
            // 유효성 검사 (4~20자 영문, 숫자)
            const regex = /^[a-zA-Z0-9]{4,20}$/;
            if (!regex.test(userId)) {
                resultDiv.textContent = '아이디는 4~20자 영문, 숫자만 사용 가능합니다.';
                resultDiv.className = 'check-result fail';
                userIdChecked = false;
                return;
            }
            
            try {
                const response = await fetch('/api/auth/check?field=USER_ID&value=' + encodeURIComponent(userId));
                const data = await response.json();
                
                if (data.success) {
                    if (data.available) {
                        resultDiv.textContent = '✓ 사용 가능한 아이디입니다.';
                        resultDiv.className = 'check-result success';
                        userIdChecked = true;
                    } else {
                        resultDiv.textContent = '✗ 이미 사용 중인 아이디입니다.';
                        resultDiv.className = 'check-result fail';
                        userIdChecked = false;
                    }
                }
            } catch (error) {
                console.error('아이디 중복 확인 오류:', error);
                resultDiv.textContent = '중복 확인 중 오류가 발생했습니다.';
                resultDiv.className = 'check-result fail';
                userIdChecked = false;
            }
        }
        
        /**
         * 이메일 인증번호 발송
         */
        async function sendVerificationCode() {
            const email = document.getElementById('email').value.trim();
            const resultDiv = document.getElementById('emailCheck');
            const sendBtn = document.getElementById('sendVerifyBtn');
            
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
            
            // 버튼 비활성화
            sendBtn.disabled = true;
            sendBtn.textContent = '발송 중...';
            
            try {
                const response = await fetch('/api/auth/send-verification', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ email: email })
                });
                const data = await response.json();
                
                if (data.success) {
                    resultDiv.textContent = '✓ ' + data.message;
                    resultDiv.className = 'check-result success';
                    
                    // 인증번호 입력 필드 표시
                    document.getElementById('verificationCodeGroup').style.display = 'block';
                    
                    // 재발송 가능하도록 버튼 활성화 (30초 후)
                    setTimeout(() => {
                        sendBtn.disabled = false;
                        sendBtn.textContent = '재발송';
                    }, 30000);
                } else {
                    resultDiv.textContent = '✗ ' + data.message;
                    resultDiv.className = 'check-result fail';
                    sendBtn.disabled = false;
                    sendBtn.textContent = '이메일 인증';
                }
            } catch (error) {
                console.error('이메일 인증번호 발송 오류:', error);
                resultDiv.textContent = '인증번호 발송 중 오류가 발생했습니다.';
                resultDiv.className = 'check-result fail';
                sendBtn.disabled = false;
                sendBtn.textContent = '이메일 인증';
            }
        }
        
        /**
         * 이메일 인증번호 검증
         */
        async function verifyEmailCode() {
            const email = document.getElementById('email').value.trim();
            const code = document.getElementById('verificationCode').value.trim();
            const resultDiv = document.getElementById('verificationResult');
            
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
                const response = await fetch('/api/auth/verify-email', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ 
                        email: email,
                        code: code 
                    })
                });
                const data = await response.json();
                
                if (data.success) {
                    resultDiv.textContent = '✓ ' + data.message;
                    resultDiv.className = 'check-result success';
                    emailVerified = true;
                    
                    // 이메일 입력 필드 비활성화
                    document.getElementById('email').readOnly = true;
                    document.getElementById('sendVerifyBtn').disabled = true;
                    document.getElementById('verificationCode').readOnly = true;
                } else {
                    resultDiv.textContent = '✗ ' + data.message;
                    resultDiv.className = 'check-result fail';
                    emailVerified = false;
                }
            } catch (error) {
                console.error('이메일 인증번호 검증 오류:', error);
                resultDiv.textContent = '인증번호 검증 중 오류가 발생했습니다.';
                resultDiv.className = 'check-result fail';
                emailVerified = false;
            }
        }
        
        /**
         * 아이디 입력값 변경 시 중복 확인 초기화
         */
        document.getElementById('userId').addEventListener('input', function() {
            userIdChecked = false;
            const resultDiv = document.getElementById('userIdCheck');
            if (resultDiv.classList.contains('success')) {
                resultDiv.textContent = '아이디가 변경되었습니다. 다시 중복 확인해주세요.';
                resultDiv.className = 'check-result fail';
            }
        });
        
        /**
         * 이메일 입력값 변경 시 중복 확인 초기화
         */
        document.getElementById('email').addEventListener('input', function() {
            emailChecked = false;
            const resultDiv = document.getElementById('emailCheck');
            if (resultDiv.classList.contains('success')) {
                resultDiv.textContent = '이메일이 변경되었습니다. 다시 중복 확인해주세요.';
                resultDiv.className = 'check-result fail';
            }
        });
        
        /**
         * 비밀번호 유효성 검사
         */
        function validatePassword() {
            const password = document.getElementById('password').value;
            const resultDiv = document.getElementById('passwordCheck');
            
            if (!password) {
                resultDiv.textContent = '';
                resultDiv.className = 'check-result';
                return false;
            }
            
            const errors = [];
            
            // 길이 체크 (8~20자)
            if (password.length < 8 || password.length > 20) {
                errors.push('8~20자');
            }
            
            // 영문 포함 체크
            if (!/[A-Za-z]/.test(password)) {
                errors.push('영문');
            }
            
            // 숫자 포함 체크
            if (!/\d/.test(password)) {
                errors.push('숫자');
            }
            
            // 특수문자 포함 체크
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
            const password = document.getElementById('password').value;
            const passwordConfirm = document.getElementById('passwordConfirm').value;
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
        document.getElementById('password').addEventListener('input', validatePassword);
        document.getElementById('password').addEventListener('blur', validatePassword);
        
        // 비밀번호 확인 입력 시 실시간 검사
        document.getElementById('passwordConfirm').addEventListener('input', validatePasswordConfirm);
        document.getElementById('passwordConfirm').addEventListener('blur', validatePasswordConfirm);
        
        /**
         * 전화번호 자동 하이픈 추가
         */
        document.getElementById('phone').addEventListener('input', function(e) {
            let value = e.target.value.replace(/[^0-9]/g, ''); // 숫자만 추출
            let result = '';
            
            if (value.length <= 3) {
                result = value;
            } else if (value.length <= 7) {
                result = value.substring(0, 3) + '-' + value.substring(3);
            } else if (value.length <= 11) {
                result = value.substring(0, 3) + '-' + value.substring(3, 7) + '-' + value.substring(7);
            } else {
                result = value.substring(0, 3) + '-' + value.substring(3, 7) + '-' + value.substring(7, 11);
            }
            
            e.target.value = result;
        });
        
        /**
         * 폼 제출 전 유효성 검사
         */
        document.querySelector('form').addEventListener('submit', function(e) {
            const errors = [];
            
            // 아이디 중복 확인 여부
            if (!userIdChecked) {
                errors.push('아이디 중복 확인이 필요합니다.');
            }
            
            // 이메일 인증 완료 여부
            if (!emailVerified) {
                errors.push('이메일 인증이 필요합니다.');
            }
            
            // 비밀번호 유효성 검사
            if (!validatePassword()) {
                errors.push('비밀번호는 8~20자 영문, 숫자, 특수문자를 포함해야 합니다.');
            }
            
            // 비밀번호 일치 확인
            if (!validatePasswordConfirm()) {
                errors.push('비밀번호가 일치하지 않습니다.');
            }
            
            // 에러가 있으면 제출 중단
            if (errors.length > 0) {
                e.preventDefault();
                alert('❌ 회원가입 실패\n\n' + errors.join('\n'));
                return false;
            }
            
            return true;
        });
    </script>
</body>
</html>
