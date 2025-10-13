<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${book.title} - Online Bookstore</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            background: #f5f5f5;
            min-height: 100vh;
        }
        
        
        /* 메인 컨텐츠 */
        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        /* 상단 정보 섹션 */
        .book-header {
            background: white;
            padding: 30px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: grid;
            grid-template-columns: 350px 1fr 300px;
            gap: 30px;
        }
        
        /* 책 이미지 */
        .book-image {
            text-align: center;
        }
        .book-image img {
            width: 100%;
            max-width: 300px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        .book-image .no-image {
            width: 300px;
            height: 400px;
            background: #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 8px;
            color: #999;
            font-size: 18px;
        }
        
        /* 책 정보 */
        .book-info {
            flex: 1;
        }
        .book-category {
            font-size: 13px;
            color: #666;
            margin-bottom: 8px;
        }
        .book-title {
            font-size: 28px;
            font-weight: bold;
            color: #333;
            margin-bottom: 15px;
            line-height: 1.4;
        }
        .book-meta {
            font-size: 15px;
            color: #666;
            margin-bottom: 20px;
            line-height: 1.8;
        }
        .book-meta div {
            margin-bottom: 5px;
        }
        .book-meta strong {
            color: #333;
            margin-right: 10px;
        }
        .book-rating {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 20px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
        }
        .rating-score {
            font-size: 32px;
            font-weight: bold;
            color: #0066cc;
        }
        .rating-stars {
            font-size: 20px;
            color: #ffc107;
        }
        .rating-count {
            font-size: 14px;
            color: #666;
        }
        
        /* 가격 정보 박스 */
        .price-box {
            background: #f9f9f9;
            padding: 25px;
            border-radius: 8px;
            border: 2px solid #e0e0e0;
        }
        .price-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            font-size: 15px;
        }
        .price-row.discount {
            font-size: 24px;
            font-weight: bold;
            color: #0066cc;
        }
        .delivery-info {
            background: white;
            padding: 15px;
            margin: 15px 0;
            border-radius: 4px;
            font-size: 14px;
            line-height: 1.6;
        }
        .delivery-info strong {
            color: #0066cc;
        }
        
        /* 구매 옵션 */
        .purchase-box {
            margin-top: 20px;
        }
        .quantity-selector {
            display: flex;
            align-items: center;
            border: 1px solid #ddd;
            border-radius: 4px;
            overflow: hidden;
            margin-bottom: 10px;
        }
        .quantity-selector label {
            padding: 12px 15px;
            background: #f5f5f5;
            font-size: 14px;
            font-weight: bold;
        }
        .quantity-selector input {
            width: 60px;
            height: 40px;
            text-align: center;
            border: none;
            font-size: 16px;
        }
        .qty-btn {
            width: 40px;
            height: 40px;
            background: #f5f5f5;
            border: none;
            cursor: pointer;
            font-size: 18px;
        }
        .qty-btn:hover {
            background: #e0e0e0;
        }
        .btn-cart, .btn-buy-now {
            width: 100%;
            padding: 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 8px;
        }
        .btn-cart {
            background: #0066cc;
            color: white;
        }
        .btn-cart:hover {
            background: #0052a3;
        }
        .btn-buy-now {
            background: #00cc88;
            color: white;
        }
        .btn-buy-now:hover {
            background: #00a370;
        }
        
        /* 하단 상세 정보 */
        .book-details {
            background: white;
            padding: 30px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .details-section {
            margin-bottom: 30px;
        }
        .details-section h3 {
            font-size: 20px;
            color: #333;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #0066cc;
        }
        .details-table {
            width: 100%;
            border-collapse: collapse;
        }
        .details-table tr {
            border-bottom: 1px solid #f0f0f0;
        }
        .details-table th {
            text-align: left;
            padding: 12px;
            background: #f9f9f9;
            font-weight: bold;
            color: #333;
            width: 150px;
        }
        .details-table td {
            padding: 12px;
            color: #666;
        }
        .book-description {
            line-height: 1.8;
            color: #555;
            font-size: 15px;
        }
        
        /* 리뷰 섹션 */
        .reviews-container {
            margin-top: 20px;
        }
        
        .review-item {
            background: #f9f9f9;
            padding: 20px;
            margin-bottom: 15px;
            border-radius: 8px;
            border-left: 4px solid #0066cc;
        }
        
        .review-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        
        .review-rating {
            font-size: 18px;
            color: #ffc107;
        }
        
        .review-meta {
            display: flex;
            gap: 15px;
            font-size: 14px;
            color: #666;
        }
        
        .reviewer-name {
            font-weight: bold;
            color: #333;
        }
        
        .review-date {
            color: #999;
        }
        
        .review-content {
            font-size: 15px;
            line-height: 1.6;
            color: #555;
        }
        
        .no-reviews {
            text-align: center;
            padding: 40px 20px;
            color: #999;
            background: #f5f5f5;
            border-radius: 8px;
        }
        
        .no-reviews p {
            font-size: 16px;
            margin: 0;
        }
        
        /* 반응형 디자인 */
        @media (max-width: 768px) {
            .book-header {
                grid-template-columns: 1fr;
                gap: 20px;
            }
            
            .book-image {
                text-align: center;
            }
            
            .book-image img {
                max-width: 250px;
            }
            
            .book-title {
                font-size: 24px;
            }
            
            .price-box {
                margin-top: 20px;
            }
            
            .review-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            
            .review-meta {
                flex-direction: column;
                gap: 5px;
            }
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
    </style>
</head>
<body>
    <!-- 헤더 -->
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <!-- 메인 컨텐츠 -->
    <div class="container">
        <!-- 상단 정보 섹션 -->
        <div class="book-header">
            <!-- 책 이미지 -->
            <div class="book-image">
                <c:choose>
                    <c:when test="${not empty book.thumbnailUrl}">
                        <img src="${book.thumbnailUrl}" alt="${book.title}">
                    </c:when>
                    <c:otherwise>
                        <div class="no-image">이미지 없음</div>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <!-- 책 정보 -->
            <div class="book-info">
                <div class="book-category">
                    <a href="/" style="color: #0066cc; text-decoration: none;">홈</a> &gt; 도서
                </div>
                
                <h1 class="book-title">${book.title}</h1>
                
                <div class="book-meta">
                    <div><strong>저자:</strong> ${book.authors}</div>
                    <div><strong>출판사:</strong> ${book.publisher}</div>
                    <div><strong>발행일:</strong> ${book.registrationDate != null ? book.registrationDate : '정보 없음'}</div>
                </div>
                
                <div class="book-rating">
                    <div class="rating-score">
                        <c:choose>
                            <c:when test="${avgRating > 0}">
                                <fmt:formatNumber value="${avgRating}" pattern="#.#"/>
                            </c:when>
                            <c:otherwise>0.0</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="rating-stars">
                        <c:forEach begin="1" end="5" var="star">
                            <c:choose>
                                <c:when test="${star <= avgRating}">★</c:when>
                                <c:otherwise>☆</c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </div>
                    <div class="rating-count">(평가 ${reviewCount}개)</div>
                </div>
            </div>
            
            <!-- 가격 및 구매 박스 -->
            <div class="price-box">
                <div class="price-row discount">
                    <span>판매가</span>
                    <span><fmt:formatNumber value="${book.price}" pattern="#,##0"/>원</span>
                </div>
                
                <div class="delivery-info">
                    <div><strong>배송:</strong> 오늘 낮 12시까지 주문하면 <strong>내일 오후 2~6시</strong> 도착 예정</div>
                </div>
                
                <div class="purchase-box">
                    <div class="quantity-selector">
                        <label>수량</label>
                        <button type="button" class="qty-btn" onclick="decreaseQty()">−</button>
                        <input type="number" id="quantity" value="1" min="1" readonly>
                        <button type="button" class="qty-btn" onclick="increaseQty()">+</button>
                    </div>
                    <button type="button" class="btn-cart" onclick="addToCart()">카트에 넣기</button>
                    <button type="button" class="btn-buy-now" onclick="buyNow()">바로 구매</button>
                </div>
            </div>
        </div>
        
        <!-- 상세 정보 -->
        <div class="book-details">
            <!-- 품목 정보 -->
            <div class="details-section">
                <h3>📋 품목 정보</h3>
                <table class="details-table">
                    <tr>
                        <th>발행일</th>
                        <td>${book.registrationDate != null ? book.registrationDate : '정보 없음'}</td>
                    </tr>
                    <tr>
                        <th>쪽수</th>
                        <td>${book.pageCount != null ? book.pageCount : '-'}쪽</td>
                    </tr>
                    <tr>
                        <th>크기</th>
                        <td>${book.sizeInfo}</td>
                    </tr>
                    <tr>
                        <th>ISBN</th>
                        <td>${book.isbn}</td>
                    </tr>
                    <tr>
                        <th>출판사</th>
                        <td>${book.publisher}</td>
                    </tr>
                </table>
            </div>
            
            <!-- 책 소개 -->
            <div class="details-section">
                <h3>📖 책 소개</h3>
                <div class="book-description">
                    <c:choose>
                        <c:when test="${not empty book.description}">
                            ${book.description}
                        </c:when>
                        <c:otherwise>
                            <p>책 소개 정보가 준비 중입니다.</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <!-- 리뷰 섹션 -->
            <div class="details-section">
                <h3>💬 고객 리뷰 (${reviewCount}개)</h3>
                <c:choose>
                    <c:when test="${not empty reviews}">
                        <div class="reviews-container">
                            <c:forEach var="review" items="${reviews}">
                                <div class="review-item">
                                    <div class="review-header">
                                        <div class="review-rating">
                                            <c:forEach begin="1" end="5" var="star">
                                                <c:choose>
                                                    <c:when test="${star <= review.rating}">★</c:when>
                                                    <c:otherwise>☆</c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </div>
                                        <div class="review-meta">
                                            <span class="reviewer-name">${review.memberName}</span>
                                            <span class="review-date">
                                                ${review.createdAt.toLocalDate()}
                                            </span>
                                        </div>
                                    </div>
                                    <div class="review-content">
                                        ${review.content}
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="no-reviews">
                            <p>아직 리뷰가 없습니다. 첫 번째 리뷰를 작성해보세요!</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    
    <!-- 푸터 -->
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    
    <script>
        const bookId = ${book.bookId};
        
        // 수량 증가
        function increaseQty() {
            const input = document.getElementById('quantity');
            input.value = parseInt(input.value) + 1;
        }
        
        // 수량 감소
        function decreaseQty() {
            const input = document.getElementById('quantity');
            if (parseInt(input.value) > 1) {
                input.value = parseInt(input.value) - 1;
            }
        }
        
        // 카트에 추가
        function addToCart() {
            const qty = document.getElementById('quantity').value;
            alert('카트에 추가되었습니다. (수량: ' + qty + ')');
            // TODO: 실제 카트 API 호출
        }
        
        // 바로 구매
        function buyNow() {
            const qty = document.getElementById('quantity').value;
            window.location.href = '/order/checkout?bookId=' + bookId + '&quantity=' + qty + '&directBuy=true';
        }
    </script>
</body>
</html>

