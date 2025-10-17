<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상품 등록 - Online Bookstore</title>
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
        .form-card {
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 24px;
        }
        .form-section {
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #e9ecef;
        }
        .form-section:last-child {
            border-bottom: none;
            margin-bottom: 0;
        }
        .section-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: #495057;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
        }
        .section-title i {
            margin-right: 10px;
            color: #007bff;
        }
        .required {
            color: #dc3545;
        }
        .form-label {
            font-weight: 500;
            color: #495057;
        }
        .form-control:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
        }
        .btn-submit {
            background: linear-gradient(45deg, #007bff, #0056b3);
            border: none;
            padding: 12px 30px;
            font-weight: 600;
        }
        .btn-submit:hover {
            background: linear-gradient(45deg, #0056b3, #004085);
        }
        .preview-image {
            max-width: 200px;
            max-height: 250px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .error-message {
            color: #dc3545;
            font-size: 0.875rem;
            margin-top: 5px;
        }
        .help-text {
            font-size: 0.875rem;
            color: #6c757d;
            margin-top: 5px;
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
                            <div class="d-flex align-items-center">
                                <a href="/admin/books" class="btn btn-outline-secondary me-3">
                                    <i class="fas fa-arrow-left me-1"></i>
                                    상품 목록
                                </a>
                                <h2 class="mb-0">
                                    <i class="fas fa-plus me-2"></i>
                                    새 상품 등록
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
                                        <li><a class="dropdown-item" href="/admin/books">상품 관리</a></li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item" href="/auth/logout">로그아웃</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- 콘텐츠 -->
                    <div class="p-4">
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger" role="alert">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                ${errorMessage}
                            </div>
                        </c:if>
                        
                        <form method="post" action="/admin/books/new" id="bookCreateForm" enctype="multipart/form-data">
                            <!-- 기본 정보 -->
                            <div class="form-card">
                                <div class="section-title">
                                    <i class="fas fa-book"></i>
                                    기본 정보
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="isbn" class="form-label">
                                                ISBN <span class="required">*</span>
                                            </label>
                                            <input type="text" class="form-control" id="isbn" name="isbn" 
                                                   value="${bookCreateRequest.isbn}" 
                                                   placeholder="978-89-123-4567-8" maxlength="20" required>
                                            <div class="help-text">ISBN-13 형식으로 입력해주세요</div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="categoryId" class="form-label">
                                                카테고리 <span class="required">*</span>
                                            </label>
                                            <select class="form-select" id="categoryId" name="categoryId" required>
                                                <option value="">카테고리를 선택하세요</option>
                                                <c:forEach var="category" items="${categories}">
                                                    <option value="${category.categoryId}" 
                                                            ${bookCreateRequest.categoryId == category.categoryId ? 'selected' : ''}>
                                                        ${category.categoryName}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="title" class="form-label">
                                        책 제목 <span class="required">*</span>
                                    </label>
                                    <input type="text" class="form-control" id="title" name="title" 
                                           value="${bookCreateRequest.title}" 
                                           placeholder="책 제목을 입력하세요" maxlength="500" required>
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="publisher" class="form-label">
                                                출판사 <span class="required">*</span>
                                            </label>
                                            <input type="text" class="form-control" id="publisher" name="publisher" 
                                                   value="${bookCreateRequest.publisher}" 
                                                   placeholder="출판사명을 입력하세요" maxlength="200" required>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="authors" class="form-label">
                                                저자 <span class="required">*</span>
                                            </label>
                                            <input type="text" class="form-control" id="authors" name="authors" 
                                                   value="${bookCreateRequest.authors}" 
                                                   placeholder="저자명을 입력하세요 (여러 명일 경우 쉼표로 구분)" required>
                                            <div class="help-text">예: 홍길동, 김철수, 이영희</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- 가격 및 판매 정보 -->
                            <div class="form-card">
                                <div class="section-title">
                                    <i class="fas fa-won-sign"></i>
                                    가격 및 판매 정보
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-4">
                                        <div class="mb-3">
                                            <label for="price" class="form-label">
                                                가격 <span class="required">*</span>
                                            </label>
                                            <div class="input-group">
                                                <input type="number" class="form-control" id="price" name="price" 
                                                       value="${bookCreateRequest.price}" 
                                                       placeholder="0" min="0" step="1" required>
                                                <span class="input-group-text">원</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="mb-3">
                                            <label for="salesCount" class="form-label">판매지수</label>
                                            <input type="number" class="form-control" id="salesCount" name="salesCount" 
                                                   value="${bookCreateRequest.salesCount}" 
                                                   placeholder="0" min="0">
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="mb-3">
                                            <label for="monthlySales" class="form-label">월간 판매량</label>
                                            <input type="number" class="form-control" id="monthlySales" name="monthlySales" 
                                                   value="${bookCreateRequest.monthlySales}" 
                                                   placeholder="0" min="0">
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="ratingAvg" class="form-label">평점</label>
                                            <input type="number" class="form-control" id="ratingAvg" name="ratingAvg" 
                                                   value="${bookCreateRequest.ratingAvg}" 
                                                   placeholder="0.0" min="0" max="5" step="0.1">
                                            <div class="help-text">0.0 ~ 5.0 사이의 값</div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="bookStatus" class="form-label">
                                                판매 상태 <span class="required">*</span>
                                            </label>
                                            <select class="form-select" id="bookStatus" name="bookStatus" required>
                                                <option value="">상태를 선택하세요</option>
                                                <option value="ACTIVE" ${bookCreateRequest.bookStatus == 'ACTIVE' ? 'selected' : ''}>판매중</option>
                                                <option value="INACTIVE" ${bookCreateRequest.bookStatus == 'INACTIVE' ? 'selected' : ''}>판매중지</option>
                                                <option value="OUT_OF_STOCK" ${bookCreateRequest.bookStatus == 'OUT_OF_STOCK' ? 'selected' : ''}>품절</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- 물리적 정보 -->
                            <div class="form-card">
                                <div class="section-title">
                                    <i class="fas fa-ruler"></i>
                                    물리적 정보
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-4">
                                        <div class="mb-3">
                                            <label for="pageCount" class="form-label">페이지 수</label>
                                            <input type="number" class="form-control" id="pageCount" name="pageCount" 
                                                   value="${bookCreateRequest.pageCount}" 
                                                   placeholder="0" min="1">
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="mb-3">
                                            <label for="width" class="form-label">가로 (mm)</label>
                                            <input type="number" class="form-control" id="width" name="width" 
                                                   value="${bookCreateRequest.width}" 
                                                   placeholder="0" min="1">
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="mb-3">
                                            <label for="height" class="form-label">세로 (mm)</label>
                                            <input type="number" class="form-control" id="height" name="height" 
                                                   value="${bookCreateRequest.height}" 
                                                   placeholder="0" min="1">
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">크기 미리보기</label>
                                    <div class="alert alert-info">
                                        <i class="fas fa-info-circle me-2"></i>
                                        <span id="sizePreview">가로와 세로를 입력하면 크기가 표시됩니다</span>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- 미디어 정보 -->
                            <div class="form-card">
                                <div class="section-title">
                                    <i class="fas fa-image"></i>
                                    미디어 정보
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="thumbnailUrl" class="form-label">썸네일 이미지 URL</label>
                                            <input type="url" class="form-control" id="thumbnailUrl" name="thumbnailUrl" 
                                                   value="${bookCreateRequest.thumbnailUrl}" 
                                                   placeholder="https://example.com/image.jpg" maxlength="500">
                                            <div class="help-text">책의 표지 이미지 URL을 입력하세요</div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="previewUrl" class="form-label">미리보기 URL</label>
                                            <input type="url" class="form-control" id="previewUrl" name="previewUrl" 
                                                   value="${bookCreateRequest.previewUrl}" 
                                                   placeholder="https://example.com/preview.pdf" maxlength="500">
                                            <div class="help-text">책의 미리보기 파일 URL을 입력하세요</div>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">썸네일 미리보기</label>
                                    <div class="text-center">
                                        <img id="thumbnailPreview" class="preview-image" style="display: none;" 
                                             onerror="this.style.display='none';">
                                        <div id="noImagePreview" class="text-muted">
                                            <i class="fas fa-image fa-3x mb-2"></i>
                                            <br>이미지 URL을 입력하면 미리보기가 표시됩니다
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- 상세 설명 -->
                            <div class="form-card">
                                <div class="section-title">
                                    <i class="fas fa-align-left"></i>
                                    상세 설명
                                </div>
                                
                                <div class="mb-3">
                                    <label for="description" class="form-label">책 소개</label>
                                    <textarea class="form-control" id="description" name="description" rows="6" 
                                              placeholder="책의 내용, 특징, 추천 대상 등을 자세히 설명해주세요" 
                                              maxlength="10000">${bookCreateRequest.description}</textarea>
                                    <div class="help-text">최대 10,000자까지 입력 가능합니다</div>
                                </div>
                            </div>
                            
                            <!-- 재고 정보 -->
                            <div class="form-card">
                                <div class="section-title">
                                    <i class="fas fa-boxes"></i>
                                    재고 정보
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="stockQuantity" class="form-label">초기 재고 수량</label>
                                            <input type="number" class="form-control" id="stockQuantity" name="stockQuantity" 
                                                   value="${bookCreateRequest.stockQuantity}" 
                                                   placeholder="0" min="0">
                                            <div class="help-text">등록 시 초기 재고 수량을 설정합니다</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- 제출 버튼 -->
                            <div class="form-card">
                                <div class="d-flex justify-content-between">
                                    <a href="/admin/books" class="btn btn-outline-secondary">
                                        <i class="fas fa-times me-2"></i>
                                        취소
                                    </a>
                                    <button type="submit" class="btn btn-primary btn-submit">
                                        <i class="fas fa-save me-2"></i>
                                        상품 등록
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // 크기 미리보기 업데이트
        function updateSizePreview() {
            const width = document.getElementById('width').value;
            const height = document.getElementById('height').value;
            const preview = document.getElementById('sizePreview');
            
            if (width && height) {
                preview.textContent = `${width} x ${height} mm`;
            } else {
                preview.textContent = '가로와 세로를 입력하면 크기가 표시됩니다';
            }
        }
        
        // 썸네일 미리보기 업데이트
        function updateThumbnailPreview() {
            const url = document.getElementById('thumbnailUrl').value;
            const preview = document.getElementById('thumbnailPreview');
            const noPreview = document.getElementById('noImagePreview');
            
            if (url) {
                preview.src = url;
                preview.style.display = 'block';
                noPreview.style.display = 'none';
            } else {
                preview.style.display = 'none';
                noPreview.style.display = 'block';
            }
        }
        
        // 이벤트 리스너 등록
        document.getElementById('width').addEventListener('input', updateSizePreview);
        document.getElementById('height').addEventListener('input', updateSizePreview);
        document.getElementById('thumbnailUrl').addEventListener('input', updateThumbnailPreview);
        
        // 폼 제출 시 유효성 검사
        document.getElementById('bookCreateForm').addEventListener('submit', function(e) {
            const requiredFields = ['isbn', 'title', 'publisher', 'authors', 'price', 'categoryId', 'bookStatus'];
            let isValid = true;
            
            requiredFields.forEach(function(fieldName) {
                const field = document.getElementById(fieldName);
                if (!field.value.trim()) {
                    field.classList.add('is-invalid');
                    isValid = false;
                } else {
                    field.classList.remove('is-invalid');
                }
            });
            
            if (!isValid) {
                e.preventDefault();
                alert('필수 항목을 모두 입력해주세요.');
            }
        });
        
        // 페이지 로드 시 초기화
        document.addEventListener('DOMContentLoaded', function() {
            updateSizePreview();
            updateThumbnailPreview();
        });
    </script>
</body>
</html>
