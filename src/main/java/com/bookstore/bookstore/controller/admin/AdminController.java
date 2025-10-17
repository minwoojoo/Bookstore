package com.bookstore.bookstore.controller.admin;

import com.bookstore.bookstore.dto.admin.AdminBookListRequest;
import com.bookstore.bookstore.dto.admin.AdminBookListResponse;
import com.bookstore.bookstore.dto.admin.AdminOrderListRequest;
import com.bookstore.bookstore.dto.admin.AdminOrderListResponse;
import com.bookstore.bookstore.dto.admin.AdminMemberListRequest;
import com.bookstore.bookstore.dto.admin.AdminMemberListResponse;
import com.bookstore.bookstore.dto.admin.AdminBookDetailResponse;
import com.bookstore.bookstore.dto.admin.AdminOrderDetailResponse;
import com.bookstore.bookstore.dto.admin.AdminMemberDetailResponse;
import com.bookstore.bookstore.dto.admin.AdminDashboardStatsResponse;
import com.bookstore.bookstore.dto.admin.AdminRecentActivityResponse;
import com.bookstore.bookstore.dto.admin.AdminBookStockRequest;
import com.bookstore.bookstore.dto.admin.AdminBookStockResponse;
import com.bookstore.bookstore.dto.admin.AdminBookCreateRequest;
import com.bookstore.bookstore.entity.book.Category;
import com.bookstore.bookstore.service.admin.AdminService;
import com.bookstore.bookstore.security.CustomUserDetails;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.WebDataBinder;
import jakarta.validation.Valid;
import org.springframework.beans.propertyeditors.CustomNumberEditor;

import java.util.List;

/**
 * 관리자 페이지 컨트롤러
 */
