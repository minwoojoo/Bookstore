<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 페이지 - Online Bookstore</title>
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
        .stat-card {
            background: white;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        .stat-card:hover {
            transform: translateY(-5px);
        }
        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: white;
        }
        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            color: #2c3e50;
        }
        .stat-label {
            color: #7f8c8d;
            font-size: 0.9rem;
        }
        .admin-header {
            background: white;
            padding: 20px 30px;
            border-bottom: 1px solid #e9ecef;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
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
                            <a class="nav-link active" href="/admin">
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
                                <i class="fas fa-tachometer-alt me-2"></i>
                                관리자 대시보드
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
                    
                    <!-- 대시보드 콘텐츠 -->
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
                                <!-- 관리자용 통계 카드 -->
                                <div class="row mb-4">
                            <div class="col-md-3 mb-3">
                                <div class="stat-card">
                                    <div class="d-flex align-items-center">
                                        <div class="stat-icon" style="background: linear-gradient(45deg, #667eea, #764ba2);">
                                            <i class="fas fa-book"></i>
                                        </div>
                                        <div class="ms-3">
                                            <div class="stat-number"><fmt:formatNumber value="${stats.totalBooks}" pattern="#,###"/></div>
                                            <div class="stat-label">총 상품 수</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3 mb-3">
                                <div class="stat-card">
                                    <div class="d-flex align-items-center">
                                        <div class="stat-icon" style="background: linear-gradient(45deg, #f093fb, #f5576c);">
                                            <i class="fas fa-shopping-cart"></i>
                                        </div>
                                        <div class="ms-3">
                                            <div class="stat-number"><fmt:formatNumber value="${stats.totalOrders}" pattern="#,###"/></div>
                                            <div class="stat-label">총 주문 수</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3 mb-3">
                                <div class="stat-card">
                                    <div class="d-flex align-items-center">
                                        <div class="stat-icon" style="background: linear-gradient(45deg, #4facfe, #00f2fe);">
                                            <i class="fas fa-users"></i>
                                        </div>
                                        <div class="ms-3">
                                            <div class="stat-number"><fmt:formatNumber value="${stats.totalMembers}" pattern="#,###"/></div>
                                            <div class="stat-label">총 회원 수</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3 mb-3">
                                <div class="stat-card">
                                    <div class="d-flex align-items-center">
                                        <div class="stat-icon" style="background: linear-gradient(45deg, #43e97b, #38f9d7);">
                                            <i class="fas fa-won-sign"></i>
                                        </div>
                                        <div class="ms-3">
                                            <div class="stat-number">₩<fmt:formatNumber value="${stats.totalSales}" pattern="#,###"/></div>
                                            <div class="stat-label">총 매출</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- 추가 통계 카드 -->
                        <div class="row mb-4">
                            <div class="col-md-3 mb-3">
                                <div class="stat-card">
                                    <div class="d-flex align-items-center">
                                        <div class="stat-icon" style="background: linear-gradient(45deg, #ff9a9e, #fecfef);">
                                            <i class="fas fa-shopping-bag"></i>
                                        </div>
                                        <div class="ms-3">
                                            <div class="stat-number"><fmt:formatNumber value="${stats.todayOrders}" pattern="#,###"/></div>
                                            <div class="stat-label">오늘 주문 수</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3 mb-3">
                                <div class="stat-card">
                                    <div class="d-flex align-items-center">
                                        <div class="stat-icon" style="background: linear-gradient(45deg, #a8edea, #fed6e3);">
                                            <i class="fas fa-won-sign"></i>
                                        </div>
                                        <div class="ms-3">
                                            <div class="stat-number">₩<fmt:formatNumber value="${stats.todaySales}" pattern="#,###"/></div>
                                            <div class="stat-label">오늘 매출</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3 mb-3">
                                <div class="stat-card">
                                    <div class="d-flex align-items-center">
                                        <div class="stat-icon" style="background: linear-gradient(45deg, #ffecd2, #fcb69f);">
                                            <i class="fas fa-exclamation-triangle"></i>
                                        </div>
                                        <div class="ms-3">
                                            <div class="stat-number"><fmt:formatNumber value="${stats.lowStockBooks}" pattern="#,###"/></div>
                                            <div class="stat-label">재고 부족 도서</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3 mb-3">
                                <div class="stat-card">
                                    <div class="d-flex align-items-center">
                                        <div class="stat-icon" style="background: linear-gradient(45deg, #d299c2, #fef9d7);">
                                            <i class="fas fa-user-check"></i>
                                        </div>
                                        <div class="ms-3">
                                            <div class="stat-number"><fmt:formatNumber value="${stats.activeMembers}" pattern="#,###"/></div>
                                            <div class="stat-label">활성 회원</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- 빠른 액션 -->
                        <div class="row">
                            <div class="col-md-6 mb-4">
                                <div class="stat-card">
                                    <h5 class="mb-3">
                                        <i class="fas fa-bolt me-2"></i>
                                        빠른 액션
                                    </h5>
                                    <div class="d-grid gap-2">
                                        <a href="/admin/books/new" class="btn btn-primary">
                                            <i class="fas fa-plus me-2"></i>
                                            새 상품 등록
                                        </a>
                                        <a href="/admin/orders" class="btn btn-outline-primary">
                                            <i class="fas fa-list me-2"></i>
                                            주문 목록 보기
                                        </a>
                                        <a href="/admin/members" class="btn btn-outline-primary">
                                            <i class="fas fa-users me-2"></i>
                                            회원 목록 보기
                                        </a>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6 mb-4">
                                <div class="stat-card">
                                    <h5 class="mb-3">
                                        <i class="fas fa-chart-line me-2"></i>
                                        최근 활동
                                    </h5>
                                    <div class="list-group list-group-flush">
                                        <c:choose>
                                            <c:when test="${not empty recentActivities}">
                                                <c:forEach var="activity" items="${recentActivities}">
                                                    <div class="list-group-item d-flex justify-content-between align-items-center">
                                                        <div>
                                                            <small class="text-muted">
                                                                <c:choose>
                                                                    <c:when test="${activity.activityType == 'ORDER'}">새로운 주문</c:when>
                                                                    <c:when test="${activity.activityType == 'MEMBER'}">새로운 회원</c:when>
                                                                    <c:when test="${activity.activityType == 'STOCK'}">상품 재고 부족</c:when>
                                                                    <c:otherwise>알림</c:otherwise>
                                                                </c:choose>
                                                            </small>
                                                            <div>${activity.message}</div>
                                                        </div>
                                                        <small class="text-muted">
                                                            ${activity.activityTime.year}/${activity.activityTime.monthValue < 10 ? '0' : ''}${activity.activityTime.monthValue}/${activity.activityTime.dayOfMonth < 10 ? '0' : ''}${activity.activityTime.dayOfMonth} ${activity.activityTime.hour < 10 ? '0' : ''}${activity.activityTime.hour}:${activity.activityTime.minute < 10 ? '0' : ''}${activity.activityTime.minute}
                                                        </small>
                                                    </div>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="list-group-item text-center text-muted">
                                                    최근 활동이 없습니다
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
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
