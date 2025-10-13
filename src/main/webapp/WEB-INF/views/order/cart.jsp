<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>장바구니 - Online Bookstore</title>
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
        
        /* 장바구니 비어있을 때 */
        .empty-cart {
            text-align: center;
            padding: 100px 20px;
            background: white;
            border-radius: 8px;
        }
        .empty-cart-icon {
            font-size: 80px;
            margin-bottom: 20px;
        }
        .empty-cart-text {
            font-size: 18px;
            color: #666;
            margin-bottom: 30px;
        }
        .btn-continue {
            display: inline-block;
            padding: 12px 30px;
            background: #0066cc;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-size: 16px;
        }
        .btn-continue:hover {
            background: #0052a3;
        }
        
        /* 장바구니 컨트롤 */
        .cart-controls {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding: 15px 20px;
            background: white;
            border-radius: 8px;
        }
        .select-all {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .select-all input[type="checkbox"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
        }
        .btn-delete-selected {
            padding: 8px 20px;
            background: #dc3545;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }
        .btn-delete-selected:hover {
            background: #c82333;
        }
        
        /* 장바구니 아이템 */
        .cart-items {
            background: white;
            border-radius: 8px;
            overflow: hidden;
            margin-bottom: 20px;
        }
        .cart-item {
            display: flex;
            align-items: center;
            gap: 20px;
            padding: 20px;
            border-bottom: 1px solid #f0f0f0;
        }
        .cart-item:last-child {
            border-bottom: none;
        }
        .cart-item-checkbox {
            flex-shrink: 0;
        }
        .cart-item-checkbox input[type="checkbox"] {
            width: 20px;
            height: 20px;
            cursor: pointer;
        }
        .cart-item-thumbnail {
            width: 100px;
            height: 130px;
            flex-shrink: 0;
        }
        .cart-item-thumbnail img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 4px;
        }
        .cart-item-thumbnail .no-image {
            width: 100%;
            height: 100%;
            background: #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 4px;
            color: #999;
            font-size: 12px;
        }
        .cart-item-info {
            flex: 1;
            min-width: 0;
        }
        .cart-item-title {
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 8px;
            color: #333;
        }
        .cart-item-title a {
            color: #333;
            text-decoration: none;
        }
        .cart-item-title a:hover {
            color: #0066cc;
        }
        .cart-item-meta {
            font-size: 14px;
            color: #666;
            margin-bottom: 10px;
        }
        .cart-item-price {
            font-size: 18px;
            font-weight: bold;
            color: #0066cc;
        }
        .cart-item-quantity {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-shrink: 0;
        }
        .quantity-control {
            display: flex;
            align-items: center;
            border: 1px solid #ddd;
            border-radius: 4px;
            overflow: hidden;
        }
        .quantity-control input {
            width: 60px;
            height: 36px;
            text-align: center;
            border: none;
            font-size: 14px;
        }
        .quantity-btn {
            width: 36px;
            height: 36px;
            background: #f5f5f5;
            border: none;
            cursor: pointer;
            font-size: 18px;
        }
        .quantity-btn:hover {
            background: #e0e0e0;
        }
        .cart-item-subtotal {
            text-align: right;
            min-width: 120px;
            flex-shrink: 0;
        }
        .subtotal-label {
            font-size: 12px;
            color: #999;
            margin-bottom: 5px;
        }
        .subtotal-amount {
            font-size: 20px;
            font-weight: bold;
            color: #333;
        }
        
        /* 주문 요약 */
        .order-summary {
            background: white;
            padding: 30px;
            border-radius: 8px;
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
        .btn-order {
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
        .btn-order:hover {
            background: #0052a3;
        }
        .btn-order:disabled {
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
            .cart-item {
                flex-direction: column;
                align-items: flex-start;
            }
            .cart-item-thumbnail {
                width: 100%;
                height: 200px;
            }
            .cart-item-quantity {
                width: 100%;
                justify-content: space-between;
            }
            .cart-item-subtotal {
                width: 100%;
                text-align: left;
            }
        }
    </style>
</head>
<body>
    <!-- 헤더 -->
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <!-- 메인 컨텐츠 -->
    <div class="main-container">
        <h1 class="page-title">🛒 장바구니</h1>
        
        <c:choose>
            <c:when test="${!isAuthenticated}">
                <!-- 비로그인 상태 -->
                <div class="empty-cart">
                    <div class="empty-cart-icon">🔒</div>
                    <div class="empty-cart-text">로그인이 필요한 서비스입니다.</div>
                    <a href="/auth/login" class="btn-continue">로그인하기</a>
                </div>
            </c:when>
            <c:when test="${empty cartItems}">
                <!-- 장바구니가 비어있을 때 -->
                <div class="empty-cart">
                    <div class="empty-cart-icon">🛒</div>
                    <div class="empty-cart-text">장바구니가 비어있습니다.</div>
                    <a href="/" class="btn-continue">쇼핑 계속하기</a>
                </div>
            </c:when>
            <c:otherwise>
                <!-- 장바구니 아이템이 있을 때 -->
                <form action="/cart/remove" method="post" id="cartForm">
                    <!-- 장바구니 컨트롤 -->
                    <div class="cart-controls">
                        <label class="select-all">
                            <input type="checkbox" id="selectAll" onclick="toggleSelectAll(this)">
                            <span>전체선택</span>
                        </label>
                        <button type="button" class="btn-delete-selected" onclick="deleteSelected()">선택 삭제</button>
                    </div>
                    
                    <!-- 장바구니 아이템 목록 -->
                    <div class="cart-items">
                        <c:forEach var="item" items="${cartItems}">
                            <div class="cart-item">
                                <div class="cart-item-checkbox">
                                    <input type="checkbox" name="cartItemIds[]" value="${item.cartItemId}" class="item-checkbox">
                                </div>
                                
                                <div class="cart-item-thumbnail">
                                    <c:choose>
                                        <c:when test="${not empty item.thumbnailUrl}">
                                            <img src="${item.thumbnailUrl}" alt="${item.title}">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="no-image">이미지 없음</div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                
                                <div class="cart-item-info">
                                    <div class="cart-item-title">
                                        <a href="/books/${item.bookId}">${item.title}</a>
                                    </div>
                                    <div class="cart-item-meta">
                                        저자: ${item.authors} | 출판사: ${item.publisher}
                                    </div>
                                    <div class="cart-item-price">
                                        <fmt:formatNumber value="${item.price}" pattern="#,##0"/>원
                                    </div>
                                </div>
                                
                                <div class="cart-item-quantity">
                                    <div class="quantity-control">
                                        <button type="button" class="quantity-btn" onclick="changeQuantity(${item.cartItemId}, -1)">−</button>
                                        <input type="number" id="qty-${item.cartItemId}" value="${item.quantity}" min="1" readonly>
                                        <button type="button" class="quantity-btn" onclick="changeQuantity(${item.cartItemId}, 1)">+</button>
                                    </div>
                                </div>
                                
                                <div class="cart-item-subtotal">
                                    <div class="subtotal-label">소계</div>
                                    <div class="subtotal-amount">
                                        <fmt:formatNumber value="${item.subtotal}" pattern="#,##0"/>원
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <!-- 주문 요약 -->
                    <div class="order-summary">
                        <h3>📋 주문 요약</h3>
                        <div class="summary-row">
                            <span>상품 금액</span>
                            <span><fmt:formatNumber value="${totalAmount}" pattern="#,##0"/>원</span>
                        </div>
                        <div class="summary-row">
                            <span>배송비</span>
                            <span>무료</span>
                        </div>
                        <div class="summary-row total">
                            <span>총 결제 금액</span>
                            <span><fmt:formatNumber value="${totalAmount}" pattern="#,##0"/>원</span>
                        </div>
                        <button type="button" class="btn-order" onclick="proceedToCheckout()">주문하기</button>
                    </div>
                </form>
            </c:otherwise>
        </c:choose>
    </div>
    
    <!-- 푸터 -->
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    
    <script>
        // 전체 선택/해제
        function toggleSelectAll(checkbox) {
            const itemCheckboxes = document.querySelectorAll('.item-checkbox');
            itemCheckboxes.forEach(cb => cb.checked = checkbox.checked);
        }
        
        // 개별 체크박스 변경 시 전체 선택 체크박스 상태 업데이트
        document.querySelectorAll('.item-checkbox').forEach(checkbox => {
            checkbox.addEventListener('change', function() {
                const allCheckboxes = document.querySelectorAll('.item-checkbox');
                const checkedCount = document.querySelectorAll('.item-checkbox:checked').length;
                document.getElementById('selectAll').checked = (checkedCount === allCheckboxes.length);
            });
        });
        
        // 선택 삭제
        function deleteSelected() {
            const checkedBoxes = document.querySelectorAll('.item-checkbox:checked');
            if (checkedBoxes.length === 0) {
                alert('삭제할 상품을 선택해주세요.');
                return;
            }
            
            if (confirm(checkedBoxes.length + '개의 상품을 삭제하시겠습니까?')) {
                document.getElementById('cartForm').submit();
            }
        }
        
        // 수량 변경
        function changeQuantity(cartItemId, delta) {
            const input = document.getElementById('qty-' + cartItemId);
            const currentQty = parseInt(input.value);
            const newQty = currentQty + delta;
            
            if (newQty < 1) {
                if (confirm('상품을 장바구니에서 삭제하시겠습니까?')) {
                    // 삭제 처리
                    const checkbox = document.querySelector('input[value="' + cartItemId + '"]');
                    checkbox.checked = true;
                    document.getElementById('cartForm').submit();
                }
                return;
            }
            
            // 수량 변경 API 호출
            fetch('/api/cart/update', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'cartItemId=' + cartItemId + '&quantity=' + newQty
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // 페이지 새로고침
                    location.reload();
                } else {
                    alert(data.message);
                }
            })
            .catch(error => {
                console.error('수량 변경 실패:', error);
                alert('수량 변경에 실패했습니다.');
            });
        }
        
        // 주문하기
        function proceedToCheckout() {
            // 장바구니 아이템이 있는지 확인
            const cartItems = document.querySelectorAll('.cart-item');
            if (cartItems.length === 0) {
                alert('장바구니가 비어있습니다.');
                return;
            }
            
            // 서버사이드에서 총 금액을 계산하므로 클라이언트 계산 제거
            // 결제 페이지로 이동 (장바구니에서 온 것을 명시)
            window.location.href = '/order/checkout?directBuy=false';
        }
    </script>
</body>
</html>

