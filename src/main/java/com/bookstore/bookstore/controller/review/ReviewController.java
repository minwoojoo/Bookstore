package com.bookstore.bookstore.controller.review;

import com.bookstore.bookstore.dto.review.ReviewRequest;
import com.bookstore.bookstore.dto.review.ReviewResponse;
import com.bookstore.bookstore.security.CustomUserDetails;
import com.bookstore.bookstore.service.review.ReviewService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/api/reviews")
@RequiredArgsConstructor
public class ReviewController {
    
    private final ReviewService reviewService;
    
    /**
     * 리뷰 작성
     */
    @PostMapping
    public ResponseEntity<Map<String, Object>> createReview(
            @RequestBody ReviewRequest request,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        
        if (userDetails == null) {
            return ResponseEntity.status(401).body(Map.of(
                    "success", false,
                    "message", "로그인이 필요합니다."
            ));
        }
        
        try {
            log.info("리뷰 작성 요청: bookId={}, memberId={}", request.getBookId(), userDetails.getMemberId());
            
            ReviewResponse review = reviewService.createReview(request, userDetails.getMemberId());
            
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "리뷰가 작성되었습니다.",
                    "review", review
            ));
        } catch (IllegalArgumentException e) {
            log.error("리뷰 작성 실패 - 잘못된 요청: {}", e.getMessage());
            return ResponseEntity.status(400).body(Map.of(
                    "success", false,
                    "message", e.getMessage()
            ));
        } catch (IllegalStateException e) {
            log.error("리뷰 작성 실패 - 비즈니스 로직 오류: {}", e.getMessage());
            return ResponseEntity.status(409).body(Map.of(
                    "success", false,
                    "message", e.getMessage()
            ));
        } catch (Exception e) {
            log.error("리뷰 작성 실패: {}", e.getMessage(), e);
            return ResponseEntity.status(500).body(Map.of(
                    "success", false,
                    "message", "리뷰 작성 중 오류가 발생했습니다: " + e.getMessage()
            ));
        }
    }
    
    
    /**
     * 리뷰 삭제
     */
    @DeleteMapping("/{reviewId}")
    public ResponseEntity<Map<String, Object>> deleteReview(
            @PathVariable Long reviewId,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        
        if (userDetails == null) {
            return ResponseEntity.status(401).body(Map.of(
                    "success", false,
                    "message", "로그인이 필요합니다."
            ));
        }
        
        try {
            log.info("리뷰 삭제 요청: reviewId={}, memberId={}", reviewId, userDetails.getMemberId());
            
            reviewService.deleteReview(reviewId, userDetails.getMemberId());
            
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "리뷰가 삭제되었습니다."
            ));
        } catch (IllegalArgumentException e) {
            log.error("리뷰 삭제 실패 - 잘못된 요청: {}", e.getMessage());
            return ResponseEntity.status(400).body(Map.of(
                    "success", false,
                    "message", e.getMessage()
            ));
        } catch (IllegalStateException e) {
            log.error("리뷰 삭제 실패 - 권한 없음: {}", e.getMessage());
            return ResponseEntity.status(403).body(Map.of(
                    "success", false,
                    "message", e.getMessage()
            ));
        } catch (Exception e) {
            log.error("리뷰 삭제 실패: {}", e.getMessage(), e);
            return ResponseEntity.status(500).body(Map.of(
                    "success", false,
                    "message", "리뷰 삭제 중 오류가 발생했습니다: " + e.getMessage()
            ));
        }
    }
    
    /**
     * 특정 책의 리뷰 목록 조회
     */
    @GetMapping("/book/{bookId}")
    public ResponseEntity<Map<String, Object>> getReviewsByBookId(
            @PathVariable Long bookId,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        
        try {
            log.info("책 리뷰 목록 조회: bookId={}", bookId);
            
            Long memberId = userDetails != null ? userDetails.getMemberId() : null;
            List<ReviewResponse> reviews = reviewService.getReviewsByBookId(bookId, memberId);
            
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "reviews", reviews
            ));
        } catch (Exception e) {
            log.error("책 리뷰 목록 조회 실패: {}", e.getMessage(), e);
            return ResponseEntity.status(500).body(Map.of(
                    "success", false,
                    "message", "리뷰 목록 조회 중 오류가 발생했습니다: " + e.getMessage()
            ));
        }
    }
    
    /**
     * 특정 책과 회원의 리뷰 조회 (리뷰 작성 여부 확인용)
     */
    @GetMapping("/book/{bookId}/member")
    public ResponseEntity<Map<String, Object>> getReviewByBookAndMember(
            @PathVariable Long bookId,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        
        if (userDetails == null) {
            return ResponseEntity.status(401).body(Map.of(
                    "success", false,
                    "message", "로그인이 필요합니다."
            ));
        }
        
        try {
            log.info("책-회원 리뷰 조회: bookId={}, memberId={}", bookId, userDetails.getMemberId());
            
            ReviewResponse review = reviewService.getReviewByBookAndMember(bookId, userDetails.getMemberId());
            
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "review", review
            ));
        } catch (Exception e) {
            log.error("책-회원 리뷰 조회 실패: {}", e.getMessage(), e);
            return ResponseEntity.status(500).body(Map.of(
                    "success", false,
                    "message", "리뷰 조회 중 오류가 발생했습니다: " + e.getMessage()
            ));
        }
    }
}
