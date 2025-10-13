package com.bookstore.bookstore.service.etc;

import com.bookstore.bookstore.entity.etc.PopularSearch;
import com.bookstore.bookstore.repository.etc.PopularSearchRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class PopularSearchService {

    private final PopularSearchRepository popularSearchRepository;

    /**
     * 검색어 저장 또는 카운트 증가
     */
    @Transactional
    public void recordSearch(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return;
        }
        
        String trimmedKeyword = keyword.trim();
        
        PopularSearch popularSearch = popularSearchRepository.findByKeyword(trimmedKeyword)
            .orElse(PopularSearch.builder()
                .keyword(trimmedKeyword)
                .searchCount(0)
                .build());
        
        popularSearch.incrementSearchCount();
        popularSearchRepository.save(popularSearch);
        
        log.info("검색어 기록 완료: keyword={}, count={}", trimmedKeyword, popularSearch.getSearchCount());
    }

    /**
     * 인기 검색어 상위 10개 조회
     */
    public List<PopularSearch> getTop10PopularSearches() {
        List<PopularSearch> top10 = popularSearchRepository.findTop10ByOrderBySearchCountDesc();
        
        // 상위 10개만 반환
        if (top10.size() > 10) {
            top10 = top10.subList(0, 10);
        }
        
        log.info("인기 검색어 상위 10개 조회 완료: {} 개", top10.size());
        return top10;
    }
}

