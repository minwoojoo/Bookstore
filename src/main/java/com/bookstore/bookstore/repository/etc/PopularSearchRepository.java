package com.bookstore.bookstore.repository.etc;

import com.bookstore.bookstore.entity.etc.PopularSearch;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PopularSearchRepository extends JpaRepository<PopularSearch, Long> {
    
    /**
     * 검색어로 인기 검색어 조회
     */
    Optional<PopularSearch> findByKeyword(String keyword);
    
    /**
     * 검색 횟수 상위 10개 조회
     */
    @Query("SELECT p FROM PopularSearch p ORDER BY p.searchCount DESC")
    List<PopularSearch> findTop10ByOrderBySearchCountDesc();
}

