<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>결제 성공 - Online Bookstore</title>
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
        
        .success-card {
            background: white;
            border-radius: 12px;
            padding: 40px;
            text-align: center;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }
        
        .success-icon {
            font-size: 80px;
            margin-bottom: 20px;
            color: #28a745;
        }
        
        .success-title {
            font-size: 28px;
            font-weight: bold;
            color: #333;
            margin-bottom: 15px;
        }
        
        .success-message {
            font-size: 16px;
            color: #666;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        
        .order-info {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 30px;
            text-align: left;
        }
        
        .order-info h3 {
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
            color: #333;
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
        
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
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
            
            .success-card {
                padding: 30px 20px;
            }
            
            .success-title {
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
        <div class="success-card">
            <div class="success-icon">✅</div>
            <h1 class="success-title">결제가 완료되었습니다!</h1>
            <p class="success-message">
                주문이 성공적으로 처리되었습니다.<br>
                주문하신 도서는 2-3일 내에 배송될 예정입니다.
            </p>
            
            <div class="order-info">
                <h3>주문 정보</h3>
                <div class="info-row">
                    <span class="info-label">주문 번호</span>
                    <span class="info-value" id="order-number">처리 중...</span>
                </div>
                <div class="info-row">
                    <span class="info-label">결제 금액</span>
                    <span class="info-value">
                        <fmt:formatNumber value="${amount}" pattern="#,##0"/>원
                    </span>
                </div>
                <div class="info-row">
                    <span class="info-label">결제 일시</span>
                    <span class="info-value">
                        <fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy년 MM월 dd일 HH:mm"/>
                    </span>
                </div>
                <div class="info-row">
                    <span class="info-label">배송 상태</span>
                    <span class="info-value" style="color: #28a745;">주문 확인</span>
                </div>
            </div>
            
            <div class="button-group">
                <a href="/order/history" class="btn btn-primary" onclick="goToOrderHistory()">주문 내역 보기</a>
                <a href="/" class="btn btn-outline">쇼핑 계속하기</a>
            </div>
        </div>
    </div>
    
    <!-- 푸터 -->
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    
    <script>
        // 페이지 로드 시 결제 처리
        document.addEventListener('DOMContentLoaded', function() {
            // URL 파라미터에서 결제 정보 가져오기
            const urlParams = new URLSearchParams(window.location.search);
            const orderId = urlParams.get('orderId');
            const paymentKey = urlParams.get('paymentKey');
            const amount = urlParams.get('amount');
            const recipientName = urlParams.get('recipientName');
            const recipientPhone = urlParams.get('recipientPhone');
            const deliveryAddress = urlParams.get('deliveryAddress');
            const memo = urlParams.get('memo');
            
            if (orderId && paymentKey && amount) {
                // 서버에 결제 완료 처리 요청
                processPayment(orderId, paymentKey, parseInt(amount), recipientName, recipientPhone, deliveryAddress, memo);
            } else {
                console.error('결제 정보가 부족합니다.');
            }
        });
        
        // 결제 처리 함수
        function processPayment(orderId, paymentKey, amount, recipientName, recipientPhone, deliveryAddress, memo) {
            console.log('결제 처리 시작:', {
                orderId: orderId,
                paymentKey: paymentKey,
                amount: amount,
                recipientName: recipientName,
                recipientPhone: recipientPhone,
                deliveryAddress: deliveryAddress,
                memo: memo
            });
            
            // URL 파라미터에서 bookId와 quantity 확인 (직접 구매인지 판단)
            const urlParams = new URLSearchParams(window.location.search);
            const bookId = urlParams.get('bookId');
            const quantity = urlParams.get('quantity');
            
            // API 엔드포인트 결정
            const apiEndpoint = (bookId && quantity) ? '/api/order/direct-payment-success' : '/api/order/payment-success';
            console.log('API 엔드포인트:', apiEndpoint, 'bookId:', bookId, 'quantity:', quantity);
            
            // 요청 데이터 구성
            const requestData = {
                orderId: orderId,
                paymentKey: paymentKey,
                amount: amount,
                recipientName: recipientName,
                recipientPhone: recipientPhone,
                deliveryAddress: deliveryAddress,
                memo: memo
            };
            
            // 직접 구매인 경우 bookId와 quantity 추가
            if (bookId && quantity) {
                requestData.bookId = parseInt(bookId);
                requestData.quantity = parseInt(quantity);
            }
            
            fetch(apiEndpoint, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(requestData)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    console.log('결제 처리 완료:', data);
                    // 주문 번호 업데이트
                    const orderNumberElement = document.getElementById('order-number');
                    if (orderNumberElement) {
                        orderNumberElement.textContent = data.orderId;
                    }
                } else {
                    console.error('결제 처리 실패:', data.message);
                    alert('결제 처리 중 오류가 발생했습니다: ' + data.message);
                }
            })
            .catch(error => {
                console.error('결제 처리 요청 실패:', error);
                alert('결제 처리 중 오류가 발생했습니다.');
            });
        }
        
        // 주문 내역 페이지로 이동 (캐싱 방지)
        function goToOrderHistory() {
            // 캐시를 무시하고 강제로 새로고침
            window.location.href = '/order/history?t=' + new Date().getTime();
        }
    </script>
</body>
</html>