@Slf4j
@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {
    
    private final AdminService adminService;
    
    /**
     * 빈 문자열을 null로 변환하는 바인더
     */
    @InitBinder
    public void initBinder(WebDataBinder binder) {
        binder.registerCustomEditor(Integer.class, new CustomNumberEditor(Integer.class, true) {
            @Override
            public void setAsText(String text) throws IllegalArgumentException {
                if (text == null || text.trim().isEmpty()) {
                    setValue(null);
                } else {
                    super.setAsText(text);
                }
            }
        });
    }
    
    /**
     * 관리자 메인 페이지
     */
    @GetMapping
    public String adminMain(@AuthenticationPrincipal CustomUserDetails userDetails, Model model) {
        if (userDetails == null) {
            // 로그인하지 않은 사용자
            return "redirect:/auth/login";
        }
        
        if (!"ADMIN".equals(userDetails.getRole())) {
            // 일반 사용자가 관리자 페이지에 접근한 경우 - 페이지에 머물면서 팝업 표시
            model.addAttribute("errorMessage", "관리자 계정으로만 접근이 가능합니다.");
            model.addAttribute("showAlert", true);
            model.addAttribute("isUnauthorized", true);
            // 관리자 페이지를 그대로 렌더링하되 권한 없음 상태로 표시
            return "admin/main";
        }
        
        // 대시보드 통계 데이터 조회
        AdminDashboardStatsResponse stats = adminService.getDashboardStats();
        List<AdminRecentActivityResponse> recentActivities = adminService.getRecentActivities();
        
        model.addAttribute("isAuthenticated", true);
        model.addAttribute("userName", userDetails.getName());
        model.addAttribute("isAdmin", true);
        model.addAttribute("stats", stats);
        model.addAttribute("recentActivities", recentActivities);
        
        return "admin/main";
    }
    
    /**
     * 상품 목록 조회
     */
    @GetMapping("/books")
    public String getBookList(
            @ModelAttribute AdminBookListRequest request,
            @AuthenticationPrincipal CustomUserDetails userDetails,
            Model model) {
        
        if (userDetails == null || !"ADMIN".equals(userDetails.getRole())) {
            return "redirect:/auth/login";
        }
        
        log.info("관리자 상품 목록 조회 요청: page={}, size={}, sortBy={}, sortDirection={}", 
                request.getPage(), request.getSize(), request.getSortBy(), request.getSortDirection());
        
        Page<AdminBookListResponse> books = adminService.getBookList(request);
        
        log.info("컨트롤러 결과: totalElements={}, totalPages={}, currentPage={}, contentSize={}", 
                books.getTotalElements(), books.getTotalPages(), books.getNumber(), books.getContent().size());
        
        model.addAttribute("isAuthenticated", true);
        model.addAttribute("userName", userDetails.getName());
        model.addAttribute("isAdmin", true);
        model.addAttribute("books", books);
        
        return "admin/book-list";
    }
    
    
    /**
     * 상품 상세 조회
     */
    @GetMapping("/books/{bookId}")
    public String getBookDetail(
            @PathVariable Long bookId,
            @AuthenticationPrincipal CustomUserDetails userDetails,
            Model model) {
        
        if (userDetails == null || !"ADMIN".equals(userDetails.getRole())) {
            return "redirect:/auth/login";
        }
        
        log.info("관리자 상품 상세 조회: bookId={}", bookId);
        
        AdminBookDetailResponse book = adminService.getBookDetail(bookId);
        
        model.addAttribute("isAuthenticated", true);
        model.addAttribute("userName", userDetails.getName());
        model.addAttribute("isAdmin", true);
        model.addAttribute("book", book);
        
        return "admin/book-detail";
    }
    
    /**
     * 주문 목록 조회
     */
    @GetMapping("/orders")
    public String getOrderList(
            @ModelAttribute AdminOrderListRequest request,
            @AuthenticationPrincipal CustomUserDetails userDetails,
            Model model) {
        
        if (userDetails == null || !"ADMIN".equals(userDetails.getRole())) {
            return "redirect:/auth/login";
        }
        
        log.info("관리자 주문 목록 조회: {}", request);
        
        Page<AdminOrderListResponse> orders = adminService.getOrderList(request);
        
        model.addAttribute("isAuthenticated", true);
        model.addAttribute("userName", userDetails.getName());
        model.addAttribute("isAdmin", true);
        model.addAttribute("orders", orders);
        model.addAttribute("request", request);
        
        return "admin/order-list";
    }
    
    /**
     * 주문 상세 조회
     */
    @GetMapping("/orders/{orderId}")
    public String getOrderDetail(
            @PathVariable Long orderId,
            @AuthenticationPrincipal CustomUserDetails userDetails,
            Model model) {
        
        if (userDetails == null || !"ADMIN".equals(userDetails.getRole())) {
            return "redirect:/auth/login";
        }
        
        log.info("관리자 주문 상세 조회: orderId={}", orderId);
        
        AdminOrderDetailResponse order = adminService.getOrderDetail(orderId);
        
        model.addAttribute("isAuthenticated", true);
        model.addAttribute("userName", userDetails.getName());
        model.addAttribute("isAdmin", true);
        model.addAttribute("order", order);
        
        return "admin/admin-order-detail";
    }
    
    /**
     * 주문 상태 변경
     */
    @PostMapping("/orders/{orderId}/status")
    public String updateOrderStatus(
            @PathVariable Long orderId,
            @RequestParam String status,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        
        if (userDetails == null || !"ADMIN".equals(userDetails.getRole())) {
            return "redirect:/auth/login";
        }
        
        log.info("관리자 주문 상태 변경: orderId={}, status={}", orderId, status);
        
        adminService.updateOrderStatus(orderId, status);
        
        return "redirect:/admin/orders/" + orderId;
    }
    
    /**
     * 회원 목록 조회
     */
    @GetMapping("/members")
    public String getMemberList(
            @ModelAttribute AdminMemberListRequest request,
            @AuthenticationPrincipal CustomUserDetails userDetails,
            Model model) {
        
        if (userDetails == null) {
            return "redirect:/auth/login";
        }
        
        if (!"ADMIN".equals(userDetails.getRole())) {
            model.addAttribute("errorMessage", "관리자 계정으로만 접근이 가능합니다.");
            model.addAttribute("showAlert", true);
            model.addAttribute("isUnauthorized", true);
            return "admin/members";
        }
        
        log.info("관리자 회원 목록 조회: {}", request);
        
        Page<AdminMemberListResponse> memberPage = adminService.getMemberList(request);
        
        // 페이징 정보 계산
        int currentPage = memberPage.getNumber();
        int totalPages = memberPage.getTotalPages();
        long totalElements = memberPage.getTotalElements();
        int pageSize = memberPage.getSize();
        
        model.addAttribute("isAuthenticated", true);
        model.addAttribute("userName", userDetails.getName());
        model.addAttribute("isAdmin", true);
        model.addAttribute("members", memberPage.getContent());
        model.addAttribute("currentPage", currentPage);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("totalElements", totalElements);
        model.addAttribute("pageSize", pageSize);
        model.addAttribute("request", request);
        
        return "admin/members";
    }
    
    /**
     * 회원 상세 조회
     */
    @GetMapping("/members/{memberId}")
    public String getMemberDetail(
            @PathVariable Long memberId,
            @AuthenticationPrincipal CustomUserDetails userDetails,
            Model model) {
        
        if (userDetails == null) {
            return "redirect:/auth/login";
        }
        
        if (!"ADMIN".equals(userDetails.getRole())) {
            model.addAttribute("errorMessage", "관리자 계정으로만 접근이 가능합니다.");
            model.addAttribute("showAlert", true);
            model.addAttribute("isUnauthorized", true);
            return "admin/member-detail";
        }
        
        log.info("관리자 회원 상세 조회: memberId={}", memberId);
        
        AdminMemberDetailResponse member = adminService.getMemberDetail(memberId);
        
        model.addAttribute("isAuthenticated", true);
        model.addAttribute("userName", userDetails.getName());
        model.addAttribute("isAdmin", true);
        model.addAttribute("member", member);
        
        return "admin/member-detail";
    }
    
    /**
     * 회원의 주문 목록 조회
     */
    @GetMapping("/members/{memberId}/orders")
    public String getMemberOrders(
            @PathVariable Long memberId,
            @ModelAttribute AdminOrderListRequest request,
            @AuthenticationPrincipal CustomUserDetails userDetails,
            Model model) {
        
        if (userDetails == null || !"ADMIN".equals(userDetails.getRole())) {
            return "redirect:/auth/login";
        }
        
        log.info("관리자 회원 주문 목록 조회: memberId={}, {}", memberId, request);
        
        // 회원 ID로 필터링된 주문 목록 조회
        request.setMemberId(memberId);
        Page<AdminOrderListResponse> orders = adminService.getOrderList(request);
        
        model.addAttribute("isAuthenticated", true);
        model.addAttribute("userName", userDetails.getName());
        model.addAttribute("isAdmin", true);
        model.addAttribute("orders", orders);
        model.addAttribute("request", request);
        model.addAttribute("memberId", memberId);
        
        return "admin/member-orders";
    }

    /**
     * 도서 재고 관리 화면
     */
    @GetMapping("/books/{bookId}/stock")
    public String getBookStockManagement(@PathVariable Long bookId, @AuthenticationPrincipal CustomUserDetails userDetails, Model model) {
        if (userDetails == null) {
            return "redirect:/auth/login";
        }

        if (!"ADMIN".equals(userDetails.getRole())) {
            model.addAttribute("errorMessage", "관리자 계정으로만 접근이 가능합니다.");
            model.addAttribute("showAlert", true);
            model.addAttribute("isUnauthorized", true);
            return "admin/book-stock";
        }

        AdminBookStockResponse stockInfo = adminService.getBookStockInfo(bookId);
        model.addAttribute("isAuthenticated", true);
        model.addAttribute("userName", userDetails.getName());
        model.addAttribute("isAdmin", true);
        model.addAttribute("book", stockInfo);
        model.addAttribute("stockHistory", stockInfo.getStockHistory());

        return "admin/book-stock";
    }

    /**
     * 도서 재고 업데이트
     */
    @PostMapping("/books/{bookId}/stock")
    public String updateBookStock(@PathVariable Long bookId, 
                               @ModelAttribute AdminBookStockRequest request,
                               @AuthenticationPrincipal CustomUserDetails userDetails,
                               Model model) {
        if (userDetails == null || !"ADMIN".equals(userDetails.getRole())) {
            return "redirect:/auth/login";
        }

        try {
            adminService.updateBookStock(bookId, request);
            return "redirect:/admin/books/" + bookId + "/stock?success=true";
        } catch (Exception e) {
            log.error("재고 업데이트 실패: bookId={}, error={}", bookId, e.getMessage());
            model.addAttribute("errorMessage", "재고 업데이트에 실패했습니다: " + e.getMessage());
            return "redirect:/admin/books/" + bookId + "/stock?error=true";
        }
    }
    
    /**
     * 새 상품 등록 화면
     */
    @GetMapping("/books/new")
    public String getBookCreateForm(@AuthenticationPrincipal CustomUserDetails userDetails, Model model) {
        if (userDetails == null || !"ADMIN".equals(userDetails.getRole())) {
            return "redirect:/auth/login";
        }
        
        log.info("상품 등록 화면 접근: {}", userDetails.getUsername());
        
        // 카테고리 목록 조회
        List<Category> categories = adminService.getAllCategories();
        
        model.addAttribute("isAuthenticated", true);
        model.addAttribute("userName", userDetails.getName());
        model.addAttribute("isAdmin", true);
        model.addAttribute("categories", categories);
        model.addAttribute("bookCreateRequest", new AdminBookCreateRequest());
        
        return "admin/book-create";
    }
    
    /**
     * 새 상품 등록 처리
     */
    @PostMapping("/books/new")
    public String createBook(@ModelAttribute @Valid AdminBookCreateRequest request,
                           @AuthenticationPrincipal CustomUserDetails userDetails,
                           Model model) {
        if (userDetails == null || !"ADMIN".equals(userDetails.getRole())) {
            return "redirect:/auth/login";
        }
        
        log.info("상품 등록 요청: {}, {}", userDetails.getUsername(), request);
        
        try {
            Long bookId = adminService.createBook(request, userDetails.getAdminId());
            return "redirect:/admin/books?success=true&bookId=" + bookId;
        } catch (Exception e) {
            log.error("상품 등록 실패: {}", e.getMessage(), e);
            
            // 카테고리 목록 다시 조회
            List<Category> categories = adminService.getAllCategories();
            
            model.addAttribute("isAuthenticated", true);
            model.addAttribute("userName", userDetails.getName());
            model.addAttribute("isAdmin", true);
            model.addAttribute("categories", categories);
            model.addAttribute("bookCreateRequest", request);
            model.addAttribute("errorMessage", "상품 등록에 실패했습니다: " + e.getMessage());
            
            return "admin/book-create";
        }
    }
    
}
