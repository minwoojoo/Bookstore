package com.bookstore.bookstore.entity.etc;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "popular_search")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PopularSearch {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "keyword_id")
    private Long keywordId;
    
    @Column(name = "keyword", nullable = false, length = 200)
    private String keyword;
    
    @Column(name = "search_count")
    private Integer searchCount;
    
    @Column(name = "updated_date")
    private LocalDateTime updatedDate;
    
    @PrePersist
    public void prePersist() {
        this.updatedDate = LocalDateTime.now();
        if (this.searchCount == null) {
            this.searchCount = 1;
        }
    }
    
    @PreUpdate
    public void preUpdate() {
        this.updatedDate = LocalDateTime.now();
    }
    
    // 검색 횟수 증가
    public void incrementSearchCount() {
        this.searchCount++;
    }
}

