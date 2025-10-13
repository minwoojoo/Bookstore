<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지 - Online Bookstore</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f5f5;
            min-height: 100vh;
        }
        
        
        /* 메인 컨텐츠 */
        .main-container {
            max-width: 800px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .page-title {
            font-size: 32px;
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
        }
        
        .page-subtitle {
            font-size: 14px;
            color: #666;
            margin-bottom: 30px;
        }
        
        .mypage-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            padding: 40px;
        }
        
        .info-list {
            list-style: none;
            padding: 0;
            margin: 20px 0;
            display: grid;
            gap: 24px;
        }
        
        .info-item {
            display: grid;
            grid-template-columns: 140px 1fr;
            align-items: center;
            gap: 20px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;
        }
        
        .info-item:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }
        
        .info-item b {
            font-weight: 700;
            color: #333;
            font-size: 14px;
        }
        
        .info-value {
            color: #666;
            font-size: 14px;
        }
        
        .edit-mode {
            display: none;
        }
        
        .edit-mode input {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
        }
        
        .edit-mode input:focus {
            outline: none;
            border-color: #0066cc;
        }
        
        .input-with-btn {
            display: flex;
            gap: 10px;
            align-items: flex-start;
            flex-direction: column;
        }
        
        .input-with-btn input {
            width: 100%;
        }
        
        .btn-small {
            padding: 8px 16px;
            font-size: 13px;
            white-space: nowrap;
        }
        
        .verification-input {
            margin-top: 8px;
            display: none;
        }
        
        .verification-message {
            font-size: 12px;
            margin-top: 6px;
            padding: 8px 12px;
            border-radius: 6px;
        }
        
        .verification-success {
            background: #d4edda;
            color: #155724;
        }
        
        .verification-error {
            background: #f8d7da;
            color: #721c24;
        }
        
        .verification-info {
            background: #d1ecf1;
            color: #0c5460;
        }
        
        .btn-group {
            display: flex;
            gap: 10px;
            margin-top: 30px;
            justify-content: center;
        }
        
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .btn-primary {
            background: #0066cc;
            color: white;
        }
        
        .btn-primary:hover {
            background: #0052a3;
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
        }
        
        .btn-ghost {
            background: white;
            color: #0066cc;
            border: 1px solid #0066cc;
        }
        
        .btn-ghost:hover {
            background: #f0f7ff;
        }
        
        .grade-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
        }
        
        .grade-bronze {
            background: #cd7f32;
            color: white;
        }
        
        .grade-silver {
            background: #c0c0c0;
            color: #333;
        }
        
        .grade-gold {
            background: #ffd700;
            color: #333;
        }
        
        .message {
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        
        .message-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .message-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        /* 주소 편집 스타일 */
        .address-item {
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 10px;
            position: relative;
        }
        
        .address-item.editing {
            border-color: #0066cc;
            background: #f0f7ff;
        }
        
        .address-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        
        .address-name {
            font-weight: 600;
            color: #0066cc;
            font-size: 14px;
        }
        
        .address-actions {
            display: flex;
            gap: 5px;
        }
        
        .address-content {
            font-size: 13px;
            color: #333;
            line-height: 1.4;
        }
        
        .address-form {
            display: grid;
            gap: 10px;
            margin-top: 10px;
        }
        
        .address-form input {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 13px;
        }
        
        .address-form input:focus {
            outline: none;
            border-color: #0066cc;
        }
        
        .address-form-actions {
            display: flex;
            gap: 5px;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <!-- 헤더 -->
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <!-- 다음 우편번호 서비스 -->
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    
    <!-- 메인 컨텐츠 -->
    <div class="main-container">
        <h1 class="page-title">마이페이지</h1>
        <p class="page-subtitle">내 정보를 확인하고 수정할 수 있습니다</p>
        
        <div class="mypage-card">
            <c:if test="${not empty message}">
                <div class="message message-success">✅ ${message}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="message message-error">❌ ${error}</div>
            </c:if>
            
            <ul class="info-list">
                <li class="info-item">
                    <b>아이디</b>
                    <span class="info-value" id="userId-display">${userId}</span>
                </li>
                <li class="info-item">
                    <b>이름</b>
                    <span class="info-value display-mode" id="name-display">불러오는 중...</span>
                    <div class="edit-mode" id="name-edit" style="display: none;">
                        <input type="text" id="name-input" placeholder="이름을 입력하세요">
                    </div>
                </li>
                <li class="info-item">
                    <b>이메일</b>
                    <span class="info-value display-mode" id="email-display">불러오는 중...</span>
                    <div class="edit-mode input-with-btn" id="email-edit" style="display: none;">
                        <div style="display: flex; gap: 10px; width: 100%;">
                            <input type="email" id="email-input" placeholder="이메일을 입력하세요" style="flex: 1;">
                            <button class="btn btn-primary btn-small" onclick="sendEmailVerification()" id="email-verify-btn">이메일 인증</button>
                        </div>
                        <div id="verification-input" class="verification-input" style="width: 100%; display: none;">
                            <div style="display: flex; gap: 10px;">
                                <input type="text" id="verification-code" placeholder="인증 코드 6자리" maxlength="6" style="flex: 1;">
                                <button class="btn btn-secondary btn-small" onclick="verifyEmailCode()">인증 확인</button>
                            </div>
                        </div>
                        <div id="email-verification-message"></div>
                    </div>
                </li>
                <li class="info-item">
                    <b>전화번호</b>
                    <span class="info-value display-mode" id="phone-display">불러오는 중...</span>
                    <div class="edit-mode" id="phone-edit" style="display: none;">
                        <input type="text" id="phone-input" placeholder="전화번호를 입력하세요" maxlength="13">
                    </div>
                </li>
                <li class="info-item">
                    <b>회원등급</b>
                    <span class="info-value" id="grade-display">
                        <span class="grade-badge">불러오는 중...</span>
                    </span>
                </li>
                <li class="info-item">
                    <b>가입일</b>
                    <span class="info-value" id="regDate-display">불러오는 중...</span>
                </li>
                <li class="info-item" style="align-items: flex-start;">
                    <b>배송 주소</b>
                    <div style="width: 100%;">
                        <div id="address-display" class="info-value">불러오는 중...</div>
                        <div class="edit-mode" id="address-edit" style="display: none;">
                            <div id="address-list"></div>
                        </div>
                    </div>
                </li>
            </ul>
            
            <div class="btn-group" id="view-buttons">
                <button class="btn btn-primary" onclick="toggleEditMode()">정보 수정</button>
                <button class="btn btn-ghost" onclick="location.href='/'">홈으로</button>
            </div>
            
            <div class="btn-group edit-mode" id="edit-buttons" style="display: none;">
                <button class="btn btn-primary" onclick="saveProfile()">저장</button>
                <button class="btn btn-secondary" onclick="cancelEdit()">취소</button>
            </div>
        </div>
    </div>
    
    <script>
        let isEditMode = false;
        let originalData = {};
        let isEmailVerified = false;  // 이메일 인증 완료 여부
        let verificationSent = false; // 인증 코드 발송 여부
        let addresses = []; // 주소 목록
        let editingAddressId = null; // 편집 중인 주소 ID
        
        /**
         * 전화번호 포맷팅
         */
        function formatPhone(value) {
            const digits = (value || '').replace(/\D/g, '').slice(0, 11);
            if (!digits) return '';
            
            if (digits.startsWith('02')) {
                if (digits.length <= 2) return digits;
                if (digits.length <= 5) return digits.slice(0, 2) + '-' + digits.slice(2);
                if (digits.length <= 9) return digits.slice(0, 2) + '-' + digits.slice(2, 5) + '-' + digits.slice(5);
                return digits.slice(0, 2) + '-' + digits.slice(2, 6) + '-' + digits.slice(6);
            } else {
                if (digits.length <= 3) return digits;
                if (digits.length <= 7) return digits.slice(0, 3) + '-' + digits.slice(3);
                if (digits.length <= 10) return digits.slice(0, 3) + '-' + digits.slice(3, 6) + '-' + digits.slice(6);
                return digits.slice(0, 3) + '-' + digits.slice(3, 7) + '-' + digits.slice(7);
            }
        }
        
        /**
         * 날짜 포맷팅
         */
        function formatDate(dateString) {
            if (!dateString) return '';
            const date = new Date(dateString);
            const year = date.getFullYear();
            const month = String(date.getMonth() + 1).padStart(2, '0');
            const day = String(date.getDate()).padStart(2, '0');
            return year + '년 ' + month + '월 ' + day + '일';
        }
        
        /**
         * 회원등급 뱃지 HTML 생성
         */
        function getGradeBadgeHTML(grade) {
            const gradeText = grade || 'BRONZE';
            const gradeClass = 'grade-' + gradeText.toLowerCase();
            const gradeKor = gradeText === 'BRONZE' ? '브론즈' : 
                            gradeText === 'SILVER' ? '실버' : 
                            gradeText === 'GOLD' ? '골드' : '브론즈';
            return '<span class="grade-badge ' + gradeClass + '">' + gradeKor + '</span>';
        }
        
        /**
         * 이메일 인증 코드 발송
         */
        async function sendEmailVerification() {
            const email = document.getElementById('email-input').value.trim();
            
            if (!email) {
                alert('이메일을 입력해주세요.');
                return;
            }
            
            // 이메일 형식 검증
            const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailPattern.test(email)) {
                alert('올바른 이메일 형식이 아닙니다.');
                return;
            }
            
            // 원본 이메일과 동일하면 인증 불필요
            if (email === originalData.email) {
                alert('현재 사용 중인 이메일과 동일합니다.');
                return;
            }
            
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
                    verificationSent = true;
                    document.getElementById('verification-input').style.display = 'block';
                    document.getElementById('email-verification-message').innerHTML = 
                        '<div class="verification-message verification-info">✉️ 인증 코드가 발송되었습니다. (유효시간: 5분)</div>';
                    alert('인증 코드가 이메일로 발송되었습니다.');
                } else {
                    alert(data.message || '인증 코드 발송에 실패했습니다.');
                }
            } catch (error) {
                console.error('이메일 인증 코드 발송 오류:', error);
                alert('인증 코드 발송 중 오류가 발생했습니다.');
            }
        }
        
        /**
         * 이메일 인증 코드 확인
         */
        async function verifyEmailCode() {
            const email = document.getElementById('email-input').value.trim();
            const code = document.getElementById('verification-code').value.trim();
            
            if (!code) {
                alert('인증 코드를 입력해주세요.');
                return;
            }
            
            if (code.length !== 6) {
                alert('인증 코드는 6자리입니다.');
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
                    isEmailVerified = true;
                    document.getElementById('email-verification-message').innerHTML = 
                        '<div class="verification-message verification-success">✅ 이메일 인증이 완료되었습니다.</div>';
                    document.getElementById('email-input').readOnly = true;
                    document.getElementById('email-verify-btn').disabled = true;
                    document.getElementById('verification-input').style.display = 'none';
                    alert('이메일 인증이 완료되었습니다.');
                } else {
                    isEmailVerified = false;
                    document.getElementById('email-verification-message').innerHTML = 
                        '<div class="verification-message verification-error">❌ ' + (data.message || '인증 코드가 올바르지 않습니다.') + '</div>';
                }
            } catch (error) {
                console.error('이메일 인증 확인 오류:', error);
                alert('인증 확인 중 오류가 발생했습니다.');
            }
        }
        
        /**
         * 이메일 입력 필드 변경 감지
         */
        function onEmailInputChange() {
            const email = document.getElementById('email-input').value.trim();
            
            // 이메일이 변경되면 인증 상태 초기화
            if (email !== originalData.email) {
                isEmailVerified = false;
                document.getElementById('email-input').readOnly = false;
                document.getElementById('email-verify-btn').disabled = false;
                document.getElementById('email-verification-message').innerHTML = '';
                document.getElementById('verification-input').style.display = 'none';
                document.getElementById('verification-code').value = '';
            } else {
                // 원본 이메일로 돌아오면 인증 완료로 간주
                isEmailVerified = true;
            }
        }
        
        /**
         * 편집 모드 토글
         */
        function toggleEditMode() {
            console.log('toggleEditMode 호출됨, 현재 isEditMode:', isEditMode);
            isEditMode = !isEditMode;
            
            if (isEditMode) {
                console.log('편집 모드로 전환');
                // 편집 모드로 전환
                document.getElementById('view-buttons').style.display = 'none';
                document.getElementById('edit-buttons').style.display = 'flex';
                
                // 표시 모드 숨김
                document.querySelectorAll('.display-mode').forEach(el => {
                    el.style.display = 'none';
                });
                
                // 편집 모드 표시
                document.querySelectorAll('.edit-mode').forEach(el => {
                    if (el.id !== 'edit-buttons') {
                        // input-with-btn 클래스는 flex로 표시
                        if (el.classList.contains('input-with-btn')) {
                            el.style.display = 'flex';
                        } else {
                            el.style.display = 'block';
                        }
                    }
                });
                
                // 주소 편집 UI 표시
                document.getElementById('address-edit').style.display = 'block';
                
                // 현재 값들을 입력 필드에 설정
                document.getElementById('name-input').value = originalData.name || '';
                document.getElementById('email-input').value = originalData.email || '';
                document.getElementById('phone-input').value = originalData.phone || '';
                
                // 주소 목록 초기화
                addresses = [...(originalData.addresses || [])];
                editingAddressId = null;
                displayAddressEditList();
                
                // 편집 모드에서는 기존 주소 표시 숨김
                document.getElementById('address-display').style.display = 'none';
                
                // 이메일 인증 상태 초기화 (원본 이메일은 인증 완료로 간주)
                isEmailVerified = true;
                document.getElementById('email-input').readOnly = false;
                document.getElementById('email-verify-btn').disabled = false;
                document.getElementById('email-verification-message').innerHTML = '';
                document.getElementById('verification-input').style.display = 'none';
                document.getElementById('verification-code').value = '';
                
                // 이메일 입력 필드에 이벤트 리스너 추가
                document.getElementById('email-input').addEventListener('input', onEmailInputChange);
                
            } else {
                // 보기 모드로 전환
                document.getElementById('view-buttons').style.display = 'flex';
                document.getElementById('edit-buttons').style.display = 'none';
                
                // 표시 모드 보이기
                document.querySelectorAll('.display-mode').forEach(el => {
                    el.style.display = 'block';
                });
                
                // 편집 모드 숨김
                document.querySelectorAll('.edit-mode').forEach(el => {
                    if (el.id !== 'edit-buttons') {
                        el.style.display = 'none';
                    }
                });
                
                // 주소 편집 UI 숨김
                document.getElementById('address-edit').style.display = 'none';
                
                // 보기 모드에서는 기존 주소 표시 보이기
                document.getElementById('address-display').style.display = 'block';
                
                // 이메일 인증 상태 초기화
                isEmailVerified = false;
                verificationSent = false;
                document.getElementById('email-verification-message').innerHTML = '';
                document.getElementById('verification-input').style.display = 'none';
                document.getElementById('verification-code').value = '';
                
                // 이벤트 리스너 제거
                document.getElementById('email-input').removeEventListener('input', onEmailInputChange);
            }
        }
        
        /**
         * 편집 취소
         */
        function cancelEdit() {
            toggleEditMode();
        }
        
        /**
         * 프로필 저장
         */
        async function saveProfile() {
            const name = document.getElementById('name-input').value.trim();
            const email = document.getElementById('email-input').value.trim();
            const phone = document.getElementById('phone-input').value.trim();
            
            if (!name) {
                alert('이름을 입력해주세요.');
                return;
            }
            
            if (!email) {
                alert('이메일을 입력해주세요.');
                return;
            }
            
            if (!phone) {
                alert('전화번호를 입력해주세요.');
                return;
            }
            
            // 이메일이 변경되었는데 인증하지 않았으면 저장 불가
            if (email !== originalData.email && !isEmailVerified) {
                alert('이메일이 변경되었습니다. 이메일 인증을 완료해주세요.');
                return;
            }
            
            try {
                const response = await fetch('/api/mypage/update', {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        name: name,
                        email: email,
                        phone: phone
                    })
                });
                
                const data = await response.json();
                
                if (data.success) {
                    alert('정보가 수정되었습니다.');
                    location.reload();
                } else {
                    alert(data.message || '정보 수정에 실패했습니다.');
                }
            } catch (error) {
                console.error('프로필 수정 오류:', error);
                alert('정보 수정 중 오류가 발생했습니다.');
            }
        }
        
        /**
         * 전화번호 자동 하이픈 추가
         */
        document.getElementById('phone-input').addEventListener('input', function(e) {
            e.target.value = formatPhone(e.target.value);
        });
        
        /**
         * 페이지 로드 시 사용자 정보 가져오기
         */
        (async function() {
            // 페이지 로드 시 편집 모드 요소들 확실히 숨김
            document.querySelectorAll('.edit-mode').forEach(el => {
                el.style.display = 'none';
            });
            
            try {
                const response = await fetch('/api/mypage/info');
                
                if (!response.ok) {
                    if (response.status === 401) {
                        alert('로그인이 필요합니다.');
                        window.location.href = '/auth/login';
                        return;
                    }
                    throw new Error('정보를 불러올 수 없습니다.');
                }
                
                const data = await response.json();
                
                // 원본 데이터 저장
                originalData = data;
                
                // 화면에 표시
                document.getElementById('name-display').textContent = data.name || '-';
                document.getElementById('email-display').textContent = data.email || '-';
                document.getElementById('phone-display').textContent = formatPhone(data.phone) || '-';
                document.getElementById('grade-display').innerHTML = getGradeBadgeHTML(data.memberGrade);
                document.getElementById('regDate-display').textContent = formatDate(data.registrationDate);
                
                // 주소 정보 표시
                displayAddresses(data.addresses);
                
                // 주소 목록 초기화 (편집용)
                addresses = [...(data.addresses || [])];
                
            } catch (error) {
                console.error('사용자 정보 로드 오류:', error);
                alert('사용자 정보를 불러올 수 없습니다.');
            }
        })();
        
        /**
         * 주소 정보 표시 (보기 모드)
         */
        function displayAddresses(addressList) {
            const addressDisplay = document.getElementById('address-display');
            
            if (!addressList || addressList.length === 0) {
                addressDisplay.innerHTML = '<div style="color: #999; font-style: italic;">등록된 주소가 없습니다.</div>';
                return;
            }
            
            let html = '';
            addressList.forEach((addr, index) => {
                html += '<div style="margin-bottom: ' + (index < addressList.length - 1 ? '15px' : '0') + '; padding: 12px; background: #f8f9fa; border-radius: 8px; border-left: 3px solid #0066cc;">';
                
                if (addr.addressName) {
                    html += '<div style="font-weight: 600; color: #0066cc; margin-bottom: 6px; font-size: 13px;">' + addr.addressName + '</div>';
                }
                
                if (addr.postCode) {
                    html += '<div style="font-size: 13px; color: #666; margin-bottom: 4px;">우편번호: ' + addr.postCode + '</div>';
                }
                
                if (addr.addressBasic) {
                    html += '<div style="font-size: 13px; color: #333;">' + addr.addressBasic;
                    if (addr.addressDetail) {
                        html += ' ' + addr.addressDetail;
                    }
                    html += '</div>';
                }
                
                html += '</div>';
            });
            
            addressDisplay.innerHTML = html;
        }
        
        /**
         * 주소 편집 목록 표시
         */
        function displayAddressEditList() {
            console.log('displayAddressEditList 호출됨, addresses:', addresses);
            console.log('현재 editingAddressId:', editingAddressId);
            const addressList = document.getElementById('address-list');
            
            if (!addresses || addresses.length === 0) {
                console.log('주소가 없음, 주소 추가 버튼 표시');
                addressList.innerHTML = '<div style="color: #999; font-style: italic; text-align: center; padding: 20px;">등록된 주소가 없습니다.<br><button class="btn btn-primary btn-small" onclick="addNewAddress()" style="margin-top: 10px;">주소 추가</button></div>';
                return;
            }
            
            let html = '';
            addresses.forEach(addr => {
                const isEditing = editingAddressId === addr.addressId;
                console.log('주소 처리 중:', addr.addressId, 'isEditing:', isEditing);
                
                html += '<div class="address-item ' + (isEditing ? 'editing' : '') + '" id="address-' + addr.addressId + '">' +
                    '<div class="address-header">' +
                        '<div class="address-name">' + (addr.addressName || '기본 주소') + '</div>' +
                        '<div class="address-actions">' +
                            (isEditing ? '' : '<button class="btn btn-primary btn-small" onclick="editAddress(' + JSON.stringify(addr.addressId) + ')">수정</button>') +
                            '<button class="btn btn-secondary btn-small" onclick="deleteAddress(' + JSON.stringify(addr.addressId) + ')">삭제</button>' +
                        '</div>' +
                    '</div>' +
                    '<div class="address-content">' +
                        (addr.postCode ? '우편번호: ' + addr.postCode + '<br>' : '') +
                        (addr.addressBasic || '') + ' ' + (addr.addressDetail || '') +
                    '</div>' +
                    (isEditing ? getAddressForm(addr) : '') +
                '</div>';
            });
            
            console.log('생성된 HTML:', html);
            addressList.innerHTML = html;
            console.log('HTML 설정 완료');
        }
        
        /**
         * 주소 편집 폼 HTML 생성
         */
        function getAddressForm(addr) {
            return '<div class="address-form">' +
                '<input type="text" id="edit-addressName-' + addr.addressId + '" placeholder="주소명 (예: 집, 회사)" value="' + (addr.addressName || '') + '">' +
                '<input type="text" id="edit-postCode-' + addr.addressId + '" placeholder="우편번호" value="' + (addr.postCode || '') + '" readonly>' +
                '<button type="button" class="btn btn-primary btn-small" onclick="searchAddressForEdit(\'' + addr.addressId + '\')">주소 검색</button>' +
                '<input type="text" id="edit-addressBasic-' + addr.addressId + '" placeholder="기본 주소" value="' + (addr.addressBasic || '') + '" readonly>' +
                '<input type="text" id="edit-addressDetail-' + addr.addressId + '" placeholder="상세 주소" value="' + (addr.addressDetail || '') + '">' +
                '<div class="address-form-actions">' +
                    '<button class="btn btn-primary btn-small" onclick="saveAddress(\'' + addr.addressId + '\')">저장</button>' +
                    '<button class="btn btn-secondary btn-small" onclick="cancelEditAddress()">취소</button>' +
                '</div>' +
            '</div>';
        }
        
        /**
         * 주소가 없을 때 새 주소 추가
         */
        function addNewAddress() {
            console.log('addNewAddress 호출됨');
            const newAddress = {
                addressId: 'new_' + Date.now(),
                addressName: '',
                postCode: '',
                addressBasic: '',
                addressDetail: ''
            };
            
            addresses = [newAddress]; // 기존 주소를 새 주소로 교체
            editingAddressId = newAddress.addressId;
            console.log('새 주소 추가됨:', newAddress);
            console.log('편집 모드로 전환, editingAddressId:', editingAddressId);
            displayAddressEditList();
        }
        
        /**
         * 주소 편집 시작
         */
        function editAddress(addressId) {
            console.log('editAddress 호출됨, addressId:', addressId);
            console.log('현재 addresses:', addresses);
            console.log('현재 editingAddressId:', editingAddressId);
            
            editingAddressId = addressId;
            console.log('editingAddressId 설정 후:', editingAddressId);
            
            displayAddressEditList();
            console.log('displayAddressEditList 호출 완료');
        }
        
        /**
         * 주소 편집 취소
         */
        function cancelEditAddress() {
            editingAddressId = null;
            displayAddressEditList();
        }
        
        /**
         * 주소 삭제
         */
        async function deleteAddress(addressId) {
            if (!confirm('이 주소를 삭제하시겠습니까?')) {
                return;
            }
            
            try {
                const response = await fetch('/api/mypage/address/' + addressId, {
                    method: 'DELETE'
                });
                
                const data = await response.json();
                
                if (data.success) {
                    addresses = addresses.filter(addr => addr.addressId != addressId);
                    displayAddressEditList();
                    alert('주소가 삭제되었습니다.');
                } else {
                    alert(data.message || '주소 삭제에 실패했습니다.');
                }
            } catch (error) {
                console.error('주소 삭제 오류:', error);
                alert('주소 삭제 중 오류가 발생했습니다.');
            }
        }
        
        /**
         * 주소 저장
         */
        async function saveAddress(addressId) {
            console.log('saveAddress 호출됨, addressId:', addressId);
            const addressName = document.getElementById('edit-addressName-' + addressId).value.trim();
            const postCode = document.getElementById('edit-postCode-' + addressId).value.trim();
            const addressBasic = document.getElementById('edit-addressBasic-' + addressId).value.trim();
            const addressDetail = document.getElementById('edit-addressDetail-' + addressId).value.trim();
            
            console.log('주소 데이터:', { addressName, postCode, addressBasic, addressDetail });
            
            if (!addressName) {
                alert('주소명을 입력해주세요.');
                return;
            }
            
            if (!postCode || !addressBasic) {
                alert('주소를 검색해주세요.');
                return;
            }
            
            try {
                const addressData = {
                    addressName: addressName,
                    postCode: postCode,
                    addressBasic: addressBasic,
                    addressDetail: addressDetail
                };
                
                let response;
                if (addressId.startsWith('new_')) {
                    // 새 주소 추가
                    console.log('새 주소 추가 요청');
                    response = await fetch('/api/mypage/address', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify(addressData)
                    });
                } else {
                    // 기존 주소 수정
                    console.log('기존 주소 수정 요청, addressId:', addressId);
                    response = await fetch('/api/mypage/address/' + addressId, {
                        method: 'PUT',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify(addressData)
                    });
                }
                
                console.log('서버 응답 상태:', response.status);
                console.log('서버 응답 헤더:', response.headers);
                
                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }
                
                const data = await response.json();
                console.log('서버 응답 데이터:', data);
                
                if (data.success) {
                    // 주소 목록 업데이트
                    const addressIndex = addresses.findIndex(addr => addr.addressId == addressId);
                    if (addressIndex !== -1) {
                        addresses[addressIndex] = { ...addresses[addressIndex], ...addressData };
                        if (data.addressId) {
                            addresses[addressIndex].addressId = data.addressId;
                        }
                    }
                    
                    editingAddressId = null;
                    displayAddressEditList();
                    alert('주소가 저장되었습니다.');
                } else {
                    console.error('서버에서 실패 응답:', data);
                    alert(data.message || '주소 저장에 실패했습니다.');
                }
            } catch (error) {
                console.error('주소 저장 오류:', error);
                console.error('오류 상세:', error.message);
                alert('주소 저장 중 오류가 발생했습니다: ' + error.message);
            }
        }
        
        /**
         * 주소 검색 (다음 우편번호 서비스)
         */
        function searchAddressForEdit(addressId) {
            console.log('searchAddressForEdit 호출됨, addressId:', addressId);
            new daum.Postcode({
                oncomplete: function(data) {
                    console.log('주소 검색 완료:', data);
                    document.getElementById('edit-postCode-' + addressId).value = data.zonecode;
                    document.getElementById('edit-addressBasic-' + addressId).value = data.address;
                    document.getElementById('edit-addressDetail-' + addressId).focus();
                }
            }).open();
        }
    </script>
</body>
</html>

