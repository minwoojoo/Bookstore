<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<body>

<main class="main-container">
    <div class="container">
        <!-- 페이지 헤더 -->
        <div class="page-header">
            <h1 class="page-title">주문 상세</h1>
        </div>

        <!-- 주문 상세 정보 -->
        <div class="order-detail" id="orderDetail">
            <c:choose>
                <c:when test="${order != null}">
                    <!-- 주문 정보 -->
                    <div class="order-card">
                        <h2 class="card-title">주문 정보</h2>
                        <div class="order-info">
                            <div class="info-item">
                                <span class="info-label">주문번호</span>
                                <span class="info-value">${order.orderId}</span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">주문일시</span>
                                <span class="info-value">
                                    ${order.orderDate.year}년 ${order.orderDate.monthValue}월 ${order.orderDate.dayOfMonth}일 ${order.orderDate.hour}:${order.orderDate.minute < 10 ? '0' : ''}${order.orderDate.minute}
                                </span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">주문상태</span>
                                <span class="order-status ${order.orderStatus == 'PENDING' ? 'status-pending' : 
                                                           order.orderStatus == 'CONFIRMED' ? 'status-confirmed' :
                                                           order.orderStatus == 'SHIPPED' ? 'status-shipped' :
                                                           order.orderStatus == 'DELIVERED' ? 'status-delivered' :
                                                           order.orderStatus == 'CANCELLED' ? 'status-cancelled' : 'status-pending'}">
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
                            <div class="info-item">
                                <span class="info-label">총 결제금액</span>
                                <span class="info-value" style="color: var(--pink-1); font-weight: 600;">
                                    <fmt:formatNumber value="${order.totalAmount}" pattern="#,###" />원
                                </span>
                            </div>
                        </div>
                    </div>

                    <!-- 배송 정보 -->
                    <div class="order-card">
                        <h2 class="card-title">배송 정보</h2>
                        <div class="order-info">
                            <div class="info-item">
                                <span class="info-label">수령인</span>
                                <span class="info-value">${order.recipientName != null ? order.recipientName : '-'}</span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">연락처</span>
                                <span class="info-value">${order.recipientPhone != null ? order.recipientPhone : '-'}</span>
                            </div>
                            <div class="info-item" style="grid-column: 1 / -1;">
                                <span class="info-label">배송주소</span>
                                <span class="info-value">${order.deliveryAddress != null ? order.deliveryAddress : '-'}</span>
                            </div>
                            <c:if test="${order.memo != null && order.memo.trim() != ''}">
                                <div class="info-item" style="grid-column: 1 / -1;">
                                    <span class="info-label">배송메모</span>
                                    <span class="info-value">${order.memo}</span>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <!-- 주문 상품 -->
                    <div class="order-card">
                        <h2 class="card-title">주문 상품</h2>
                        <div class="order-items">
                            <c:forEach var="item" items="${order.orderItems}">
                                <div class="order-item-book" data-book-id="${item.bookId}">
                                    <img src="${item.thumbnailUrl != null ? item.thumbnailUrl : '/images/no-image.png'}" 
                                         alt="${item.bookTitle}" class="book-thumbnail">
                                    <div class="book-info">
                                        <h4 class="book-title">${item.bookTitle}</h4>
                                        <p class="book-author">${item.bookAuthor}</p>
                                        <p class="book-publisher">${item.publisher}</p>
                                        <p class="book-quantity">수량: ${item.quantity}개</p>
                                    </div>
                                    <div class="book-price">
                                        <div class="book-unit-price">
                                            단가: <fmt:formatNumber value="${item.price}" pattern="#,###" />원
                                        </div>
                                        <div class="book-total-price">
                                            <fmt:formatNumber value="${item.totalPrice}" pattern="#,###" />원
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        
                        <div class="order-summary">
                            <div class="summary-row">
                                <span class="summary-label">총 상품금액</span>
                                <span class="summary-value">
                                    <fmt:formatNumber value="${order.totalAmount}" pattern="#,###" />원
                                </span>
                            </div>
                            <div class="summary-row">
                                <span class="summary-label">배송비</span>
                                <span class="summary-value">무료</span>
                            </div>
                            <div class="summary-row">
                                <span class="summary-label">총 결제금액</span>
                                <span class="summary-value">
                                    <fmt:formatNumber value="${order.totalAmount}" pattern="#,###" />원
                                </span>
                            </div>
            </div>
        </div>

                    <!-- 리뷰 섹션 (결제완료 상태에서만 표시) -->
                    <c:if test="${order.orderStatus == 'CONFIRMED'}">
                        <div class="order-card">
                            <h2 class="card-title">리뷰 작성</h2>
                            <div id="review-section">
                                <!-- 리뷰 작성/수정 폼이 여기에 동적으로 로드됩니다 -->
                            </div>
                        </div>
                    </c:if>

                    <!-- 주문 액션 -->
                    <div class="order-actions">
                        <button class="btn btn-outline" onclick="history.back()">목록으로</button>
                        <c:if test="${order.orderStatus == 'PENDING' || order.orderStatus == 'CONFIRMED'}">
                            <button class="btn btn-danger" onclick="cancelOrder('${order.orderId}')">주문취소</button>
                        </c:if>
                    </div>
                </c:when>
                <c:otherwise>
        <!-- 에러 상태 -->
                    <div class="error-state">
            <div class="error-icon">
                <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1">
                    <circle cx="12" cy="12" r="10"/>
                    <line x1="15" y1="9" x2="9" y2="15"/>
                    <line x1="9" y1="9" x2="15" y2="15"/>
                </svg>
            </div>
            <h3>주문 정보를 불러올 수 없습니다</h3>
            <p>주문 정보를 불러오는 중 오류가 발생했습니다.<br>잠시 후 다시 시도해주세요.</p>
                        <button class="btn btn-primary" onclick="location.reload()">다시 시도</button>
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
        margin-bottom: 32px;
    }

    .page-title {
        font-size: 28px;
        font-weight: 700;
        color: var(--text-1);
        margin: 0;
    }

    .order-detail {
        max-width: 800px;
        margin: 0 auto;
    }

    .order-card {
        background: var(--white);
        border-radius: 12px;
        padding: 24px;
        margin-bottom: 24px;
        box-shadow: var(--shadow);
        border: 1px solid rgba(0,0,0,0.05);
    }

    .card-title {
        font-size: 20px;
        font-weight: 600;
        color: var(--text-1);
        margin: 0 0 20px 0;
        padding-bottom: 12px;
        border-bottom: 2px solid var(--pink-1);
    }

    .order-info {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 16px;
        margin-bottom: 20px;
    }

    .info-item {
        display: flex;
        flex-direction: column;
        gap: 4px;
    }

    .info-label {
        font-size: 14px;
        color: var(--text-2);
        font-weight: 500;
    }

    .info-value {
        font-size: 16px;
        color: var(--text-1);
        font-weight: 500;
    }

    .order-status {
        display: inline-block;
        padding: 8px 16px;
        border-radius: 20px;
        font-size: 14px;
        font-weight: 500;
        text-align: center;
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

    .order-items {
        margin-top: 20px;
    }

    .order-item-book {
        display: flex;
        align-items: center;
        gap: 16px;
        padding: 16px 0;
        border-bottom: 1px solid var(--border-light);
    }

    .order-item-book:last-child {
        border-bottom: none;
    }

    .book-thumbnail {
        width: 80px;
        height: 100px;
        object-fit: cover;
        border-radius: 8px;
        background: var(--bg-light);
    }

    .book-info {
        flex: 1;
    }

    .book-title {
        font-size: 18px;
        font-weight: 600;
        color: var(--text-1);
        margin: 0 0 8px 0;
        line-height: 1.4;
    }

    .book-author {
        font-size: 14px;
        color: var(--text-2);
        margin: 0 0 4px 0;
    }

    .book-publisher {
        font-size: 13px;
        color: var(--text-3);
        margin: 0 0 8px 0;
    }

    .book-quantity {
        font-size: 14px;
        color: var(--text-2);
    }

    .book-price {
        text-align: right;
    }

    .book-unit-price {
        font-size: 14px;
        color: var(--text-2);
        margin-bottom: 4px;
    }

    .book-total-price {
        font-size: 18px;
        font-weight: 600;
        color: var(--text-1);
    }

    .order-summary {
        background: var(--bg-light);
        border-radius: 8px;
        padding: 20px;
        margin-top: 20px;
    }

    .summary-row {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 12px;
    }

    .summary-row:last-child {
        margin-bottom: 0;
        padding-top: 12px;
        border-top: 2px solid var(--border);
        font-size: 18px;
        font-weight: 700;
        color: var(--pink-1);
    }

    .summary-label {
        font-size: 16px;
        color: var(--text-1);
    }

    .summary-value {
        font-size: 16px;
        font-weight: 600;
        color: var(--text-1);
    }

    .order-actions {
        display: flex;
        gap: 12px;
        justify-content: center;
        margin-top: 24px;
    }

    /* 리뷰 섹션 스타일 */
    .review-form {
        background: #f8f9fa;
        border-radius: 8px;
        padding: 20px;
        margin-bottom: 20px;
    }

    .review-form h3 {
        font-size: 18px;
        margin-bottom: 15px;
        color: #333;
    }

    .review-form-group {
        margin-bottom: 15px;
    }

    .review-form-group label {
        display: block;
        margin-bottom: 5px;
        font-weight: 500;
        color: #333;
    }

    .rating-input {
        display: flex;
        gap: 5px;
        margin-bottom: 10px;
    }

    .rating-star {
        font-size: 24px;
        color: #ddd;
        cursor: pointer;
        transition: color 0.2s;
    }

    .rating-star.active {
        color: #ffc107;
    }

    .rating-star:hover {
        color: #ffc107;
    }

    .review-textarea {
        width: 100%;
        min-height: 100px;
        padding: 10px;
        border: 1px solid #ddd;
        border-radius: 4px;
        font-family: inherit;
        resize: vertical;
    }

    .review-buttons {
        display: flex;
        gap: 10px;
        justify-content: flex-end;
    }

    .review-item {
        background: white;
        border: 1px solid #e0e0e0;
        border-radius: 8px;
        padding: 20px;
        margin-bottom: 15px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }

    .review-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 10px;
    }

    .review-author {
        font-weight: 500;
        color: #333;
    }

    .review-date {
        font-size: 12px;
        color: #666;
    }

    .review-rating {
        color: #ffc107;
        font-size: 16px;
        margin-bottom: 8px;
    }

    .review-content {
        color: #333;
        line-height: 1.5;
        margin-bottom: 10px;
    }

    .review-actions {
        display: flex;
        gap: 10px;
        justify-content: flex-end;
    }

    .btn-small {
        padding: 6px 12px;
        font-size: 12px;
    }

    .no-review {
        text-align: center;
        color: #666;
        padding: 20px;
        font-style: italic;
    }

    .error-state {
        text-align: center;
        padding: 80px 20px;
    }

    .error-icon {
        color: var(--text-3);
        margin-bottom: 24px;
    }

    .error-state h3 {
        font-size: 24px;
        font-weight: 600;
        color: var(--text-1);
        margin: 0 0 12px 0;
    }

    .error-state p {
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

        .order-card {
            padding: 16px;
        }

        .order-info {
            grid-template-columns: 1fr;
        }

        .order-item-book {
            flex-direction: column;
            align-items: flex-start;
            gap: 12px;
        }

        .book-thumbnail {
            width: 60px;
            height: 80px;
        }

        .book-price {
            text-align: left;
            width: 100%;
        }

        .order-actions {
            flex-direction: column;
        }
    }
