<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원 관리 - Online Bookstore</title>
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
                            <h2 class="mb-0">
                                <i class="fas fa-users me-2"></i>
                                회원 관리
                            </h2>
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
                                <form method="get" action="/admin/members" id="searchForm">
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
                                            <label for="memberId" class="form-label">회원 ID</label>
                                            <input type="number" class="form-control" id="memberId" name="memberId" 
                                                   value="${param.memberId}" placeholder="회원 ID 입력" min="1">
                                        </div>
                                        <div class="col-md-3">
                                            <label for="memberStatus" class="form-label">회원 상태</label>
                                            <select class="form-select" id="memberStatus" name="memberStatus">
                                                <option value="">전체</option>
                                                <option value="ACTIVE" ${param.memberStatus == 'ACTIVE' ? 'selected' : ''}>활성</option>
                                                <option value="INACTIVE" ${param.memberStatus == 'INACTIVE' ? 'selected' : ''}>비활성</option>
                                                <option value="SUSPENDED" ${param.memberStatus == 'SUSPENDED' ? 'selected' : ''}>정지</option>
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <label for="email" class="form-label">이메일</label>
                                            <input type="text" class="form-control" id="email" name="email" 
                                                   value="${param.email}" placeholder="이메일 입력">
                                        </div>
                                        <div class="col-md-3">
                                            <label for="memberGrade" class="form-label">회원 등급</label>
                                            <select class="form-select" id="memberGrade" name="memberGrade">
                                                <option value="">전체</option>
                                                <option value="GOLD" ${param.memberGrade == 'GOLD' ? 'selected' : ''}>GOLD</option>
                                                <option value="SILVER" ${param.memberGrade == 'SILVER' ? 'selected' : ''}>SILVER</option>
                                                <option value="BRONZE" ${param.memberGrade == 'BRONZE' ? 'selected' : ''}>BRONZE</option>
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <label for="memberName" class="form-label">회원 이름</label>
                                            <input type="text" class="form-control" id="memberName" name="memberName" 
                                                   value="${param.memberName}" placeholder="회원 이름 입력">
                                        </div>
                                        <div class="col-md-3">
                                            <label for="startDate" class="form-label">가입일 시작</label>
                                            <input type="date" class="form-control" id="startDate" name="startDate" 
                                                   value="${param.startDate}">
                                        </div>
                                        <div class="col-md-3">
                                            <label for="endDate" class="form-label">가입일 종료</label>
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
                                <form method="get" action="/admin/members" id="sortForm">
                                    <!-- 검색 조건 유지 (빈 값이 아닌 경우만) -->
                                    <c:if test="${not empty param.memberId}">
                                        <input type="hidden" name="memberId" value="${param.memberId}">
                                    </c:if>
                                    <c:if test="${not empty param.memberStatus}">
                                        <input type="hidden" name="memberStatus" value="${param.memberStatus}">
                                    </c:if>
                                    <c:if test="${not empty param.email}">
                                        <input type="hidden" name="email" value="${param.email}">
                                    </c:if>
                                    <c:if test="${not empty param.memberGrade}">
                                        <input type="hidden" name="memberGrade" value="${param.memberGrade}">
                                    </c:if>
                                    <c:if test="${not empty param.memberName}">
                                        <input type="hidden" name="memberName" value="${param.memberName}">
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
                                                <option value="memberId" ${param.sortBy == 'memberId' ? 'selected' : ''}>회원 ID</option>
                                                <option value="memberName" ${param.sortBy == 'memberName' ? 'selected' : ''}>회원 이름</option>
                                                <option value="registrationDate" ${param.sortBy == 'registrationDate' ? 'selected' : ''}>가입일</option>
                                            </select>
                                        </div>
                                        <div class="col-md-4">
                                            <label for="sortDirection" class="form-label">정렬 방향</label>
                                            <select class="form-select" id="sortDirection" name="sortDirection">
                                                <option value="asc" ${param.sortDirection == 'asc' ? 'selected' : ''}>오름차순</option>
                                                <option value="desc" ${param.sortDirection == 'desc' ? 'selected' : ''}>내림차순</option>
                                            </select>
                                        </div>
                                        <div class="col-md-4">
                                            <label for="size" class="form-label">페이지 크기</label>
                                            <select class="form-select" id="size" name="size">
                                                <option value="30" ${param.size == '30' ? 'selected' : ''}>30개</option>
                                                <option value="50" ${param.size == '50' ? 'selected' : ''}>50개</option>
                                                <option value="100" ${param.size == '100' ? 'selected' : ''}>100개</option>
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
                        
                        <!-- 회원 목록 테이블 -->
                        <div class="table-card">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h5 class="mb-0">
                                    <i class="fas fa-list me-2"></i>
                                    회원 목록
                                </h5>
                                <div class="pagination-info">
                                    총 ${totalElements}명 중 ${(currentPage * pageSize) + 1}-${Math.min((currentPage + 1) * pageSize, totalElements)}명 표시
                                </div>
                            </div>
                            
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead class="table-light">
                                        <tr>
                                            <th>회원 ID</th>
                                            <th>이름</th>
                                            <th>이메일</th>
                                            <th>전화번호</th>
                                            <th>회원 등급</th>
                                            <th>상태</th>
                                            <th>가입일</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty members}">
                                                <c:forEach var="member" items="${members}">
                                                    <tr style="cursor: pointer;" onclick="viewMember('${member.memberId}')" 
                                                        onmouseover="this.style.backgroundColor='#f8f9fa'" 
                                                        onmouseout="this.style.backgroundColor=''">
                                                        <td>${member.memberId}</td>
                                                        <td>${member.memberName}</td>
                                                        <td>${member.email}</td>
                                                        <td>${member.phone}</td>
                                                        <td>
                                                            <span class="badge bg-${member.memberGrade == 'GOLD' ? 'warning' : member.memberGrade == 'SILVER' ? 'secondary' : 'success'}">
                                                                ${member.memberGrade}
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <span class="badge status-badge bg-${member.memberStatus == 'ACTIVE' ? 'success' : member.memberStatus == 'INACTIVE' ? 'secondary' : 'danger'}">
                                                                ${member.memberStatus == 'ACTIVE' ? '활성' : member.memberStatus == 'INACTIVE' ? '비활성' : '정지'}
                                                            </span>
                                                        </td>
                                                        <td>
                                                            ${member.createdAt}
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="7" class="text-center text-muted py-4">
                                                        <i class="fas fa-users fa-3x mb-3"></i>
                                                        <br>
                                                        검색 조건에 맞는 회원이 없습니다.
                                                    </td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                            
                            <!-- 페이징 -->
                            <c:if test="${totalPages > 1}">
                                <nav aria-label="회원 목록 페이징">
                                    <ul class="pagination justify-content-center">
                                        <!-- 이전 페이지 -->
                                        <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                                            <a class="page-link" href="#" onclick="goToPage(${currentPage - 1}); return false;">
                                                <i class="fas fa-chevron-left"></i>
                                            </a>
                                        </li>
                                        
                                        <!-- 페이지 번호 -->
                                        <c:forEach begin="0" end="${totalPages - 1}" var="pageNum">
                                            <c:if test="${pageNum >= currentPage - 2 && pageNum <= currentPage + 2}">
                                                <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                                    <a class="page-link" href="#" onclick="goToPage(${pageNum}); return false;">
                                                        ${pageNum + 1}
                                                    </a>
                                                </li>
                                            </c:if>
                                        </c:forEach>
                                        
                                        <!-- 다음 페이지 -->
                                        <li class="page-item ${currentPage == totalPages - 1 ? 'disabled' : ''}">
                                            <a class="page-link" href="#" onclick="goToPage(${currentPage + 1}); return false;">
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
            let url = '/admin/members';
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
            let url = '/admin/members';
            let params = [];
            
            if ('${param.memberId}' !== '') params.push('memberId=${param.memberId}');
            if ('${param.memberStatus}' !== '') params.push('memberStatus=${param.memberStatus}');
            if ('${param.email}' !== '') params.push('email=${param.email}');
            if ('${param.memberGrade}' !== '') params.push('memberGrade=${param.memberGrade}');
            if ('${param.memberName}' !== '') params.push('memberName=${param.memberName}');
            if ('${param.startDate}' !== '') params.push('startDate=${param.startDate}');
            if ('${param.endDate}' !== '') params.push('endDate=${param.endDate}');
            
            if (params.length > 0) {
                url += '?' + params.join('&');
            }
            
            window.location.href = url;
        }
        
        // 회원 상세 보기
        function viewMember(memberId) {
            window.location.href = '/admin/members/' + memberId;
        }
        
        // 회원 수정
        function editMember(memberId) {
            // TODO: 회원 수정 모달 또는 페이지 구현
            alert('회원 ID: ' + memberId + ' 수정 페이지로 이동합니다.');
        }
        
        // 검색 폼 제출 시 빈 값 제거하고 정렬 조건 유지
        document.getElementById('searchForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            let url = '/admin/members';
            let params = [];
            
            // 검색 조건 수집 (빈 값이 아닌 경우만)
            const memberId = document.querySelector('input[name="memberId"]').value.trim();
            const memberStatus = document.querySelector('select[name="memberStatus"]').value;
            const email = document.querySelector('input[name="email"]').value.trim();
            const memberGrade = document.querySelector('select[name="memberGrade"]').value;
            const memberName = document.querySelector('input[name="memberName"]').value.trim();
            const startDate = document.querySelector('input[name="startDate"]').value;
            const endDate = document.querySelector('input[name="endDate"]').value;
            
            // 회원 ID 유효성 검사
            if (memberId !== '') {
                if (!/^\d+$/.test(memberId)) {
                    alert('회원 ID는 숫자만 입력 가능합니다.');
                    return;
                }
                params.push('memberId=' + encodeURIComponent(memberId));
            }
            if (memberStatus !== '') params.push('memberStatus=' + encodeURIComponent(memberStatus));
            if (email !== '') params.push('email=' + encodeURIComponent(email));
            if (memberGrade !== '') params.push('memberGrade=' + encodeURIComponent(memberGrade));
            if (memberName !== '') params.push('memberName=' + encodeURIComponent(memberName));
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
            
            let url = '/admin/members';
            let params = [];
            
            // 검색 조건 유지
            if ('${param.memberId}' !== '') params.push('memberId=${param.memberId}');
            if ('${param.memberStatus}' !== '') params.push('memberStatus=${param.memberStatus}');
            if ('${param.email}' !== '') params.push('email=${param.email}');
            if ('${param.memberGrade}' !== '') params.push('memberGrade=${param.memberGrade}');
            if ('${param.memberName}' !== '') params.push('memberName=${param.memberName}');
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
            let url = '/admin/members';
            let params = [];
            
            // 현재 URL의 모든 파라미터를 수집
            if ('${param.memberId}' !== '') params.push('memberId=${param.memberId}');
            if ('${param.memberStatus}' !== '') params.push('memberStatus=${param.memberStatus}');
            if ('${param.email}' !== '') params.push('email=${param.email}');
            if ('${param.memberGrade}' !== '') params.push('memberGrade=${param.memberGrade}');
            if ('${param.memberName}' !== '') params.push('memberName=${param.memberName}');
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
