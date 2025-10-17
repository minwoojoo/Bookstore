<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>재고 관리 - Online Bookstore</title>
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
        .book-info-card {
            background: white;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 24px;
        }
        .stock-management-card {
            background: white;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .book-thumbnail {
            width: 120px;
            height: 150px;
            object-fit: cover;
            border-radius: 8px;
        }
        .stock-input-group {
            max-width: 300px;
        }
        .stock-history-item {
            border-left: 4px solid #28a745;
            padding-left: 16px;
            margin-bottom: 12px;
        }
        .stock-history-item.decrease {
            border-left-color: #dc3545;
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
                                <i class="fas fa-boxes me-2"></i>
                                재고 관리
                            </h2>
                            <div class="d-flex align-items-center gap-2">
                                <a href="/admin/books" class="btn btn-outline-secondary">
                                    <i class="fas fa-arrow-left me-2"></i>
                                    상품 목록으로
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
                        <c:choose>
                            <c:when test="${isUnauthorized == true}">
                                <div class="alert alert-danger text-center" role="alert">
                                    <h4 class="alert-heading">접근 권한 없음!</h4>
                                    <p>관리자 계정으로만 접근이 가능합니다.</p>
                                    <hr>
                                    <p class="mb-0">
                                        <a href="/admin" class="btn btn-danger">관리자 대시보드로 돌아가기</a>
                                    </p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <!-- 도서 정보 -->
                                <div class="book-info-card">
                                    <div class="row">
                                        <div class="col-md-3">
                                            <img src="${book.thumbnailUrl}" alt="${book.title}" class="book-thumbnail">
                                        </div>
                                        <div class="col-md-9">
                                            <h4 class="mb-3">${book.title}</h4>
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <p class="mb-2"><strong>저자:</strong> ${book.authors[0]}</p>
                                                    <p class="mb-2"><strong>출판사:</strong> ${book.publisher}</p>
                                                    <p class="mb-2"><strong>ISBN:</strong> ${book.isbn}</p>
                                                </div>
                                                <div class="col-md-6">
                                                    <p class="mb-2"><strong>가격:</strong> <fmt:formatNumber value="${book.price}" pattern="#,##0"/>원</p>
                                                    <p class="mb-2"><strong>판매상태:</strong> 
                                                        <span class="badge bg-${book.saleStatus == '판매중' ? 'success' : book.saleStatus == '절판' ? 'danger' : book.saleStatus == '일시품절' ? 'warning' : 'info'}">
                                                            ${book.saleStatus}
                                                        </span>
                                                    </p>
                                                    <p class="mb-2"><strong>현재 재고:</strong> 
                                                        <span class="h5 text-${book.stock < 10 ? 'danger' : book.stock < 30 ? 'warning' : 'success'}">
                                                            ${book.stock}권
                                                        </span>
                                                    </p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- 재고 관리 -->
                                <div class="stock-management-card">
                                    <h5 class="mb-4">
                                        <i class="fas fa-edit me-2"></i>
                                        재고 수정
                                    </h5>
                                    
                                    <form id="stockForm" method="post" action="/admin/books/${book.bookId}/stock">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="stock-input-group">
                                                    <label for="currentStock" class="form-label">현재 재고</label>
                                                    <input type="number" class="form-control form-control-lg text-center" 
                                                           id="currentStock" value="${book.stock}" readonly>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="stock-input-group">
                                                    <label for="adjustment" class="form-label">재고 조정량</label>
                                                    <div class="input-group">
                                                        <button type="button" class="btn btn-outline-secondary" onclick="adjustStock(-1)">
                                                            <i class="fas fa-minus"></i>
                                                        </button>
                                                        <input type="number" class="form-control text-center" 
                                                               id="adjustment" name="adjustment" value="0" min="-999" max="999">
                                                        <button type="button" class="btn btn-outline-secondary" onclick="adjustStock(1)">
                                                            <i class="fas fa-plus"></i>
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="row mt-4">
                                            <div class="col-md-6">
                                                <div class="stock-input-group">
                                                    <label for="newStock" class="form-label">새 재고 수량</label>
                                                    <input type="number" class="form-control form-control-lg text-center" 
                                                           id="newStock" name="newStock" value="${book.stock}" min="0" max="9999">
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="row mt-4">
                                            <div class="col-12">
                                                <div class="d-flex gap-2">
                                                    <button type="submit" class="btn btn-success">
                                                        <i class="fas fa-save me-2"></i>
                                                        재고 업데이트
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

                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // 재고 조정량 변경 시 새 재고 수량 계산
        function adjustStock(amount) {
            const adjustmentInput = document.getElementById('adjustment');
            const currentValue = parseInt(adjustmentInput.value) || 0;
            const newValue = currentValue + amount;
            adjustmentInput.value = newValue;
            updateNewStock();
        }
        
        // 새 재고 수량 업데이트
        function updateNewStock() {
            const currentStock = parseInt(document.getElementById('currentStock').value) || 0;
            const adjustment = parseInt(document.getElementById('adjustment').value) || 0;
            const newStock = Math.max(0, currentStock + adjustment);
            document.getElementById('newStock').value = newStock;
        }
        
        // 조정량 입력 시 새 재고 수량 업데이트
        document.getElementById('adjustment').addEventListener('input', updateNewStock);
        
        // 새 재고 수량 직접 입력 시 조정량 계산
        document.getElementById('newStock').addEventListener('input', function() {
            const currentStock = parseInt(document.getElementById('currentStock').value) || 0;
            const newStock = parseInt(this.value) || 0;
            const adjustment = newStock - currentStock;
            document.getElementById('adjustment').value = adjustment;
        });
        
        // 폼 초기화
        function resetForm() {
            document.getElementById('adjustment').value = 0;
            document.getElementById('newStock').value = ${book.stock};
        }
        
        // 폼 제출 시 확인
        document.getElementById('stockForm').addEventListener('submit', function(e) {
            e.preventDefault(); // 기본 제출 동작 중단
            
            // DOM 요소 찾기
            const adjustmentInput = document.getElementById('adjustment');
            const newStockInput = document.getElementById('newStock');
            const currentStockInput = document.getElementById('currentStock');
            
            if (!adjustmentInput || !newStockInput || !currentStockInput) {
                console.error('필요한 DOM 요소를 찾을 수 없습니다.');
                alert('오류가 발생했습니다. 페이지를 새로고침해주세요.');
                return;
            }
            
            // 값 읽기
            const adjustment = parseInt(adjustmentInput.value) || 0;
            const newStock = parseInt(newStockInput.value) || 0;
            const currentStock = parseInt(currentStockInput.value) || 0;
            
            console.log('DOM 요소 확인:');
            console.log('- adjustmentInput:', adjustmentInput);
            console.log('- newStockInput:', newStockInput);
            console.log('- currentStockInput:', currentStockInput);
            console.log('값 확인:');
            console.log('- 현재 재고:', currentStock, '(원본값:', currentStockInput.value, ')');
            console.log('- 조정량:', adjustment, '(원본값:', adjustmentInput.value, ')');
            console.log('- 새 재고:', newStock, '(원본값:', newStockInput.value, ')');
            
            if (newStock !== currentStock + adjustment) {
                alert('재고 수량이 일치하지 않습니다. 다시 확인해주세요.');
                return;
            }
            
            if (adjustment === 0) {
                alert('재고 변경량을 입력해주세요.');
                return;
            }
            
            // 문자열을 더 안전하게 구성
            const adjustmentText = adjustment > 0 ? '+' + adjustment : adjustment.toString();
            const message = '재고를 ' + adjustmentText + '권 조정하시겠습니까?\n\n변경 후 재고: ' + newStock + '권';
            console.log('확인 메시지:', message);
            console.log('adjustmentText:', adjustmentText);
            
            if (confirm(message)) {
                // 확인을 누르면 폼 제출
                this.submit();
            }
        });
    </script>
</body>
</html>
