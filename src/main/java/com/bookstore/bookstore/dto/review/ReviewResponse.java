package com.bookstore.bookstore.dto.review;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReviewResponse {
    
    private Long reviewId;
    private Long bookId;
    private String bookTitle;
    private String memberName;
    private Integer rating;
    private String content;
    private LocalDateTime createdAt;
    private boolean canEdit; // 수정 가능 여부
    private boolean canDelete; // 삭제 가능 여부
}