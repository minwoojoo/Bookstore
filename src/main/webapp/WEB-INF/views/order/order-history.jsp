<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<body>

<main class="main-container">
    <div class="container">
        <!-- 페이지 헤더 -->
        <div class="page-header">
            <h1 class="page-title">주문 내역</h1>
            <p class="page-subtitle">나의 주문 내역을 확인하세요</p>
        </div>

        <!-- 주문 내역 목록 -->
        <div class="order-list">
            <c:choose>
                <c:when test="${not empty orders}">
                    <c:forEach var="order" items="${orders}" varStatus="status">
                        <div class="order-item">
                            <div class="order-header">
                                <div class="order-info">
                                    <div class="order-number">주문번호: #${status.index + 1}</div>
                                    <div class="order-date">
                                        ${order.orderDate.year}년 ${order.orderDate.monthValue}월 ${order.orderDate.dayOfMonth}일 ${order.orderDate.hour}:${order.orderDate.minute < 10 ? '0' : ''}${order.orderDate.minute}
                                    </div>
                                </div>
                                <span class="order-status ${order.orderStatus == 'PENDING' ? 'status-pending' : order.orderStatus == 'CONFIRMED' ? 'status-confirmed' : order.orderStatus == 'SHIPPED' ? 'status-shipped' : order.orderStatus == 'DELIVERED' ? 'status-delivered' : order.orderStatus == 'CANCELLED' ? 'status-cancelled' : 'status-pending'}">
                                    <c:choose>
                                        <c:when test="${order.orderStatus == 'PENDING'}">결제대기</c:when>
                                        <c:when test="${order.orderStatus == 'CONFIRMED'}">결제완료</c:when>
                                        <c:when test="${order.orderStatus == 'SHIPPED'}">배송중</c:when>
                                        <c:when test="${order.orderStatus == 'DELIVERED'}">배송완료</c:when>
                                        <c:when test="${order.orderStatus == 'CANCELLED'}">주문취소</c:when>
                                        <c:otherwise>결제대기</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            
                            <div class="order-details">
                                <div class="order-info-grid">
                                    <div class="info-item">
                                        <span class="info-label">수령인</span>
                                        <span class="info-value">${order.recipientName != null && order.recipientName.trim() != '' ? order.recipientName : '-'}</span>
                                    </div>
                                    <div class="info-item">
                                        <span class="info-label">연락처</span>
                                        <span class="info-value">${order.recipientPhone != null && order.recipientPhone.trim() != '' ? order.recipientPhone : '-'}</span>
                                    </div>
                                    <div class="info-item">
                                        <span class="info-label">배송지</span>
                                        <span class="info-value">${order.deliveryAddress != null && order.deliveryAddress.trim() != '' ? order.deliveryAddress : '-'}</span>
                                    </div>
                                    <div class="info-item">
                                        <span class="info-label">배송메모</span>
                                        <span class="info-value">${order.memo != null && order.memo.trim() != '' ? order.memo : '없음'}</span>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="order-summary">
                                <div class="order-amount">
                                    총 <fmt:formatNumber value="${order.totalAmount}" pattern="#,##0"/>원
                                </div>
                                <div class="order-actions">
                                    <button class="btn btn-outline btn-small" onclick="viewOrderDetail('${order.orderId}')">
                                        상세보기
                                    </button>
                                </div>
                            </div>

                            <div class="order-items">
                                <c:forEach var="item" items="${order.orderItems}">
                                    <div class="order-item-book">
                                        <img src="${item.thumbnailUrl != null ? item.thumbnailUrl : '/images/no-image.png'}" 
                                             alt="${item.bookTitle}" class="book-thumbnail">
                                        <div class="book-info">
                                            <h4 class="book-title">${item.bookTitle}</h4>
                                            <p class="book-author">${item.bookAuthor}</p>
                                            <p class="book-quantity">수량: ${item.quantity}개</p>
                                        </div>
                                        <div class="book-price">
                                            <fmt:formatNumber value="${item.totalPrice}" pattern="#,##0"/>원
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <div class="empty-icon">
                            <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1">
                                <path d="M16 11V7a4 4 0 0 0-8 0v4M5 9h14l1 12H4L5 9z"/>
                            </svg>
                        </div>
                        <h3>주문 내역이 없습니다</h3>
                        <p>아직 주문한 상품이 없습니다.<br>마음에 드는 도서를 주문해보세요!</p>
                        <a href="/" class="btn btn-primary">쇼핑하러 가기</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<style>
    .main-container {
        padding: 40px 0;
        min-height: calc(100vh - 200px);
    }

    .page-header {
        text-align: center;
        margin-bottom: 40px;
    }

    .page-title {
        font-size: 32px;
        font-weight: 700;
        color: var(--text-1);
        margin: 0 0 8px 0;
    }

    .page-subtitle {
        font-size: 16px;
        color: var(--text-2);
        margin: 0;
    }

    .order-list {
        max-width: 800px;
        margin: 0 auto;
    }

    .order-item {
        background: var(--white);
        border-radius: 12px;
        padding: 24px;
        margin-bottom: 16px;
        box-shadow: var(--shadow);
        border: 1px solid rgba(0,0,0,0.05);
        transition: all 0.2s;
    }

    .order-item:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(0,0,0,0.1);
    }

    .order-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 16px;
        padding-bottom: 16px;
        border-bottom: 1px solid var(--border);
    }

    .order-info {
        display: flex;
        flex-direction: column;
        gap: 4px;
    }

    .order-number {
        font-size: 18px;
        font-weight: 600;
        color: var(--text-1);
    }

    .order-date {
        font-size: 14px;
        color: var(--text-2);
    }

    .order-status {
        padding: 6px 12px;
        border-radius: 20px;
        font-size: 14px;
        font-weight: 500;
    }

    .status-pending {
        background: #fff3cd;
        color: #856404;
    }

    .status-confirmed {
        background: #d1ecf1;
        color: #0c5460;
    }

    .status-shipped {
        background: #d4edda;
        color: #155724;
    }

    .status-delivered {
        background: #e2e3e5;
        color: #383d41;
    }

    .status-cancelled {
        background: #f8d7da;
        color: #721c24;
    }

    .order-summary {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 16px;
    }

    .order-amount {
        font-size: 20px;
        font-weight: 700;
        color: var(--pink-1);
    }

    .order-actions {
        display: flex;
        gap: 8px;
    }

    .order-details {
        margin: 16px 0;
        padding: 16px;
        background: var(--bg-light);
        border-radius: 8px;
        border: 1px solid var(--border-light);
    }

    .order-info-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 12px;
    }

    .info-item {
        display: flex;
        flex-direction: column;
        gap: 4px;
    }

    .info-label {
        font-size: 12px;
        font-weight: 500;
        color: var(--text-3);
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .info-value {
        font-size: 14px;
        color: var(--text-1);
        word-break: break-all;
    }

    .btn-small {
        padding: 8px 16px;
        font-size: 14px;
    }

    .order-items {
        margin-top: 16px;
    }

    .order-item-book {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 12px 0;
        border-bottom: 1px solid var(--border-light);
    }

    .order-item-book:last-child {
        border-bottom: none;
    }

    .book-thumbnail {
        width: 60px;
        height: 80px;
        object-fit: cover;
        border-radius: 6px;
        background: var(--bg-light);
    }

    .book-info {
        flex: 1;
    }

    .book-title {
        font-size: 16px;
        font-weight: 500;
        color: var(--text-1);
        margin: 0 0 4px 0;
        line-height: 1.4;
    }

    .book-author {
        font-size: 14px;
        color: var(--text-2);
        margin: 0 0 4px 0;
    }

    .book-quantity {
        font-size: 14px;
        color: var(--text-2);
    }

    .book-price {
        font-size: 16px;
        font-weight: 600;
        color: var(--text-1);
        text-align: right;
    }

    .loading {
        text-align: center;
        padding: 60px 20px;
    }

    .spinner {
        width: 40px;
        height: 40px;
        border: 4px solid var(--border-light);
        border-top: 4px solid var(--pink-1);
        border-radius: 50%;
        animation: spin 1s linear infinite;
        margin: 0 auto 16px;
    }

    @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }

    .empty-state {
        text-align: center;
        padding: 80px 20px;
    }

    .empty-icon {
        color: var(--text-3);
        margin-bottom: 24px;
    }

    .empty-state h3 {
        font-size: 24px;
        font-weight: 600;
        color: var(--text-1);
        margin: 0 0 12px 0;
    }

    .empty-state p {
        font-size: 16px;
        color: var(--text-2);
        margin: 0 0 32px 0;
        line-height: 1.6;
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
        .main-container {
            padding: 20px 0;
        }

        .page-title {
            font-size: 24px;
        }

        .order-item {
            padding: 16px;
        }

        .order-header {
            flex-direction: column;
            align-items: flex-start;
            gap: 12px;
        }

        .order-summary {
            flex-direction: column;
            align-items: flex-start;
            gap: 12px;
        }

        .order-actions {
            width: 100%;
            justify-content: flex-end;
        }

        .order-info-grid {
            grid-template-columns: 1fr;
        }

        .order-details {
            margin: 12px 0;
            padding: 12px;
        }
    }
</style>

<script>

    // 주문 상세보기
    function viewOrderDetail(orderId) {
        console.log('viewOrderDetail 호출됨, orderId:', orderId, typeof orderId);
        
        // orderId를 숫자로 변환
        const numericOrderId = Number(orderId);
        console.log('변환된 numericOrderId:', numericOrderId, typeof numericOrderId);
        
        // orderId 유효성 검사
        if (!numericOrderId || isNaN(numericOrderId) || numericOrderId <= 0) {
            console.error('주문 ID가 유효하지 않습니다:', orderId);
            alert('주문 정보를 찾을 수 없습니다.');
            return;
        }
        
        const url = '/order/' + numericOrderId + '/detail';
        console.log('이동할 URL:', url);
        console.log('URL 구성 요소 확인 - orderId:', orderId, 'numericOrderId:', numericOrderId);
        window.location.href = url;
    }


</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
