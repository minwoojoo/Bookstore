package com.bookstore.bookstore.service.review;

import com.bookstore.bookstore.dto.review.ReviewRequest;
import com.bookstore.bookstore.dto.review.ReviewResponse;
import com.bookstore.bookstore.entity.book.Book;
import com.bookstore.bookstore.entity.customer.Member;
import com.bookstore.bookstore.entity.review.Review;
import com.bookstore.bookstore.repository.book.BookRepository;
import com.bookstore.bookstore.repository.customer.MemberRepository;
import com.bookstore.bookstore.repository.review.ReviewRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ReviewService {
    
    private final ReviewRepository reviewRepository;
    private final BookRepository bookRepository;
    private final MemberRepository memberRepository;
    
    /**
     * 리뷰 작성
     */
    @Transactional
    public ReviewResponse createReview(ReviewRequest request, Long memberId) {
        log.info("리뷰 작성: bookId={}, memberId={}, rating={}", request.getBookId(), memberId, request.getRating());
        
        // 책 존재 확인
        Book book = bookRepository.findById(request.getBookId())
                .orElseThrow(() -> new IllegalArgumentException("책을 찾을 수 없습니다: " + request.getBookId()));
        
        // 회원 존재 확인
        Member member = memberRepository.findById(memberId)
                .orElseThrow(() -> new IllegalArgumentException("회원을 찾을 수 없습니다: " + memberId));
        
        // 중복 리뷰 확인
        if (reviewRepository.findByBookBookIdAndMemberMemberId(request.getBookId(), memberId).isPresent()) {
            throw new IllegalStateException("이미 리뷰를 작성한 책입니다.");
        }
        
        // 리뷰 생성
        Review review = Review.builder()
                .book(book)
                .member(member)
                .rating(request.getRating())
                .content(request.getContent())
                .build();
        
        Review savedReview = reviewRepository.save(review);
        log.info("리뷰 작성 완료: reviewId={}", savedReview.getReviewId());
        
        return convertToResponse(savedReview, memberId);
    }
    
    
    /**
     * 리뷰 삭제
     */
    @Transactional
    public void deleteReview(Long reviewId, Long memberId) {
        log.info("리뷰 삭제: reviewId={}, memberId={}", reviewId, memberId);
        
        Review review = reviewRepository.findById(reviewId)
                .orElseThrow(() -> new IllegalArgumentException("리뷰를 찾을 수 없습니다: " + reviewId));
        
        // 권한 확인
        if (!review.getMember().getMemberId().equals(memberId)) {
            throw new IllegalStateException("리뷰를 삭제할 권한이 없습니다.");
        }
        
        reviewRepository.delete(review);
        log.info("리뷰 삭제 완료: reviewId={}", reviewId);
    }
    
    /**
     * 특정 책의 리뷰 목록 조회
     */
    public List<ReviewResponse> getReviewsByBookId(Long bookId, Long memberId) {
        log.info("책 리뷰 목록 조회: bookId={}", bookId);
        
        List<Review> reviews = reviewRepository.findByBookBookIdOrderByCreatedDateDesc(bookId);
        log.info("조회된 리뷰 수: {}", reviews.size());
        
        List<ReviewResponse> responses = reviews.stream()
                .map(review -> convertToResponse(review, memberId))
                .collect(Collectors.toList());
        
        log.info("변환된 리뷰 응답 수: {}", responses.size());
        return responses;
    }
    
    /**
     * 특정 회원의 리뷰 목록 조회
     */
    public List<ReviewResponse> getReviewsByMemberId(Long memberId) {
        log.info("회원 리뷰 목록 조회: memberId={}", memberId);
        
        List<Review> reviews = reviewRepository.findByMemberMemberIdOrderByCreatedDateDesc(memberId);
        
        return reviews.stream()
                .map(review -> convertToResponse(review, memberId))
                .collect(Collectors.toList());
    }
    
    /**
     * 특정 책과 회원의 리뷰 조회 (리뷰 작성 여부 확인용)
     */
    public ReviewResponse getReviewByBookAndMember(Long bookId, Long memberId) {
        log.info("책-회원 리뷰 조회: bookId={}, memberId={}", bookId, memberId);
        
        return reviewRepository.findByBookBookIdAndMemberMemberId(bookId, memberId)
                .map(review -> convertToResponse(review, memberId))
                .orElse(null);
    }
    
    /**
     * 책의 평균 평점 조회
     */
    public Double getAverageRating(Long bookId) {
        log.info("책 평균 평점 조회: bookId={}", bookId);
        Double avgRating = reviewRepository.findAverageRatingByBookId(bookId);
        log.info("조회된 평균 평점: {}", avgRating);
        return avgRating;
    }
    
    /**
     * 책의 리뷰 개수 조회
     */
    public Long getReviewCount(Long bookId) {
        return reviewRepository.countByBookBookId(bookId);
    }
    
    /**
     * Review 엔티티를 ReviewResponse로 변환
     */
    private ReviewResponse convertToResponse(Review review, Long currentMemberId) {
        boolean canEdit = review.getMember().getMemberId().equals(currentMemberId);
        boolean canDelete = review.getMember().getMemberId().equals(currentMemberId);
        
        log.info("ReviewResponse 변환: reviewId={}, content='{}', rating={}", 
                review.getReviewId(), review.getContent(), review.getRating());
        
        return ReviewResponse.builder()
                .reviewId(review.getReviewId())
                .bookId(review.getBook().getBookId())
                .bookTitle(review.getBook().getTitle())
                .memberName(review.getMember().getName())
                .rating(review.getRating())
                .content(review.getContent())
                .createdAt(review.getCreatedDate())
                .canEdit(canEdit)
                .canDelete(canDelete)
                .build();
    }
}