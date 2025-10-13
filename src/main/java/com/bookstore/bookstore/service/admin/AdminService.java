package com.bookstore.bookstore.service.admin;

import com.bookstore.bookstore.dto.admin.*;
import com.bookstore.bookstore.entity.book.Book;
import com.bookstore.bookstore.entity.order.Order;
import com.bookstore.bookstore.entity.customer.Member;
import com.bookstore.bookstore.repository.admin.AdminBookRepository;
import com.bookstore.bookstore.repository.admin.AdminOrderRepository;
import com.bookstore.bookstore.repository.admin.AdminMemberRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 관리자 서비스
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AdminService {
    
    private final AdminBookRepository adminBookRepository;
    private final AdminOrderRepository adminOrderRepository;
    private final AdminMemberRepository adminMemberRepository;
    
    /**
     * 상품 목록 조회
     */
    public Page<AdminBookListResponse> getBookList(AdminBookListRequest request) {
        log.info("관리자 상품 목록 조회: {}", request);
        
        // 정렬 설정
        Sort sort = Sort.by(
            request.isAscending() ? Sort.Direction.ASC : Sort.Direction.DESC,
            request.getSortProperty()
        );
        
        // 페이징 설정
        Pageable pageable = PageRequest.of(request.getPage(), request.getSize(), sort);
        
        // 상품 목록 조회
        Page<Book> books = adminBookRepository.findBooksWithFilters(request, pageable);
        
        // DTO 변환
        return books.map(this::convertToBookListResponse);
    }
    
    /**
     * 상품 상세 조회
     */
    public AdminBookDetailResponse getBookDetail(Long bookId) {
        log.info("관리자 상품 상세 조회: bookId={}", bookId);
        
        Book book = adminBookRepository.findByIdWithDetails(bookId)
                .orElseThrow(() -> new IllegalArgumentException("상품을 찾을 수 없습니다: " + bookId));
        
        return convertToBookDetailResponse(book);
    }
    
    /**
     * 주문 목록 조회
     */
    public Page<AdminOrderListResponse> getOrderList(AdminOrderListRequest request) {
        log.info("관리자 주문 목록 조회: {}", request);
        
        // 정렬 설정
        Sort sort = Sort.by(
            request.isAscending() ? Sort.Direction.ASC : Sort.Direction.DESC,
            request.getSortProperty()
        );
        
        // 페이징 설정
        Pageable pageable = PageRequest.of(request.getPage(), request.getSize(), sort);
        
        // 주문 목록 조회
        Page<Order> orders = adminOrderRepository.findOrdersWithFilters(request, pageable);
        
        // DTO 변환
        return orders.map(this::convertToOrderListResponse);
    }
    
    /**
     * 주문 상세 조회
     */
    public AdminOrderDetailResponse getOrderDetail(Long orderId) {
        log.info("관리자 주문 상세 조회: orderId={}", orderId);
        
        Order order = adminOrderRepository.findByIdWithDetails(orderId)
                .orElseThrow(() -> new IllegalArgumentException("주문을 찾을 수 없습니다: " + orderId));
        
        return convertToOrderDetailResponse(order);
    }
    
    /**
     * 주문 상태 변경
     */
    @Transactional
    public void updateOrderStatus(Long orderId, String status) {
        log.info("관리자 주문 상태 변경: orderId={}, status={}", orderId, status);
        
        Order order = adminOrderRepository.findById(orderId)
                .orElseThrow(() -> new IllegalArgumentException("주문을 찾을 수 없습니다: " + orderId));
        
        order.setOrderStatus(status);
        
        adminOrderRepository.save(order);
        
        log.info("주문 상태 변경 완료: orderId={}, status={}", orderId, status);
    }
    
    /**
     * 회원 목록 조회
     */
    public Page<AdminMemberListResponse> getMemberList(AdminMemberListRequest request) {
        log.info("관리자 회원 목록 조회: {}", request);
        
        // 정렬 설정
        Sort sort = Sort.by(
            request.isAscending() ? Sort.Direction.ASC : Sort.Direction.DESC,
            request.getSortProperty()
        );
        
        // 페이징 설정
        Pageable pageable = PageRequest.of(request.getPage(), request.getSize(), sort);
        
        // 회원 목록 조회
        Page<Member> members = adminMemberRepository.findMembersWithFilters(request, pageable);
        
        // DTO 변환
        return members.map(this::convertToMemberListResponse);
    }
    
    /**
     * 회원 상세 조회
     */
    public AdminMemberDetailResponse getMemberDetail(Long memberId) {
        log.info("관리자 회원 상세 조회: memberId={}", memberId);
        
        Member member = adminMemberRepository.findByIdWithDetails(memberId)
                .orElseThrow(() -> new IllegalArgumentException("회원을 찾을 수 없습니다: " + memberId));
        
        return convertToMemberDetailResponse(member);
    }
    
    // === 변환 메서드들 ===
    
    /**
     * Book을 AdminBookListResponse로 변환
     */
    private AdminBookListResponse convertToBookListResponse(Book book) {
        return AdminBookListResponse.builder()
                .bookId(book.getBookId())
                .isbn(book.getIsbn())
                .title(book.getTitle())
                .publisher(book.getPublisher())
                .authors(book.getBookAuthors() != null ? 
                    book.getBookAuthors().stream()
                        .map(ba -> ba.getAuthor().getName())
                        .collect(Collectors.toList()) : List.of())
                .price(book.getPrice())
                .stock(book.getStock() != null ? book.getStock().getQuantity() : 0)
                .saleStatus(book.getBookStatus())
                .thumbnailUrl(book.getThumbnailUrl())
                .createdAt(book.getRegistrationDate()) // registration_date 필드 사용
                .updatedAt(null) // updatedAt 컬럼이 없음
                .averageRating(book.getRatingAvg() != null ? book.getRatingAvg().doubleValue() : 0.0) // rating_avg 필드 사용, null 체크
                .reviewCount(null) // reviewCount 필드가 없음 (별도 계산 필요)
                .categoryName(book.getCategory() != null ? book.getCategory().getCategoryName() : null)
                .build();
    }
    
    /**
     * Book을 AdminBookDetailResponse로 변환
     */
    private AdminBookDetailResponse convertToBookDetailResponse(Book book) {
        return AdminBookDetailResponse.builder()
                .bookId(book.getBookId())
                .isbn(book.getIsbn())
                .title(book.getTitle())
                .publisher(book.getPublisher())
                .authors(book.getBookAuthors() != null ? 
                    book.getBookAuthors().stream()
                        .map(ba -> ba.getAuthor().getName())
                        .collect(Collectors.toList()) : List.of())
                .price(book.getPrice())
                .stock(book.getStock() != null ? book.getStock().getQuantity() : 0)
                .saleStatus(book.getBookStatus())
                .thumbnailUrl(book.getThumbnailUrl())
                .previewUrl(book.getPreviewUrl())
                .description(book.getDescription())
                .bookSize(book.getWidth() + "x" + book.getHeight() + "mm, " + book.getPageCount() + "페이지") // width, height, pageCount로 구성
                .averageRating(book.getRatingAvg() != null ? book.getRatingAvg().doubleValue() : 0.0) // rating_avg 필드 사용, null 체크
                .reviewCount(null) // reviewCount 필드가 없음 (별도 계산 필요)
                .salesCount(book.getSalesCount())
                .categoryName(book.getCategory() != null ? book.getCategory().getCategoryName() : null)
                .createdAt(book.getRegistrationDate()) // registration_date 필드 사용
                .updatedAt(null) // updatedAt 컬럼이 없음
                .totalOrders(0L) // TODO: 실제 통계 계산
                .totalSales(BigDecimal.ZERO) // TODO: 실제 통계 계산
                .monthlySales(0) // TODO: 실제 통계 계산
                .build();
    }
    
    /**
     * Order를 AdminOrderListResponse로 변환
     */
    private AdminOrderListResponse convertToOrderListResponse(Order order) {
        return AdminOrderListResponse.builder()
                .orderId(order.getOrderId())
                .memberId(order.getMemberId())
                .memberName(order.getMember() != null ? order.getMember().getName() : "알 수 없음")
                .memberEmail(order.getMember() != null ? order.getMember().getEmail() : "")
                .totalAmount(BigDecimal.valueOf(order.getTotalAmount()))
                .discountAmount(BigDecimal.valueOf(order.getDiscountAmount()))
                .finalPaymentAmount(BigDecimal.valueOf(order.getFinalPaymentAmount()))
                .orderStatus(order.getOrderStatus())
                .recipientName(order.getRecipientName())
                .recipientPhone(order.getRecipientPhone())
                .deliveryAddress(order.getDeliveryAddress())
                .memo(order.getMemo())
                .orderDate(order.getOrderDate())
                .updatedAt(null) // Order 엔티티에 updatedAt 필드가 없음
                .orderItems(order.getOrderItems() != null ? 
                    order.getOrderItems().stream()
                        .map(this::convertToOrderItemInfo)
                        .collect(Collectors.toList()) : List.of())
                .build();
    }
    
    /**
     * Order를 AdminOrderDetailResponse로 변환
     */
    private AdminOrderDetailResponse convertToOrderDetailResponse(Order order) {
        return AdminOrderDetailResponse.builder()
                .orderId(order.getOrderId())
                .memberId(order.getMemberId())
                .memberName(order.getMember() != null ? order.getMember().getName() : "알 수 없음")
                .memberEmail(order.getMember() != null ? order.getMember().getEmail() : "")
                .memberPhone(order.getMember() != null ? order.getMember().getPhone() : "")
                .totalAmount(BigDecimal.valueOf(order.getTotalAmount()))
                .discountAmount(BigDecimal.valueOf(order.getDiscountAmount()))
                .finalPaymentAmount(BigDecimal.valueOf(order.getFinalPaymentAmount()))
                .orderStatus(order.getOrderStatus())
                .recipientName(order.getRecipientName())
                .recipientPhone(order.getRecipientPhone())
                .deliveryAddress(order.getDeliveryAddress())
                .memo(order.getMemo())
                .orderDate(order.getOrderDate())
                .updatedAt(null) // Order 엔티티에 updatedAt 필드가 없음
                .payment(convertToPaymentInfo(order))
                .orderItems(order.getOrderItems() != null ? 
                    order.getOrderItems().stream()
                        .map(this::convertToOrderItemDetail)
                        .collect(Collectors.toList()) : List.of())
                .build();
    }
    
    /**
     * Member를 AdminMemberListResponse로 변환
     */
    private AdminMemberListResponse convertToMemberListResponse(Member member) {
        return AdminMemberListResponse.builder()
                .memberId(member.getMemberId())
                .memberName(member.getName())
                .email(member.getEmail())
                .phone(member.getPhone())
                .memberStatus(member.getStatus())
                .memberGrade(member.getMemberGrade())
                .createdAt(member.getRegistrationDate())
                .lastLoginAt(null) // Member 엔티티에 lastLoginAt 필드가 없음
                .totalOrders(0L) // TODO: 실제 통계 계산
                .totalAmount(0L) // TODO: 실제 통계 계산
                .totalReviews(0L) // TODO: 실제 통계 계산
                .build();
    }
    
    /**
     * Member를 AdminMemberDetailResponse로 변환
     */
    private AdminMemberDetailResponse convertToMemberDetailResponse(Member member) {
        return AdminMemberDetailResponse.builder()
                .memberId(member.getMemberId())
                .memberName(member.getName())
                .email(member.getEmail())
                .phone(member.getPhone())
                .memberStatus(member.getStatus())
                .memberGrade(member.getMemberGrade())
                .createdAt(member.getRegistrationDate())
                .lastLoginAt(null) // Member 엔티티에 lastLoginAt 필드가 없음
                .updatedAt(null) // Member 엔티티에 updatedDate 필드가 없음
                .addresses(member.getAddresses() != null ? 
                    member.getAddresses().stream()
                        .map(this::convertToAddressInfo)
                        .collect(Collectors.toList()) : List.of())
                .totalOrders(0L) // TODO: 실제 통계 계산
                .totalAmount(0L) // TODO: 실제 통계 계산
                .totalReviews(0L) // TODO: 실제 통계 계산
                .averageRating(0.0) // TODO: 실제 통계 계산
                .lastOrderDate(null) // TODO: 실제 통계 계산
                .lastReviewDate(null) // TODO: 실제 통계 계산
                .build();
    }
    
    // === 헬퍼 메서드들 ===
    
    private AdminOrderListResponse.OrderItemInfo convertToOrderItemInfo(com.bookstore.bookstore.entity.order.OrderItem orderItem) {
        return AdminOrderListResponse.OrderItemInfo.builder()
                .orderItemId(orderItem.getOrderItemId())
                .bookId(orderItem.getBookId())
                .bookTitle(orderItem.getBook() != null ? orderItem.getBook().getTitle() : "알 수 없음")
                .bookAuthor(orderItem.getBook() != null && orderItem.getBook().getBookAuthors() != null ? 
                    orderItem.getBook().getBookAuthors().stream()
                        .map(ba -> ba.getAuthor().getName())
                        .findFirst()
                        .orElse("작자미상") : "작자미상")
                .publisher(orderItem.getBook() != null ? orderItem.getBook().getPublisher() : "알 수 없음")
                .thumbnailUrl(orderItem.getBook() != null ? orderItem.getBook().getThumbnailUrl() : "")
                .quantity(orderItem.getQuantity())
                .price(BigDecimal.valueOf(orderItem.getPrice()))
                .totalPrice(BigDecimal.valueOf(orderItem.getPrice() * orderItem.getQuantity()))
                .build();
    }
    
    private AdminOrderDetailResponse.OrderItemDetail convertToOrderItemDetail(com.bookstore.bookstore.entity.order.OrderItem orderItem) {
        return AdminOrderDetailResponse.OrderItemDetail.builder()
                .orderItemId(orderItem.getOrderItemId())
                .bookId(orderItem.getBookId())
                .bookTitle(orderItem.getBook() != null ? orderItem.getBook().getTitle() : "알 수 없음")
                .bookAuthor(orderItem.getBook() != null && orderItem.getBook().getBookAuthors() != null ? 
                    orderItem.getBook().getBookAuthors().stream()
                        .map(ba -> ba.getAuthor().getName())
                        .findFirst()
                        .orElse("작자미상") : "작자미상")
                .publisher(orderItem.getBook() != null ? orderItem.getBook().getPublisher() : "알 수 없음")
                .thumbnailUrl(orderItem.getBook() != null ? orderItem.getBook().getThumbnailUrl() : "")
                .quantity(orderItem.getQuantity())
                .price(BigDecimal.valueOf(orderItem.getPrice()))
                .totalPrice(BigDecimal.valueOf(orderItem.getPrice() * orderItem.getQuantity()))
                .isbn(orderItem.getBook() != null ? orderItem.getBook().getIsbn() : "")
                .categoryName(orderItem.getBook() != null && orderItem.getBook().getCategory() != null ? 
                    orderItem.getBook().getCategory().getCategoryName() : "")
                .build();
    }
    
    private AdminOrderDetailResponse.PaymentInfo convertToPaymentInfo(Order order) {
        // Order 엔티티에 getPayments() 메서드가 없으므로 null 반환
        // TODO: Order와 Payment 관계를 확인하고 수정 필요
        return null;
    }
    
    private AdminMemberDetailResponse.AddressInfo convertToAddressInfo(com.bookstore.bookstore.entity.customer.MemberAddress address) {
        return AdminMemberDetailResponse.AddressInfo.builder()
                .addressId(address.getAddressId())
                .postCode(address.getPostCode())
                .addressName(address.getAddressName())
                .addressBasic(address.getAddressBasic())
                .addressDetail(address.getAddressDetail())
                .fullAddress(address.getAddressBasic() + " " + address.getAddressDetail())
                .isDefault(false) // MemberAddress 엔티티에 isDefault 필드가 없음
                .build();
    }
}
