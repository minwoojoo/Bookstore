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
import com.bookstore.bookstore.service.admin.AdminService;
import com.bookstore.bookstore.security.CustomUserDetails;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

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
     * 관리자 메인 페이지
     */
    @GetMapping
    public String adminMain(@AuthenticationPrincipal CustomUserDetails userDetails, Model model) {
        if (userDetails == null) {
            // 로그인하지 않은 사용자
            return "redirect:/auth/login";
        }
        
        if (!"ADMIN".equals(userDetails.getRole())) {
            // 일반 사용자가 관리자 페이지에 접근한 경우
            model.addAttribute("errorMessage", "허용되지 않은 사용자입니다.");
            model.addAttribute("showAlert", true);
            return "redirect:/?error=unauthorized";
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
        
        log.info("관리자 상품 목록 조회: {}", request);
        
        Page<AdminBookListResponse> books = adminService.getBookList(request);
        
        model.addAttribute("isAuthenticated", true);
        model.addAttribute("userName", userDetails.getName());
        model.addAttribute("isAdmin", true);
        model.addAttribute("books", books);
        model.addAttribute("request", request);
        
        return "admin/book-list";
    }
    
    /**
     * 상품 등록 화면
     */
    @GetMapping("/books/new")
    public String createBookForm(@AuthenticationPrincipal CustomUserDetails userDetails, Model model) {
        if (userDetails == null || !"ADMIN".equals(userDetails.getRole())) {
            return "redirect:/auth/login";
        }
        
        model.addAttribute("isAuthenticated", true);
        model.addAttribute("userName", userDetails.getName());
        model.addAttribute("isAdmin", true);
        
        return "admin/book-form";
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
        
        return "admin/order-detail";
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
        
        if (userDetails == null || !"ADMIN".equals(userDetails.getRole())) {
            return "redirect:/auth/login";
        }
        
        log.info("관리자 회원 목록 조회: {}", request);
        
        Page<AdminMemberListResponse> members = adminService.getMemberList(request);
        
        model.addAttribute("isAuthenticated", true);
        model.addAttribute("userName", userDetails.getName());
        model.addAttribute("isAdmin", true);
        model.addAttribute("members", members);
        model.addAttribute("request", request);
        
        return "admin/member-list";
    }
    
    /**
     * 회원 상세 조회
     */
    @GetMapping("/members/{memberId}")
    public String getMemberDetail(
            @PathVariable Long memberId,
            @AuthenticationPrincipal CustomUserDetails userDetails,
            Model model) {
        
        if (userDetails == null || !"ADMIN".equals(userDetails.getRole())) {
            return "redirect:/auth/login";
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
}
