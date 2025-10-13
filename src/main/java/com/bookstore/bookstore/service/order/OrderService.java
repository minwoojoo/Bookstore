package com.bookstore.bookstore.service.order;

import com.bookstore.bookstore.dto.order.CartItemResponse;
import com.bookstore.bookstore.dto.order.OrderHistoryResponse;
import com.bookstore.bookstore.entity.book.Book;
import com.bookstore.bookstore.entity.order.Order;
import com.bookstore.bookstore.entity.order.OrderItem;
import com.bookstore.bookstore.entity.order.Payment;
import com.bookstore.bookstore.repository.book.BookRepository;
import com.bookstore.bookstore.repository.order.OrderRepository;
import com.bookstore.bookstore.repository.order.OrderItemRepository;
import com.bookstore.bookstore.repository.order.PaymentRepository;
import com.bookstore.bookstore.service.order.CartService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * 주문 관련 서비스
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class OrderService {
    
    private final OrderRepository orderRepository;
    private final OrderItemRepository orderItemRepository;
    private final PaymentRepository paymentRepository;
    private final BookRepository bookRepository;
    private final CartService cartService;
    
    /**
     * 주문 생성
     */
    private Order createOrder(Long memberId, String orderId, Integer totalAmount, 
                            String recipientName, String recipientPhone, String deliveryAddress, String memo) {
        return Order.builder()
                .memberId(memberId)
                .totalAmount(totalAmount)
                .discountAmount(0)
                .finalPaymentAmount(totalAmount)
                .orderStatus("PENDING")
                .recipientName(recipientName)
                .recipientPhone(recipientPhone)
                .deliveryAddress(deliveryAddress)
                .memo(memo)
                .orderDate(LocalDateTime.now())
                .build();
    }
    
    /**
     * 주문 아이템 생성
     */
    private OrderItem createOrderItem(Order order, CartItemResponse cartItem) {
        // Book 엔티티 조회
        Book book = bookRepository.findById(cartItem.getBookId())
                .orElseThrow(() -> new IllegalArgumentException("도서를 찾을 수 없습니다: " + cartItem.getBookId()));
        
        return OrderItem.builder()
                .orderId(order.getOrderId())
                .bookId(cartItem.getBookId())
                .quantity(cartItem.getQuantity())
                .price(cartItem.getPrice().intValue())
                .order(order)  // Order 엔티티 설정
                .book(book)    // Book 엔티티 설정
                .build();
    }
    
    /**
     * 결제 정보 생성
     */
    private Payment createPayment(Order order, String paymentKey, Integer amount) {
        return Payment.builder()
                .orderId(order.getOrderId())
                .paymentMethod("CARD")
                .transactionId(paymentKey)
                .amount(amount)
                .status("COMPLETED")
                .paymentDate(LocalDateTime.now())
                .build();
    }
    
    /**
     * 사용자별 주문 목록 조회
     */
    @Transactional(readOnly = true)
    public List<Order> getOrdersByUserId(Long memberId) {
        return orderRepository.findByMemberIdOrderByOrderDateDesc(memberId);
    }
    
    /**
     * 주문 상세 조회
     */
    @Transactional(readOnly = true)
    public Order getOrderById(Long orderId) {
        return orderRepository.findById(orderId)
                .orElseThrow(() -> new IllegalArgumentException("주문을 찾을 수 없습니다: " + orderId));
    }
    
    /**
     * 회원의 주문 내역 조회
     */
    @Transactional(readOnly = true)
    public List<OrderHistoryResponse> getOrderHistory(Long memberId) {
        log.info("주문 내역 조회: 회원ID={}", memberId);
        
        List<Order> orders = orderRepository.findByMemberMemberIdOrderByOrderDateDesc(memberId);
        log.info("DB에서 조회된 주문 수: {}", orders.size());
        
        // 디버깅: 모든 주문 조회
        List<Order> allOrders = orderRepository.findAll();
        log.info("전체 주문 수: {}", allOrders.size());
        allOrders.forEach(order -> 
            log.info("주문 정보: orderId={}, memberId={}, status={}", 
                    order.getOrderId(), order.getMember().getMemberId(), order.getOrderStatus()));
        
        if (!orders.isEmpty()) {
            log.info("첫 번째 주문 정보: orderId={}, status={}, totalAmount={}", 
                    orders.get(0).getOrderId(), orders.get(0).getOrderStatus(), orders.get(0).getTotalAmount());
        }
        
        List<OrderHistoryResponse> result = orders.stream()
                .map(this::convertToOrderHistoryResponse)
                .collect(java.util.stream.Collectors.toList());
        
        log.info("변환된 주문 내역 수: {}", result.size());
        return result;
    }
    
    /**
     * 주문 상세 조회 (회원 권한 확인)
     */
    @Transactional(readOnly = true)
    public OrderHistoryResponse getOrderDetail(Long orderId, Long memberId) {
        log.info("주문 상세 조회: 주문ID={}, 회원ID={}", orderId, memberId);
        
        Order order = orderRepository.findByIdAndMemberMemberId(orderId, memberId)
                .orElseThrow(() -> new IllegalArgumentException("주문을 찾을 수 없거나 권한이 없습니다: " + orderId));
        
        return convertToOrderHistoryResponse(order);
    }
    
    /**
     * 결제 성공 처리 (토스페이먼츠 콜백용)
     */
    @Transactional
    public Long processPaymentSuccess(Long memberId, String orderId, String paymentKey, 
                                    Integer amount, String recipientName, String recipientPhone, 
                                    String deliveryAddress, String memo) {
        log.info("결제 성공 처리 시작: memberId={}, orderId={}, paymentKey={}, amount={}", 
                memberId, orderId, paymentKey, amount);
        
        try {
            // 1. 장바구니 아이템 조회
            log.info("1단계: 장바구니 아이템 조회 시작");
            List<CartItemResponse> cartItems = cartService.getCartItems(memberId);
            log.info("장바구니 아이템 수: {}", cartItems.size());
            if (cartItems.isEmpty()) {
                throw new IllegalStateException("장바구니가 비어있습니다.");
            }
            
            // 2. 주문 생성
            log.info("2단계: 주문 생성 시작");
            Order order = createOrder(memberId, orderId, amount, recipientName, recipientPhone, deliveryAddress, memo);
            log.info("주문 엔티티 생성 완료: {}", order);
            Order savedOrder = orderRepository.save(order);
            log.info("주문 생성 완료: orderId={}", savedOrder.getOrderId());
            
            // 3. 주문 아이템 생성
            log.info("3단계: 주문 아이템 생성 시작");
            for (CartItemResponse cartItem : cartItems) {
                log.info("주문 아이템 생성 중: bookId={}, quantity={}", cartItem.getBookId(), cartItem.getQuantity());
                OrderItem orderItem = createOrderItem(savedOrder, cartItem);
                orderItemRepository.save(orderItem);
                log.info("주문 아이템 저장 완료: {}", orderItem);
            }
            log.info("주문 아이템 생성 완료: {} 개", cartItems.size());
            
            // 4. 결제 정보 생성
            log.info("4단계: 결제 정보 생성 시작");
            Payment payment = createPayment(savedOrder, paymentKey, amount);
            log.info("결제 엔티티 생성 완료: {}", payment);
            paymentRepository.save(payment);
            log.info("결제 정보 생성 완료: paymentId={}", payment.getPaymentId());
            
            // 5. 장바구니 비우기
            log.info("5단계: 장바구니 비우기 시작");
            cartService.clearCart(memberId);
            log.info("장바구니 비우기 완료: userId={}", memberId);
            
            log.info("결제 성공 처리 완료: orderId={}", savedOrder.getOrderId());
            return savedOrder.getOrderId();
            
        } catch (Exception e) {
            log.error("결제 성공 처리 실패: memberId={}, orderId={}, error={}", memberId, orderId, e.getMessage(), e);
            log.error("상세 오류 정보:", e);
            throw new RuntimeException("결제 처리 중 오류가 발생했습니다: " + e.getMessage(), e);
        }
    }
    
    /**
     * Order 엔티티를 OrderHistoryResponse로 변환
     */
    private OrderHistoryResponse convertToOrderHistoryResponse(Order order) {
        List<OrderHistoryResponse.OrderItemResponse> orderItems = new ArrayList<>();
        
        if (order.getOrderItems() != null && !order.getOrderItems().isEmpty()) {
            orderItems = order.getOrderItems().stream()
                    .map(item -> {
                        try {
                            return OrderHistoryResponse.OrderItemResponse.builder()
                                    .orderItemId(item.getOrderItemId())
                                    .bookId(item.getBook() != null ? item.getBook().getBookId() : null)
                                    .bookTitle(item.getBook() != null ? item.getBook().getTitle() : "도서 정보 없음")
                                    .bookAuthor(item.getBook() != null && item.getBook().getBookAuthors() != null ? 
                                            item.getBook().getBookAuthors().stream()
                                                    .map(bookAuthor -> bookAuthor.getAuthor().getName())
                                                    .findFirst()
                                                    .orElse("작자미상") : "작자미상")
                                    .publisher(item.getBook() != null ? item.getBook().getPublisher() : "출판사 정보 없음")
                                    .thumbnailUrl(item.getBook() != null ? item.getBook().getThumbnailUrl() : "")
                                    .quantity(item.getQuantity())
                                    .price(item.getPrice())
                                    .totalPrice(item.getPrice() * item.getQuantity())
                                    .build();
                        } catch (Exception e) {
                            log.error("주문 아이템 변환 중 오류: {}", e.getMessage(), e);
                            return OrderHistoryResponse.OrderItemResponse.builder()
                                    .orderItemId(item.getOrderItemId())
                                    .bookId(null)
                                    .bookTitle("도서 정보 오류")
                                    .bookAuthor("작자미상")
                                    .publisher("출판사 정보 없음")
                                    .thumbnailUrl("")
                                    .quantity(item.getQuantity())
                                    .price(item.getPrice())
                                    .totalPrice(item.getPrice() * item.getQuantity())
                                    .build();
                        }
                    })
                    .toList();
        }
        
        return OrderHistoryResponse.builder()
                .orderId(order.getOrderId())
                .orderDate(order.getOrderDate())
                .orderStatus(order.getOrderStatus())
                .totalAmount(order.getTotalAmount())
                .recipientName(order.getRecipientName())
                .recipientPhone(order.getRecipientPhone())
                .deliveryAddress(order.getDeliveryAddress())
                .memo(order.getMemo())
                .orderItems(orderItems)
                .build();
    }
    
    /**
     * 주문 상태 업데이트
     */
    @Transactional
    public void updateOrderStatus(Long orderId, String status) {
        log.info("주문 상태 업데이트: orderId={}, status={}", orderId, status);
        
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new IllegalArgumentException("주문을 찾을 수 없습니다: " + orderId));
        
        order.setOrderStatus(status);
        orderRepository.save(order);
        
        log.info("주문 상태 업데이트 완료: orderId={}, status={}", orderId, status);
    }
}
