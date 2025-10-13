package com.bookstore.bookstore.controller.order;

import com.bookstore.bookstore.dto.order.CartItemResponse;
import com.bookstore.bookstore.dto.order.OrderHistoryResponse;
import com.bookstore.bookstore.entity.order.Order;
import com.bookstore.bookstore.security.CustomUserDetails;
import com.bookstore.bookstore.service.order.CartService;
import com.bookstore.bookstore.service.order.OrderService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 주문 관련 REST API 컨트롤러
 */
@Slf4j
@RestController
@RequestMapping("/api/order")
@RequiredArgsConstructor
public class OrderController {
    
    private final CartService cartService;
    private final OrderService orderService;
    
    /**
     * 장바구니 아이템 조회 API
     * GET /api/order/cart-items
     */
    @GetMapping("/cart-items")
    public ResponseEntity<?> getCartItems(@AuthenticationPrincipal CustomUserDetails userDetails) {
        if (userDetails == null) {
            return ResponseEntity.status(401).body(Map.of("success", false, "message", "로그인이 필요합니다."));
        }
        
        try {
            List<CartItemResponse> cartItems = cartService.getCartItems(userDetails.getMemberId());
            
            // 총 금액 계산
            Integer totalAmount = cartItems.stream()
                    .mapToInt(item -> item.getSubtotal().intValue())
                    .sum();
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("cartItems", cartItems);
            response.put("totalAmount", totalAmount);
            
            log.info("장바구니 아이템 조회 완료: 사용자={}, 아이템 수={}, 총 금액={}", 
                    userDetails.getUsername(), cartItems.size(), totalAmount);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("장바구니 아이템 조회 실패: {}", e.getMessage(), e);
            return ResponseEntity.status(500).body(Map.of("success", false, "message", "장바구니 조회에 실패했습니다."));
        }
    }
    
    /**
     * 결제 처리 API
     * POST /api/order/payment
     */
    @PostMapping("/payment")
    public ResponseEntity<?> processPayment(
            @RequestParam("orderId") String orderId,
            @RequestParam("paymentKey") String paymentKey,
            @RequestParam("amount") Integer amount,
            @RequestParam(value = "recipientName", required = false) String recipientName,
            @RequestParam(value = "recipientPhone", required = false) String recipientPhone,
            @RequestParam(value = "deliveryAddress", required = false) String deliveryAddress,
            @RequestParam(value = "memo", required = false) String memo,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        
        if (userDetails == null) {
            return ResponseEntity.status(401).body(Map.of("success", false, "message", "로그인이 필요합니다."));
        }
        
        try {
            log.info("결제 처리 요청: 사용자={}, 주문ID={}, 결제키={}, 금액={}", 
                    userDetails.getUsername(), orderId, paymentKey, amount);
            
            // 주문 생성 및 결제 처리
            Long orderIdLong = orderService.processPaymentSuccess(
                    userDetails.getMemberId(), 
                    orderId, 
                    paymentKey, 
                    amount,
                    recipientName,
                    recipientPhone,
                    deliveryAddress,
                    memo
            );
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("orderId", orderIdLong);
            response.put("message", "결제가 성공적으로 완료되었습니다.");
            
            log.info("결제 처리 완료: 주문ID={}", orderIdLong);
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            log.error("결제 처리 실패: {}", e.getMessage(), e);
            return ResponseEntity.status(500).body(Map.of("success", false, "message", "결제 처리 중 오류가 발생했습니다."));
        }
    }
    
    /**
     * 주문 목록 조회 API
     * GET /api/order/list
     */
    @GetMapping("/list")
    public ResponseEntity<?> getOrderList(@AuthenticationPrincipal CustomUserDetails userDetails) {
        if (userDetails == null) {
            return ResponseEntity.status(401).body(Map.of("success", false, "message", "로그인이 필요합니다."));
        }
        
        try {
            List<Order> orders = orderService.getOrdersByUserId(userDetails.getMemberId());
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("orders", orders);
            
            log.info("주문 목록 조회 완료: 사용자={}, 주문 수={}", 
                    userDetails.getUsername(), orders.size());
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("주문 목록 조회 실패: {}", e.getMessage(), e);
            return ResponseEntity.status(500).body(Map.of("success", false, "message", "주문 목록 조회에 실패했습니다."));
        }
    }
    
