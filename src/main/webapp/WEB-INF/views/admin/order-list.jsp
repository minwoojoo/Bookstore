<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>주문 관리 - Online Bookstore</title>
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
        .order-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 16px;
            transition: all 0.3s ease;
        }
        .order-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
        }
        .order-status {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
        }
        .status-pending { background: #fff3cd; color: #856404; }
        .status-confirmed { background: #d1ecf1; color: #0c5460; }
        .status-shipping { background: #d4edda; color: #155724; }
        .status-delivered { background: #cce5ff; color: #004085; }
        .status-cancelled { background: #f8d7da; color: #721c24; }
        .order-item {
            border-left: 3px solid #007bff;
            padding-left: 12px;
            margin: 8px 0;
        }
        .pagination-custom .page-link {
            color: #667eea;
            border: 1px solid #dee2e6;
            padding: 8px 16px;
        }
        .pagination-custom .page-item.active .page-link {
            background: #667eea;
            border-color: #667eea;
        }
        .sort-btn {
            background: none;
            border: none;
            color: #6c757d;
            padding: 4px 8px;
            border-radius: 4px;
            transition: all 0.2s ease;
        }
        .sort-btn:hover {
            background: #f8f9fa;
            color: #495057;
        }
        .sort-btn.active {
            background: #667eea;
            color: white;
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
                            <a class="nav-link active" href="/admin/orders">
                                <i class="fas fa-shopping-cart me-2"></i>
                                주문 관리
                            </a>
                            <a class="nav-link" href="/admin/members">
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
                            <h2 class="mb-0">
                                <i class="fas fa-shopping-cart me-2"></i>
                                주문 관리
                            </h2>
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
                    
                    <!-- 콘텐츠 -->
                    <div class="p-4">
                        <!-- 검색 및 필터 -->
                        <div class="filter-card">
                            <form method="get" action="/admin/orders" id="searchForm">
                                <div class="row g-3">
                                    <div class="col-md-3">
                                        <label for="memberName" class="form-label">주문자 이름</label>
                                        <input type="text" class="form-control" id="memberName" name="memberName" 
                                               value="${request.memberName}" placeholder="주문자 이름 검색">
                                    </div>
                                    <div class="col-md-3">
                                        <label for="bookTitle" class="form-label">도서명</label>
                                        <input type="text" class="form-control" id="bookTitle" name="bookTitle" 
                                               value="${request.bookTitle}" placeholder="도서명 검색">
                                    </div>
                                    <div class="col-md-2">
                                        <label for="startDate" class="form-label">시작일</label>
                                        <input type="date" class="form-control" id="startDate" name="startDate" 
                                               value="${request.startDate}">
                                    </div>
                                    <div class="col-md-2">
                                        <label for="endDate" class="form-label">종료일</label>
                                        <input type="date" class="form-control" id="endDate" name="endDate" 
                                               value="${request.endDate}">
                                    </div>
                                    <div class="col-md-2">
                                        <label for="size" class="form-label">페이지 크기</label>
                                        <select class="form-select" id="size" name="size" onchange="this.form.submit()">
                                            <option value="30" ${request.size == 30 ? 'selected' : ''}>30개</option>
                                            <option value="50" ${request.size == 50 ? 'selected' : ''}>50개</option>
                                            <option value="100" ${request.size == 100 ? 'selected' : ''}>100개</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row mt-3">
                                    <div class="col-12">
                                        <div class="d-flex gap-2">
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fas fa-search me-2"></i>
                                                검색
                                            </button>
                                            <button type="button" class="btn btn-outline-secondary" onclick="resetForm()">
                                                <i class="fas fa-undo me-2"></i>
                                                초기화
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>

                        <!-- 정렬 옵션 -->
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <div class="d-flex gap-2">
                                <span class="text-muted">정렬:</span>
                                <button class="sort-btn ${request.sortBy == 'orderDate' ? 'active' : ''}" 
                                        onclick="sortBy('orderDate')">
                                    주문일 <i class="fas fa-${request.sortBy == 'orderDate' && request.sortDirection == 'asc' ? 'sort-up' : 'sort-down'}"></i>
                                </button>
                                <button class="sort-btn ${request.sortBy == 'memberId' ? 'active' : ''}" 
                                        onclick="sortBy('memberId')">
                                    주문자 ID <i class="fas fa-${request.sortBy == 'memberId' && request.sortDirection == 'asc' ? 'sort-up' : 'sort-down'}"></i>
                                </button>
                                <button class="sort-btn ${request.sortBy == 'totalAmount' ? 'active' : ''}" 
                                        onclick="sortBy('totalAmount')">
                                    주문금액 <i class="fas fa-${request.sortBy == 'totalAmount' && request.sortDirection == 'asc' ? 'sort-up' : 'sort-down'}"></i>
                                </button>
                                <button class="sort-btn ${request.sortBy == 'orderStatus' ? 'active' : ''}" 
                                        onclick="sortBy('orderStatus')">
                                    주문상태 <i class="fas fa-${request.sortBy == 'orderStatus' && request.sortDirection == 'asc' ? 'sort-up' : 'sort-down'}"></i>
                                </button>
                            </div>
                            <div class="text-muted">
                                총 ${orders.totalElements}건 (${orders.number + 1}/${orders.totalPages}페이지)
                            </div>
                        </div>

                        <!-- 주문 목록 -->
                        <c:choose>
                            <c:when test="${not empty orders.content}">
                                <c:forEach var="order" items="${orders.content}">
                                    <div class="order-card">
                                        <div class="row">
                                            <div class="col-md-8">
                                                <div class="d-flex justify-content-between align-items-start mb-3">
                                                    <div>
                                                        <h5 class="mb-1">주문 #${order.orderId}</h5>
                                                        <p class="text-muted mb-0">
                                                            <i class="fas fa-user me-1"></i>
                                                            ${order.memberName} (${order.memberEmail})
                                                        </p>
                                                    </div>
                                                    <div class="text-end">
                                                        <span class="order-status status-${order.orderStatus.toLowerCase()}">
                                                            ${order.orderStatus}
                                                        </span>
                                                        <div class="text-muted small mt-1">
                                                            ${order.orderDate}
                                                        </div>
                                                    </div>
                                                </div>
                                                
                                                <!-- 주문 아이템 -->
                                                <div class="mb-3">
                                                    <c:forEach var="item" items="${order.orderItems}" varStatus="status">
                                                        <div class="order-item">
                                                            <div class="d-flex justify-content-between align-items-center">
                                                                <div>
                                                                    <strong>${item.bookTitle}</strong>
                                                                    <div class="text-muted small">
                                                                        ${item.bookAuthor} | ${item.publisher}
                                                                    </div>
                                                                </div>
                                                                <div class="text-end">
                                                                    <div>${item.quantity}권</div>
                                                                    <div class="text-muted small">
                                                                        <fmt:formatNumber value="${item.totalPrice}" pattern="#,##0"/>원
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                                
                                                <!-- 배송 정보 -->
                                                <div class="row">
                                                    <div class="col-md-6">
                                                        <small class="text-muted">
                                                            <i class="fas fa-user me-1"></i>
                                                            수령인: ${order.recipientName}
                                                        </small>
                                                        <br>
                                                        <small class="text-muted">
                                                            <i class="fas fa-phone me-1"></i>
                                                            ${order.recipientPhone}
                                                        </small>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <small class="text-muted">
                                                            <i class="fas fa-map-marker-alt me-1"></i>
                                                            ${order.deliveryAddress}
                                                        </small>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div class="col-md-4">
                                                <div class="text-end">
                                                    <div class="mb-2">
                                                        <div class="text-muted small">주문금액</div>
                                                        <div class="h5 mb-0">
                                                            <fmt:formatNumber value="${order.totalAmount}" pattern="#,##0"/>원
                                                        </div>
                                                    </div>
                                                    <c:if test="${order.discountAmount > 0}">
                                                        <div class="mb-2">
                                                            <div class="text-muted small">할인금액</div>
                                                            <div class="text-danger">
                                                                -<fmt:formatNumber value="${order.discountAmount}" pattern="#,##0"/>원
                                                            </div>
                                                        </div>
                                                    </c:if>
                                                    <div class="mb-3">
                                                        <div class="text-muted small">최종결제금액</div>
                                                        <div class="h4 text-primary mb-0">
                                                            <fmt:formatNumber value="${order.finalPaymentAmount}" pattern="#,##0"/>원
                                                        </div>
                                                    </div>
                                                    
                                                    <div class="d-flex gap-2">
                                                        <a href="/admin/orders/${order.orderId}" class="btn btn-outline-primary btn-sm">
                                                            <i class="fas fa-eye me-1"></i>
                                                            상세보기
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-5">
                                    <i class="fas fa-shopping-cart fa-3x text-muted mb-3"></i>
                                    <h4 class="text-muted">주문이 없습니다</h4>
                                    <p class="text-muted">검색 조건을 변경해보세요.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <!-- 페이징 -->
                        <c:if test="${orders.totalPages > 1}">
                            <nav aria-label="주문 목록 페이징">
                                <ul class="pagination pagination-custom justify-content-center">
                                    <!-- 이전 페이지 -->
                                    <c:if test="${orders.hasPrevious()}">
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${orders.number - 1}&size=${request.size}&sortBy=${request.sortBy}&sortDirection=${request.sortDirection}&memberName=${request.memberName}&bookTitle=${request.bookTitle}&startDate=${request.startDate}&endDate=${request.endDate}">
                                                <i class="fas fa-chevron-left"></i>
                                            </a>
                                        </li>
                                    </c:if>
                                    
                                    <!-- 페이지 번호 -->
                                    <c:forEach var="i" begin="${Math.max(0, orders.number - 2)}" end="${Math.min(orders.totalPages - 1, orders.number + 2)}">
                                        <li class="page-item ${i == orders.number ? 'active' : ''}">
                                            <a class="page-link" href="?page=${i}&size=${request.size}&sortBy=${request.sortBy}&sortDirection=${request.sortDirection}&memberName=${request.memberName}&bookTitle=${request.bookTitle}&startDate=${request.startDate}&endDate=${request.endDate}">
                                                ${i + 1}
                                            </a>
                                        </li>
                                    </c:forEach>
                                    
                                    <!-- 다음 페이지 -->
                                    <c:if test="${orders.hasNext()}">
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${orders.number + 1}&size=${request.size}&sortBy=${request.sortBy}&sortDirection=${request.sortDirection}&memberName=${request.memberName}&bookTitle=${request.bookTitle}&startDate=${request.startDate}&endDate=${request.endDate}">
                                                <i class="fas fa-chevron-right"></i>
                                            </a>
                                        </li>
                                    </c:if>
                                </ul>
                            </nav>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // 정렬 함수
        function sortBy(sortBy) {
            const currentSortBy = '${request.sortBy}';
            const currentSortDirection = '${request.sortDirection}';
            
            let newSortDirection = 'desc';
            if (currentSortBy === sortBy && currentSortDirection === 'desc') {
                newSortDirection = 'asc';
            }
            
            const form = document.getElementById('searchForm');
            const sortByInput = document.createElement('input');
            sortByInput.type = 'hidden';
            sortByInput.name = 'sortBy';
            sortByInput.value = sortBy;
            form.appendChild(sortByInput);
            
            const sortDirectionInput = document.createElement('input');
            sortDirectionInput.type = 'hidden';
            sortDirectionInput.name = 'sortDirection';
            sortDirectionInput.value = newSortDirection;
            form.appendChild(sortDirectionInput);
            
            form.submit();
        }
        
        // 폼 초기화
        function resetForm() {
            document.getElementById('memberName').value = '';
            document.getElementById('bookTitle').value = '';
            document.getElementById('startDate').value = '';
            document.getElementById('endDate').value = '';
            document.getElementById('size').value = '30';
            document.getElementById('searchForm').submit();
        }
        
    </script>
</body>
</html>
