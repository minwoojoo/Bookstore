package com.bookstore.bookstore.service.etc;

import com.bookstore.bookstore.entity.etc.RecentView;
import com.bookstore.bookstore.repository.etc.RecentViewRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 최근 본 상품 서비스
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class RecentViewService {
    
    private final RecentViewRepository recentViewRepository;
    
    /**
     * 최근 본 상품 추가 또는 업데이트
     */
    @Transactional
    public void addRecentView(Long memberId, Long bookId) {
        try {
            // 기존 기록이 있는지 확인
            var existingView = recentViewRepository.findByMemberIdAndBookId(memberId, bookId);
            
            if (existingView.isPresent()) {
                // 기존 기록이 있으면 시간만 업데이트
                RecentView recentView = existingView.get();
                recentView.setViewedTime(LocalDateTime.now());
                recentViewRepository.save(recentView);
                log.info("최근 본 상품 시간 업데이트: memberId={}, bookId={}", memberId, bookId);
            } else {
                // 새로운 기록 생성
                RecentView newView = RecentView.builder()
                        .memberId(memberId)
                        .bookId(bookId)
                        .build();
                recentViewRepository.save(newView);
                log.info("최근 본 상품 추가: memberId={}, bookId={}", memberId, bookId);
            }
            
            // 최대 20개까지만 유지 (오래된 것 삭제)
            recentViewRepository.deleteOldRecentViews(memberId);
            
        } catch (Exception e) {
            log.error("최근 본 상품 추가 실패: memberId={}, bookId={}, error={}", 
                    memberId, bookId, e.getMessage());
        }
    }
    
    /**
     * 사용자의 최근 본 상품 목록 조회 (최대 5개)
     */
    public List<RecentView> getRecentViews(Long memberId) {
        try {
            List<RecentView> recentViews = recentViewRepository.findTop5ByMemberIdOrderByViewedTimeDesc(memberId);
            log.info("최근 본 상품 조회: memberId={}, count={}", memberId, recentViews.size());
            return recentViews;
        } catch (Exception e) {
            log.error("최근 본 상품 조회 실패: memberId={}, error={}", memberId, e.getMessage());
            return List.of();
        }
    }
}
