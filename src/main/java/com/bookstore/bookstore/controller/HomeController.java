package com.bookstore.bookstore.controller;

import com.bookstore.bookstore.dto.customer.MemberResponse;
import com.bookstore.bookstore.dto.customer.SignupRequest;
import com.bookstore.bookstore.dto.book.CategoryResponse;
import com.bookstore.bookstore.dto.book.BookListResponse;
import com.bookstore.bookstore.dto.book.BookDetailResponse;
import com.bookstore.bookstore.dto.review.ReviewResponse;
import com.bookstore.bookstore.dto.order.CartItemResponse;
import com.bookstore.bookstore.dto.order.OrderHistoryResponse;
import java.util.List;
import java.util.ArrayList;
import com.bookstore.bookstore.entity.book.Book;
import com.bookstore.bookstore.entity.etc.PopularSearch;
import com.bookstore.bookstore.entity.etc.RecentView;
import com.bookstore.bookstore.repository.book.BookRepository;
import com.bookstore.bookstore.security.CustomUserDetails;
import com.bookstore.bookstore.service.customer.AuthService;
import com.bookstore.bookstore.service.customer.MemberService;
import com.bookstore.bookstore.service.book.BookService;
import com.bookstore.bookstore.service.etc.PopularSearchService;
import com.bookstore.bookstore.service.order.CartService;
import com.bookstore.bookstore.service.order.OrderService;
import com.bookstore.bookstore.service.etc.RecentViewService;
import com.bookstore.bookstore.service.review.ReviewService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * 홈 및 인증 페이지 컨트롤러
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class HomeController {
    
    private final AuthService authService;
    private final BookRepository bookRepository;
    private final BookService bookService;
    private final PopularSearchService popularSearchService;
    private final CartService cartService;
    private final OrderService orderService;
    private final RecentViewService recentViewService;
    private final MemberService memberService;
    private final ReviewService reviewService;
    
    /**
     * 홈 페이지
     * GET /
     */
    @GetMapping("/")
    public String home(@AuthenticationPrincipal CustomUserDetails userDetails, Model model) {
        if (userDetails != null) {
            // 로그인 상태
            model.addAttribute("isAuthenticated", true);
            model.addAttribute("userName", userDetails.getName());
            model.addAttribute("userId", userDetails.getUsername());
            log.info("홈 페이지 접속: 로그인 사용자 = {}", userDetails.getUsername());
        } else {
            // 비로그인 상태
            model.addAttribute("isAuthenticated", false);
            log.info("홈 페이지 접속: 비로그인 사용자");
        }
        
        // Level 2 카테고리 목록 조회 (대분류)
        List<CategoryResponse> level2Categories = bookService.getLevel2Categories();
        model.addAttribute("level2Categories", level2Categories);
        
        // 월간 베스트셀러 20개 조회 (평균평점 포함)
        List<BookListResponse> bestsellers = bookService.getMonthlyBestsellersWithRatings(20);
        model.addAttribute("bestsellers", bestsellers);
        
        // 인기 검색어 상위 10개 조회
        List<PopularSearch> popularSearches = popularSearchService.getTop10PopularSearches();
        model.addAttribute("popularSearches", popularSearches);
        
        // 로그인한 사용자의 최근 본 상품 조회
        if (userDetails != null) {
            try {
                List<RecentView> recentViews = 
                        recentViewService.getRecentViews(userDetails.getMemberId());
                model.addAttribute("recentViews", recentViews);
                log.info("최근 본 상품 조회 완료: memberId={}, count={}", 
                        userDetails.getMemberId(), recentViews.size());
            } catch (Exception e) {
                log.warn("최근 본 상품 조회 실패: memberId={}, error={}", 
                        userDetails.getMemberId(), e.getMessage());
            }
        }
        
        return "index";
    }
    
    /**
     * 회원가입 페이지
     * GET /auth/signup
     */
    @GetMapping("/auth/signup")
    public String signupPage(Model model) {
        model.addAttribute("signupRequest", new SignupRequest());
        return "auth/signup";
    }
    
    /**
     * 회원가입 처리
     * POST /auth/signup
     */
    @PostMapping("/auth/signup")
    public String signup(
        @Valid @ModelAttribute SignupRequest request,
        BindingResult bindingResult,
        RedirectAttributes redirectAttributes
    ) {
        log.info("회원가입 요청: userId = {}", request.getUserId());
        
        // 유효성 검사 실패
        if (bindingResult.hasErrors()) {
            log.warn("회원가입 유효성 검사 실패: {}", bindingResult.getAllErrors());
            return "auth/signup";
        }
        
        try {
            // 회원가입 처리
            MemberResponse member = authService.signup(request);
            
            log.info("회원가입 성공: memberId = {}", member.getMemberId());
            
            redirectAttributes.addFlashAttribute("message", "회원가입이 완료되었습니다. 로그인해주세요.");
            return "redirect:/auth/login";
            
        } catch (IllegalArgumentException e) {
            log.error("회원가입 실패: {}", e.getMessage());
            bindingResult.reject("signupFailed", e.getMessage());
            return "auth/signup";
        }
    }
    
    /**
     * 로그인 페이지
     * GET /auth/login
     */
    @GetMapping("/auth/login")
    public String loginPage(
        @RequestParam(value = "error", required = false) String error,
        @RequestParam(value = "expired", required = false) String expired,
        @RequestParam(value = "message", required = false) String message,
        @RequestParam(value = "redirectUrl", required = false) String redirectUrl,
        Model model
    ) {
        if (error != null) {
            model.addAttribute("error", "아이디 또는 비밀번호가 올바르지 않습니다.");
        }
        if (expired != null) {
            model.addAttribute("error", "세션이 만료되었습니다. 다시 로그인해주세요.");
        }
        if (message != null) {
            model.addAttribute("message", message);
        }
        if (redirectUrl != null) {
            model.addAttribute("redirectUrl", redirectUrl);
        }
        return "auth/login";
    }
    
    /**
     * 비밀번호 찾기 페이지
     * GET /auth/find-password
     */
    @GetMapping("/auth/find-password")
    public String passwordFindPage() {
        log.info("비밀번호 찾기 페이지 접속");
        return "auth/password-find";
    }
    
    /**
     * 마이페이지
     * GET /mypage
     */
    @GetMapping("/mypage")
    public String mypage(@AuthenticationPrincipal CustomUserDetails userDetails, Model model, HttpServletRequest request) {
        if (userDetails == null) {
            log.warn("비로그인 사용자가 마이페이지 접근 시도");
            return "redirect:/auth/login?redirectUrl=" + request.getRequestURL();
        }
        
        log.info("마이페이지 접속: userId = {}", userDetails.getUsername());
        model.addAttribute("isAuthenticated", true);
        model.addAttribute("userId", userDetails.getUsername());
        model.addAttribute("userName", userDetails.getName());
        return "customer/mypage";
    }
    
    /**
     * 카테고리별 책 목록 페이지
     * GET /books/category?categoryId=xxx
     */
    @GetMapping("/books/category")
    public String getBooksByCategory(
            @RequestParam("categoryId") Long categoryId,
            @RequestParam(value = "page", defaultValue = "0") int page,
            @RequestParam(value = "size", defaultValue = "30") int size,
            @AuthenticationPrincipal CustomUserDetails userDetails,
            Model model
    ) {
        log.info("카테고리별 책 목록 페이지 요청: categoryId={}, page={}, size={}", categoryId, page, size);
        
        // 페이지 크기 유효성 검사
        if (size != 30 && size != 50 && size != 100) {
            size = 30; // 기본값으로 설정
        }
        
        // 로그인 상태 확인
        if (userDetails != null) {
            model.addAttribute("isAuthenticated", true);
            model.addAttribute("userName", userDetails.getName());
        } else {
            model.addAttribute("isAuthenticated", false);
        }
        
        // 카테고리 정보 조회
        CategoryResponse category = bookService.getCategory(categoryId);
        model.addAttribute("category", category);
        
        // 카테고리별 책 수 조회
        long totalBooks = bookService.getBookCountByCategory(categoryId);
        int totalPages = (int) Math.ceil((double) totalBooks / size);
        
        // 해당 카테고리의 책 목록 조회 (페이징, 평균평점 포함)
        List<BookListResponse> books = bookService.getBooksByCategoryWithRatings(categoryId, page, size);
        model.addAttribute("books", books);
        
        // 페이징 정보
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        model.addAttribute("totalBooks", totalBooks);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("hasNextPage", page < totalPages - 1);
        model.addAttribute("hasPrevPage", page > 0);
        
        // Level 2 카테고리 목록 (메뉴용)
        List<CategoryResponse> level2Categories = bookService.getLevel2Categories();
        model.addAttribute("level2Categories", level2Categories);
        
        // 선택된 카테고리의 부모가 있으면 하위 카테고리 목록도 조회
        if (category.getParentId() != null) {
            List<CategoryResponse> siblingCategories = bookService.getLevel3Categories(category.getParentId());
            model.addAttribute("level3Categories", siblingCategories);
            model.addAttribute("selectedParentId", category.getParentId());
            
            // 부모 카테고리 정보도 전달
            CategoryResponse parentCategory = bookService.getCategory(category.getParentId());
            model.addAttribute("parentCategory", parentCategory);
        }
        
        log.info("카테고리별 책 목록 페이지 완료: categoryId={}, page={}, size={}, 책 수={}, 총 책 수={}", 
                categoryId, page, size, books.size(), totalBooks);
        
        return "book/category-books";
    }
    
    /**
     * 전체 책 목록 페이지
     * GET /books/all
     */
    @GetMapping("/books/all")
    public String getAllBooks(
            @RequestParam(value = "page", defaultValue = "0") int page,
            @RequestParam(value = "size", defaultValue = "30") int size,
            @AuthenticationPrincipal CustomUserDetails userDetails,
            Model model
    ) {
        log.info("전체 책 목록 페이지 요청: page={}, size={}", page, size);
        
        // 페이지 크기 유효성 검사
        if (size != 30 && size != 50 && size != 100) {
            size = 30; // 기본값으로 설정
        }
        
        // 로그인 상태 확인
        if (userDetails != null) {
            model.addAttribute("isAuthenticated", true);
            model.addAttribute("userName", userDetails.getName());
        } else {
            model.addAttribute("isAuthenticated", false);
        }
        
        // 전체 책 수 조회
        long totalBooks = bookService.getTotalBookCount();
        int totalPages = (int) Math.ceil((double) totalBooks / size);
        
        // 전체 책 목록 조회 (페이징, 평균평점 포함)
        List<BookListResponse> books = bookService.getAllBooksWithRatings(page, size);
        model.addAttribute("books", books);
        
        // 페이징 정보
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        model.addAttribute("totalBooks", totalBooks);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("hasNextPage", page < totalPages - 1);
        model.addAttribute("hasPrevPage", page > 0);
        
        // Level 2 카테고리 목록 (메뉴용)
        List<CategoryResponse> level2Categories = bookService.getLevel2Categories();
        model.addAttribute("level2Categories", level2Categories);
        
        // 카테고리 정보 (전체 도서)
        CategoryResponse allBooksCategory = bookService.getAllBooksCategory();
        model.addAttribute("category", allBooksCategory);
        
        log.info("전체 책 목록 페이지 완료: page={}, size={}, 책 수={}, 총 책 수={}", 
                page, size, books.size(), totalBooks);
        
        return "book/category-books";
    }
    
    /**
     * 책 검색 페이지
     * GET /books/search?keyword=xxx
     */
    @GetMapping("/books/search")
    public String searchBooks(
            @RequestParam("keyword") String keyword,
            @RequestParam(value = "page", defaultValue = "0") int page,
            @RequestParam(value = "size", defaultValue = "30") int size,
            @AuthenticationPrincipal CustomUserDetails userDetails,
            Model model
    ) {
        log.info("책 검색 페이지 요청: keyword={}, page={}, size={}", keyword, page, size);
        
        // 페이지 크기 유효성 검사
        if (size != 30 && size != 50 && size != 100) {
            size = 30; // 기본값으로 설정
        }
        
        // 로그인 상태 확인
        if (userDetails != null) {
            model.addAttribute("isAuthenticated", true);
            model.addAttribute("userName", userDetails.getName());
        } else {
            model.addAttribute("isAuthenticated", false);
        }
        
        // 검색어 기록 (인기 검색어)
        popularSearchService.recordSearch(keyword);
        
        // 검색 결과 수 조회
        long totalBooks = bookService.getSearchResultCount(keyword);
        int totalPages = (int) Math.ceil((double) totalBooks / size);
        
        // 검색 결과 조회 (페이징, 평균평점 포함)
        List<BookListResponse> books = bookService.searchBooksWithRatings(keyword, page, size);
        model.addAttribute("books", books);
        model.addAttribute("keyword", keyword);
        
        // 페이징 정보
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        model.addAttribute("totalBooks", totalBooks);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("hasNextPage", page < totalPages - 1);
        model.addAttribute("hasPrevPage", page > 0);
        
        // Level 2 카테고리 목록 (메뉴용)
        List<CategoryResponse> level2Categories = bookService.getLevel2Categories();
        model.addAttribute("level2Categories", level2Categories);
        
        // 카테고리 정보 (검색 결과)
        CategoryResponse searchCategory = bookService.getSearchResultCategory();
        model.addAttribute("category", searchCategory);
        
        log.info("책 검색 페이지 완료: keyword={}, page={}, size={}, 책 수={}, 총 책 수={}", 
                keyword, page, size, books.size(), totalBooks);
        
        return "book/category-books";
    }
    
    /**
     * 도서 상세 페이지
     * GET /books/{bookId}
     */
    @GetMapping("/books/{bookId}")
    public String getBookDetail(
            @org.springframework.web.bind.annotation.PathVariable Long bookId,
            @AuthenticationPrincipal CustomUserDetails userDetails,
            Model model
    ) {
        log.info("도서 상세 페이지 요청: bookId={}", bookId);
        
        // 로그인 상태 확인
        if (userDetails != null) {
            model.addAttribute("isAuthenticated", true);
            model.addAttribute("userName", userDetails.getName());
            
            // 최근 본 상품 기록 (비동기로 처리)
            try {
                recentViewService.addRecentView(userDetails.getMemberId(), bookId);
            } catch (Exception e) {
                log.warn("최근 본 상품 기록 실패: memberId={}, bookId={}, error={}", 
                        userDetails.getMemberId(), bookId, e.getMessage());
            }
        } else {
            model.addAttribute("isAuthenticated", false);
        }
        
        try {
            // 도서 상세 정보 조회
            BookDetailResponse book = bookService.getBookDetail(bookId);
            model.addAttribute("book", book);
            
            // 리뷰 데이터 조회 (실제 데이터)
            Long memberId = userDetails != null ? userDetails.getMemberId() : null;
            List<ReviewResponse> reviews = reviewService.getReviewsByBookId(bookId, memberId);
            log.info("리뷰 데이터 조회 완료: bookId={}, 리뷰 수={}", bookId, reviews.size());
            model.addAttribute("reviews", reviews);
            
            // 리뷰 통계
            long reviewCount = reviewService.getReviewCount(bookId);
            Double avgRatingValue = reviewService.getAverageRating(bookId);
            double avgRating = avgRatingValue != null ? avgRatingValue : 0.0;
            model.addAttribute("reviewCount", reviewCount);
            model.addAttribute("avgRating", avgRating);
            
            log.info("도서 상세 페이지 완료: bookId={}, title={}, 리뷰 수={}, 평균 평점={}", 
                    bookId, book.getTitle(), reviewCount, avgRating);
            
            return "book/book-detail";
        } catch (IllegalArgumentException e) {
            log.error("도서를 찾을 수 없음: bookId={}", bookId);
            return "redirect:/";
        }
    }
    
    /**
     * 장바구니 페이지
     * GET /cart
     */
    @GetMapping("/cart")
    public String cart(@AuthenticationPrincipal CustomUserDetails userDetails, Model model, HttpServletRequest request) {
        log.info("장바구니 페이지 요청");
        
        // 로그인 상태 확인
        if (userDetails != null) {
            model.addAttribute("isAuthenticated", true);
            model.addAttribute("userName", userDetails.getName());
            
            // 장바구니 아이템 조회
            List<CartItemResponse> cartItems = 
                    cartService.getCartItems(userDetails.getMemberId());
            model.addAttribute("cartItems", cartItems);
            
            // 총 금액 계산
            java.math.BigDecimal totalAmount = cartItems.stream()
                    .map(CartItemResponse::getSubtotal)
                    .reduce(java.math.BigDecimal.ZERO, java.math.BigDecimal::add);
            model.addAttribute("totalAmount", totalAmount);
            
            log.info("장바구니 조회 완료: memberId={}, 아이템 수={}, 총 금액={}", 
                    userDetails.getMemberId(), cartItems.size(), totalAmount);
        } else {
            model.addAttribute("isAuthenticated", false);
            // 비로그인 상태에서는 로그인 페이지로 리다이렉트 (Spring Security가 자동으로 처리)
            return "redirect:/auth/login?redirectUrl=" + request.getRequestURL();
        }
        
        return "order/cart";
    }
    
    /**
     * 장바구니 아이템 삭제
     * POST /cart/remove
     */
    @PostMapping("/cart/remove")
    public String removeCartItems(
            @RequestParam(value = "cartItemIds[]", required = false) List<Long> cartItemIds
    ) {
        if (cartItemIds != null && !cartItemIds.isEmpty()) {
            cartService.removeItems(cartItemIds);
            log.info("장바구니 아이템 삭제: {} 개", cartItemIds.size());
        }
        return "redirect:/cart";
    }
    
    /**
     * 주문내역 확인 페이지
     * GET /order/checkout
     */
    @GetMapping("/order/checkout")
    public String checkout(
            @RequestParam(value = "bookId", required = false) Long bookId,
            @RequestParam(value = "quantity", required = false) Integer quantity,
            @RequestParam(value = "directBuy", required = false) Boolean directBuy,
            @AuthenticationPrincipal CustomUserDetails userDetails, 
            Model model) {
        
        if (userDetails == null) {
            log.info("주문내역 확인 페이지 접속: 비로그인 사용자");
            model.addAttribute("isAuthenticated", false);
            return "order/checkout";
        }
        
        log.info("주문내역 확인 페이지 접속: 로그인 사용자 = {}, 바로구매 = {}, 책ID = {}, 수량 = {}", 
                userDetails.getUsername(), directBuy, bookId, quantity);
        
        // 로그인 상태
        model.addAttribute("isAuthenticated", true);
        model.addAttribute("userName", userDetails.getName());
        model.addAttribute("userId", userDetails.getUsername());
        
        // 회원의 주소 정보 및 연락처 조회
        try {
            Long memberId = userDetails.getMemberId();
            MemberResponse memberInfo = memberService.getMemberInfo(memberId);
            model.addAttribute("memberAddresses", memberInfo.getAddresses());
            model.addAttribute("memberPhone", memberInfo.getPhone());
            log.info("회원 정보 조회 완료: 주소 개수 = {}, 연락처 = {}", 
                    memberInfo.getAddresses().size(), memberInfo.getPhone());
        } catch (Exception e) {
            log.error("회원 정보 조회 실패: {}", e.getMessage(), e);
            model.addAttribute("memberAddresses", List.of());
            model.addAttribute("memberPhone", "");
        }
        
        // 바로 구매인 경우 책 정보를 장바구니 아이템 형태로 변환
        if (directBuy != null && directBuy && bookId != null && quantity != null) {
            try {
                // 책 정보 조회
                BookListResponse book = bookService.getBookById(bookId);
                
                // CartItemResponse 형태로 변환
                CartItemResponse directBuyItem = CartItemResponse.builder()
                        .bookId(book.getBookId())
                        .title(book.getTitle())
                        .authors(book.getAuthors())
                        .publisher(book.getPublisher())
                        .thumbnailUrl(book.getThumbnailUrl())
                        .price(book.getPrice())
                        .quantity(quantity)
                        .subtotal(book.getPrice().multiply(java.math.BigDecimal.valueOf(quantity)))
                        .build();
                
                List<CartItemResponse> cartItems = List.of(directBuyItem);
                Integer totalAmount = directBuyItem.getSubtotal().intValue();
                
                model.addAttribute("cartItems", cartItems);
                model.addAttribute("totalAmount", totalAmount);
                model.addAttribute("directBuy", true);
                
                log.info("바로 구매 모드: bookId={}, quantity={}, 총 금액={}", bookId, quantity, totalAmount);
            } catch (Exception e) {
                log.error("바로 구매 아이템 로드 실패: {}", e.getMessage(), e);
                model.addAttribute("cartItems", List.of());
                model.addAttribute("totalAmount", 0);
            }
        } else {
            // 장바구니에서 온 경우 장바구니 아이템 로드
            log.info("장바구니 모드: directBuy={}, 사용자ID={}", directBuy, userDetails.getUsername());
            try {
                Long memberId = userDetails.getMemberId();
                log.info("장바구니 조회 시작: memberId={}", memberId);
                
                List<CartItemResponse> cartItems = cartService.getCartItems(memberId);
                log.info("장바구니 조회 결과: 아이템 수={}", cartItems.size());
                
                Integer totalAmount = cartItems.stream()
                        .mapToInt(item -> item.getSubtotal().intValue())
                        .sum();
                
                model.addAttribute("cartItems", cartItems);
                model.addAttribute("totalAmount", totalAmount);
                
                log.info("장바구니 데이터 로드 완료: 아이템 수={}, 총 금액={}", cartItems.size(), totalAmount);
            } catch (Exception e) {
                log.error("장바구니 데이터 로드 실패: {}", e.getMessage(), e);
                model.addAttribute("cartItems", List.of());
                model.addAttribute("totalAmount", 0);
            }
        }
        
        return "order/checkout";
    }
    
    /**
     * 토스페이먼츠 결제 페이지
     * GET /order/payment
     */
    @GetMapping("/order/payment")
    public String payment(
            @RequestParam("totalAmount") Integer totalAmount,
            @RequestParam(value = "recipientName", required = false) String recipientName,
            @RequestParam(value = "recipientPhone", required = false) String recipientPhone,
            @RequestParam(value = "deliveryAddress", required = false) String deliveryAddress,
            @RequestParam(value = "zipCode", required = false) String zipCode,
            @RequestParam(value = "deliveryMemo", required = false) String deliveryMemo,
            @AuthenticationPrincipal CustomUserDetails userDetails,
            Model model) {
        
        if (userDetails == null) {
            log.info("결제 페이지 접속: 비로그인 사용자");
            return "redirect:/auth/login";
        }
        
        log.info("결제 페이지 접속: 사용자={}, 총 금액={}, 수령인={}, 연락처={}", 
                userDetails.getUsername(), totalAmount, recipientName, recipientPhone);
        
        // 로그인 상태
        model.addAttribute("isAuthenticated", true);
        model.addAttribute("userName", userDetails.getName());
        model.addAttribute("userId", userDetails.getUsername());
        model.addAttribute("totalAmount", totalAmount);
        
        // 배송지 정보
        model.addAttribute("recipientName", recipientName);
        model.addAttribute("recipientPhone", recipientPhone);
        model.addAttribute("deliveryAddress", deliveryAddress);
        model.addAttribute("zipCode", zipCode);
        model.addAttribute("deliveryMemo", deliveryMemo);
        
        return "order/payment";
    }
    
    /**
     * 결제 성공 페이지
     * GET /order/payment/success
     */
    @GetMapping("/order/payment/success")
    public String paymentSuccess(
            @RequestParam("orderId") String orderId,
            @RequestParam("paymentKey") String paymentKey,
            @RequestParam("amount") Integer amount,
            @AuthenticationPrincipal CustomUserDetails userDetails,
            Model model) {
        
        if (userDetails == null) {
            log.info("결제 성공 페이지 접속: 비로그인 사용자");
            return "redirect:/auth/login";
        }
        
        log.info("결제 성공: 사용자={}, 주문ID={}, 결제키={}, 금액={}", 
                userDetails.getUsername(), orderId, paymentKey, amount);
        
        // 로그인 상태
        model.addAttribute("isAuthenticated", true);
        model.addAttribute("userName", userDetails.getName());
        model.addAttribute("orderId", orderId);
        model.addAttribute("amount", amount);
        
        return "order/payment-success";
    }
    
    /**
     * 결제 실패 페이지
     * GET /order/payment/fail
     */
    @GetMapping("/order/payment/fail")
    public String paymentFail(
            @RequestParam(value = "code", required = false) String code,
            @RequestParam(value = "message", required = false) String message,
            @AuthenticationPrincipal CustomUserDetails userDetails,
            Model model) {
        
        log.info("결제 실패: 사용자={}, 코드={}, 메시지={}", 
                userDetails != null ? userDetails.getUsername() : "비로그인", code, message);
        
        // 로그인 상태
        if (userDetails != null) {
            model.addAttribute("isAuthenticated", true);
            model.addAttribute("userName", userDetails.getName());
        } else {
            model.addAttribute("isAuthenticated", false);
        }
        
        model.addAttribute("errorCode", code);
        model.addAttribute("errorMessage", message);
        
        return "order/payment-fail";
    }
    
    /**
     * 주문 목록 페이지
     * GET /order/list
     */
    @GetMapping("/order/list")
    public String orderList(@AuthenticationPrincipal CustomUserDetails userDetails, Model model) {
        if (userDetails == null) {
            log.info("주문 목록 페이지 접속: 비로그인 사용자");
            return "redirect:/auth/login";
        }
        
        log.info("주문 목록 페이지 접속: 사용자={}", userDetails.getUsername());
        
        // 로그인 상태
        model.addAttribute("isAuthenticated", true);
        model.addAttribute("userName", userDetails.getName());
        
        return "order/order-history";
    }
    
    /**
     * 주문 내역 페이지
     * GET /order/history
     */
    @GetMapping("/order/history")
    public String orderHistory(@AuthenticationPrincipal CustomUserDetails userDetails, Model model) {
        if (userDetails == null) {
            log.info("주문 내역 페이지 접속: 비로그인 사용자");
            return "redirect:/auth/login";
        }
        
        log.info("주문 내역 페이지 접속: 사용자={}", userDetails.getUsername());
        
        try {
            // 주문 내역 조회
            List<OrderHistoryResponse> orders = orderService.getOrderHistory(userDetails.getMemberId());
            
            // 로그인 상태
            model.addAttribute("isAuthenticated", true);
            model.addAttribute("userName", userDetails.getName());
            model.addAttribute("orders", orders);
            
            log.info("주문 내역 조회 완료: 사용자={}, 주문수={}", userDetails.getUsername(), orders.size());
            
            return "order/order-history";
        } catch (Exception e) {
            log.error("주문 내역 조회 실패: 사용자={}, 오류={}", userDetails.getUsername(), e.getMessage(), e);
            model.addAttribute("isAuthenticated", true);
            model.addAttribute("userName", userDetails.getName());
            model.addAttribute("orders", new ArrayList<>());
            return "order/order-history";
        }
    }
    
    /**
     * 주문 상세 페이지
     * GET /order/{orderId}/detail
     */
    @GetMapping("/order/{orderId}/detail")
    public String orderDetail(@PathVariable Long orderId, 
                             @AuthenticationPrincipal CustomUserDetails userDetails, 
                             Model model) {
        if (userDetails == null) {
            log.info("주문 상세 페이지 접속: 비로그인 사용자");
            return "redirect:/auth/login";
        }
        
        log.info("주문 상세 페이지 접속: 주문ID={}, 사용자={}", orderId, userDetails.getUsername());
        
        try {
            // 주문 상세 정보 조회
            OrderHistoryResponse orderDetail = orderService.getOrderDetail(orderId, userDetails.getMemberId());
            
                // 로그인 상태
                model.addAttribute("isAuthenticated", true);
                model.addAttribute("userName", userDetails.getName());
                model.addAttribute("orderId", orderId);
                model.addAttribute("order", orderDetail);
                
                // 리뷰 작성용 첫 번째 책 ID 추가
                if (!orderDetail.getOrderItems().isEmpty()) {
                    model.addAttribute("firstBookId", orderDetail.getOrderItems().get(0).getBookId());
                }
            
            log.info("주문 상세 정보 조회 완료: 주문ID={}, 주문상태={}, 총금액={}", 
                    orderId, orderDetail.getOrderStatus(), orderDetail.getTotalAmount());
            
            return "order/order-detail";
        } catch (IllegalArgumentException e) {
            log.error("주문을 찾을 수 없거나 권한이 없음: 주문ID={}, 사용자={}", orderId, userDetails.getUsername());
            return "redirect:/order/history";
        } catch (Exception e) {
            log.error("주문 상세 조회 실패: 주문ID={}, 오류={}", orderId, e.getMessage(), e);
            return "redirect:/order/history";
        }
    }
}
