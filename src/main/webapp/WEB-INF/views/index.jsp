<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Online Bookstore - 온라인 서점</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            background: #f5f5f5;
            min-height: 100vh;
        }
        
        
        /* 네비게이션 */
        nav {
            background: #0066cc;
            padding: 0;
        }
        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            padding: 0 20px;
        }
        .nav-item {
            padding: 15px 20px;
            color: white;
            text-decoration: none;
            cursor: pointer;
            transition: background 0.3s;
            position: relative;
        }
        .nav-item:hover {
            background: #0052a3;
        }
        .nav-item.active {
            background: #0052a3;
        }
        
        /* 드롭다운 메뉴 */
        .nav-item.dropdown {
            position: relative;
        }
        .dropdown-content {
            display: none;
            position: absolute;
            top: 100%;
            left: 0;
            background: white;
            min-width: 200px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            z-index: 1000;
        }
        .nav-item.dropdown:hover .dropdown-content {
            display: block;
        }
        .dropdown-content a {
            display: block;
            padding: 10px 15px;
            color: #333;
            text-decoration: none;
            border-bottom: 1px solid #eee;
        }
        .dropdown-content a:hover {
            background: #f5f5f5;
        }
        
        /* 메인 컨텐츠 */
        .main-container {
            max-width: 1400px;
            margin: 20px auto;
            padding: 0 20px;
            display: grid;
            grid-template-columns: 250px 1fr 250px;
            gap: 20px;
        }
        
        /* 인기 검색어 (좌측) */
        .popular-searches {
            background: white;
            padding: 20px;
            border-radius: 8px;
            height: fit-content;
        }
        
        .popular-searches h3 {
            font-size: 18px;
            margin-bottom: 15px;
            color: #333;
            border-bottom: 2px solid #0066cc;
            padding-bottom: 10px;
        }
        
        .search-rank {
            list-style: none;
        }
        
        .search-rank li {
            padding: 10px 0;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 14px;
            cursor: pointer;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .search-rank li:hover {
            color: #0066cc;
            background: #f9f9f9;
        }
        
        .rank-number {
            display: inline-block;
            width: 24px;
            height: 24px;
            background: #0066cc;
            color: white;
            text-align: center;
            line-height: 24px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
            flex-shrink: 0;
        }
        
        .rank-number.top3 {
            background: #ff6b00;
        }
        
        .rank-keyword {
            flex: 1;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        
        /* 중앙 컨텐츠 */
        .content-wrapper {
            background: white;
            padding: 30px;
            border-radius: 8px;
        }
        
        .content-wrapper h2 {
            font-size: 24px;
            margin-bottom: 20px;
            color: #333;
            border-bottom: 3px solid #0066cc;
            padding-bottom: 15px;
        }
        
        /* 베스트셀러 섹션 */
        .bestseller-section {
            margin-bottom: 30px;
        }
        
        .bestseller-row {
            background: linear-gradient(to right, #fff9f0, #ffffff);
            border-left: 4px solid #ff6b00;
        }
        
        .bestseller-row:hover {
            background: linear-gradient(to right, #fff5e6, #f9f9f9);
        }
        
        .bestseller-rank {
            color: #ff6b00;
            font-weight: 900;
        }
        
        /* 최근 본 상품 (우측) */
        .recent-views {
            background: white;
            padding: 20px;
            border-radius: 8px;
            height: fit-content;
        }
        
        .recent-views h3 {
            font-size: 18px;
            margin-bottom: 15px;
            color: #333;
            border-bottom: 2px solid #0066cc;
            padding-bottom: 10px;
        }
        
        .recent-item {
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid #f0f0f0;
            cursor: pointer;
        }
        
        .recent-item:last-child {
            border-bottom: none;
        }
        
        .recent-cover {
            width: 100%;
            height: 150px;
            background: #f0f0f0;
            border-radius: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 8px;
            font-size: 30px;
        }
        
        .recent-title {
            font-size: 12px;
            color: #333;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        
        /* 도서 리스트 (가로 레이아웃) */
        .book-list {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        
        .book-row {
            display: flex;
            align-items: center;
            gap: 20px;
            padding: 20px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            transition: all 0.3s;
        }
        
        .book-row:hover {
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            background: #f9f9f9;
        }
        
        .book-rank {
            font-size: 24px;
            font-weight: bold;
            color: #999;
            min-width: 40px;
            text-align: center;
        }
        
        .book-thumbnail {
            width: 120px;
            height: 160px;
            flex-shrink: 0;
        }
        
        .book-thumbnail img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 4px;
        }
        
        .book-thumbnail .no-image {
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
        
        .book-info {
            flex: 1;
            min-width: 0;
        }
        
        .book-title-large {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 8px;
            color: #333;
        }
        
        .book-title-large a {
            color: #333;
            text-decoration: none;
        }
        
        .book-title-large a:hover {
            color: #0066cc;
        }
        
        .book-meta {
            font-size: 14px;
            color: #666;
            margin-bottom: 10px;
        }
        
        .meta-item {
            display: inline;
        }
        
        .meta-separator {
            margin: 0 8px;
            color: #ddd;
        }
        
        .book-details {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .price-info .price {
            font-size: 20px;
            font-weight: bold;
            color: #0066cc;
        }
        
        .price-info .discount {
            font-size: 14px;
            color: #ff6b00;
            margin-left: 8px;
        }
        
        .stats {
            font-size: 14px;
            color: #666;
        }
        
        .stat-item {
            display: inline;
        }
        
        .stat-item strong {
            color: #333;
        }
        
        /* 구매 옵션 */
        .book-actions {
            display: flex;
            flex-direction: column;
            gap: 8px;
            min-width: 150px;
        }
        
        .quantity-selector {
            display: flex;
            align-items: center;
            border: 1px solid #ddd;
            border-radius: 4px;
            overflow: hidden;
        }
        
        .quantity-selector input {
            width: 50px;
            height: 32px;
            text-align: center;
            border: none;
            font-size: 14px;
        }
        
        .qty-btn {
            width: 32px;
            height: 32px;
            background: #f5f5f5;
            border: none;
            cursor: pointer;
            font-size: 16px;
            transition: all 0.2s;
        }
        
        .qty-btn:hover {
            background: #e0e0e0;
        }
        
        .btn-cart, .btn-buy-now {
            padding: 8px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s;
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
        
        /* 반응형 디자인 - 화면이 작아질 때 */
        @media (max-width: 1400px) {
            .main-container {
                grid-template-columns: 200px 1fr 200px;
            }
        }
        
        @media (max-width: 1200px) {
            .main-container {
                grid-template-columns: 1fr;
            }
            
            .popular-searches, .recent-views {
                display: none; /* 작은 화면에서는 사이드바 숨김 */
            }
            
            .book-row {
                flex-wrap: wrap;
            }
            
            .book-actions {
                width: 100%;
                flex-direction: row;
                justify-content: flex-end;
                gap: 10px;
            }
            
            .quantity-selector {
                width: auto;
            }
        }
        
        @media (max-width: 768px) {
            .header-container {
                flex-direction: column;
            }
            
            .nav-container {
                flex-wrap: wrap;
                font-size: 14px;
            }
            
            .nav-item {
                padding: 12px 15px;
            }
            
            .book-row {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .book-rank {
                position: absolute;
                top: 10px;
                left: 10px;
                background: rgba(255, 255, 255, 0.9);
                padding: 5px 10px;
                border-radius: 4px;
            }
            
            .book-thumbnail {
                width: 100%;
                height: 200px;
                margin-bottom: 15px;
            }
            
            .book-thumbnail img {
                width: 100%;
                height: 100%;
                object-fit: contain;
            }
            
            .book-info {
                width: 100%;
            }
            
            .book-actions {
                width: 100%;
                margin-top: 15px;
            }
        }
        
        @media (max-width: 480px) {
            .book-title-large {
                font-size: 16px;
            }
            
            .book-meta {
                font-size: 12px;
            }
            
            .price {
                font-size: 18px !important;
            }
        }
    </style>
</head>
<body>
    <!-- 헤더 -->
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <!-- 네비게이션 -->
    <nav>
        <div class="nav-container">
            <a href="/" class="nav-item active">홈</a>
            <a href="/books/all" class="nav-item">전체 도서</a>
            <c:forEach var="cat" items="${level2Categories}">
            <div class="nav-item dropdown">
                    <span>${cat.categoryName}</span>
                    <div class="dropdown-content" id="dropdown-${cat.categoryId}">
                        <!-- 하위 카테고리는 마우스 오버 시 로드됩니다 -->
            </div>
                </div>
            </c:forEach>
        </div>
    </nav>
    
    <!-- 메인 컨텐츠 -->
    <div class="main-container">
        <!-- 인기 검색어 (좌측) -->
        <aside class="popular-searches">
            <h3>🔥 실시간 인기 검색어</h3>
            <ul class="search-rank">
                <c:choose>
                    <c:when test="${not empty popularSearches}">
                        <c:forEach var="search" items="${popularSearches}" varStatus="status">
                            <li onclick="window.location.href='/books/search?keyword=${search.keyword}'">
                                <span class="rank-number ${status.index < 3 ? 'top3' : ''}">${status.index + 1}</span>
                                <span class="rank-keyword">${search.keyword}</span>
                            </li>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <li style="text-align: center; color: #999; padding: 20px 0;">
                            아직 검색 데이터가 없습니다
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </aside>
        
        <!-- 중앙 컨텐츠 -->
        <div class="content-wrapper">
            <!-- 월간 베스트셀러 섹션 -->
            <c:if test="${not empty bestsellers}">
                <section class="bestseller-section">
                    <h2>🏆 이달의 베스트셀러 TOP 20</h2>
                    
                    <div class="book-list">
                        <c:forEach var="book" items="${bestsellers}" varStatus="status">
                            <div class="book-row bestseller-row">
                                <div class="book-rank bestseller-rank">${status.index + 1}</div>
                                
                                <!-- 썸네일 -->
                                <div class="book-thumbnail">
                                    <c:choose>
                                        <c:when test="${not empty book.thumbnailUrl}">
                                            <img src="${book.thumbnailUrl}" alt="${book.title}">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="no-image">이미지 없음</div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                
                                <!-- 도서 정보 -->
                                <div class="book-info">
                                    <div class="book-title-large">
                                        <a href="/books/${book.bookId}">${book.title}</a>
                                    </div>
                                    <div class="book-meta">
                                        <span class="meta-item">저자: ${book.authors}</span>
                                        <span class="meta-separator">|</span>
                                        <span class="meta-item">출판사: ${book.publisher}</span>
                                        <span class="meta-separator">|</span>
                                        <span class="meta-item">등록일: 2025년 10월</span>
                                    </div>
                                    <div class="book-details">
                                        <div class="price-info">
                                            <span class="price"><fmt:formatNumber value="${book.price}" pattern="#,##0"/>원</span>
                                        </div>
                                        <div class="stats">
                                            <span class="stat-item">판매지수: <strong>${book.salesCount != null ? book.salesCount : 0}</strong></span>
                                            <span class="meta-separator">|</span>
                                            <span class="stat-item">평균평점: <strong>⭐ <fmt:formatNumber value="${book.averageRating}" pattern="#.#"/></strong></span>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- 구매 옵션 -->
                                <div class="book-actions">
                                    <div class="quantity-selector">
                                        <button type="button" class="qty-btn minus" onclick="decreaseQty(${book.bookId})">−</button>
                                        <input type="number" id="qty-${book.bookId}" value="1" min="1" readonly>
                                        <button type="button" class="qty-btn plus" onclick="increaseQty(${book.bookId})">+</button>
                                    </div>
                                    <button type="button" class="btn-cart" onclick="addToCart(${book.bookId})">카트에 넣기</button>
                                    <button type="button" class="btn-buy-now" onclick="buyNow(${book.bookId})">바로 구매</button>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </section>
            </c:if>
        </div>
        
        <!-- 최근 본 상품 (우측) -->
        <aside class="recent-views">
            <h3>👀 최근 본 상품</h3>
            <c:choose>
                <c:when test="${not empty recentViews}">
                    <c:forEach var="recentView" items="${recentViews}">
                        <div class="recent-item" onclick="location.href='/books/${recentView.bookId}'">
                            <div class="recent-cover">
                                <c:choose>
                                    <c:when test="${not empty recentView.book.thumbnailUrl}">
                                        <img src="${recentView.book.thumbnailUrl}" alt="${recentView.book.title}" style="width: 100%; height: 100%; object-fit: cover; border-radius: 4px;">
                                    </c:when>
                                    <c:otherwise>
                                        📖
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="recent-title">${recentView.book.title}</div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div style="text-align: center; color: #999; padding: 20px 0;">
                        <c:choose>
                            <c:when test="${isAuthenticated}">
                                아직 본 상품이 없습니다
                            </c:when>
                            <c:otherwise>
                                로그인하면 최근 본 상품을 확인할 수 있습니다
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:otherwise>
            </c:choose>
        </aside>
    </div>
    
    <!-- 푸터 -->
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    
    <!-- 카테고리 데이터를 hidden input으로 전달 -->
    <div id="categoryData" style="display: none;">
        <c:forEach var="cat" items="${level2Categories}">
            <span data-id="${cat.categoryId}" data-name="${cat.categoryName}"></span>
        </c:forEach>
    </div>
    
    <script>
        // 카테고리 데이터 로드
        const level2Categories = [];
        const categoryElements = document.querySelectorAll('#categoryData span');
        categoryElements.forEach(function(el) {
            level2Categories.push({
                categoryId: parseInt(el.getAttribute('data-id')),
                categoryName: el.getAttribute('data-name')
            });
        });
        
        // Level 2 카테고리에 마우스를 올리면 하위 카테고리 로드
        document.querySelectorAll('.nav-item.dropdown').forEach((dropdown, index) => {
            if (index < level2Categories.length) {
                const categoryId = level2Categories[index].categoryId;
                dropdown.addEventListener('mouseenter', function() {
                    loadSubCategories(categoryId);
                });
            }
        });
        
        function loadSubCategories(parentId) {
            const dropdownContent = document.getElementById('dropdown-' + parentId);
            console.log('loadSubCategories 호출:', parentId, 'dropdownContent:', dropdownContent);
            
            if (dropdownContent && dropdownContent.children.length === 0) {
                console.log('API 호출 시작: /api/categories/' + parentId + '/children');
                
                // AJAX로 하위 카테고리 로드
                fetch('/api/categories/' + parentId + '/children')
                    .then(response => {
                        console.log('API 응답 상태:', response.status);
                        return response.json();
                    })
                    .then(data => {
                        console.log('API 응답 데이터:', data);
                        const categories = data.data || [];
                        console.log('하위 카테고리 개수:', categories.length);
                        
                        if (categories.length > 0) {
                            categories.forEach(cat => {
                                const link = document.createElement('a');
                                link.href = '/books/category?categoryId=' + cat.categoryId;
                                link.textContent = cat.categoryName;
                                dropdownContent.appendChild(link);
                                console.log('카테고리 추가:', cat.categoryName);
                            });
                        } else {
                            // 하위 카테고리가 없으면 전체보기만 표시
                            const link = document.createElement('a');
                            link.href = '/books/category?categoryId=' + parentId;
                            link.textContent = '전체보기';
                            dropdownContent.appendChild(link);
                            console.log('하위 카테고리 없음 - 전체보기 추가');
                        }
                    })
                    .catch(error => {
                        console.error('하위 카테고리 로드 실패:', error);
                        // 오류 발생 시 전체보기만 표시
                        const link = document.createElement('a');
                        link.href = '/books/category?categoryId=' + parentId;
                        link.textContent = '전체보기';
                        dropdownContent.appendChild(link);
                    });
            } else {
                console.log('이미 로드됨 또는 dropdownContent 없음');
            }
        }
        
        // 수량 증가
        function increaseQty(bookId) {
            const input = document.getElementById('qty-' + bookId);
            input.value = parseInt(input.value) + 1;
        }
        
        // 수량 감소
        function decreaseQty(bookId) {
            const input = document.getElementById('qty-' + bookId);
            if (parseInt(input.value) > 1) {
                input.value = parseInt(input.value) - 1;
            }
        }
        
        // 카트에 추가
        function addToCart(bookId) {
            const qty = document.getElementById('qty-' + bookId).value;
            
            // 카트 API 호출
            fetch('/api/cart/add', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'bookId=' + bookId + '&quantity=' + qty
            })
            .then(response => response.json())
            .then(data => {
                alert(data.message);
                if (data.success && confirm('장바구니로 이동하시겠습니까?')) {
                    location.href = '/cart';
                }
            })
            .catch(error => {
                console.error('장바구니 추가 실패:', error);
                alert('장바구니 추가에 실패했습니다.');
            });
        }
        
        // 바로 구매
        function buyNow(bookId) {
            const qty = document.getElementById('qty-' + bookId).value;
            
            // 바로 주문 페이지로 이동 (책 정보와 수량을 URL 파라미터로 전달)
            window.location.href = '/order/checkout?bookId=' + bookId + '&quantity=' + qty + '&directBuy=true';
        }
    </script>
</body>
</html>

