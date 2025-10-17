<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원 상세 정보 - Online Bookstore</title>
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
        .detail-card {
            background: white;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 24px;
        }
        .info-row {
            padding: 12px 0;
            border-bottom: 1px solid #f8f9fa;
        }
        .info-row:last-child {
            border-bottom: none;
        }
        .info-label {
            font-weight: 600;
            color: #495057;
            width: 150px;
        }
        .info-value {
            color: #212529;
        }
        .status-badge {
            font-size: 0.9rem;
            padding: 6px 12px;
        }
        .action-buttons {
            gap: 12px;
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
                                    목록으로
                                </a>
                                <h2 class="mb-0">
                                    <i class="fas fa-user me-2"></i>
                                    회원 상세 정보
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
                        <c:choose>
                            <c:when test="${isUnauthorized == true}">
                                <!-- 권한 없는 사용자에게 보여줄 메시지 -->
                                <div class="row justify-content-center">
                                    <div class="col-md-8">
                                        <div class="alert alert-warning text-center" role="alert">
                                            <h4 class="alert-heading">
                                                <i class="fas fa-exclamation-triangle me-2"></i>
                                                접근 권한이 없습니다
                                            </h4>
                                            <p class="mb-0">이 페이지는 관리자 계정으로만 접근할 수 있습니다.</p>
                                            <hr>
                                            <p class="mb-0">
                                                <a href="/" class="btn btn-primary">메인 페이지로 이동</a>
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <!-- 회원 기본 정보 -->
                                <div class="detail-card">
                                    <h5 class="mb-4">
                                        <i class="fas fa-user me-2"></i>
                                        기본 정보
                                    </h5>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="info-row d-flex">
                                                <div class="info-label">회원 ID</div>
                                                <div class="info-value">${member.memberId}</div>
                                            </div>
                                            <div class="info-row d-flex">
                                                <div class="info-label">회원 이름</div>
                                                <div class="info-value">${member.memberName}</div>
                                            </div>
                                            <div class="info-row d-flex">
                                                <div class="info-label">이메일</div>
                                                <div class="info-value">${member.email}</div>
                                            </div>
                                            <div class="info-row d-flex">
                                                <div class="info-label">전화번호</div>
                                                <div class="info-value">${member.phone}</div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="info-row d-flex">
                                                <div class="info-label">회원 등급</div>
                                                <div class="info-value">
                                                    <span class="badge bg-${member.memberGrade == 'GOLD' ? 'warning' : member.memberGrade == 'SILVER' ? 'secondary' : 'success'} status-badge">
                                                        ${member.memberGrade}
                                                    </span>
                                                </div>
                                            </div>
                                            <div class="info-row d-flex">
                                                <div class="info-label">가입 상태</div>
                                                <div class="info-value">
                                                    <span class="badge status-badge bg-${member.memberStatus == 'ACTIVE' ? 'success' : member.memberStatus == 'INACTIVE' ? 'secondary' : member.memberStatus == 'SUSPENDED' ? 'warning' : 'danger'}">
                                                        ${member.memberStatus == 'ACTIVE' ? '활성' : member.memberStatus == 'INACTIVE' ? '비활성' : member.memberStatus == 'SUSPENDED' ? '휴면' : '탈퇴'}
                                                    </span>
                                                </div>
                                            </div>
                                            <div class="info-row d-flex">
                                                <div class="info-label">가입일</div>
                                                <div class="info-value">${member.createdAt}</div>
                                            </div>
                                            <div class="info-row d-flex">
                                                <div class="info-label">최종 접속일</div>
                                                <div class="info-value">
                                                    <c:choose>
                                                        <c:when test="${member.lastLoginAt != null && member.lastLoginAt != ''}">
                                                            ${member.lastLoginAt}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">접속 기록 없음</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- 주소 정보 -->
                                <div class="detail-card">
                                    <h5 class="mb-4">
                                        <i class="fas fa-map-marker-alt me-2"></i>
                                        주소 정보
                                    </h5>
                                    <c:choose>
                                        <c:when test="${not empty member.addresses}">
                                            <c:forEach var="address" items="${member.addresses}" varStatus="status">
                                                <div class="info-row">
                                                    <div class="d-flex justify-content-between align-items-start">
                                                        <div>
                                                            <strong>주소 ${status.index + 1}</strong>
                                                            <div class="mt-2">
                                                                <div>${address.addressBasic}</div>
                                                                <div class="text-muted small">${address.addressDetail}</div>
                                                                <div class="text-muted small">우편번호: ${address.postCode}</div>
                                                            </div>
                                                        </div>
                                                        <c:if test="${address.isDefault}">
                                                            <span class="badge bg-primary">기본 주소</span>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="text-center text-muted py-3">
                                                <i class="fas fa-map-marker-alt fa-2x mb-2"></i>
                                                <div>등록된 주소가 없습니다.</div>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                
                                <!-- 통계 정보 -->
                                <div class="detail-card">
                                    <h5 class="mb-4">
                                        <i class="fas fa-chart-bar me-2"></i>
                                        통계 정보
                                    </h5>
                                    <div class="row">
                                        <div class="col-md-3">
                                            <div class="text-center">
                                                <div class="h4 text-primary">${member.totalOrders}</div>
                                                <div class="text-muted">총 주문 수</div>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="text-center">
                                                <div class="h4 text-success">₩<fmt:formatNumber value="${member.totalAmount}" pattern="#,###"/></div>
                                                <div class="text-muted">총 구매 금액</div>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="text-center">
                                                <div class="h4 text-info">${member.totalReviews}</div>
                                                <div class="text-muted">총 리뷰 수</div>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="text-center">
                                                <div class="h4 text-warning">
                                                    <c:choose>
                                                        <c:when test="${member.averageRating > 0}">
                                                            <fmt:formatNumber value="${member.averageRating}" pattern="#.#"/>★
                                                        </c:when>
                                                        <c:otherwise>0.0★</c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="text-muted">평균 평점</div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- 추가 통계 정보 -->
                                    <div class="row mt-4">
                                        <div class="col-md-6">
                                            <div class="text-center">
                                                <div class="h6 text-secondary">
                                                    <c:choose>
                                                        <c:when test="${member.lastOrderDate != null && member.lastOrderDate != ''}">
                                                            최근 주문: ${member.lastOrderDate}
                                                        </c:when>
                                                        <c:otherwise>
                                                            최근 주문: 없음
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="text-center">
                                                <div class="h6 text-secondary">
                                                    <c:choose>
                                                        <c:when test="${member.lastReviewDate != null && member.lastReviewDate != ''}">
                                                            최근 리뷰: ${member.lastReviewDate}
                                                        </c:when>
                                                        <c:otherwise>
                                                            최근 리뷰: 없음
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- 액션 버튼 -->
                                <div class="detail-card">
                                    <h5 class="mb-4">
                                        <i class="fas fa-cogs me-2"></i>
                                        관리 액션
                                    </h5>
                                    <div class="d-flex action-buttons">
                                        <a href="/admin/members/${member.memberId}/orders" class="btn btn-primary">
                                            <i class="fas fa-shopping-cart me-2"></i>
                                            주문 내역 보기
                                        </a>
                                    </div>
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
        // 페이지 로드 시 권한 없음 팝업 표시
        document.addEventListener('DOMContentLoaded', function() {
            <c:if test="${showAlert == true}">
                alert('${errorMessage}');
            </c:if>
        });
    </script>
</body>
</html>