</style>

<script>
    let currentReview = null;
    let currentRating = 0;

    // 페이지 로드 시 리뷰 섹션 초기화
    document.addEventListener('DOMContentLoaded', function() {
        const reviewSection = document.getElementById('review-section');
        if (reviewSection) {
            loadReviewSection();
        }
    });

    // 리뷰 섹션 로드
    async function loadReviewSection() {
        const reviewSection = document.getElementById('review-section');
        if (!reviewSection) return;

        try {
            // 주문의 첫 번째 책 ID 가져오기
            const firstBookId = getFirstBookId();
            if (!firstBookId) return;

            // 기존 리뷰 확인
            const response = await fetch(`/api/reviews/book/${firstBookId}/member`);
            const data = await response.json();

            if (data.success && data.review) {
                // 기존 리뷰가 있는 경우 리뷰 표시 + 수정 버튼
                currentReview = data.review;
                showReviewDisplay(data.review);
            } else {
                // 리뷰가 없는 경우 작성 폼 표시
                showCreateReviewForm(firstBookId);
            }
        } catch (error) {
            console.error('리뷰 섹션 로드 실패:', error);
            reviewSection.innerHTML = '<div class="no-review">리뷰를 불러올 수 없습니다.</div>';
        }
    }

    // 주문의 첫 번째 책 ID 가져오기
    function getFirstBookId() {
        const orderItems = document.querySelectorAll('.order-item-book[data-book-id]');
        if (orderItems.length > 0) {
            return parseInt(orderItems[0].dataset.bookId);
        }
        return null;
    }

    // 리뷰 표시 (작성된 리뷰 보기)
    function showReviewDisplay(review) {
        console.log('showReviewDisplay 호출됨, review:', review);
        const reviewSection = document.getElementById('review-section');
        const stars = '★'.repeat(review.rating) + '☆'.repeat(5 - review.rating);
        const reviewDate = new Date(review.createdAt).toLocaleDateString('ko-KR');
        
        console.log('리뷰 내용:', review.content);
        console.log('리뷰 평점:', review.rating);
        
        // 전역 변수에 리뷰 데이터 저장
        currentReview = review;
        
        // 안전한 변수 처리
        const reviewContent = review.content || '리뷰 내용이 없습니다.';
        const reviewId = review.reviewId || 0;
        
        console.log('처리된 리뷰 내용:', reviewContent);
        console.log('처리된 reviewId:', reviewId);
        
        // HTML 직접 생성 방식으로 변경
        const reviewItem = document.createElement('div');
        reviewItem.className = 'review-item';
        reviewItem.setAttribute('data-review-id', reviewId); // data 속성으로 reviewId 저장
        
        reviewItem.innerHTML = 
            '<div class="review-header">' +
                '<span class="review-author">내 리뷰</span>' +
                '<span class="review-date">' + reviewDate + '</span>' +
            '</div>' +
            '<div class="review-rating">' + stars + '</div>' +
            '<div class="review-content">' + reviewContent + '</div>' +
            '<div class="review-actions">' +
                '<button class="btn btn-danger btn-small" onclick="deleteReviewFromButton(this)">삭제</button>' +
            '</div>';
        
        reviewSection.innerHTML = '';
        reviewSection.appendChild(reviewItem);
    }

    // 리뷰 작성 폼 표시
    function showCreateReviewForm(bookId) {
        const reviewSection = document.getElementById('review-section');
        reviewSection.innerHTML = `
            <div class="review-form">
                <h3>리뷰 작성</h3>
                <form id="reviewForm">
                    <div class="review-form-group">
                        <label>평점</label>
                        <div class="rating-input" id="ratingInput">
                            <span class="rating-star" data-rating="1">★</span>
                            <span class="rating-star" data-rating="2">★</span>
                            <span class="rating-star" data-rating="3">★</span>
                            <span class="rating-star" data-rating="4">★</span>
                            <span class="rating-star" data-rating="5">★</span>
                        </div>
                    </div>
                    <div class="review-form-group">
                        <label for="reviewContent">리뷰 내용</label>
                        <textarea id="reviewContent" class="review-textarea" placeholder="리뷰를 작성해주세요..." required></textarea>
                    </div>
                    <div class="review-buttons">
                        <button type="button" class="btn btn-outline btn-small" onclick="cancelReview()">취소</button>
                        <button type="submit" class="btn btn-primary btn-small">작성</button>
                    </div>
                </form>
            </div>
        `;

        // 평점 클릭 이벤트
        setupRatingInput();
        
        // 폼 제출 이벤트
        document.getElementById('reviewForm').addEventListener('submit', function(e) {
            e.preventDefault();
            createReview(bookId);
        });
    }


    // 평점 입력 설정
    function setupRatingInput() {
        const stars = document.querySelectorAll('.rating-star');
        stars.forEach(star => {
            star.addEventListener('click', function() {
                currentRating = parseInt(this.dataset.rating);
                updateRatingDisplay();
            });
        });
    }

    // 평점 표시 업데이트
    function updateRatingDisplay() {
        const stars = document.querySelectorAll('.rating-star');
        stars.forEach((star, index) => {
            if (index < currentRating) {
                star.classList.add('active');
            } else {
                star.classList.remove('active');
            }
        });
    }

    // 리뷰 작성
    async function createReview(bookId) {
        const content = document.getElementById('reviewContent').value.trim();
        
        if (currentRating === 0) {
            alert('평점을 선택해주세요.');
            return;
        }
        
        if (!content) {
            alert('리뷰 내용을 입력해주세요.');
            return;
        }
        
        try {
            const response = await fetch('/api/reviews', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    bookId: bookId,
                    rating: currentRating,
                    content: content
                })
            });

            const data = await response.json();
            
            if (data.success) {
                alert('리뷰가 작성되었습니다.');
                console.log('리뷰 작성 성공, 응답 데이터:', data);
                // 작성된 리뷰를 즉시 표시
                showReviewDisplay(data.review);
            } else {
                alert('리뷰 작성에 실패했습니다: ' + data.message);
            }
        } catch (error) {
            console.error('리뷰 작성 오류:', error);
            alert('리뷰 작성 중 오류가 발생했습니다.');
        }
    }


    // 버튼에서 리뷰 삭제 (새로운 방법)
    async function deleteReviewFromButton(button) {
        const reviewItem = button.closest('.review-item');
        const reviewId = reviewItem.getAttribute('data-review-id');
        
        console.log('deleteReviewFromButton 호출됨');
        console.log('reviewItem:', reviewItem);
        console.log('reviewId from data attribute:', reviewId);
        
        if (!reviewId || reviewId === '0') {
            alert('삭제할 리뷰 ID를 찾을 수 없습니다.');
            return;
        }
        
        await deleteReview(reviewId);
    }

    // 현재 리뷰 삭제
    async function deleteCurrentReview() {
        console.log('deleteCurrentReview 호출됨, currentReview:', currentReview);
        if (!currentReview) {
            alert('삭제할 리뷰가 없습니다.');
            return;
        }
        console.log('삭제할 reviewId:', currentReview.reviewId);
        await deleteReview(currentReview.reviewId);
    }

    // 리뷰 삭제
    async function deleteReview(reviewId) {
        console.log('리뷰 삭제 요청:', reviewId);
        console.log('reviewId 타입:', typeof reviewId);
        console.log('reviewId 값:', reviewId);
        
        // reviewId를 숫자로 변환
        const numericReviewId = parseInt(reviewId);
        console.log('변환된 reviewId:', numericReviewId);
        
        if (!numericReviewId || numericReviewId === 0 || isNaN(numericReviewId)) {
            alert('삭제할 리뷰 ID가 올바르지 않습니다.');
            return;
        }
        
        if (!confirm('정말로 이 리뷰를 삭제하시겠습니까?')) {
            return;
        }

        try {
            // 더 안전한 URL 생성
            const baseUrl = '/api/reviews/';
            const deleteUrl = baseUrl + numericReviewId;
            console.log('삭제 API 호출:', deleteUrl);
            console.log('baseUrl:', baseUrl);
            console.log('numericReviewId 값:', numericReviewId);
            console.log('최종 URL:', deleteUrl);
            
            const response = await fetch(deleteUrl, {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json'
                }
            });

            console.log('삭제 응답 상태:', response.status);
            
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            
            const data = await response.json();
            console.log('삭제 응답 데이터:', data);
            
            if (data.success) {
                alert('리뷰가 삭제되었습니다.');
                // 삭제 후 작성 폼 표시
                const firstBookId = getFirstBookId();
                if (firstBookId) {
                    showCreateReviewForm(firstBookId);
                }
            } else {
                alert('리뷰 삭제에 실패했습니다: ' + data.message);
            }
        } catch (error) {
            console.error('리뷰 삭제 오류:', error);
            alert('리뷰 삭제 중 오류가 발생했습니다: ' + error.message);
        }
    }

    // 리뷰 취소
    function cancelReview() {
        // 리뷰가 없으면 작성 폼 표시
        const firstBookId = getFirstBookId();
        if (firstBookId) {
            showCreateReviewForm(firstBookId);
        }
    }

    // 주문 취소
    async function cancelOrder(orderId) {
        console.log('주문 취소 요청:', orderId);
        
        if (!confirm('정말로 이 주문을 취소하시겠습니까?')) {
            return;
        }

        try {
            const response = await fetch(`/api/order/${orderId}/cancel`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                }
            });

            const data = await response.json();
            
            if (data.success) {
                alert('주문이 취소되었습니다.');
                // 주문 내역 페이지로 이동
                window.location.href = '/order/history';
            } else {
                alert('주문 취소에 실패했습니다: ' + data.message);
            }
        } catch (error) {
            console.error('주문 취소 오류:', error);
            alert('주문 취소 중 오류가 발생했습니다.');
        }
    }
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
