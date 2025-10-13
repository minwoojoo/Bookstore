package com.bookstore.bookstore.repository.etc;

import com.bookstore.bookstore.entity.etc.RecentView;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * 최근 본 상품 Repository
 */
@Repository
public interface RecentViewRepository extends JpaRepository<RecentView, Long> {
    
    /**
     * 특정 사용자의 최근 본 상품 목록 조회 (최신순)
     */
    @Query("SELECT rv FROM RecentView rv " +
           "JOIN FETCH rv.member m " +
           "JOIN FETCH rv.book b " +
           "WHERE rv.memberId = :memberId " +
           "ORDER BY rv.viewedTime DESC")
    List<RecentView> findByMemberIdOrderByViewedTimeDesc(@Param("memberId") Long memberId);
    
    /**
     * 특정 사용자의 최근 본 상품 목록 조회 (제한된 개수)
     */
    @Query("SELECT rv FROM RecentView rv " +
           "JOIN FETCH rv.member m " +
           "JOIN FETCH rv.book b " +
           "WHERE rv.memberId = :memberId " +
           "ORDER BY rv.viewedTime DESC")
    List<RecentView> findTop5ByMemberIdOrderByViewedTimeDesc(@Param("memberId") Long memberId);
    
    /**
     * 특정 사용자가 특정 책을 본 기록 조회
     */
    @Query("SELECT rv FROM RecentView rv " +
           "WHERE rv.memberId = :memberId AND rv.bookId = :bookId")
    Optional<RecentView> findByMemberIdAndBookId(@Param("memberId") Long memberId, @Param("bookId") Long bookId);
    
    /**
     * 특정 사용자의 오래된 최근 본 상품 삭제 (최대 20개 유지)
     */
    @Modifying
    @Query(value = "DELETE FROM recent_view " +
                   "WHERE member_id = :memberId " +
                   "AND recent_view_id NOT IN (" +
                   "  SELECT recent_view_id FROM (" +
                   "    SELECT recent_view_id FROM recent_view " +
                   "    WHERE member_id = :memberId " +
                   "    ORDER BY viewed_time DESC " +
                   "    LIMIT 20" +
                   "  ) AS keep_records" +
                   ")", nativeQuery = true)
    void deleteOldRecentViews(@Param("memberId") Long memberId);
}
