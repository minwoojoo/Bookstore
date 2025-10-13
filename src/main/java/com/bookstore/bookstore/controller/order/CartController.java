package com.bookstore.bookstore.controller.order;

import com.bookstore.bookstore.dto.order.CartItemResponse;
import com.bookstore.bookstore.security.CustomUserDetails;
import com.bookstore.bookstore.service.order.CartService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 장바구니 관련 REST API 컨트롤러
 */
@Slf4j
@RestController
@RequestMapping("/api/cart")
@RequiredArgsConstructor
public class CartController {
    
    private final CartService cartService;
    
    /**
     * 장바구니 아이템 추가 API
     * POST /api/cart/add
     */
    @PostMapping("/add")
    public ResponseEntity<?> addToCart(
            @RequestParam("bookId") Long bookId,
            @RequestParam("quantity") Integer quantity,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        
        if (userDetails == null) {
            return ResponseEntity.status(401).body(Map.of("success", false, "message", "로그인이 필요합니다."));
        }
        
        try {
            cartService.addToCart(userDetails.getMemberId(), bookId, quantity);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "장바구니에 상품이 추가되었습니다.");
            
            log.info("장바구니 추가 완료: 사용자={}, 책ID={}, 수량={}", 
                    userDetails.getUsername(), bookId, quantity);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("장바구니 추가 실패: {}", e.getMessage(), e);
            return ResponseEntity.status(500).body(Map.of("success", false, "message", "장바구니 추가에 실패했습니다."));
        }
    }
    
    /**
     * 장바구니 아이템 조회 API
     * GET /api/cart/items
     */
    @GetMapping("/items")
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
            
            log.info("장바구니 조회 완료: 사용자={}, 아이템 수={}, 총 금액={}", 
                    userDetails.getUsername(), cartItems.size(), totalAmount);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("장바구니 조회 실패: {}", e.getMessage(), e);
            return ResponseEntity.status(500).body(Map.of("success", false, "message", "장바구니 조회에 실패했습니다."));
        }
    }
    
    /**
     * 장바구니 아이템 수량 변경 API
     * POST /api/cart/update
     */
    @PostMapping("/update")
    public ResponseEntity<?> updateCartItem(
            @RequestParam("cartItemId") Long cartItemId,
            @RequestParam("quantity") Integer quantity,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        
        if (userDetails == null) {
            return ResponseEntity.status(401).body(Map.of("success", false, "message", "로그인이 필요합니다."));
        }
        
        try {
            cartService.updateQuantity(cartItemId, quantity);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "수량이 변경되었습니다.");
            
            log.info("장바구니 수량 변경 완료: 사용자={}, 아이템ID={}, 수량={}", 
                    userDetails.getUsername(), cartItemId, quantity);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("장바구니 수량 변경 실패: {}", e.getMessage(), e);
            return ResponseEntity.status(500).body(Map.of("success", false, "message", "수량 변경에 실패했습니다."));
        }
    }
    
    /**
     * 장바구니 아이템 삭제 API
     * POST /api/cart/remove
     */
    @PostMapping("/remove")
    public ResponseEntity<?> removeCartItems(
            @RequestParam(value = "cartItemIds[]", required = false) List<Long> cartItemIds,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        
        if (userDetails == null) {
            return ResponseEntity.status(401).body(Map.of("success", false, "message", "로그인이 필요합니다."));
        }
        
        try {
            if (cartItemIds != null && !cartItemIds.isEmpty()) {
                cartService.removeItems(cartItemIds);
                
                Map<String, Object> response = new HashMap<>();
                response.put("success", true);
                response.put("message", cartItemIds.size() + "개의 상품이 삭제되었습니다.");
                
                log.info("장바구니 아이템 삭제 완료: 사용자={}, 삭제된 아이템 수={}", 
                        userDetails.getUsername(), cartItemIds.size());
                
                return ResponseEntity.ok(response);
            } else {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "삭제할 상품을 선택해주세요."));
            }
        } catch (Exception e) {
            log.error("장바구니 아이템 삭제 실패: {}", e.getMessage(), e);
            return ResponseEntity.status(500).body(Map.of("success", false, "message", "상품 삭제에 실패했습니다."));
        }
    }
}