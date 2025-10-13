<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>주문내역 확인 - Online Bookstore</title>
    <!-- 다음 우편번호 서비스 -->
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            background: #f5f5f5;
            min-height: 100vh;
        }
        
        /* 메인 컨텐츠 */
        .main-container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .page-title {
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 3px solid #0066cc;
        }
        
        .checkout-content {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 30px;
        }
        
        /* 주문 상품 목록 */
        .order-items {
            background: white;
            border-radius: 8px;
            padding: 30px;
            margin-bottom: 20px;
        }
        
        .order-items h3 {
            font-size: 20px;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .order-item {
            display: flex;
            align-items: center;
            gap: 20px;
            padding: 20px 0;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .order-item:last-child {
            border-bottom: none;
        }
        
        .order-item-thumbnail {
            width: 80px;
            height: 100px;
            flex-shrink: 0;
        }
        
        .order-item-thumbnail img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 4px;
        }
        
        .order-item-thumbnail .no-image {
            width: 100%;
            height: 100%;
            background: #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 4px;
            color: #999;
            font-size: 10px;
        }
        
        .order-item-info {
            flex: 1;
            min-width: 0;
        }
        
        .order-item-title {
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 5px;
            color: #333;
        }
        
        .order-item-meta {
            font-size: 14px;
            color: #666;
            margin-bottom: 8px;
        }
        
        .order-item-price {
            font-size: 16px;
            font-weight: bold;
            color: #0066cc;
        }
        
        .order-item-quantity {
            text-align: center;
            min-width: 60px;
            font-weight: bold;
        }
        
        .order-item-subtotal {
            text-align: right;
            min-width: 100px;
            font-weight: bold;
            color: #333;
        }
        
        /* 배송지 정보 */
        .shipping-info {
            background: white;
            border-radius: 8px;
            padding: 30px;
            margin-bottom: 20px;
        }
        
        .shipping-info h3 {
            font-size: 20px;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .shipping-form {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
        }
        
        .form-group.full-width {
            grid-column: 1 / -1;
        }
        
        .form-group label {
            font-weight: 500;
            margin-bottom: 8px;
            color: #333;
        }
        
        .form-group input,
        .form-group select {
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        
        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #0066cc;
            box-shadow: 0 0 0 2px rgba(0, 102, 204, 0.2);
        }
        
        .address-input-group {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }
        
        .btn-address-search {
            padding: 12px 20px;
            background: #0066cc;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: background 0.3s;
        }
        
        .btn-address-search:hover {
            background: #0052a3;
        }
        
        /* 체크박스 스타일 */
        .form-group label {
            display: flex;
            align-items: center;
            cursor: pointer;
            font-weight: normal;
        }
        
        .form-group input[type="checkbox"] {
            margin-right: 8px;
            transform: scale(1.2);
        }
        
        .form-group input[readonly] {
            background-color: #f5f5f5;
            color: #666;
        }
        
        /* 주문 요약 */
        .order-summary {
            background: white;
            border-radius: 8px;
            padding: 30px;
            height: fit-content;
            position: sticky;
            top: 20px;
        }
        
        .order-summary h3 {
            font-size: 20px;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            font-size: 16px;
        }
        
        .summary-row.total {
            font-size: 22px;
            font-weight: bold;
            color: #0066cc;
            padding-top: 15px;
            border-top: 2px solid #f0f0f0;
            margin-top: 15px;
        }
        
        .btn-payment {
            width: 100%;
            padding: 18px;
            background: #0066cc;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 18px;
            font-weight: bold;
            cursor: pointer;
            margin-top: 20px;
        }
        
        .btn-payment:hover {
            background: #0052a3;
        }
        
        .btn-payment:disabled {
            background: #ccc;
            cursor: not-allowed;
        }
        
        /* 푸터 */
        footer {
            background: #333;
            color: white;
            padding: 30px 0;
            margin-top: 40px;
        }
        .footer-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            text-align: center;
        }
        .footer-container p {
            margin: 5px 0;
            font-size: 14px;
            color: #aaa;
        }
        
        /* 반응형 */
        @media (max-width: 768px) {
            .checkout-content {
                grid-template-columns: 1fr;
            }
            
            .shipping-form {
                grid-template-columns: 1fr;
            }
            
            .order-item {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .order-item-thumbnail {
                width: 100%;
                height: 150px;
            }
            
            .order-item-quantity,
            .order-item-subtotal {
                width: 100%;
                text-align: left;
                margin-top: 10px;
            }
        }
    </style>
</head>
<body>
    <!-- 헤더 -->
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <!-- 메인 컨텐츠 -->
    <div class="main-container">
        <h1 class="page-title">📋 주문내역 확인</h1>
        
        <c:choose>
            <c:when test="${!isAuthenticated}">
                <!-- 비로그인 상태 -->
                <div style="text-align: center; padding: 100px 20px; background: white; border-radius: 8px;">
                    <div style="font-size: 80px; margin-bottom: 20px;">🔒</div>
                    <div style="font-size: 18px; color: #666; margin-bottom: 30px;">로그인이 필요한 서비스입니다.</div>
                    <a href="/auth/login" style="display: inline-block; padding: 12px 30px; background: #0066cc; color: white; text-decoration: none; border-radius: 4px; font-size: 16px;">로그인하기</a>
                </div>
            </c:when>
            <c:otherwise>
                <!-- 주문내역 확인 -->
                <div class="checkout-content">
                    <!-- 주문 상품 목록 -->
                    <div class="order-items">
                        <h3>주문 상품</h3>
                        <div id="cartItemsContainer">
                            <c:choose>
                                <c:when test="${not empty cartItems}">
                                    <c:forEach var="item" items="${cartItems}">
                                        <div class="order-item">
                                            <div class="order-item-thumbnail">
                                                <c:choose>
                                                    <c:when test="${not empty item.thumbnailUrl}">
                                                        <img src="${item.thumbnailUrl}" alt="${item.title}">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="no-image">이미지 없음</div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            
                                            <div class="order-item-info">
                                                <div class="order-item-title">${item.title}</div>
                                                <div class="order-item-meta">
                                                    저자: ${item.authors} | 출판사: ${item.publisher}
                                                </div>
                                                <div class="order-item-price">
                                                    <fmt:formatNumber value="${item.price}" pattern="#,##0"/>원
                                                </div>
                                            </div>
                                            
                                            <div class="order-item-quantity">
                                                ${item.quantity}개
                                            </div>
                                            
                                            <div class="order-item-subtotal">
                                                <fmt:formatNumber value="${item.subtotal}" pattern="#,##0"/>원
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div style="text-align: center; padding: 100px 20px; background: white; border-radius: 8px;">
                                        <div style="font-size: 80px; margin-bottom: 20px;">🛒</div>
                                        <div style="font-size: 18px; color: #666; margin-bottom: 30px;">장바구니가 비어있습니다.</div>
                                        <a href="/" style="display: inline-block; padding: 12px 30px; background: #0066cc; color: white; text-decoration: none; border-radius: 4px; font-size: 16px;">쇼핑 계속하기</a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    
                    <!-- 배송지 정보 -->
                    <div class="shipping-info">
                        <h3>배송지 정보</h3>
                        <form id="shippingForm">
                            <div class="shipping-form">
                                <div class="form-group">
                                    <label for="recipientName">수령인 이름 *</label>
                                    <input type="text" id="recipientName" name="recipientName" value="${userName}" 
                                           placeholder="수령인 이름을 입력해주세요" required>
                                </div>
                                <div class="form-group">
                                    <label for="recipientPhone">수령인 연락처 *</label>
                                    <input type="tel" id="recipientPhone" name="recipientPhone" 
                                           placeholder="010-1234-5678" pattern="[0-9]{3}-[0-9]{4}-[0-9]{4}" required>
                                </div>
                                <div class="form-group">
                                    <label>
                                        <input type="checkbox" id="useDefaultPhone" onchange="toggleDefaultPhone()">
                                        기본 연락처 사용
                                    </label>
                                </div>
                                <div class="form-group full-width">
                                    <label for="deliveryAddress">배송 주소 *</label>
                                    <div class="address-input-group">
                                        <input type="text" id="zipCode" name="zipCode" placeholder="우편번호" 
                                               style="width: 120px; margin-right: 10px;" readonly>
                                        <button type="button" class="btn-address-search" onclick="searchAddress()">주소 검색</button>
                                    </div>
                                    <input type="text" id="deliveryAddress" name="deliveryAddress" 
                                           placeholder="주소를 검색해주세요" readonly style="margin-top: 10px;">
                                    <input type="text" id="detailAddress" name="detailAddress" 
                                           placeholder="상세주소를 입력해주세요" style="margin-top: 10px;">
                                </div>
                                <div class="form-group">
                                    <label for="deliveryMemo">배송 메모</label>
                                    <select id="deliveryMemo" name="deliveryMemo">
                                        <option value="">배송 메모를 선택해주세요</option>
                                        <option value="부재시 경비실에 맡겨주세요">부재시 경비실에 맡겨주세요</option>
                                        <option value="부재시 문앞에 놓아주세요">부재시 문앞에 놓아주세요</option>
                                        <option value="배송 전 연락바랍니다">배송 전 연락바랍니다</option>
                                        <option value="직접 수령하겠습니다">직접 수령하겠습니다</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label>
                                        <input type="checkbox" id="useDefaultAddress" onchange="toggleDefaultAddress()">
                                        기본배송지로 설정
                                    </label>
                                </div>
                            </div>
                        </form>
                    </div>
                    
                    <!-- 주문 요약 -->
                    <div class="order-summary">
                        <h3>주문 요약</h3>
                        <div class="summary-row">
                            <span>상품 금액</span>
                            <span><fmt:formatNumber value="${totalAmount != null ? totalAmount : 0}" pattern="#,##0"/>원</span>
                        </div>
                        <div class="summary-row">
                            <span>배송비</span>
                            <span>무료</span>
                        </div>
                        <div class="summary-row total">
                            <span>총 결제 금액</span>
                            <span><fmt:formatNumber value="${totalAmount != null ? totalAmount : 0}" pattern="#,##0"/>원</span>
                        </div>
                        <button type="button" class="btn-payment" onclick="proceedToPayment()">
                            결제하기
                        </button>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    
    <!-- 푸터 -->
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    
    <script>
        let cartItems = [];
        let totalAmount = 0;
        
        // 회원의 주소 정보 (서버에서 전달받은 데이터)
        const memberAddresses = [
            <c:forEach var="address" items="${memberAddresses}" varStatus="status">
            {
                addressId: ${address.addressId},
                postCode: '${address.postCode}',
                addressName: '${address.addressName}',
                addressBasic: '${address.addressBasic}',
                addressDetail: '${address.addressDetail}'
            }<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];
        
        // 페이지 로드 시 초기화
        document.addEventListener('DOMContentLoaded', function() {
            // 바로 구매인지 확인
            const urlParams = new URLSearchParams(window.location.search);
            const directBuy = urlParams.get('directBuy');
            const bookId = urlParams.get('bookId');
            const quantity = urlParams.get('quantity');
            
            if (directBuy === 'true' && bookId && quantity) {
                // 바로 구매인 경우
                loadDirectBuyItem(bookId, quantity);
            } else {
                // 장바구니에서 온 경우 - 서버사이드에서 이미 로드됨
                console.log('서버사이드에서 장바구니 데이터 로드 완료');
            }
        });
        
        // 바로 구매 아이템 로드 (서버사이드에서 이미 처리됨)
        function loadDirectBuyItem(bookId, quantity) {
            // 바로 구매의 경우 서버사이드에서 이미 처리되므로 
            // 클라이언트사이드 로직은 필요 없음
            console.log('바로 구매 모드: 서버사이드에서 처리됨');
        }
        
        // 장바구니 아이템 로드
        function loadCartItems() {
            console.log('장바구니 아이템 로드 시작');
            fetch('/api/cart/items')
                .then(response => {
                    console.log('API 응답 상태:', response.status);
                    return response.json();
                })
                .then(data => {
                    console.log('API 응답 데이터:', data);
                    if (data.success) {
                        cartItems = data.cartItems || [];
                        totalAmount = data.totalAmount || 0;
                        console.log('장바구니 아이템 수:', cartItems.length);
                        console.log('총 금액:', totalAmount);
                        renderCartItems();
                        updateOrderSummary();
                    } else {
                        console.log('API 응답 실패:', data.message);
                        showEmptyCart();
                    }
                })
                .catch(error => {
                    console.error('장바구니 로드 실패:', error);
                    showEmptyCart();
                });
        }
        
        // 장바구니 아이템 렌더링
        function renderCartItems() {
            const container = document.getElementById('cartItemsContainer');
            
            if (cartItems.length === 0) {
                showEmptyCart();
                return;
            }
            
            let html = '';
            cartItems.forEach(item => {
                const thumbnailHtml = item.thumbnailUrl ? 
                    '<img src="' + item.thumbnailUrl + '" alt="' + item.title + '">' : 
                    '<div class="no-image">이미지 없음</div>';
                
                html += '<div class="order-item">' +
                    '<div class="order-item-thumbnail">' + thumbnailHtml + '</div>' +
                    '<div class="order-item-info">' +
                        '<div class="order-item-title">' + item.title + '</div>' +
                        '<div class="order-item-meta">저자: ' + item.authors + ' | 출판사: ' + item.publisher + '</div>' +
                        '<div class="order-item-price">' + item.price.toLocaleString() + '원</div>' +
                    '</div>' +
                    '<div class="order-item-quantity">' + item.quantity + '개</div>' +
                    '<div class="order-item-subtotal">' + item.subtotal.toLocaleString() + '원</div>' +
                '</div>';
            });
            
            container.innerHTML = html;
        }
        
        // 빈 장바구니 표시
        function showEmptyCart() {
            const container = document.getElementById('cartItemsContainer');
            container.innerHTML = '<div style="text-align: center; padding: 100px 20px; background: white; border-radius: 8px;">' +
                '<div style="font-size: 80px; margin-bottom: 20px;">🛒</div>' +
                '<div style="font-size: 18px; color: #666; margin-bottom: 30px;">장바구니가 비어있습니다.</div>' +
                '<a href="/" style="display: inline-block; padding: 12px 30px; background: #0066cc; color: white; text-decoration: none; border-radius: 4px; font-size: 16px;">쇼핑 계속하기</a>' +
            '</div>';
        }
        
        // 주문 요약 업데이트
        function updateOrderSummary() {
            const totalAmountElement = document.querySelector('.summary-row.total span:last-child');
            if (totalAmountElement) {
                totalAmountElement.textContent = totalAmount.toLocaleString() + '원';
            }
            
            const productAmountElement = document.querySelector('.summary-row:not(.total) span:last-child');
            if (productAmountElement) {
                productAmountElement.textContent = totalAmount.toLocaleString() + '원';
            }
        }
        
        // 주소 검색 (다음 우편번호 서비스)
        function searchAddress() {
            new daum.Postcode({
                oncomplete: function(data) {
                    // 우편번호와 주소 정보를 해당 필드에 넣는다.
                    document.getElementById('zipCode').value = data.zonecode;
                    document.getElementById('deliveryAddress').value = data.address;
                    // 커서를 상세주소 필드로 이동한다.
                    document.getElementById('detailAddress').focus();
                }
            }).open();
        }
        
        // 기본 배송지 토글 함수
        function toggleDefaultAddress() {
            const checkbox = document.getElementById('useDefaultAddress');
            const zipCodeInput = document.getElementById('zipCode');
            const deliveryAddressInput = document.getElementById('deliveryAddress');
            const detailAddressInput = document.getElementById('detailAddress');
            
            if (checkbox.checked) {
                // 기본 배송지 사용
                if (memberAddresses.length > 0) {
                    // 첫 번째 주소를 기본 배송지로 사용
                    const defaultAddress = memberAddresses[0];
                    zipCodeInput.value = defaultAddress.postCode || '';
                    deliveryAddressInput.value = defaultAddress.addressBasic || '';
                    detailAddressInput.value = defaultAddress.addressDetail || '';
                    
                    // 필드들을 읽기 전용으로 설정
                    zipCodeInput.readOnly = true;
                    deliveryAddressInput.readOnly = true;
                    detailAddressInput.readOnly = true;
                    
                    console.log('기본 배송지 적용:', defaultAddress);
                } else {
                    alert('저장된 기본 배송지가 없습니다.');
                    checkbox.checked = false;
                }
            } else {
                // 수동 입력 모드
                zipCodeInput.value = '';
                deliveryAddressInput.value = '';
                detailAddressInput.value = '';
                
                // 필드들을 입력 가능하도록 설정
                zipCodeInput.readOnly = true; // 우편번호는 주소 검색으로만 입력
                deliveryAddressInput.readOnly = true; // 주소는 주소 검색으로만 입력
                detailAddressInput.readOnly = false; // 상세주소는 직접 입력 가능
            }
        }
        
        // 기본 연락처 토글 함수
        function toggleDefaultPhone() {
            const checkbox = document.getElementById('useDefaultPhone');
            const phoneInput = document.getElementById('recipientPhone');
            const memberPhone = '${memberPhone}';
            
            if (checkbox.checked) {
                // 기본 연락처 사용
                if (memberPhone && memberPhone.trim() !== '') {
                    phoneInput.value = memberPhone;
                    phoneInput.readOnly = true;
                    console.log('기본 연락처 적용:', memberPhone);
                } else {
                    alert('저장된 기본 연락처가 없습니다.');
                    checkbox.checked = false;
                }
            } else {
                // 수동 입력 모드
                phoneInput.value = '';
                phoneInput.readOnly = false;
            }
        }
        
        function proceedToPayment() {
            // 장바구니가 비어있는지 확인 (서버사이드 데이터 사용)
            const cartItemsContainer = document.getElementById('cartItemsContainer');
            const hasItems = cartItemsContainer.querySelector('.order-item') !== null;
            
            if (!hasItems) {
                alert('장바구니가 비어있습니다.');
                return;
            }
            
            // 배송지 정보 유효성 검사
            const form = document.getElementById('shippingForm');
            const formData = new FormData(form);
            
            // 필수 필드 검사
            const recipientName = formData.get('recipientName');
            const recipientPhone = formData.get('recipientPhone');
            const zipCode = formData.get('zipCode');
            const deliveryAddress = formData.get('deliveryAddress');
            const detailAddress = formData.get('detailAddress');
            
            if (!recipientName || recipientName.trim() === '') {
                alert('수령인 이름을 입력해주세요.');
                document.getElementById('recipientName').focus();
                return;
            }
            
            if (!recipientPhone || recipientPhone.trim() === '') {
                alert('수령인 연락처를 입력해주세요.');
                document.getElementById('recipientPhone').focus();
                return;
            }
            
            // 전화번호 형식 검사
            const phonePattern = /^[0-9]{3}-[0-9]{4}-[0-9]{4}$/;
            if (!phonePattern.test(recipientPhone)) {
                alert('연락처는 010-1234-5678 형식으로 입력해주세요.');
                document.getElementById('recipientPhone').focus();
                return;
            }
            
            if (!zipCode || zipCode.trim() === '') {
                alert('우편번호를 검색해주세요.');
                searchAddress();
                return;
            }
            
            if (!deliveryAddress || deliveryAddress.trim() === '') {
                alert('주소를 검색해주세요.');
                searchAddress();
                return;
            }
            
            if (!detailAddress || detailAddress.trim() === '') {
                alert('상세주소를 입력해주세요.');
                document.getElementById('detailAddress').focus();
                return;
            }
            
            // 전체 주소 조합
            const fullAddress = deliveryAddress + ' ' + detailAddress;
            
            // 결제 페이지로 이동 (주소 정보 포함, 서버사이드 계산된 총 금액 사용)
            const params = new URLSearchParams();
            params.append('totalAmount', '${totalAmount != null ? totalAmount : 0}');
            params.append('recipientName', recipientName);
            params.append('recipientPhone', recipientPhone);
            params.append('deliveryAddress', fullAddress);
            params.append('zipCode', zipCode);
            
            // 직접 구매인 경우 bookId와 quantity 추가
            const urlParams = new URLSearchParams(window.location.search);
            const bookId = urlParams.get('bookId');
            const quantity = urlParams.get('quantity');
            const directBuy = urlParams.get('directBuy');
            
            if (directBuy === 'true' && bookId && quantity) {
                params.append('bookId', bookId);
                params.append('quantity', quantity);
                params.append('directBuy', 'true');
                console.log('직접 구매 정보 전달:', { bookId, quantity });
            }
            
            const deliveryMemo = formData.get('deliveryMemo');
            if (deliveryMemo) {
                params.append('deliveryMemo', deliveryMemo);
            }
            
            window.location.href = '/order/payment?' + params.toString();
        }
    </script>
</body>
</html>
