package com.bookstore.bookstore.controller.book;

import com.bookstore.bookstore.dto.book.BookListResponse;
import com.bookstore.bookstore.dto.book.CategoryResponse;
import com.bookstore.bookstore.service.book.BookService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 책 관련 REST API 컨트롤러 (JSON 응답)
 */
@Slf4j
@RestController
@RequestMapping("/api/books")
@RequiredArgsConstructor
public class BookController {
    
    private final BookService bookService;
    
    /**
     * 전체 책 목록 조회 API
     * GET /api/books/all
     */
    @GetMapping("/all")
    public ResponseEntity<?> getAllBooks() {
        log.info("전체 책 목록 조회 API 요청");
        
        List<BookListResponse> books = bookService.getAllBooks();
        
        log.info("전체 책 목록 조회 API 완료: {} 권", books.size());
        
        return ResponseEntity.ok(Map.of(
            "success", true,
            "data", books,
            "count", books.size()
        ));
    }
    
    /**
     * 카테고리별 책 목록 조회 API
     * GET /api/books/category?categoryId=xxx
     */
    @GetMapping("/category")
    public ResponseEntity<?> getBooksByCategory(@RequestParam("categoryId") Long categoryId) {
        log.info("카테고리별 책 목록 조회 API 요청: categoryId={}", categoryId);
        
        try {
            CategoryResponse category = bookService.getCategory(categoryId);
            List<BookListResponse> books = bookService.getBooksByCategory(categoryId);
            
            log.info("카테고리별 책 목록 조회 API 완료: categoryId={}, {} 권", categoryId, books.size());
            
            return ResponseEntity.ok(Map.of(
                "success", true,
                "category", category,
                "data", books,
                "count", books.size()
            ));
        } catch (IllegalArgumentException e) {
            log.error("카테고리 조회 실패: {}", e.getMessage());
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", e.getMessage()
            ));
        }
    }
    
    /**
     * 책 상세 정보 조회 API
     * GET /api/books/{bookId}
     */
    @GetMapping("/{bookId}")
    public ResponseEntity<?> getBookDetail(@PathVariable Long bookId) {
        log.info("책 상세 정보 조회 API 요청: bookId={}", bookId);
        
        try {
            BookListResponse book = bookService.getBookById(bookId);
            
            log.info("책 상세 정보 조회 API 완료: bookId={}, title={}", bookId, book.getTitle());
            
            return ResponseEntity.ok(Map.of(
                "success", true,
                "book", book
            ));
        } catch (IllegalArgumentException e) {
            log.error("책 조회 실패: {}", e.getMessage());
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", e.getMessage()
            ));
        } catch (Exception e) {
            log.error("책 상세 조회 실패: {}", e.getMessage());
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", "책 정보 조회에 실패했습니다."
            ));
        }
    }
    
    /**
     * 책 검색 API
     * GET /api/books/search?keyword=xxx
     */
    @GetMapping("/search")
    public ResponseEntity<?> searchBooks(@RequestParam("keyword") String keyword) {
        log.info("책 검색 API 요청: keyword={}", keyword);
        
        // TODO: BookService에 검색 메서드 추가 필요
        return ResponseEntity.ok(Map.of(
            "success", true,
            "message", "책 검색 API (구현 예정)",
            "keyword", keyword
        ));
    }
}