    /**
     * 주문 내역 조회 API
     * GET /api/order/history
     */
    @GetMapping("/history")
    public ResponseEntity<?> getOrderHistory(@AuthenticationPrincipal CustomUserDetails userDetails) {
        log.info("주문 내역 조회 요청: 사용자={}", userDetails != null ? userDetails.getUsername() : "비로그인");
        
        if (userDetails == null) {
            return ResponseEntity.status(401).body(Map.of("success", false, "message", "로그인이 필요합니다."));
        }
        
        try {
            List<OrderHistoryResponse> orderHistory = orderService.getOrderHistory(userDetails.getMemberId());
            return ResponseEntity.ok(Map.of("success", true, "orders", orderHistory));
        } catch (Exception e) {
            log.error("주문 내역 조회 실패: {}", e.getMessage(), e);
            return ResponseEntity.status(500).body(Map.of("success", false, "message", "주문 내역 조회에 실패했습니다."));
        }
    }
    
    /**
     * 주문 상세 조회 API (개선된 버전)
     * GET /api/order/{orderId}/detail
     */
    @GetMapping("/{orderId}/detail")
    public ResponseEntity<?> getOrderDetail(@PathVariable Long orderId, @AuthenticationPrincipal CustomUserDetails userDetails) {
        log.info("주문 상세 조회 요청: 주문ID={}, 사용자={}", orderId, userDetails != null ? userDetails.getUsername() : "비로그인");
        
        if (userDetails == null) {
            return ResponseEntity.status(401).body(Map.of("success", false, "message", "로그인이 필요합니다."));
        }
        
        try {
            OrderHistoryResponse orderDetail = orderService.getOrderDetail(orderId, userDetails.getMemberId());
            return ResponseEntity.ok(Map.of("success", true, "order", orderDetail));
        } catch (Exception e) {
            log.error("주문 상세 조회 실패: {}", e.getMessage(), e);
            return ResponseEntity.status(500).body(Map.of("success", false, "message", "주문 상세 조회에 실패했습니다."));
        }
    }
    
    /**
     * 결제 성공 처리 API
     * POST /api/order/payment-success
     */
    @PostMapping("/payment-success")
    public ResponseEntity<?> processPaymentSuccess(
            @RequestBody Map<String, Object> paymentData,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        
        log.info("결제 성공 처리 요청: 사용자={}, 데이터={}", 
                userDetails != null ? userDetails.getUsername() : "비로그인", paymentData);
        
        if (userDetails == null) {
            return ResponseEntity.status(401).body(Map.of("success", false, "message", "로그인이 필요합니다."));
        }
        
        try {
            String orderId = (String) paymentData.get("orderId");
            String paymentKey = (String) paymentData.get("paymentKey");
            Integer amount = (Integer) paymentData.get("amount");
            String recipientName = (String) paymentData.get("recipientName");
            String recipientPhone = (String) paymentData.get("recipientPhone");
            String deliveryAddress = (String) paymentData.get("deliveryAddress");
            String memo = (String) paymentData.get("memo");
            
            Long savedOrderId = orderService.processPaymentSuccess(
                    userDetails.getMemberId(),
                    orderId,
                    paymentKey,
                    amount,
                    recipientName,
                    recipientPhone,
                    deliveryAddress,
                    memo
            );
            
            // 주문 상태를 'CONFIRMED' (결제완료)로 업데이트
            orderService.updateOrderStatus(savedOrderId, "CONFIRMED");
            
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "orderId", savedOrderId,
                    "message", "결제가 성공적으로 처리되었습니다."
            ));
        } catch (Exception e) {
            log.error("결제 성공 처리 실패: {}", e.getMessage(), e);
            return ResponseEntity.status(500).body(Map.of(
                    "success", false,
                    "message", "결제 처리 중 오류가 발생했습니다: " + e.getMessage()
            ));
        }
    }
    
    /**
     * 주문 취소
     */
    @PostMapping("/{orderId}/cancel")
    public ResponseEntity<Map<String, Object>> cancelOrder(
            @PathVariable Long orderId,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        
        if (userDetails == null) {
            return ResponseEntity.status(401).body(Map.of(
                    "success", false,
                    "message", "로그인이 필요합니다."
            ));
        }
        
        try {
            log.info("주문 취소 요청: orderId={}, userId={}", orderId, userDetails.getMemberId());
            
            // 주문 상태를 'CANCELLED'로 업데이트
            orderService.updateOrderStatus(orderId, "CANCELLED");
            
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "주문이 취소되었습니다."
            ));
        } catch (IllegalArgumentException e) {
            log.error("주문 취소 실패 - 주문을 찾을 수 없음: orderId={}", orderId);
            return ResponseEntity.status(404).body(Map.of(
                    "success", false,
                    "message", "주문을 찾을 수 없습니다."
            ));
        } catch (Exception e) {
            log.error("주문 취소 실패: orderId={}, error={}", orderId, e.getMessage(), e);
            return ResponseEntity.status(500).body(Map.of(
                    "success", false,
                    "message", "주문 취소 중 오류가 발생했습니다: " + e.getMessage()
            ));
        }
    }
}
