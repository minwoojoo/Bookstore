<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>토스페이먼츠 결제 - Online Bookstore</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            background: #f5f5f5;
            min-height: 100vh;
        }
        
        /* 메인 컨텐츠 */
        .main-container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .page-title {
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 3px solid #0066cc;
        }
        
        /* 토스페이먼츠 스타일 */
        .hero.toss-checkout-page {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 0;
        }
        
        .container {
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .page-header {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
            padding: 20px 0;
        }
        
        .back-btn {
            background: rgba(255, 255, 255, 0.2);
            border: none;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            margin-right: 15px;
            transition: all 0.3s;
        }
        
        .back-btn:hover {
            background: rgba(255, 255, 255, 0.3);
        }
        
        .back-btn svg {
            color: white;
        }
        
        .page-title {
            color: white;
            font-size: 24px;
            font-weight: bold;
            margin: 0;
            padding: 0;
            border: none;
        }
        
        .payment-amount {
            background: white;
            border-radius: 12px;
            padding: 30px;
            margin-bottom: 20px;
            text-align: center;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }
        
        .amount-title {
            font-size: 18px;
            color: #666;
            margin-bottom: 15px;
        }
        
        .amount-display {
            font-size: 36px;
            font-weight: bold;
            color: #333;
        }
        
        .amount-value {
            color: #0066cc;
        }
        
        .payment-section {
            background: white;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .payment-section h3 {
            font-size: 18px;
            margin-bottom: 20px;
            color: #333;
            padding-bottom: 10px;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .payment-button {
            width: 100%;
            background: #0066cc;
            color: white;
            border: none;
            border-radius: 12px;
            padding: 20px;
            font-size: 18px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 20px;
        }
        
        .payment-button:hover {
            background: #0052a3;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.3);
        }
        
        .payment-button:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }
        
        /* 로딩 스피너 */
        .loading {
            display: none;
            text-align: center;
            padding: 20px;
        }
        
        .spinner {
            border: 4px solid #f3f3f3;
            border-top: 4px solid #0066cc;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            animation: spin 1s linear infinite;
            margin: 0 auto 10px;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
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
            .container {
                padding: 15px;
            }
            
            .page-title {
                font-size: 20px;
            }
            
            .amount-display {
                font-size: 28px;
            }
            
            .payment-section {
                padding: 20px;
            }
        }
    </style>
</head>
<body>
    <main class="hero toss-checkout-page">
        <div class="container">
            <!-- 페이지 헤더 -->
            <div class="page-header">
                <button class="back-btn" onclick="history.back()">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                        <path d="M15 18L9 12L15 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                </button>
                <h1 class="page-title">토스페이먼츠 결제</h1>
            </div>

            <!-- 토스페이먼츠 SDK -->
            <script src="https://js.tosspayments.com/v2/standard"></script>

            <!-- 결제 금액 표시 -->
            <div class="payment-amount">
                <h2 class="amount-title">결제 금액</h2>
                <div class="amount-display">
                    <span class="amount-value" id="finalAmount">
                        <c:if test="${not empty totalAmount}">
                            <fmt:formatNumber value="${totalAmount}" type="currency" currencySymbol="₩"/>
                        </c:if>
                        <c:if test="${empty totalAmount}">
                            0원
                        </c:if>
                    </span>
                </div>
            </div>

            <!-- 결제 UI -->
            <div class="payment-section">
                <h3>결제 수단</h3>
                <div id="payment-method"></div>
            </div>

            <!-- 이용약관 UI -->
            <div class="payment-section">
                <h3>이용약관</h3>
                <div id="agreement"></div>
            </div>

            <!-- 로딩 스피너 -->
            <div class="loading" id="loading">
                <div class="spinner"></div>
                <p>결제를 처리하고 있습니다...</p>
            </div>

            <!-- 결제하기 버튼 -->
            <button class="payment-button" id="payment-button">
                결제하기
            </button>
        </div>
    </main>
    
    <!-- 푸터 -->
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    
    <script>
        // 페이지 로드 완료 후 토스페이먼츠 초기화
        document.addEventListener('DOMContentLoaded', function() {
            // 토스페이먼츠 SDK가 로드될 때까지 대기
            if (typeof TossPayments === 'undefined') {
                console.error('토스페이먼츠 SDK가 로드되지 않았습니다.');
                return;
            }
            
            // 1초 지연 후 초기화 (API 요청 분산)
            setTimeout(() => {
                main();
            }, 1000);
        });

        async function main() {
            try {
                console.log('토스페이먼츠 초기화 시작');
                
                // 토스페이먼츠 SDK 초기화
                const clientKey = 'test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm'; // 테스트 키
                const tossPayments = TossPayments(clientKey);
                
                // 결제 금액
                const amount = ${totalAmount != null ? totalAmount : 0};
                console.log('결제 금액:', amount);
                
                // URL 파라미터에서 배송지 정보와 메모 가져오기
                const urlParams = new URLSearchParams(window.location.search);
                const recipientName = urlParams.get('recipientName') || '';
                const recipientPhoneRaw = urlParams.get('recipientPhone') || '';
                // 토스페이먼츠용 전화번호 (하이픈 제거)
                const recipientPhone = recipientPhoneRaw.replace(/[^0-9]/g, '');
                const deliveryAddress = urlParams.get('deliveryAddress') || '';
                const memo = urlParams.get('memo') || '';
                
                console.log('원본 전화번호:', recipientPhoneRaw);
                console.log('정리된 전화번호:', recipientPhone);
                
                // 전화번호 유효성 검사
                if (recipientPhone && recipientPhone.length < 10) {
                    console.warn('전화번호가 너무 짧습니다:', recipientPhone);
                }
                
                // 고객 키 생성 (회원 ID 기반, 영문/숫자만 사용)
                const userName = '${userName}' || '';
                const customerKey = userName ? 'customer_' + '${userId}' + '_' + Date.now() : TossPayments.ANONYMOUS;
                console.log('고객 키:', customerKey);
                
                // 결제위젯 인스턴스 생성
                const widgets = tossPayments.widgets({
                    customerKey: customerKey
                });
                
                // 주문의 결제 금액 설정
                await widgets.setAmount({
                    currency: 'KRW',
                    value: amount
                });
                console.log('결제 금액 설정 완료');
                
                // 결제 UI와 이용약관 UI 렌더링
                console.log('위젯 렌더링 시작');
                await Promise.all([
                    widgets.renderPaymentMethods({
                        selector: '#payment-method',
                        variantKey: 'DEFAULT'
                    }),
                    widgets.renderAgreement({
                        selector: '#agreement',
                        variantKey: 'AGREEMENT'
                    })
                ]);
                console.log('위젯 렌더링 완료');
                
                // 결제하기 버튼 클릭 이벤트
                document.getElementById('payment-button').addEventListener('click', async function() {
                    try {
                        console.log('결제 버튼 클릭됨');
                        
                        // 로딩 표시
                        document.getElementById('loading').style.display = 'block';
                        document.getElementById('payment-button').disabled = true;
                        
                        // 주문 ID 생성
                        const orderId = generateOrderId();
                        const successUrl = window.location.origin + '/order/payment/success?orderId=' + orderId + 
                                         '&amount=' + amount +
                                         '&recipientName=' + encodeURIComponent(recipientName) +
                                         '&recipientPhone=' + encodeURIComponent(recipientPhone) +
                                         '&deliveryAddress=' + encodeURIComponent(deliveryAddress) +
                                         '&memo=' + encodeURIComponent(memo);
                        
                        console.log('결제 요청 시작:', {
                            orderId: orderId,
                            successUrl: successUrl
                        });
                        
                        // 결제 요청
                        await widgets.requestPayment({
                            orderId: orderId,
                            orderName: '온라인 서점 도서 구매',
                            successUrl: successUrl,
                            failUrl: window.location.origin + '/order/payment/fail',
                            customerEmail: '${userId}@bookstore.com',
                            customerName: recipientName || '고객',
                            customerMobilePhone: recipientPhone || '01012345678'
                        });
                    } catch (error) {
                        console.error('결제 요청 실패:', error);
                        alert('결제 요청에 실패했습니다: ' + error.message);
                        
                        // 로딩 숨김
                        document.getElementById('loading').style.display = 'none';
                        document.getElementById('payment-button').disabled = false;
                    }
                });
                
            } catch (error) {
                console.error('토스페이먼츠 초기화 실패:', error);
                
                // 429 에러 (요청 한도 초과) 특별 처리
                if (error.message && error.message.includes('요청량이 초과')) {
                    alert('일시적으로 요청이 많습니다. 10-15분 후 다시 시도해주세요.');
                } else {
                    alert('결제 시스템 초기화에 실패했습니다: ' + error.message);
                }
            }
        }
        
        // 주문 ID 생성
        function generateOrderId() {
            const timestamp = Date.now();
            const random = Math.random().toString(36).substring(2, 8);
            return 'ORDER_' + timestamp + '_' + random;
        }
    </script>
</body>
</html>
