package com.bookstore.bookstore.service.admin;

import com.bookstore.bookstore.dto.admin.*;
import com.bookstore.bookstore.entity.book.Book;
import com.bookstore.bookstore.entity.book.Stock;
import com.bookstore.bookstore.entity.book.Category;
import com.bookstore.bookstore.entity.book.Author;
import com.bookstore.bookstore.entity.book.BookAuthor;
import com.bookstore.bookstore.entity.customer.Admin;
import com.bookstore.bookstore.entity.order.Order;
import com.bookstore.bookstore.entity.order.OrderItem;
import com.bookstore.bookstore.entity.customer.Member;
import com.bookstore.bookstore.repository.admin.AdminBookRepository;
import com.bookstore.bookstore.repository.admin.AdminOrderRepository;
import com.bookstore.bookstore.repository.admin.AdminOrderItemRepository;
import com.bookstore.bookstore.repository.admin.AdminMemberRepository;
import com.bookstore.bookstore.repository.book.CategoryRepository;
import com.bookstore.bookstore.repository.book.StockRepository;
import com.bookstore.bookstore.repository.book.BookRepository;
import com.bookstore.bookstore.repository.book.AuthorRepository;
import com.bookstore.bookstore.repository.book.BookAuthorRepository;
import com.bookstore.bookstore.repository.admin.AdminRepository;
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
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.ArrayList;
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
    private final AdminOrderItemRepository adminOrderItemRepository;
    private final AdminMemberRepository adminMemberRepository;
    private final CategoryRepository categoryRepository;
    private final StockRepository stockRepository;
    private final BookRepository bookRepository;
    private final AuthorRepository authorRepository;
    private final BookAuthorRepository bookAuthorRepository;
    private final AdminRepository adminRepository;
    
    /**
     * 관리자 대시보드 통계 조회
     */
    public AdminDashboardStatsResponse getDashboardStats() {
        log.info("관리자 대시보드 통계 조회");
        
        LocalDate today = LocalDate.now();
        LocalDate monthStart = today.withDayOfMonth(1);
        
        // 기본 통계
        Long totalBooks = adminBookRepository.count();
        Long totalOrders = adminOrderRepository.count();
        Long totalMembers = adminMemberRepository.count();
        
        // 총 매출액 조회
        BigDecimal totalSales = adminOrderRepository.getTotalSales();
        if (totalSales == null) {
            totalSales = BigDecimal.ZERO;
        }
        
        // 오늘 통계
        LocalDateTime todayStart = today.atStartOfDay();
        LocalDateTime todayEnd = today.plusDays(1).atStartOfDay();
        Long todayOrders = adminOrderRepository.countByOrderDate(todayStart, todayEnd);
        BigDecimal todaySales = adminOrderRepository.getSalesByDate(todayStart, todayEnd);
        if (todaySales == null) {
            todaySales = BigDecimal.ZERO;
        }
        
        // 이번 달 통계
        LocalDateTime monthStartDateTime = monthStart.atStartOfDay();
        LocalDateTime todayEndDateTime = today.plusDays(1).atStartOfDay();
        Long monthlyOrders = adminOrderRepository.countByOrderDateBetween(monthStartDateTime, todayEndDateTime);
        BigDecimal monthlySales = adminOrderRepository.getSalesByDateBetween(monthStartDateTime, todayEndDateTime);
        if (monthlySales == null) {
            monthlySales = BigDecimal.ZERO;
        }
        
        // 판매중인 도서 수
        Long activeBooks = adminBookRepository.countByBookStatus("판매중");
        
        // 재고 부족 도서 수 (재고 10개 이하)
        Long lowStockBooks = adminBookRepository.countLowStockBooks(10);
        
        // 활성 회원 수 (ACTIVE 상태인 회원)
        Long activeMembers = adminMemberRepository.countActiveMembers(null);
        
        return AdminDashboardStatsResponse.builder()
                .totalBooks(totalBooks)
                .totalOrders(totalOrders)
                .totalMembers(totalMembers)
                .totalSales(totalSales)
                .todayOrders(todayOrders)
                .todaySales(todaySales)
                .monthlyOrders(monthlyOrders)
                .monthlySales(monthlySales)
                .activeBooks(activeBooks)
                .lowStockBooks(lowStockBooks)
                .activeMembers(activeMembers)
                .build();
    }
    
    /**
     * 최근 활동 조회
     */
    public List<AdminRecentActivityResponse> getRecentActivities() {
        log.info("최근 활동 조회");
        
        List<AdminRecentActivityResponse> activities = new ArrayList<>();
        
        // 최근 주문 (최근 5개)
        List<Order> recentOrders = adminOrderRepository.findTop5ByOrderByOrderDateDesc();
        for (Order order : recentOrders) {
            activities.add(AdminRecentActivityResponse.builder()
                    .activityType("ORDER")
                    .message("새로운 주문 #" + order.getOrderId())
                    .activityTime(order.getOrderDate())
                    .relatedId(order.getOrderId())
                    .priority(1)
                    .build());
        }
        
        // 최근 회원 가입 (최근 3개)
        List<Member> recentMembers = adminMemberRepository.findTop3ByOrderByRegistrationDateDesc();
        for (Member member : recentMembers) {
            activities.add(AdminRecentActivityResponse.builder()
                    .activityType("MEMBER")
                    .message(member.getName() + "님이 가입했습니다")
                    .activityTime(member.getRegistrationDate())
                    .relatedId(member.getMemberId())
                    .priority(2)
                    .build());
        }
        
        // 재고 부족 도서 (최근 2개)
        List<Book> lowStockBooks = adminBookRepository.findLowStockBooks(10, 2);
        for (Book book : lowStockBooks) {
            activities.add(AdminRecentActivityResponse.builder()
                    .activityType("STOCK")
                    .message(book.getTitle() + " - " + book.getStock().getQuantity() + "권 남음")
                    .activityTime(book.getLastSalesUpdate() != null ? book.getLastSalesUpdate() : book.getRegistrationDate())
                    .relatedId(book.getBookId())
                    .priority(3)
                    .build());
        }
        
        // 시간순으로 정렬하여 최근 5개만 반환
        return activities.stream()
                .sorted((a, b) -> b.getActivityTime().compareTo(a.getActivityTime()))
                .limit(5)
                .collect(Collectors.toList());
    }
    
    /**
     * 상품 목록 조회
     */
    public Page<AdminBookListResponse> getBookList(AdminBookListRequest request) {
        log.info("관리자 상품 목록 조회 요청: page={}, size={}, sortBy={}, sortDirection={}", 
                request.getPage(), request.getSize(), request.getSortBy(), request.getSortDirection());
        
        // 정렬 설정
        Sort sort = Sort.by(
            request.isAscending() ? Sort.Direction.ASC : Sort.Direction.DESC,
            request.getSortProperty()
        );
        
        // 페이징 설정
        Pageable pageable = PageRequest.of(request.getPage(), request.getSize(), sort);
        log.info("페이징 설정: page={}, size={}, sort={}", pageable.getPageNumber(), pageable.getPageSize(), sort);
        
                // 상품 목록 조회
                Page<Book> books = adminBookRepository.findBooksWithFilters(request, pageable);
        
        log.info("조회 결과: totalElements={}, totalPages={}, currentPage={}, contentSize={}", 
                books.getTotalElements(), books.getTotalPages(), books.getNumber(), books.getContent().size());
        
        // DTO 변환
        Page<AdminBookListResponse> result = books.map(this::convertToBookListResponse);
        log.info("변환 결과: totalElements={}, totalPages={}, currentPage={}, contentSize={}", 
                result.getTotalElements(), result.getTotalPages(), result.getNumber(), result.getContent().size());
        
        return result;
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
        
        // 날짜 변환 (LocalDate -> LocalDateTime)
        LocalDateTime startDate = request.getStartDate() != null ? 
            request.getStartDate().atStartOfDay() : null;
        LocalDateTime endDate = request.getEndDate() != null ? 
            request.getEndDate().plusDays(1).atStartOfDay() : null;
        
        // 주문 목록 조회
        Page<Order> orders = adminOrderRepository.findOrdersWithFilters(
            request.getMemberName(),
            request.getBookTitle(),
            request.getPublisher(),
            request.getAuthor(),
            request.getSaleStatus(),
            startDate,
            endDate,
            request.getMemberId(),
            pageable
        );
        
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
        
        // 회원 목록 조회 (Repository의 default 메서드 사용)
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
        // 연관 엔티티 지연 로딩 처리
        List<String> authors = List.of();
        try {
            if (book.getBookAuthors() != null && !book.getBookAuthors().isEmpty()) {
                authors = book.getBookAuthors().stream()
                    .map(ba -> ba.getAuthor().getName())
                    .collect(Collectors.toList());
            }
        } catch (Exception e) {
            log.warn("저자 정보 로딩 실패: bookId={}, error={}", book.getBookId(), e.getMessage());
        }
        
        String categoryName = null;
        try {
            if (book.getCategory() != null) {
                categoryName = book.getCategory().getCategoryName();
            }
        } catch (Exception e) {
            log.warn("카테고리 정보 로딩 실패: bookId={}, error={}", book.getBookId(), e.getMessage());
        }
        
        Integer stockQuantity = 0;
        try {
            if (book.getStock() != null) {
                stockQuantity = book.getStock().getQuantity();
            }
        } catch (Exception e) {
            log.warn("재고 정보 로딩 실패: bookId={}, error={}", book.getBookId(), e.getMessage());
        }
        
        return AdminBookListResponse.builder()
                .bookId(book.getBookId())
                .isbn(book.getIsbn())
                .title(book.getTitle())
                .publisher(book.getPublisher())
                .authors(authors)
                .price(book.getPrice())
                .stock(stockQuantity)
                .saleStatus(book.getBookStatus())
                .thumbnailUrl(book.getThumbnailUrl())
                .createdAt(formatDateTime(book.getRegistrationDate()))
                .updatedAt(null)
                .averageRating(book.getRatingAvg() != null ? book.getRatingAvg().doubleValue() : 0.0)
                .reviewCount(null)
                .categoryName(categoryName)
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
                .createdAt(formatDateTime(book.getRegistrationDate())) // registration_date 필드 사용
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
        // 주문 아이템들을 별도로 조회
        List<AdminOrderListResponse.OrderItemInfo> orderItems = getOrderItemsForOrder(order.getOrderId());
        
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
                .orderDate(order.getOrderDate() != null ? 
                    order.getOrderDate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")) : "")
                .updatedAt(null) // Order 엔티티에 updatedAt 필드가 없음
                .orderItems(orderItems)
                .build();
    }
    
    /**
     * 주문의 아이템들을 조회
     */
    private List<AdminOrderListResponse.OrderItemInfo> getOrderItemsForOrder(Long orderId) {
        // OrderItem을 직접 조회하여 N+1 문제 방지
        List<OrderItem> orderItems = adminOrderItemRepository.findByOrderId(orderId);
        return orderItems.stream()
                .map(this::convertToOrderItemInfo)
                .collect(Collectors.toList());
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
                .deliveryFee(BigDecimal.valueOf(0)) // 기본 배송비 0원
                .finalPaymentAmount(BigDecimal.valueOf(order.getFinalPaymentAmount()))
                .orderStatus(order.getOrderStatus())
                .recipientName(order.getRecipientName())
                .recipientPhone(order.getRecipientPhone())
                .deliveryAddress(order.getDeliveryAddress())
                .memo(order.getMemo())
                .orderDate(order.getOrderDate() != null ? 
                    order.getOrderDate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")) : "")
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
                .createdAt(formatDateTime(member.getRegistrationDate()))
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
        Long memberId = member.getMemberId();
        
        // 실제 통계 데이터 조회
        Long totalOrders = adminMemberRepository.countOrdersByMemberId(memberId);
        Long totalAmount = adminMemberRepository.getTotalAmountByMemberId(memberId);
        Long totalReviews = adminMemberRepository.countReviewsByMemberId(memberId);
        Double averageRating = adminMemberRepository.getAverageRatingByMemberId(memberId);
        LocalDateTime lastOrderDate = adminMemberRepository.getLastOrderDateByMemberId(memberId);
        LocalDateTime lastReviewDate = adminMemberRepository.getLastReviewDateByMemberId(memberId);
        
        return AdminMemberDetailResponse.builder()
                .memberId(member.getMemberId())
                .memberName(member.getName())
                .email(member.getEmail())
                .phone(member.getPhone())
                .memberStatus(member.getStatus())
                .memberGrade(member.getMemberGrade())
                .createdAt(formatDateTime(member.getRegistrationDate()))
                .lastLoginAt(null) // Member 엔티티에 lastLoginAt 필드가 없음
                .updatedAt(null) // Member 엔티티에 updatedDate 필드가 없음
                .addresses(member.getAddresses() != null ? 
                    member.getAddresses().stream()
                        .map(this::convertToAddressInfo)
                        .collect(Collectors.toList()) : List.of())
                .totalOrders(totalOrders != null ? totalOrders : 0L)
                .totalAmount(totalAmount != null ? totalAmount : 0L)
                .totalReviews(totalReviews != null ? totalReviews : 0L)
                .averageRating(averageRating != null ? averageRating : 0.0)
                .lastOrderDate(formatDateTime(lastOrderDate))
                .lastReviewDate(formatDateTime(lastReviewDate))
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
                .bookAuthor("작자미상") // bookAuthors를 별도 fetch하지 않으므로 기본값 사용
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

    /**
     * 도서 재고 정보 조회
     */
    public AdminBookStockResponse getBookStockInfo(Long bookId) {
        log.info("도서 재고 정보 조회: bookId={}", bookId);

        Book book = adminBookRepository.findByIdWithDetails(bookId)
                .orElseThrow(() -> new IllegalArgumentException("도서를 찾을 수 없습니다: " + bookId));

        // 재고 변경 이력 조회 (간단한 구현 - 실제로는 별도 테이블 필요)
        List<AdminBookStockResponse.StockHistoryItem> stockHistory = List.of();

        return AdminBookStockResponse.builder()
                .bookId(book.getBookId())
                .title(book.getTitle())
                .isbn(book.getIsbn())
                .publisher(book.getPublisher())
                .authors(book.getBookAuthors().stream()
                        .map(ba -> ba.getAuthor().getName())
                        .collect(Collectors.toList()))
                .price(book.getPrice())
                .stock(book.getStock() != null ? book.getStock().getQuantity() : 0)
                .saleStatus(book.getBookStatus())
                .thumbnailUrl(book.getThumbnailUrl())
                .stockHistory(stockHistory)
                .build();
    }

    /**
     * 도서 재고 업데이트
     */
    @Transactional
    public void updateBookStock(Long bookId, AdminBookStockRequest request) {
        log.info("도서 재고 업데이트: bookId={}, adjustment={}, newStock={}", 
                bookId, request.getAdjustment(), request.getNewStock());

        Book book = adminBookRepository.findByIdWithDetails(bookId)
                .orElseThrow(() -> new IllegalArgumentException("도서를 찾을 수 없습니다: " + bookId));

        Stock stock = book.getStock();
        if (stock == null) {
            throw new IllegalArgumentException("재고 정보를 찾을 수 없습니다: " + bookId);
        }

        int currentQuantity = stock.getQuantity();
        int newQuantity = request.getNewStock();

        // 재고 수량 검증
        if (newQuantity < 0) {
            throw new IllegalArgumentException("재고 수량은 0 이상이어야 합니다.");
        }

        // 재고 업데이트
        stock.setQuantity(newQuantity);
        stock.setLastUpdated(LocalDateTime.now());

        // 판매상태 자동 업데이트
        if (newQuantity == 0) {
            book.setBookStatus("일시품절");
        } else if (newQuantity < 10) {
            book.setBookStatus("일시품절");
        } else if ("일시품절".equals(book.getBookStatus()) && newQuantity >= 10) {
            book.setBookStatus("판매중");
        } else if (book.getBookStatus() == null) {
            // bookStatus가 null인 경우 기본값 설정
            book.setBookStatus("판매중");
        }

        log.info("재고 업데이트 완료: bookId={}, {} -> {} ({}권 {})", 
                bookId, currentQuantity, newQuantity, 
                request.getAdjustment() > 0 ? "+" : "", request.getAdjustment());
    }
    
    /**
     * 최하위 카테고리 조회 (상품 등록용)
     */
    @Transactional(readOnly = true)
    public List<Category> getAllCategories() {
        return categoryRepository.findByLevel(3);
    }
    
    /**
     * 새 상품 등록
     */
    @Transactional
    public Long createBook(AdminBookCreateRequest request, Long adminId) {
        log.info("상품 등록 시작: {}", request);
        
        // 카테고리 조회
        Category category = categoryRepository.findById(request.getCategoryId())
                .orElseThrow(() -> new IllegalArgumentException("카테고리를 찾을 수 없습니다: " + request.getCategoryId()));
        
        // 관리자 조회
        Admin admin = adminRepository.findById(adminId)
                .orElseThrow(() -> new IllegalArgumentException("관리자를 찾을 수 없습니다: " + adminId));
        
        // Book 엔티티 생성
        Book book = Book.builder()
                .isbn(request.getIsbn())
                .title(request.getTitle())
                .description(request.getDescription())
                .width(request.getWidth())
                .height(request.getHeight())
                .pageCount(request.getPageCount())
                .thumbnailUrl(request.getThumbnailUrl())
                .previewUrl(request.getPreviewUrl())
                .ratingAvg(request.getRatingAvg() != null ? request.getRatingAvg() : BigDecimal.ZERO)
                .bookStatus(request.getBookStatus())
                .registrationDate(LocalDateTime.now())
                .price(request.getPrice())
                .publisher(request.getPublisher())
                .salesCount(request.getSalesCount() != null ? request.getSalesCount() : 0)
                .monthlySales(request.getMonthlySales() != null ? request.getMonthlySales() : 0)
                .lastSalesUpdate(LocalDateTime.now())
                .category(category)
                .createdAdmin(admin)
                .updatedAdmin(admin)
                .build();
        
        // Book 저장
        Book savedBook = bookRepository.save(book);
        
        // 저자 정보 처리 (Book 저장 후)
        if (request.getAuthors() != null && !request.getAuthors().trim().isEmpty()) {
            String[] authorNames = request.getAuthors().split(",");
            
            for (int i = 0; i < authorNames.length; i++) {
                String authorName = authorNames[i].trim();
                if (!authorName.isEmpty()) {
                    // Author 조회 또는 생성
                    Author author = authorRepository.findByName(authorName)
                            .orElseGet(() -> {
                                Author newAuthor = Author.builder()
                                        .name(authorName)
                                        .description("")
                                        .build();
                                return authorRepository.save(newAuthor);
                            });
                    
                    // BookAuthor 관계 생성
                    BookAuthor bookAuthor = BookAuthor.builder()
                            .bookId(savedBook.getBookId())
                            .authorId(author.getAuthorId())
                            .authorOrder(i + 1)
                            .book(savedBook)
                            .author(author)
                            .build();
                    
                    // BookAuthor 저장
                    bookAuthorRepository.save(bookAuthor);
                }
            }
        }
        
        // 재고 정보 생성
        Stock stock = Stock.builder()
                .book(savedBook)
                .quantity(request.getStockQuantity() != null ? request.getStockQuantity() : 0)
                .lastUpdated(LocalDateTime.now())
                .build();
        stockRepository.save(stock);
        
        log.info("상품 등록 완료: bookId={}", savedBook.getBookId());
        return savedBook.getBookId();
    }
    
    /**
     * LocalDateTime을 포맷된 문자열로 변환하는 헬퍼 메서드
     */
    private String formatDateTime(LocalDateTime dateTime) {
        return dateTime != null ? 
            dateTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")) : "";
    }
}
