package com.bookstore.bookstore.controller.book;

import com.bookstore.bookstore.dto.book.CategoryResponse;
import com.bookstore.bookstore.service.book.BookService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

/**
 * 카테고리 관련 REST API 컨트롤러
 */
@Slf4j
@RestController
@RequestMapping("/api/categories")
@RequiredArgsConstructor
public class CategoryController {
    
    private final BookService bookService;
    
    /**
     * 특정 카테고리의 하위 카테고리 조회
     * GET /api/categories/{parentId}/children
     */
    @GetMapping("/{parentId}/children")
    public ResponseEntity<?> getChildCategories(@PathVariable Long parentId) {
        log.info("하위 카테고리 조회 API 요청: parentId={}", parentId);
        List<CategoryResponse> categories = bookService.getLevel3Categories(parentId);
        log.info("하위 카테고리 조회 완료: parentId={}, {} 개", parentId, categories.size());
        return ResponseEntity.ok(Map.of(
            "success", true,
            "data", categories
        ));
    }
}

