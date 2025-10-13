<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상품 관리 - Online Bookstore</title>
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
        .book-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        .book-card:hover {
            transform: translateY(-5px);
        }
        .book-thumbnail {
            width: 80px;
            height: 100px;
            object-fit: cover;
            border-radius: 8px;
        }
        .status-badge {
            font-size: 0.75rem;
            padding: 4px 8px;
            border-radius: 12px;
        }
        .filter-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
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
                            <a class="nav-link active" href="/admin/books">
                                <i class="fas fa-book me-2"></i>
                                상품 관리
                            </a>
                            <a class="nav-link" href="/admin/orders">
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
                                <i class="fas fa-book me-2"></i>
                                상품 관리
                            </h2>
                            <div class="d-flex align-items-center gap-2">
                                <a href="/admin/books/new" class="btn btn-primary">
                                    <i class="fas fa-plus me-2"></i>
                                    새 상품 등록
                                </a>
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
                            <form method="get" action="/admin/books">
                                <div class="row g-3">
                                    <div class="col-md-3">
                                        <label class="form-label">책 이름</label>
                                        <input type="text" class="form-control" name="bookTitle" value="${request.bookTitle}" placeholder="책 이름으로 검색">
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label">출판사</label>
                                        <input type="text" class="form-control" name="publisher" value="${request.publisher}" placeholder="출판사로 검색">
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label">저자</label>
                                        <input type="text" class="form-control" name="author" value="${request.author}" placeholder="저자로 검색">
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label">판매상태</label>
                                        <select class="form-select" name="saleStatus">
                                            <option value="">전체</option>
                                            <option value="판매중" ${request.saleStatus == '판매중' ? 'selected' : ''}>판매중</option>
                                            <option value="절판" ${request.saleStatus == '절판' ? 'selected' : ''}>절판</option>
                                            <option value="일시품절" ${request.saleStatus == '일시품절' ? 'selected' : ''}>일시품절</option>
                                            <option value="입고예정" ${request.saleStatus == '입고예정' ? 'selected' : ''}>입고예정</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label">재고 수량 (최소)</label>
                                        <input type="number" class="form-control" name="minStock" value="${request.minStock}" placeholder="최소 재고">
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label">재고 수량 (최대)</label>
                                        <input type="number" class="form-control" name="maxStock" value="${request.maxStock}" placeholder="최대 재고">
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label">등록일 시작</label>
                                        <input type="date" class="form-control" name="startDate" value="${request.startDate}">
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label">등록일 종료</label>
                                        <input type="date" class="form-control" name="endDate" value="${request.endDate}">
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label">정렬 기준</label>
                                        <select class="form-select" name="sortBy">
                                            <option value="bookId" ${request.sortBy == 'bookId' ? 'selected' : ''}>상품 ID</option>
                                            <option value="bookTitle" ${request.sortBy == 'bookTitle' ? 'selected' : ''}>책 이름</option>
                                            <option value="price" ${request.sortBy == 'price' ? 'selected' : ''}>가격</option>
                                            <option value="createdAt" ${request.sortBy == 'createdAt' ? 'selected' : ''}>등록일</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label">정렬 방향</label>
                                        <select class="form-select" name="sortDirection">
                                            <option value="asc" ${request.sortDirection == 'asc' ? 'selected' : ''}>오름차순</option>
                                            <option value="desc" ${request.sortDirection == 'desc' ? 'selected' : ''}>내림차순</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label">페이지 크기</label>
                                        <select class="form-select" name="size">
                                            <option value="30" ${request.size == 30 ? 'selected' : ''}>30개</option>
                                            <option value="50" ${request.size == 50 ? 'selected' : ''}>50개</option>
                                            <option value="100" ${request.size == 100 ? 'selected' : ''}>100개</option>
                                        </select>
                                    </div>
                                    <div class="col-12">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-search me-2"></i>
                                            검색
                                        </button>
                                        <a href="/admin/books" class="btn btn-outline-secondary ms-2">
                                            <i class="fas fa-refresh me-2"></i>
                                            초기화
                                        </a>
                                    </div>
                                </div>
                            </form>
                        </div>
                        
                        <!-- 상품 목록 -->
                        <div class="row">
                            <c:forEach var="book" items="${books.content}">
                                <div class="col-md-6 col-lg-4 mb-4">
                                    <div class="book-card">
                                        <div class="d-flex">
                                            <img src="${book.thumbnailUrl}" alt="${book.title}" class="book-thumbnail me-3">
                                            <div class="flex-grow-1">
                                                <h6 class="mb-2">${book.title}</h6>
                                                <p class="text-muted small mb-1">
                                                    <i class="fas fa-user me-1"></i>
                                                    ${book.authors[0]}
                                                </p>
                                                <p class="text-muted small mb-1">
                                                    <i class="fas fa-building me-1"></i>
                                                    ${book.publisher}
                                                </p>
                                                <p class="text-muted small mb-2">
                                                    <i class="fas fa-box me-1"></i>
                                                    재고: ${book.stock}권
                                                </p>
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <span class="fw-bold text-primary">
                                                        <fmt:formatNumber value="${book.price}" pattern="#,##0"/>원
                                                    </span>
                                                    <span class="status-badge 
                                                        ${book.saleStatus == '판매중' ? 'bg-success' : 
                                                          book.saleStatus == '절판' ? 'bg-danger' : 
                                                          book.saleStatus == '일시품절' ? 'bg-warning' : 'bg-info'} text-white">
                                                        ${book.saleStatus}
                                                    </span>
                                                </div>
                                                <div class="mt-2">
                                                    <a href="/admin/books/${book.bookId}" class="btn btn-sm btn-outline-primary">
                                                        <i class="fas fa-eye me-1"></i>
                                                        상세보기
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        
                        <!-- 페이지네이션 -->
                        <c:if test="${books.totalPages > 1}">
                            <nav aria-label="상품 목록 페이지네이션">
                                <ul class="pagination justify-content-center">
                                    <c:if test="${books.hasPrevious()}">
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${books.number - 1}&size=${request.size}&bookTitle=${request.bookTitle}&publisher=${request.publisher}&author=${request.author}&saleStatus=${request.saleStatus}&minStock=${request.minStock}&maxStock=${request.maxStock}&startDate=${request.startDate}&endDate=${request.endDate}&sortBy=${request.sortBy}&sortDirection=${request.sortDirection}">
                                                <i class="fas fa-chevron-left"></i>
                                            </a>
                                        </li>
                                    </c:if>
                                    
                                    <c:forEach var="i" begin="${Math.max(0, books.number - 2)}" end="${Math.min(books.totalPages - 1, books.number + 2)}">
                                        <li class="page-item ${i == books.number ? 'active' : ''}">
                                            <a class="page-link" href="?page=${i}&size=${request.size}&bookTitle=${request.bookTitle}&publisher=${request.publisher}&author=${request.author}&saleStatus=${request.saleStatus}&minStock=${request.minStock}&maxStock=${request.maxStock}&startDate=${request.startDate}&endDate=${request.endDate}&sortBy=${request.sortBy}&sortDirection=${request.sortDirection}">
                                                ${i + 1}
                                            </a>
                                        </li>
                                    </c:forEach>
                                    
                                    <c:if test="${books.hasNext()}">
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${books.number + 1}&size=${request.size}&bookTitle=${request.bookTitle}&publisher=${request.publisher}&author=${request.author}&saleStatus=${request.saleStatus}&minStock=${request.minStock}&maxStock=${request.maxStock}&startDate=${request.startDate}&endDate=${request.endDate}&sortBy=${request.sortBy}&sortDirection=${request.sortDirection}">
                                                <i class="fas fa-chevron-right"></i>
                                            </a>
                                        </li>
                                    </c:if>
                                </ul>
                            </nav>
                        </c:if>
                        
                        <!-- 결과 정보 -->
                        <div class="text-center text-muted">
                            총 ${books.totalElements}개의 상품이 있습니다. (${books.number + 1}/${books.totalPages} 페이지)
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
