package com.bookstore.bookstore.repository.review;

import com.bookstore.bookstore.entity.review.Review;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ReviewRepository extends JpaRepository<Review, Long> {
    
    // 특정 책의 모든 리뷰 조회
    List<Review> findByBookBookIdOrderByCreatedDateDesc(Long bookId);
    
    // 특정 회원의 모든 리뷰 조회
    List<Review> findByMemberMemberIdOrderByCreatedDateDesc(Long memberId);
    
    // 특정 책과 회원의 리뷰 조회 (중복 리뷰 방지)
    Optional<Review> findByBookBookIdAndMemberMemberId(Long bookId, Long memberId);
    
    // 특정 책의 평균 평점 계산
    @Query("SELECT AVG(r.rating) FROM Review r WHERE r.book.bookId = :bookId")
    Double findAverageRatingByBookId(@Param("bookId") Long bookId);
    
    // 특정 책의 리뷰 개수
    Long countByBookBookId(Long bookId);
}