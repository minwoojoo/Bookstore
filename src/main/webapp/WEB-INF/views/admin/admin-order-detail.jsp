<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>주문 상세보기 - Online Bookstore</title>
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
        .order-detail-card {
            background: white;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 24px;
        }
        .order-status {
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 500;
        }
        .status-pending { background: #fff3cd; color: #856404; }
        .status-confirmed { background: #d1ecf1; color: #0c5460; }
        .status-shipping { background: #d4edda; color: #155724; }
        .status-delivered { background: #cce5ff; color: #004085; }
        .status-cancelled { background: #f8d7da; color: #721c24; }
        .order-item {
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 16px;
            margin-bottom: 12px;
            background: #f8f9fa;
        }
        .status-change-card {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 8px;
            padding: 16px;
            margin-top: 20px;
        }
        .timeline {
            position: relative;
            padding-left: 30px;
        }
        .timeline::before {
            content: '';
            position: absolute;
            left: 15px;
            top: 0;
            bottom: 0;
            width: 2px;
            background: #dee2e6;
        }
        .timeline-item {
            position: relative;
            margin-bottom: 20px;
        }
        .timeline-item::before {
            content: '';
            position: absolute;
            left: -22px;
            top: 5px;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: #007bff;
            border: 3px solid white;
            box-shadow: 0 0 0 2px #dee2e6;
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
                            <div>
                                <h2 class="mb-0">
                                    <i class="fas fa-shopping-cart me-2"></i>
                                    주문 상세보기
                                </h2>
                                <nav aria-label="breadcrumb" class="mt-2">
                                    <ol class="breadcrumb">
                                        <li class="breadcrumb-item"><a href="/admin">관리자</a></li>
                                        <li class="breadcrumb-item"><a href="/admin/orders">주문 관리</a></li>
                                        <li class="breadcrumb-item active">주문 #${order.orderId}</li>
                                    </ol>
                                </nav>
                            </div>
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
                        <c:choose>
                            <c:when test="${not empty order}">
                                <!-- 주문 기본 정보 -->
                                <div class="order-detail-card">
                                    <div class="row">
                                        <div class="col-md-8">
                                            <div class="d-flex justify-content-between align-items-start mb-3">
                                                <div>
                                                    <h4 class="mb-1">주문 #${order.orderId}</h4>
                                                    <p class="text-muted mb-0">
                                                        <i class="fas fa-user me-1"></i>
                                                        ${order.memberName} (${order.memberEmail})
                                                    </p>
                                                    <p class="text-muted mb-0">
                                                        <i class="fas fa-calendar me-1"></i>
                                                        주문일: ${order.orderDate}
                                                    </p>
                                                </div>
                                                <div class="text-end">
                                                    <span class="order-status status-${order.orderStatus.toLowerCase()}">
                                                        ${order.orderStatus}
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="text-end">
                                                <div class="h4 text-primary mb-0">
                                                    <fmt:formatNumber value="${order.finalPaymentAmount}" pattern="#,##0"/>원
                                                </div>
                                                <div class="text-muted small">최종 결제금액</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- 주문 상품 목록 -->
                                <div class="order-detail-card">
                                    <h5 class="mb-3">
                                        <i class="fas fa-book me-2"></i>
                                        주문 상품 (${order.orderItems.size()}개)
                                    </h5>
                                    <c:forEach var="item" items="${order.orderItems}" varStatus="status">
                                        <div class="order-item">
                                            <div class="row">
                                                <div class="col-md-8">
                                                    <h6 class="mb-1">${item.bookTitle}</h6>
                                                    <p class="text-muted mb-1">${item.bookAuthor} | ${item.publisher}</p>
                                                    <div class="d-flex gap-3">
                                                        <span class="badge bg-light text-dark">수량: ${item.quantity}권</span>
                                                        <span class="badge bg-light text-dark">단가: <fmt:formatNumber value="${item.price}" pattern="#,##0"/>원</span>
                                                    </div>
                                                </div>
                                                <div class="col-md-4 text-end">
                                                    <div class="h6 mb-0">
                                                        <fmt:formatNumber value="${item.totalPrice}" pattern="#,##0"/>원
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>

                                <!-- 배송 정보 -->
                                <div class="order-detail-card">
                                    <h5 class="mb-3">
                                        <i class="fas fa-truck me-2"></i>
                                        배송 정보
                                    </h5>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label class="form-label fw-bold">수령인</label>
                                                <p class="mb-0">${order.recipientName}</p>
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label fw-bold">연락처</label>
                                                <p class="mb-0">${order.recipientPhone}</p>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label class="form-label fw-bold">배송 주소</label>
                                                <p class="mb-0">${order.deliveryAddress}</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- 결제 정보 -->
                                <div class="order-detail-card">
                                    <h5 class="mb-3">
                                        <i class="fas fa-credit-card me-2"></i>
                                        결제 정보
                                    </h5>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="d-flex justify-content-between mb-2">
                                                <span>주문금액:</span>
                                                <span><fmt:formatNumber value="${order.totalAmount}" pattern="#,##0"/>원</span>
                                            </div>
                                            <c:if test="${order.discountAmount > 0}">
                                                <div class="d-flex justify-content-between mb-2">
                                                    <span>할인금액:</span>
                                                    <span class="text-danger">-<fmt:formatNumber value="${order.discountAmount}" pattern="#,##0"/>원</span>
                                                </div>
                                            </c:if>
                                            <div class="d-flex justify-content-between mb-2">
                                                <span>배송비:</span>
                                                <span><fmt:formatNumber value="${order.deliveryFee}" pattern="#,##0"/>원</span>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="d-flex justify-content-between fw-bold h5">
                                                <span>최종결제금액:</span>
                                                <span class="text-primary"><fmt:formatNumber value="${order.finalPaymentAmount}" pattern="#,##0"/>원</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- 주문 상태 변경 -->
                                <div class="status-change-card">
                                    <h5 class="mb-3">
                                        <i class="fas fa-cog me-2"></i>
                                        주문 상태 관리
                                    </h5>
                                    <div class="row">
                                        <div class="col-md-8">
                                            <p class="mb-3">현재 상태: <strong>${order.orderStatus}</strong></p>
                                            <c:if test="${order.orderStatus == 'PENDING' || order.orderStatus == 'CONFIRMED' || order.orderStatus == 'SHIPPING'}">
                                                <form method="post" action="/admin/orders/${order.orderId}/status" class="d-inline">
                                                    <div class="d-flex gap-2">
                                                        <select name="status" class="form-select" style="width: auto;">
                                                            <option value="">상태 선택</option>
                                                            <c:if test="${order.orderStatus == 'PENDING'}">
                                                                <option value="CONFIRMED">주문확인</option>
                                                                <option value="CANCELLED">주문취소</option>
                                                            </c:if>
                                                            <c:if test="${order.orderStatus == 'CONFIRMED'}">
                                                                <option value="SHIPPING">배송중</option>
                                                                <option value="CANCELLED">주문취소</option>
                                                            </c:if>
                                                            <c:if test="${order.orderStatus == 'SHIPPING'}">
                                                                <option value="DELIVERED">배송완료</option>
                                                            </c:if>
                                                        </select>
                                                        <button type="submit" class="btn btn-primary" onclick="return confirm('주문 상태를 변경하시겠습니까?')">
                                                            <i class="fas fa-save me-1"></i>
                                                            상태 변경
                                                        </button>
                                                    </div>
                                                </form>
                                            </c:if>
                                            <c:if test="${order.orderStatus == 'DELIVERED' || order.orderStatus == 'CANCELLED'}">
                                                <p class="text-muted">이 주문은 더 이상 상태를 변경할 수 없습니다.</p>
                                            </c:if>
                                        </div>
                                        <div class="col-md-4 text-end">
                                            <a href="/admin/orders" class="btn btn-outline-secondary">
                                                <i class="fas fa-arrow-left me-1"></i>
                                                목록으로
                                            </a>
                                        </div>
                                    </div>
                                </div>

                                <!-- 주문 이력 (타임라인) -->
                                <div class="order-detail-card">
                                    <h5 class="mb-3">
                                        <i class="fas fa-history me-2"></i>
                                        주문 이력
                                    </h5>
                                    <div class="timeline">
                                        <div class="timeline-item">
                                            <div class="d-flex justify-content-between">
                                                <div>
                                                    <h6 class="mb-1">주문 접수</h6>
                                                    <p class="text-muted mb-0">${order.orderDate}</p>
                                                </div>
                                                <span class="badge bg-primary">완료</span>
                                            </div>
                                        </div>
                                        <c:if test="${order.orderStatus != 'PENDING' && order.orderStatus != 'CANCELLED'}">
                                            <div class="timeline-item">
                                                <div class="d-flex justify-content-between">
                                                    <div>
                                                        <h6 class="mb-1">주문 확인</h6>
                                                        <p class="text-muted mb-0">관리자 확인 완료</p>
                                                    </div>
                                                    <span class="badge bg-success">완료</span>
                                                </div>
                                            </div>
                                        </c:if>
                                        <c:if test="${order.orderStatus == 'SHIPPING' || order.orderStatus == 'DELIVERED'}">
                                            <div class="timeline-item">
                                                <div class="d-flex justify-content-between">
                                                    <div>
                                                        <h6 class="mb-1">배송 중</h6>
                                                        <p class="text-muted mb-0">상품이 배송 중입니다</p>
                                                    </div>
                                                    <span class="badge bg-info">진행중</span>
                                                </div>
                                            </div>
                                        </c:if>
                                        <c:if test="${order.orderStatus == 'DELIVERED'}">
                                            <div class="timeline-item">
                                                <div class="d-flex justify-content-between">
                                                    <div>
                                                        <h6 class="mb-1">배송 완료</h6>
                                                        <p class="text-muted mb-0">고객에게 전달 완료</p>
                                                    </div>
                                                    <span class="badge bg-success">완료</span>
                                                </div>
                                            </div>
                                        </c:if>
                                        <c:if test="${order.orderStatus == 'CANCELLED'}">
                                            <div class="timeline-item">
                                                <div class="d-flex justify-content-between">
                                                    <div>
                                                        <h6 class="mb-1">주문 취소</h6>
                                                        <p class="text-muted mb-0">주문이 취소되었습니다</p>
                                                    </div>
                                                    <span class="badge bg-danger">취소</span>
                                                </div>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-5">
                                    <i class="fas fa-exclamation-triangle fa-3x text-warning mb-3"></i>
                                    <h4 class="text-muted">주문을 찾을 수 없습니다</h4>
                                    <p class="text-muted">요청하신 주문 정보가 존재하지 않습니다.</p>
                                    <a href="/admin/orders" class="btn btn-primary">
                                        <i class="fas fa-arrow-left me-1"></i>
                                        주문 목록으로
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
