<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원 주문 목록 - Online Bookstore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .admin-sidebar {
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .admin-sidebar .nav-link {
            color: rgba(255, 255, 255, 0.8);
            padding: 12px 20px;
            border-radius: 8px;
            margin: 4px 0;
            transition: all 0.3s ease;
        }
        .admin-sidebar .nav-link:hover,
        .admin-sidebar .nav-link.active {
            background: rgba(255, 255, 255, 0.1);
            color: white;
            transform: translateX(5px);
        }
        .admin-content {
            background: #f8f9fa;
            min-height: 100vh;
        }
        .admin-header {
            background: white;
            padding: 20px 30px;
            border-bottom: 1px solid #e9ecef;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .filter-card {
            background: white;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 24px;
        }
        .table-card {
            background: white;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .status-badge {
            font-size: 0.8rem;
            padding: 4px 8px;
        }
        .pagination-info {
            color: #6c757d;
            font-size: 0.9rem;
        }
        .toggle-icon {
            transition: transform 0.3s ease;
        }
        .order-item {
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 16px;
            margin-bottom: 16px;
            background: #f8f9fa;
        }
        .order-header {
            display: flex;
            justify-content: between;
            align-items: center;
            margin-bottom: 12px;
        }
        .order-number {
            font-weight: 600;
            color: #495057;
        }
        .order-date {
            color: #6c757d;
            font-size: 0.9rem;
        }
        .order-status {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
        }
        .status-pending { background-color: #fff3cd; color: #856404; }
        .status-confirmed { background-color: #d1ecf1; color: #0c5460; }
        .status-shipped { background-color: #cce5ff; color: #004085; }
        .status-delivered { background-color: #d4edda; color: #155724; }
        .status-cancelled { background-color: #f8d7da; color: #721c24; }
        .order-details {
            margin-top: 12px;
        }
        .order-info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 12px;
            margin-bottom: 12px;
        }
        .info-item {
            display: flex;
            flex-direction: column;
        }
        .info-label {
            font-size: 0.8rem;
            color: #6c757d;
            margin-bottom: 4px;
        }
        .info-value {
            font-weight: 500;
            color: #495057;
        }
        .book-list {
            margin-top: 12px;
        }
        .book-item {
            display: flex;
            align-items: center;
            padding: 8px 0;
            border-bottom: 1px solid #e9ecef;
        }
        .book-item:last-child {
            border-bottom: none;
        }
        .book-thumbnail {
            width: 40px;
            height: 60px;
            object-fit: cover;
            border-radius: 4px;
            margin-right: 12px;
        }
        .book-info {
            flex: 1;
        }
        .book-title {
            font-weight: 500;
            color: #495057;
            margin-bottom: 4px;
        }
        .book-meta {
            font-size: 0.8rem;
            color: #6c757d;
        }
        .book-quantity {
            font-weight: 500;
            color: #495057;
        }
        .book-price {
            font-weight: 600;
            color: #495057;
            text-align: right;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- 사이드바 -->
            <div class="col-md-3 col-lg-2 px-0">
                <div class="admin-sidebar">
                    <div class="p-4">
                        <h4 class="text-white mb-4">
                            <i class="fas fa-crown me-2"></i>
                            관리자 페이지
                        </h4>
                        <nav class="nav flex-column">
                            <a class="nav-link" href="/admin">
                                <i class="fas fa-tachometer-alt me-2"></i>
                                대시보드
                            </a>
                            <a class="nav-link" href="/admin/books">
                                <i class="fas fa-book me-2"></i>
                                상품 관리
                            </a>
                            <a class="nav-link" href="/admin/orders">
                                <i class="fas fa-shopping-cart me-2"></i>
                                주문 관리
                            </a>
                            <a class="nav-link active" href="/admin/members">
                                <i class="fas fa-users me-2"></i>
                                회원 관리
                            </a>
                            <hr class="my-3">
                            <a class="nav-link" href="/">
                                <i class="fas fa-home me-2"></i>
                                메인 페이지
                            </a>
                            <a class="nav-link" href="/auth/logout">
                                <i class="fas fa-sign-out-alt me-2"></i>
                                로그아웃
                            </a>
                        </nav>
                    </div>
                </div>
            </div>
            
            <!-- 메인 콘텐츠 -->
            <div class="col-md-9 col-lg-10 px-0">
                <div class="admin-content">
                    <!-- 헤더 -->
                    <div class="admin-header">
                        <div class="d-flex justify-content-between align-items-center">
                            <div class="d-flex align-items-center">
                                <a href="/admin/members" class="btn btn-outline-secondary me-3">
                                    <i class="fas fa-arrow-left me-1"></i>
                                    회원 목록
                                </a>
                                <h2 class="mb-0">
                                    <i class="fas fa-shopping-cart me-2"></i>
                                    회원 주문 목록
                                </h2>
                            </div>
                            <div class="d-flex align-items-center">
                                <span class="text-muted me-3">안녕하세요, ${userName}님</span>
                                <div class="dropdown">
                                    <button class="btn btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                        <i class="fas fa-user-circle me-1"></i>
                                        관리자
                                    </button>
                                    <ul class="dropdown-menu">
                                        <li><a class="dropdown-item" href="/admin/members">회원 관리</a></li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item" href="/auth/logout">로그아웃</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- 콘텐츠 -->
                    <div class="p-4">
                        <!-- 검색 필터 -->
                        <div class="filter-card">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h5 class="mb-0">
                                    <i class="fas fa-search me-2"></i>
                                    검색 조건
                                </h5>
                                <button class="btn btn-outline-primary btn-sm" type="button" data-bs-toggle="collapse" 
                                        data-bs-target="#searchCollapse" aria-expanded="false" aria-controls="searchCollapse">
                                    <i class="fas fa-chevron-down toggle-icon" id="searchToggleIcon"></i>
                                </button>
                            </div>
                            <div class="collapse" id="searchCollapse">
                                <form method="get" action="/admin/members/${memberId}/orders" id="searchForm">
                                    <!-- 정렬 조건 유지 (빈 값이 아닌 경우만) -->
                                    <c:if test="${not empty param.sortBy}">
                                        <input type="hidden" name="sortBy" value="${param.sortBy}">
                                    </c:if>
                                    <c:if test="${not empty param.sortDirection}">
                                        <input type="hidden" name="sortDirection" value="${param.sortDirection}">
                                    </c:if>
                                    <c:if test="${not empty param.size}">
                                        <input type="hidden" name="size" value="${param.size}">
                                    </c:if>
                                    
                                    <div class="row g-3">
                                        <div class="col-md-3">
                                            <label for="memberName" class="form-label">주문자 이름</label>
                                            <input type="text" class="form-control" id="memberName" name="memberName" 
                                                   value="${param.memberName}" placeholder="주문자 이름 입력">
                                        </div>
                                        <div class="col-md-3">
                                            <label for="bookTitle" class="form-label">책 제목</label>
                                            <input type="text" class="form-control" id="bookTitle" name="bookTitle" 
                                                   value="${param.bookTitle}" placeholder="책 제목 입력">
                                        </div>
                                        <div class="col-md-3">
                                            <label for="publisher" class="form-label">출판사</label>
                                            <input type="text" class="form-control" id="publisher" name="publisher" 
                                                   value="${param.publisher}" placeholder="출판사 입력">
                                        </div>
                                        <div class="col-md-3">
                                            <label for="author" class="form-label">저자</label>
                                            <input type="text" class="form-control" id="author" name="author" 
                                                   value="${param.author}" placeholder="저자 입력">
                                        </div>
                                        <div class="col-md-3">
                                            <label for="saleStatus" class="form-label">주문 상태</label>
                                            <select class="form-select" id="saleStatus" name="saleStatus">
                                                <option value="">전체</option>
                                                <option value="PENDING" ${param.saleStatus == 'PENDING' ? 'selected' : ''}>결제대기</option>
                                                <option value="CONFIRMED" ${param.saleStatus == 'CONFIRMED' ? 'selected' : ''}>결제완료</option>
                                                <option value="SHIPPING" ${param.saleStatus == 'SHIPPING' ? 'selected' : ''}>배송중</option>
                                                <option value="DELIVERED" ${param.saleStatus == 'DELIVERED' ? 'selected' : ''}>배송완료</option>
                                                <option value="CANCELLED" ${param.saleStatus == 'CANCELLED' ? 'selected' : ''}>주문취소</option>
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <label for="startDate" class="form-label">주문일 시작</label>
                                            <input type="date" class="form-control" id="startDate" name="startDate" 
                                                   value="${param.startDate}">
                                        </div>
                                        <div class="col-md-3">
                                            <label for="endDate" class="form-label">주문일 종료</label>
                                            <input type="date" class="form-control" id="endDate" name="endDate" 
                                                   value="${param.endDate}">
                                        </div>
                                    </div>
                                    <div class="row mt-3">
                                        <div class="col-12">
                                            <button type="submit" class="btn btn-primary me-2">
                                                <i class="fas fa-search me-1"></i>
                                                검색
                                            </button>
                                            <button type="button" class="btn btn-outline-secondary" onclick="resetForm()">
                                                <i class="fas fa-undo me-1"></i>
                                                초기화
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                        
                        <!-- 정렬 조건 -->
                        <div class="filter-card">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h5 class="mb-0">
                                    <i class="fas fa-sort me-2"></i>
                                    정렬 조건
                                </h5>
                                <button class="btn btn-outline-primary btn-sm" type="button" data-bs-toggle="collapse" 
                                        data-bs-target="#sortCollapse" aria-expanded="false" aria-controls="sortCollapse">
                                    <i class="fas fa-chevron-down toggle-icon" id="sortToggleIcon"></i>
                                </button>
                            </div>
                            <div class="collapse" id="sortCollapse">
                                <form method="get" action="/admin/members/${memberId}/orders" id="sortForm">
                                    <!-- 검색 조건 유지 (빈 값이 아닌 경우만) -->
                                    <c:if test="${not empty param.memberName}">
                                        <input type="hidden" name="memberName" value="${param.memberName}">
                                    </c:if>
                                    <c:if test="${not empty param.bookTitle}">
                                        <input type="hidden" name="bookTitle" value="${param.bookTitle}">
                                    </c:if>
                                    <c:if test="${not empty param.publisher}">
                                        <input type="hidden" name="publisher" value="${param.publisher}">
                                    </c:if>
                                    <c:if test="${not empty param.author}">
                                        <input type="hidden" name="author" value="${param.author}">
                                    </c:if>
                                    <c:if test="${not empty param.saleStatus}">
                                        <input type="hidden" name="saleStatus" value="${param.saleStatus}">
                                    </c:if>
                                    <c:if test="${not empty param.startDate}">
                                        <input type="hidden" name="startDate" value="${param.startDate}">
                                    </c:if>
                                    <c:if test="${not empty param.endDate}">
                                        <input type="hidden" name="endDate" value="${param.endDate}">
                                    </c:if>
                                    
                                    <div class="row g-3">
                                        <div class="col-md-4">
                                            <label for="sortBy" class="form-label">정렬 기준</label>
                                            <select class="form-select" id="sortBy" name="sortBy">
                                                <option value="orderDate" ${param.sortBy == 'orderDate' ? 'selected' : ''}>주문일</option>
                                                <option value="totalAmount" ${param.sortBy == 'totalAmount' ? 'selected' : ''}>주문 금액</option>
                                                <option value="orderStatus" ${param.sortBy == 'orderStatus' ? 'selected' : ''}>주문 상태</option>
                                            </select>
                                        </div>
                                        <div class="col-md-4">
                                            <label for="sortDirection" class="form-label">정렬 방향</label>
                                            <select class="form-select" id="sortDirection" name="sortDirection">
                                                <option value="desc" ${param.sortDirection == 'desc' ? 'selected' : ''}>내림차순</option>
                                                <option value="asc" ${param.sortDirection == 'asc' ? 'selected' : ''}>오름차순</option>
                                            </select>
                                        </div>
                                        <div class="col-md-4">
                                            <label for="size" class="form-label">페이지 크기</label>
                                            <select class="form-select" id="size" name="size">
                                                <option value="10" ${param.size == '10' ? 'selected' : ''}>10개</option>
                                                <option value="20" ${param.size == '20' ? 'selected' : ''}>20개</option>
                                                <option value="30" ${param.size == '30' ? 'selected' : ''}>30개</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="row mt-3">
                                        <div class="col-12">
                                            <button type="submit" class="btn btn-outline-primary me-2">
                                                <i class="fas fa-sort me-1"></i>
                                                정렬 적용
                                            </button>
                                            <button type="button" class="btn btn-outline-secondary" onclick="resetSort()">
                                                <i class="fas fa-undo me-1"></i>
                                                정렬 초기화
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                        
                        <!-- 주문 목록 -->
                        <div class="table-card">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h5 class="mb-0">
                                    <i class="fas fa-list me-2"></i>
                                    주문 목록
                                </h5>
                                <div class="pagination-info">
                                    총 ${orders.totalElements}건 중 ${(orders.number * orders.size) + 1}-${Math.min((orders.number + 1) * orders.size, orders.totalElements)}건 표시
                                </div>
                            </div>
                            
                            <c:choose>
                                <c:when test="${not empty orders.content}">
                                    <c:forEach var="order" items="${orders.content}" varStatus="status">
                                        <div class="order-item">
                                            <div class="order-header">
                                                <div>
                                                    <div class="order-number">주문번호: #${order.orderId}</div>
                                                    <div class="order-date">${order.orderDate}</div>
                                                </div>
                                                <span class="order-status ${order.orderStatus == 'PENDING' ? 'status-pending' : order.orderStatus == 'CONFIRMED' ? 'status-confirmed' : order.orderStatus == 'SHIPPING' ? 'status-shipped' : order.orderStatus == 'DELIVERED' ? 'status-delivered' : order.orderStatus == 'CANCELLED' ? 'status-cancelled' : 'status-pending'}">
                                                    <c:choose>
                                                        <c:when test="${order.orderStatus == 'PENDING'}">결제대기</c:when>
                                                        <c:when test="${order.orderStatus == 'CONFIRMED'}">결제완료</c:when>
                                                        <c:when test="${order.orderStatus == 'SHIPPING'}">배송중</c:when>
                                                        <c:when test="${order.orderStatus == 'DELIVERED'}">배송완료</c:when>
                                                        <c:when test="${order.orderStatus == 'CANCELLED'}">주문취소</c:when>
                                                        <c:otherwise>결제대기</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            
                                            <div class="order-details">
                                                <div class="order-info-grid">
                                                    <div class="info-item">
                                                        <div class="info-label">주문자</div>
                                                        <div class="info-value">${order.memberName}</div>
                                                    </div>
                                                    <div class="info-item">
                                                        <div class="info-label">총 주문 금액</div>
                                                        <div class="info-value">₩<fmt:formatNumber value="${order.totalAmount}" pattern="#,###"/></div>
                                                    </div>
                                                    <div class="info-item">
                                                        <div class="info-label">주문 상품 수</div>
                                                        <div class="info-value">
                                                            <c:set var="totalQty" value="0" />
                                                            <c:forEach var="item" items="${order.orderItems}">
                                                                <c:set var="totalQty" value="${totalQty + item.quantity}" />
                                                            </c:forEach>
                                                            ${totalQty}개
                                                        </div>
                                                    </div>
                                                </div>
                                                
                                                <div class="book-list">
                                                    <c:forEach var="item" items="${order.orderItems}">
                                                        <div class="book-item">
                                                            <img src="${item.thumbnailUrl}" alt="${item.bookTitle}" class="book-thumbnail" 
                                                                 onerror="this.src='https://via.placeholder.com/40x60?text=No+Image'">
                                                            <div class="book-info">
                                                                <div class="book-title">${item.bookTitle}</div>
                                                                <div class="book-meta">${item.bookAuthor} | ${item.publisher}</div>
                                                            </div>
                                                            <div class="book-quantity">${item.quantity}개</div>
                                                            <div class="book-price">₩<fmt:formatNumber value="${item.totalPrice}" pattern="#,###"/></div>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                                
                                                <div class="d-flex justify-content-end mt-3">
                                                    <a href="/admin/orders/${order.orderId}" class="btn btn-outline-primary btn-sm">
                                                        <i class="fas fa-eye me-1"></i>
                                                        상세보기
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center text-muted py-5">
                                        <i class="fas fa-shopping-cart fa-3x mb-3"></i>
                                        <br>
                                        검색 조건에 맞는 주문이 없습니다.
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            
                            <!-- 페이징 -->
                            <c:if test="${orders.totalPages > 1}">
                                <nav aria-label="주문 목록 페이징">
                                    <ul class="pagination justify-content-center">
                                        <!-- 이전 페이지 -->
                                        <li class="page-item ${orders.first ? 'disabled' : ''}">
                                            <a class="page-link" href="#" onclick="goToPage(${orders.number - 1}); return false;">
                                                <i class="fas fa-chevron-left"></i>
                                            </a>
                                        </li>
                                        
                                        <!-- 페이지 번호 -->
                                        <c:forEach begin="0" end="${orders.totalPages - 1}" var="pageNum">
                                            <c:if test="${pageNum >= orders.number - 2 && pageNum <= orders.number + 2}">
                                                <li class="page-item ${pageNum == orders.number ? 'active' : ''}">
                                                    <a class="page-link" href="#" onclick="goToPage(${pageNum}); return false;">
                                                        ${pageNum + 1}
                                                    </a>
                                                </li>
                                            </c:if>
                                        </c:forEach>
                                        
                                        <!-- 다음 페이지 -->
                                        <li class="page-item ${orders.last ? 'disabled' : ''}">
                                            <a class="page-link" href="#" onclick="goToPage(${orders.number + 1}); return false;">
                                                <i class="fas fa-chevron-right"></i>
                                            </a>
                                        </li>
                                    </ul>
                                </nav>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // 검색 폼 초기화
        function resetForm() {
            document.getElementById('searchForm').reset();
            // 정렬 조건은 유지하고 검색만 초기화
            let url = '/admin/members/${memberId}/orders';
            let params = [];
            
            if ('${param.sortBy}' !== '') params.push('sortBy=${param.sortBy}');
            if ('${param.sortDirection}' !== '') params.push('sortDirection=${param.sortDirection}');
            if ('${param.size}' !== '') params.push('size=${param.size}');
            
            if (params.length > 0) {
                url += '?' + params.join('&');
            }
            
            window.location.href = url;
        }
        
        // 정렬 폼 초기화
        function resetSort() {
            document.getElementById('sortForm').reset();
            // 검색 조건은 유지하고 정렬만 초기화
            let url = '/admin/members/${memberId}/orders';
            let params = [];
            
            if ('${param.memberName}' !== '') params.push('memberName=${param.memberName}');
            if ('${param.bookTitle}' !== '') params.push('bookTitle=${param.bookTitle}');
            if ('${param.publisher}' !== '') params.push('publisher=${param.publisher}');
            if ('${param.author}' !== '') params.push('author=${param.author}');
            if ('${param.saleStatus}' !== '') params.push('saleStatus=${param.saleStatus}');
            if ('${param.startDate}' !== '') params.push('startDate=${param.startDate}');
            if ('${param.endDate}' !== '') params.push('endDate=${param.endDate}');
            
            if (params.length > 0) {
                url += '?' + params.join('&');
            }
            
            window.location.href = url;
        }
        
        // 검색 폼 제출 시 빈 값 제거하고 정렬 조건 유지
        document.getElementById('searchForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            let url = '/admin/members/${memberId}/orders';
            let params = [];
            
            // 검색 조건 수집 (빈 값이 아닌 경우만)
            const memberName = document.querySelector('input[name="memberName"]').value.trim();
            const bookTitle = document.querySelector('input[name="bookTitle"]').value.trim();
            const publisher = document.querySelector('input[name="publisher"]').value.trim();
            const author = document.querySelector('input[name="author"]').value.trim();
            const saleStatus = document.querySelector('select[name="saleStatus"]').value;
            const startDate = document.querySelector('input[name="startDate"]').value;
            const endDate = document.querySelector('input[name="endDate"]').value;
            
            if (memberName !== '') params.push('memberName=' + encodeURIComponent(memberName));
            if (bookTitle !== '') params.push('bookTitle=' + encodeURIComponent(bookTitle));
            if (publisher !== '') params.push('publisher=' + encodeURIComponent(publisher));
            if (author !== '') params.push('author=' + encodeURIComponent(author));
            if (saleStatus !== '') params.push('saleStatus=' + encodeURIComponent(saleStatus));
            if (startDate !== '') params.push('startDate=' + encodeURIComponent(startDate));
            if (endDate !== '') params.push('endDate=' + encodeURIComponent(endDate));
            
            // 정렬 조건 유지
            if ('${param.sortBy}' !== '') params.push('sortBy=${param.sortBy}');
            if ('${param.sortDirection}' !== '') params.push('sortDirection=${param.sortDirection}');
            if ('${param.size}' !== '') params.push('size=${param.size}');
            
            if (params.length > 0) {
                url += '?' + params.join('&');
            }
            
            window.location.href = url;
        });
        
        // 정렬 폼 제출 시 검색 조건 유지
        document.getElementById('sortForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            let url = '/admin/members/${memberId}/orders';
            let params = [];
            
            // 검색 조건 유지
            if ('${param.memberName}' !== '') params.push('memberName=${param.memberName}');
            if ('${param.bookTitle}' !== '') params.push('bookTitle=${param.bookTitle}');
            if ('${param.publisher}' !== '') params.push('publisher=${param.publisher}');
            if ('${param.author}' !== '') params.push('author=${param.author}');
            if ('${param.saleStatus}' !== '') params.push('saleStatus=${param.saleStatus}');
            if ('${param.startDate}' !== '') params.push('startDate=${param.startDate}');
            if ('${param.endDate}' !== '') params.push('endDate=${param.endDate}');
            
            // 정렬 조건 수집
            const sortBy = document.querySelector('select[name="sortBy"]').value;
            const sortDirection = document.querySelector('select[name="sortDirection"]').value;
            const size = document.querySelector('select[name="size"]').value;
            
            if (sortBy !== '') params.push('sortBy=' + encodeURIComponent(sortBy));
            if (sortDirection !== '') params.push('sortDirection=' + encodeURIComponent(sortDirection));
            if (size !== '') params.push('size=' + encodeURIComponent(size));
            
            if (params.length > 0) {
                url += '?' + params.join('&');
            }
            
            window.location.href = url;
        });
        
        // 페이지 크기 변경 시 자동 정렬 적용
        document.getElementById('size').addEventListener('change', function() {
            document.getElementById('sortForm').submit();
        });
        
        // 페이지 이동 함수
        function goToPage(pageNumber) {
            let url = '/admin/members/${memberId}/orders';
            let params = [];
            
            // 현재 URL의 모든 파라미터를 수집
            if ('${param.memberName}' !== '') params.push('memberName=${param.memberName}');
            if ('${param.bookTitle}' !== '') params.push('bookTitle=${param.bookTitle}');
            if ('${param.publisher}' !== '') params.push('publisher=${param.publisher}');
            if ('${param.author}' !== '') params.push('author=${param.author}');
            if ('${param.saleStatus}' !== '') params.push('saleStatus=${param.saleStatus}');
            if ('${param.startDate}' !== '') params.push('startDate=${param.startDate}');
            if ('${param.endDate}' !== '') params.push('endDate=${param.endDate}');
            if ('${param.sortBy}' !== '') params.push('sortBy=${param.sortBy}');
            if ('${param.sortDirection}' !== '') params.push('sortDirection=${param.sortDirection}');
            if ('${param.size}' !== '') params.push('size=${param.size}');
            
            // 페이지 번호 추가
            params.push('page=' + pageNumber);
            
            if (params.length > 0) {
                url += '?' + params.join('&');
            }
            
            window.location.href = url;
        }
        
        // 토글 아이콘 회전 처리
        document.addEventListener('DOMContentLoaded', function() {
            // 검색 조건 토글
            const searchCollapse = document.getElementById('searchCollapse');
            const searchToggleIcon = document.getElementById('searchToggleIcon');
            
            searchCollapse.addEventListener('show.bs.collapse', function() {
                searchToggleIcon.style.transform = 'rotate(180deg)';
            });
            
            searchCollapse.addEventListener('hide.bs.collapse', function() {
                searchToggleIcon.style.transform = 'rotate(0deg)';
            });
            
            // 정렬 조건 토글
            const sortCollapse = document.getElementById('sortCollapse');
            const sortToggleIcon = document.getElementById('sortToggleIcon');
            
            sortCollapse.addEventListener('show.bs.collapse', function() {
                sortToggleIcon.style.transform = 'rotate(180deg)';
            });
            
            sortCollapse.addEventListener('hide.bs.collapse', function() {
                sortToggleIcon.style.transform = 'rotate(0deg)';
            });
        });
    </script>
</body>
</html>
