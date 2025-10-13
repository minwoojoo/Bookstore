<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>결제 실패 - Online Bookstore</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            background: #f5f5f5;
            min-height: 100vh;
        }
        
        /* 메인 컨텐츠 */
        .main-container {
            max-width: 600px;
            margin: 50px auto;
            padding: 0 20px;
        }
        
        .fail-card {
            background: white;
            border-radius: 12px;
            padding: 40px;
            text-align: center;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }
        
        .fail-icon {
            font-size: 80px;
            margin-bottom: 20px;
            color: #dc3545;
        }
        
        .fail-title {
            font-size: 28px;
            font-weight: bold;
            color: #333;
            margin-bottom: 15px;
        }
        
        .fail-message {
            font-size: 16px;
            color: #666;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        
        .error-info {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 30px;
            text-align: left;
        }
        
        .error-info h3 {
            font-size: 18px;
            margin-bottom: 15px;
            color: #333;
        }
        
        .info-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            font-size: 14px;
        }
        
        .info-label {
            color: #666;
        }
        
        .info-value {
            font-weight: bold;
            color: #dc3545;
        }
        
        .button-group {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s;
        }
        
        .btn-primary {
            background: #0066cc;
            color: white;
        }
        
        .btn-primary:hover {
            background: #0052a3;
        }
        
        .btn-outline {
            background: transparent;
            color: #0066cc;
            border: 2px solid #0066cc;
        }
        
        .btn-outline:hover {
            background: #0066cc;
            color: white;
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
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
        
        /* 반응형 */
        @media (max-width: 768px) {
            .main-container {
                margin: 20px auto;
            }
            
            .fail-card {
                padding: 30px 20px;
            }
            
            .fail-title {
                font-size: 24px;
            }
            
            .button-group {
                flex-direction: column;
                align-items: center;
            }
            
            .btn {
                width: 100%;
                max-width: 200px;
            }
        }
    </style>
</head>
<body>
    <!-- 헤더 -->
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <!-- 메인 컨텐츠 -->
    <div class="main-container">
        <div class="fail-card">
            <div class="fail-icon">❌</div>
            <h1 class="fail-title">결제에 실패했습니다</h1>
            <p class="fail-message">
                결제 처리 중 오류가 발생했습니다.<br>
                다시 시도하시거나 다른 결제 수단을 이용해주세요.
            </p>
            
            <c:if test="${not empty errorCode or not empty errorMessage}">
                <div class="error-info">
                    <h3>오류 정보</h3>
                    <c:if test="${not empty errorCode}">
                        <div class="info-row">
                            <span class="info-label">오류 코드</span>
                            <span class="info-value">${errorCode}</span>
                        </div>
                    </c:if>
                    <c:if test="${not empty errorMessage}">
                        <div class="info-row">
                            <span class="info-label">오류 메시지</span>
                            <span class="info-value">${errorMessage}</span>
                        </div>
                    </c:if>
                </div>
            </c:if>
            
            <div class="button-group">
                <a href="/order/checkout" class="btn btn-primary">다시 결제하기</a>
                <a href="/cart" class="btn btn-outline">장바구니로 돌아가기</a>
                <a href="/" class="btn btn-secondary">홈으로 가기</a>
            </div>
        </div>
    </div>
    
    <!-- 푸터 -->
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>
