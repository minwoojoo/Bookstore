package com.bookstore.bookstore.dto.book;

import com.bookstore.bookstore.entity.book.Category;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
import java.util.stream.Collectors;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CategoryResponse {
    
    private Long categoryId;
    private String categoryName;
    private Integer level;
    private Long parentId;
    private List<CategoryResponse> children;
    
    /**
     * Category 엔티티를 CategoryResponse DTO로 변환
     */
    public static CategoryResponse from(Category category) {
        return CategoryResponse.builder()
                .categoryId(category.getCategoryId())
                .categoryName(category.getCategoryName())
                .level(category.getLevel())
                .parentId(category.getParent() != null ? category.getParent().getCategoryId() : null)
                .children(category.getChildren().stream()
                        .map(CategoryResponse::from)
                        .collect(Collectors.toList()))
                .build();
    }
    
    /**
     * Category 엔티티를 하위 카테고리 없이 변환
     */
    public static CategoryResponse fromWithoutChildren(Category category) {
        return CategoryResponse.builder()
                .categoryId(category.getCategoryId())
                .categoryName(category.getCategoryName())
                .level(category.getLevel())
                .parentId(category.getParent() != null ? category.getParent().getCategoryId() : null)
                .build();
    }
}

