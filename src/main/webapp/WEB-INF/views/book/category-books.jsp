<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${category.categoryName} - Online Bookstore</title>
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
        .nav-item:hover, .nav-item.active {
            background: #0052a3;
        }
        
        /* 카테고리 서브메뉴 */
        .category-submenu {
            background: #f8f9fa;
            border-bottom: 1px solid #dee2e6;
            display: none;
        }
        .category-submenu.show {
            display: block;
        }
        .submenu-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 10px 20px;
            display: flex;
            gap: 5px;
            flex-wrap: wrap;
        }
        .submenu-item {
            padding: 8px 15px;
            background: white;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            color: #495057;
            text-decoration: none;
            font-size: 14px;
            transition: all 0.3s;
        }
        .submenu-item:hover {
            background: #0066cc;
            color: white;
            border-color: #0066cc;
        }
        .submenu-item.active {
            background: #0066cc;
            color: white;
            border-color: #0066cc;
        }
        
        /* 메인 컨텐츠 */
        .container {
            max-width: 1400px;
            margin: 20px auto;
            padding: 0 20px;
        }
        
        /* 카테고리 경로 */
        .breadcrumb {
            background: white;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
            color: #666;
        }
        .breadcrumb a {
            color: #0066cc;
            text-decoration: none;
        }
        .breadcrumb a:hover {
            text-decoration: underline;
        }
        
        /* 하위 카테고리 탭 */
        .category-tabs {
            background: white;
            padding: 0;
            border-radius: 8px;
            margin-bottom: 20px;
            overflow: hidden;
        }
        .category-tabs-container {
            display: flex;
            gap: 0;
            overflow-x: auto;
        }
        .category-tab {
            padding: 15px 25px;
            color: #666;
            text-decoration: none;
            border-bottom: 3px solid transparent;
            white-space: nowrap;
            transition: all 0.3s;
        }
        .category-tab:hover {
            background: #f5f5f5;
            color: #333;
        }
        .category-tab.active {
            color: #0066cc;
            border-bottom-color: #0066cc;
            font-weight: bold;
        }
        
        /* 책 목록 헤더 */
        .books-header {
            background: white;
            padding: 20px;
            border-radius: 8px 8px 0 0;
            border-bottom: 2px solid #f0f0f0;
        }
        .books-header-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        .books-header h2 {
            font-size: 24px;
            color: #333;
            margin: 0;
        }
        .books-count {
            font-size: 14px;
            color: #666;
        }
        
        /* 책 목록 */
        .books-container {
            background: white;
            padding: 30px;
            border-radius: 0 0 8px 8px;
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
        
        .book-thumbnail-large {
            width: 120px;
            height: 160px;
            flex-shrink: 0;
        }
        
        .book-thumbnail-large img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 4px;
        }
        
        .book-thumbnail-large .no-image {
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
        
        /* 빈 상태 */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }
        .empty-state-icon {
            font-size: 60px;
            margin-bottom: 20px;
        }
        .empty-state-text {
            font-size: 18px;
            color: #666;
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
        
        /* 페이지 크기 선택 */
        .page-size-selector {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .page-size-selector label {
            font-weight: 500;
            color: #333;
        }
        
        .page-size-selector select {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            background: white;
            font-size: 14px;
            cursor: pointer;
        }
        
        .page-size-selector select:focus {
            outline: none;
            border-color: #0066cc;
            box-shadow: 0 0 0 2px rgba(0, 102, 204, 0.2);
        }
        
        /* 하단 페이징 */
        .pagination-bottom {
            background: white;
            padding: 20px;
            border-radius: 0 0 8px 8px;
            border-top: 1px solid #e0e0e0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 20px;
        }
        
        .pagination-info {
            color: #666;
            font-size: 14px;
        }
        
        .pagination {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .pagination a, .pagination span {
            display: inline-block;
            padding: 8px 12px;
            text-decoration: none;
            border: 1px solid #ddd;
            color: #333;
            border-radius: 4px;
            transition: all 0.3s;
        }
        
        .pagination a:hover {
            background: #0066cc;
            color: white;
            border-color: #0066cc;
        }
        
        .pagination .current {
            background: #0066cc;
            color: white;
            border-color: #0066cc;
        }
        
        .pagination .disabled {
            color: #ccc;
            cursor: not-allowed;
            background: #f5f5f5;
        }
        
        .pagination .disabled:hover {
            background: #f5f5f5;
            color: #ccc;
            border-color: #ddd;
        }
        
        /* 반응형 디자인 - 화면이 작아질 때 */
        @media (max-width: 1200px) {
            .book-row {
                flex-wrap: wrap;
            }
            
            .book-actions {
                width: 100%;
                flex-direction: row;
                justify-content: flex-end;
                gap: 10px;
                margin-top: 10px;
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
            
            .breadcrumb {
                font-size: 12px;
            }
            
            .books-header-top {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
            
            .pagination-bottom {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }
            
            .book-row {
                flex-direction: column;
                align-items: flex-start;
                position: relative;
            }
            
            .book-rank {
                position: absolute;
                top: 10px;
                left: 10px;
                background: rgba(255, 255, 255, 0.9);
                padding: 5px 10px;
                border-radius: 4px;
                z-index: 1;
            }
            
            .book-thumbnail-large {
                width: 100%;
                height: 200px;
                margin-bottom: 15px;
            }
            
            .book-thumbnail-large img {
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
            
            .books-header h2 {
                font-size: 20px;
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
            <a href="/" class="nav-item">홈</a>
            <a href="/books/all" class="nav-item <c:if test='${category.categoryId == 0}'>active</c:if>">전체 도서</a>
            <c:forEach var="cat" items="${level2Categories}">
                <a href="#" class="nav-item category-menu-item <c:if test='${cat.categoryId == selectedParentId or cat.categoryId == category.categoryId}'>active</c:if>" 
                   data-category-id="${cat.categoryId}">
                    ${cat.categoryName}
                </a>
            </c:forEach>
        </div>
    </nav>
    
    <!-- 하위 카테고리 서브메뉴 -->
    <c:if test="${not empty level3Categories and category.categoryId != 0}">
        <div class="category-submenu show">
            <div class="submenu-container">
                <c:forEach var="subCat" items="${level3Categories}">
                    <a href="/books/category?categoryId=${subCat.categoryId}" 
                       class="submenu-item <c:if test='${subCat.categoryId == category.categoryId}'>active</c:if>">
                        ${subCat.categoryName}
                    </a>
                </c:forEach>
            </div>
        </div>
    </c:if>
    
    <!-- 메인 컨텐츠 -->
    <div class="container">
        <!-- 카테고리 경로 -->
        <div class="breadcrumb">
            <a href="/">홈</a> &gt; 
            <c:choose>
                <c:when test="${category.categoryId == 0}">
                    <strong>전체 도서</strong>
                </c:when>
                <c:when test="${category.parentId != null}">
                    <!-- Level 3 카테고리: 부모 카테고리 > 현재 카테고리 -->
                    <c:if test="${not empty parentCategory}">
                        <a href="/books/category?categoryId=${parentCategory.categoryId}">${parentCategory.categoryName}</a> &gt; 
                    </c:if>
                    <strong>${category.categoryName}</strong>
                </c:when>
                <c:otherwise>
                    <!-- Level 2 카테고리 -->
                    <strong>${category.categoryName}</strong>
                </c:otherwise>
            </c:choose>
        </div>
        
        <!-- 책 목록 헤더 -->
        <div class="books-header">
            <div class="books-header-top">
                <h2>
                    ${category.categoryName}
                    <c:if test="${not empty keyword}">
                        <span style="color: #0066cc;"> - "${keyword}"</span>
                    </c:if>
                </h2>
                
                <!-- 페이지 크기 선택 (상단) -->
                <div class="page-size-selector">
                    <label for="pageSize">페이지당 표시:</label>
                    <select id="pageSize" onchange="changePageSize()">
                        <option value="30" <c:if test="${pageSize == 30}">selected</c:if>>30개</option>
                        <option value="50" <c:if test="${pageSize == 50}">selected</c:if>>50개</option>
                        <option value="100" <c:if test="${pageSize == 100}">selected</c:if>>100개</option>
                    </select>
                </div>
            </div>
            
            <div class="books-count">
                <c:choose>
                    <c:when test="${not empty keyword}">
                        "${keyword}" 검색 결과: 총 ${totalBooks}권의 도서가 있습니다.
                    </c:when>
                    <c:otherwise>
                        총 ${totalBooks}권의 도서가 있습니다.
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        
        <!-- 책 목록 -->
        <div class="books-container">
            <c:choose>
                <c:when test="${not empty books}">
                    <div class="book-list">
                        <c:forEach var="book" items="${books}" varStatus="status">
                            <div class="book-row">
                                <div class="book-rank">${status.index + 1}</div>
                                
                                <!-- 썸네일 -->
                                <div class="book-thumbnail-large">
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
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <div class="empty-state-icon">📚</div>
                        <div class="empty-state-text">
                            <c:choose>
                                <c:when test="${not empty keyword}">
                                    "${keyword}"에 대한 검색 결과가 없습니다.
                                </c:when>
                                <c:otherwise>
                                    이 카테고리에는 아직 등록된 도서가 없습니다.
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        
        <!-- 페이지 번호 선택 (하단) -->
        <c:if test="${totalPages > 1}">
            <div class="pagination-bottom">
                <div class="pagination-info">
                    <c:choose>
                        <c:when test="${totalBooks > 0}">
                            ${currentPage * pageSize + 1}-${Math.min((currentPage + 1) * pageSize, totalBooks)} / ${totalBooks}권
                            (${currentPage + 1}/${totalPages} 페이지)
                        </c:when>
                        <c:otherwise>
                            검색 결과가 없습니다.
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <div class="pagination">
                    <c:choose>
                        <c:when test="${hasPrevPage}">
                            <a href="?page=${currentPage - 1}&size=${pageSize}<c:if test='${not empty keyword}'>&keyword=${keyword}</c:if><c:if test='${category.categoryId != 0}'>&categoryId=${category.categoryId}</c:if>">이전</a>
                        </c:when>
                        <c:otherwise>
                            <span class="disabled">이전</span>
                        </c:otherwise>
                    </c:choose>
                    
                    <c:forEach begin="0" end="${totalPages - 1}" var="pageNum">
                        <c:choose>
                            <c:when test="${pageNum == currentPage}">
                                <span class="current">${pageNum + 1}</span>
                            </c:when>
                            <c:otherwise>
                                <a href="?page=${pageNum}&size=${pageSize}<c:if test='${not empty keyword}'>&keyword=${keyword}</c:if><c:if test='${category.categoryId != 0}'>&categoryId=${category.categoryId}</c:if>">${pageNum + 1}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                    
                    <c:choose>
                        <c:when test="${hasNextPage}">
                            <a href="?page=${currentPage + 1}&size=${pageSize}<c:if test='${not empty keyword}'>&keyword=${keyword}</c:if><c:if test='${category.categoryId != 0}'>&categoryId=${category.categoryId}</c:if>">다음</a>
                        </c:when>
                        <c:otherwise>
                            <span class="disabled">다음</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </c:if>
    </div>
    
    <!-- 푸터 -->
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    
    <script>
        // 카테고리 메뉴 클릭 시 하위 카테고리 페이지로 이동
        document.querySelectorAll('.category-menu-item').forEach(item => {
            item.addEventListener('click', function(e) {
                e.preventDefault();
                const categoryId = this.getAttribute('data-category-id');
                
                // 해당 카테고리의 첫 번째 하위 카테고리로 이동
                // 또는 카테고리 전체 페이지로 이동
                fetch('/api/categories/' + categoryId + '/children')
                    .then(response => response.json())
                    .then(data => {
                        if (data.data && data.data.length > 0) {
                            // 첫 번째 하위 카테고리로 이동
                            window.location.href = '/books/category?categoryId=' + data.data[0].categoryId;
                        } else {
                            // 하위 카테고리가 없으면 해당 카테고리로 이동
                            window.location.href = '/books/category?categoryId=' + categoryId;
                        }
                    })
                    .catch(error => {
                        console.log('카테고리 로드 실패:', error);
                        // 오류 발생 시 해당 카테고리로 이동
                        window.location.href = '/books/category?categoryId=' + categoryId;
                    });
            });
        });
        
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
        
        // 페이지 크기 변경
        function changePageSize() {
            const pageSize = document.getElementById('pageSize').value;
            const currentUrl = new URL(window.location);
            currentUrl.searchParams.set('size', pageSize);
            currentUrl.searchParams.set('page', '0'); // 첫 페이지로 이동
            window.location.href = currentUrl.toString();
        }
    </script>
</body>
</html>

