package com.bookstore.bookstore.controller.performance;

import com.bookstore.bookstore.entity.book.Book;
import com.bookstore.bookstore.entity.customer.Member;
import com.bookstore.bookstore.entity.order.Order;
import com.bookstore.bookstore.repository.book.BookRepository;
import com.bookstore.bookstore.repository.customer.MemberRepository;
import com.bookstore.bookstore.repository.order.OrderRepository;
import com.bookstore.bookstore.dto.performance.BookPerformanceDto;
import com.bookstore.bookstore.service.admin.AdminService;
import com.bookstore.bookstore.dto.admin.AdminBookListRequest;
import com.bookstore.bookstore.dto.admin.AdminOrderListRequest;
import com.bookstore.bookstore.dto.admin.AdminMemberListRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;

/**
 * 성능 테스트용 컨트롤러
 * JMeter를 통한 N+1 문제 해결 효과 측정
 */
@RestController
@RequestMapping("/api/performance")
@RequiredArgsConstructor
@Slf4j
public class PerformanceTestController {
    
    private final BookRepository bookRepository;
    private final MemberRepository memberRepository;
    private final OrderRepository orderRepository;
    private final AdminService adminService;
    
    /**
     * N+1 문제가 발생하는 방식으로 도서 목록 조회
     * - 기본 JPA 메서드 사용 (연관 엔티티 지연 로딩)
     */
    @GetMapping("/books/n-plus-1")
    public List<BookPerformanceDto> getBooksWithNPlus1Problem() {
        log.info("=== N+1 문제 발생 방식 테스트 시작 ===");
        long startTime = System.currentTimeMillis();
        
        // 기본 JPA 메서드 사용 (N+1 문제 발생)
        // findAll()은 연관 엔티티를 지연 로딩으로 가져옴
        List<Book> books = bookRepository.findAll();
        
        // 연관 엔티티 접근 시 추가 쿼리 발생 (N+1 문제)
        for (Book book : books) {
            // 각 도서마다 별도 쿼리 실행 (N+1 문제 발생)
            book.getBookAuthors().size();
            for (var bookAuthor : book.getBookAuthors()) {
                // 각 저자마다 별도 쿼리 실행 (N+1 문제 발생)
                bookAuthor.getAuthor().getName();
            }
            // 카테고리 접근 시 별도 쿼리 실행
            book.getCategory().getCategoryName();
            // 재고 정보 접근 시 별도 쿼리 실행
            if (book.getStock() != null) {
                book.getStock().getQuantity();
            }
        }
        
        long endTime = System.currentTimeMillis();
        long executionTime = endTime - startTime;
        
        log.info("N+1 문제 발생 방식 - 실행 시간: {}ms, 도서 수: {}", executionTime, books.size());
        log.info("=== N+1 문제 발생 방식 테스트 완료 ===");
        
        // DTO로 변환하여 반환
        return convertToPerformanceDto(books);
    }
    
    /**
     * LEFT JOIN FETCH를 사용한 최적화된 방식으로 도서 목록 조회
     * - 한 번의 쿼리로 모든 연관 엔티티 조회
     */
    @GetMapping("/books/optimized")
    public List<BookPerformanceDto> getBooksOptimized() {
        log.info("=== LEFT JOIN FETCH 최적화 방식 테스트 시작 ===");
        long startTime = System.currentTimeMillis();
        
        // LEFT JOIN FETCH를 사용한 최적화된 쿼리
        List<Book> books = bookRepository.findAllWithAuthors();
        
        // 추가 쿼리 없이 연관 엔티티 접근 가능
        for (Book book : books) {
            book.getBookAuthors().size();
            for (var bookAuthor : book.getBookAuthors()) {
                bookAuthor.getAuthor().getName();
            }
            book.getCategory().getCategoryName();
            if (book.getStock() != null) {
                book.getStock().getQuantity();
            }
        }
        
        long endTime = System.currentTimeMillis();
        long executionTime = endTime - startTime;
        
        log.info("LEFT JOIN FETCH 최적화 방식 - 실행 시간: {}ms, 도서 수: {}", executionTime, books.size());
        log.info("=== LEFT JOIN FETCH 최적화 방식 테스트 완료 ===");
        
        // DTO로 변환하여 반환
        return convertToPerformanceDto(books);
    }
    
    /**
     * 카테고리별 도서 조회 - N+1 문제 발생
     */
    @GetMapping("/books/category/{categoryId}/n-plus-1")
    public List<BookPerformanceDto> getBooksByCategoryWithNPlus1(@PathVariable Long categoryId) {
        log.info("=== 카테고리별 N+1 문제 발생 방식 테스트 시작 ===");
        
        long startTime = System.currentTimeMillis();
        
        // 기본 쿼리 사용 (N+1 문제 발생)
        // findBooksByCategoryIdNPlus1는 연관 엔티티를 지연 로딩으로 가져옴
        List<Book> books = bookRepository.findBooksByCategoryIdNPlus1(categoryId);
        
        log.info("카테고리 ID: {}, 도서 수: {}개", categoryId, books.size());
        
        // DTO 변환 과정에서 연관 엔티티 접근 시 N+1 문제 발생
        // 이 시점에서 각 도서마다 별도 쿼리가 실행됩니다
        List<BookPerformanceDto> result = convertToPerformanceDtoWithNPlus1(books);
        
        long endTime = System.currentTimeMillis();
        long executionTime = endTime - startTime;
        
        log.info("카테고리별 N+1 문제 발생 방식 - 실행 시간: {}ms, 도서 수: {}", 
                executionTime, books.size());
        log.info("=== 카테고리별 N+1 문제 발생 방식 테스트 완료 ===");
        
        return result;
    }
    
    /**
     * 카테고리별 도서 조회 - 최적화된 방식
     */
    @GetMapping("/books/category/{categoryId}/optimized")
    public List<BookPerformanceDto> getBooksByCategoryOptimized(@PathVariable Long categoryId) {
        log.info("=== 카테고리별 LEFT JOIN FETCH 최적화 방식 테스트 시작 ===");
        
        long startTime = System.currentTimeMillis();
        
        // LEFT JOIN FETCH를 사용한 최적화된 쿼리
        // 한 번의 쿼리로 모든 연관 엔티티를 가져옴
        List<Book> books = bookRepository.findByCategoryCategoryId(categoryId);
        
        log.info("카테고리 ID: {}, 도서 수: {}개", categoryId, books.size());
        
        // DTO 변환 과정에서 추가 쿼리 없이 연관 엔티티 접근 가능
        List<BookPerformanceDto> result = convertToPerformanceDto(books);
        
        long endTime = System.currentTimeMillis();
        long executionTime = endTime - startTime;
        
        log.info("카테고리별 LEFT JOIN FETCH 최적화 방식 - 실행 시간: {}ms, 도서 수: {}", 
                executionTime, books.size());
        log.info("=== 카테고리별 LEFT JOIN FETCH 최적화 방식 테스트 완료 ===");
        
        return result;
    }
    
    /**
     * 검색 기능 - N+1 문제 발생
     */
    @GetMapping("/books/search/n-plus-1")
    public List<BookPerformanceDto> searchBooksWithNPlus1(@RequestParam String keyword) {
        log.info("=== 검색 N+1 문제 발생 방식 테스트 시작 ===");
        long startTime = System.currentTimeMillis();
        
        // 기본 쿼리 사용 (N+1 문제 발생)
        // 연관 엔티티를 fetch하지 않아서 N+1 문제가 발생합니다
        List<Book> books = bookRepository.searchBooksNPlus1(keyword);
        
        long endTime = System.currentTimeMillis();
        long executionTime = endTime - startTime;
        
        log.info("검색 N+1 문제 발생 방식 - 실행 시간: {}ms, 도서 수: {}", executionTime, books.size());
        log.info("=== 검색 N+1 문제 발생 방식 테스트 완료 ===");
        
        // DTO로 변환하여 반환 (N+1 문제 발생)
        return convertToPerformanceDtoWithNPlus1(books);
    }
    
    /**
     * 검색 기능 - 최적화된 방식
     */
    @GetMapping("/books/search/optimized")
    public List<BookPerformanceDto> searchBooksOptimized(@RequestParam String keyword) {
        log.info("=== 검색 LEFT JOIN FETCH 최적화 방식 테스트 시작 ===");
        long startTime = System.currentTimeMillis();
        
        // LEFT JOIN FETCH를 사용한 최적화된 쿼리
        List<Book> books = bookRepository.searchBooks(keyword);
        
        // 추가 쿼리 없이 연관 엔티티 접근 가능
        for (Book book : books) {
            book.getBookAuthors().size();
            for (var bookAuthor : book.getBookAuthors()) {
                bookAuthor.getAuthor().getName();
            }
            book.getCategory().getCategoryName();
            // 재고 정보 접근
            if (book.getStock() != null) {
                book.getStock().getQuantity();
            }
        }
        
        long endTime = System.currentTimeMillis();
        long executionTime = endTime - startTime;
        
        log.info("검색 LEFT JOIN FETCH 최적화 방식 - 실행 시간: {}ms, 도서 수: {}", executionTime, books.size());
        log.info("=== 검색 LEFT JOIN FETCH 최적화 방식 테스트 완료 ===");
        
        // DTO로 변환하여 반환 (JSON 직렬화 오류 방지)
        return convertToPerformanceDto(books);
    }
    
    
    
    /**
     * 전체 도서 조회 성능 비교 엔드포인트
     */
    @GetMapping("/compare/all")
    public Map<String, Object> compareAllBooksPerformance() {
        Map<String, Object> result = new HashMap<>();
        
        log.info("=== 전체 도서 조회 성능 비교 테스트 시작 ===");
        
        // N+1 문제 방식 테스트
        long n1StartTime = System.currentTimeMillis();
        List<BookPerformanceDto> n1Result = getBooksWithNPlus1Problem();
        long n1EndTime = System.currentTimeMillis();
        long n1ExecutionTime = n1EndTime - n1StartTime;
        
        // 잠시 대기 (캐시 효과 방지)
        try {
            Thread.sleep(100);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        
        // 최적화 방식 테스트
        long optStartTime = System.currentTimeMillis();
        List<BookPerformanceDto> optResult = getBooksOptimized();
        long optEndTime = System.currentTimeMillis();
        long optExecutionTime = optEndTime - optStartTime;
        
        // 결과 비교
        result.put("testType", "전체 도서 조회");
        result.put("bookCount", n1Result.size());
        
        Map<String, Object> n1Stats = new HashMap<>();
        n1Stats.put("executionTime", n1ExecutionTime);
        n1Stats.put("avgTimePerBook", n1Result.size() > 0 ? n1ExecutionTime / n1Result.size() : 0);
        result.put("n1Problem", n1Stats);
        
        Map<String, Object> optStats = new HashMap<>();
        optStats.put("executionTime", optExecutionTime);
        optStats.put("avgTimePerBook", optResult.size() > 0 ? optExecutionTime / optResult.size() : 0);
        result.put("optimized", optStats);
        
        // 성능 개선율 계산
        double timeImprovement = n1ExecutionTime > 0 ? 
            ((double)(n1ExecutionTime - optExecutionTime) / n1ExecutionTime) * 100 : 0;
        
        Map<String, Object> improvement = new HashMap<>();
        improvement.put("timeImprovement", String.format("%.1f%%", timeImprovement));
        result.put("improvement", improvement);
        
        log.info("=== 전체 도서 조회 성능 비교 결과 ===");
        log.info("N+1 방식: {}ms", n1ExecutionTime);
        log.info("최적화 방식: {}ms", optExecutionTime);
        log.info("성능 개선: {}% (시간)", String.format("%.1f", timeImprovement));
        
        return result;
    }
    
    /**
     * 카테고리별 도서 조회 성능 비교 엔드포인트
     */
    @GetMapping("/compare/{categoryId}")
    public Map<String, Object> comparePerformance(@PathVariable Long categoryId) {
        Map<String, Object> result = new HashMap<>();
        
        log.info("=== 성능 비교 테스트 시작 (카테고리: {}) ===", categoryId);
        
        // N+1 문제 방식 테스트
        long n1StartTime = System.currentTimeMillis();
        List<BookPerformanceDto> n1Result = getBooksByCategoryWithNPlus1(categoryId);
        long n1EndTime = System.currentTimeMillis();
        long n1ExecutionTime = n1EndTime - n1StartTime;
        
        // 잠시 대기 (캐시 효과 방지)
        try {
            Thread.sleep(100);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        
        // 최적화 방식 테스트
        long optStartTime = System.currentTimeMillis();
        List<BookPerformanceDto> optResult = getBooksByCategoryOptimized(categoryId);
        long optEndTime = System.currentTimeMillis();
        long optExecutionTime = optEndTime - optStartTime;
        
        // 결과 비교
        result.put("categoryId", categoryId);
        result.put("bookCount", n1Result.size());
        
        Map<String, Object> n1Stats = new HashMap<>();
        n1Stats.put("executionTime", n1ExecutionTime);
        n1Stats.put("avgTimePerBook", n1Result.size() > 0 ? n1ExecutionTime / n1Result.size() : 0);
        result.put("n1Problem", n1Stats);
        
        Map<String, Object> optStats = new HashMap<>();
        optStats.put("executionTime", optExecutionTime);
        optStats.put("avgTimePerBook", optResult.size() > 0 ? optExecutionTime / optResult.size() : 0);
        result.put("optimized", optStats);
        
        // 성능 개선율 계산
        double timeImprovement = n1ExecutionTime > 0 ? 
            ((double)(n1ExecutionTime - optExecutionTime) / n1ExecutionTime) * 100 : 0;
        
        Map<String, Object> improvement = new HashMap<>();
        improvement.put("timeImprovement", String.format("%.1f%%", timeImprovement));
        result.put("improvement", improvement);
        
        log.info("=== 성능 비교 결과 ===");
        log.info("N+1 방식: {}ms", n1ExecutionTime);
        log.info("최적화 방식: {}ms", optExecutionTime);
        log.info("성능 개선: {}% (시간)", String.format("%.1f", timeImprovement));
        
        return result;
    }
    
    /**
     * 검색 기능 성능 비교 엔드포인트
     */
    @GetMapping("/compare/search")
    public Map<String, Object> compareSearchPerformance(@RequestParam String keyword) {
        Map<String, Object> result = new HashMap<>();
        
        log.info("=== 검색 기능 성능 비교 테스트 시작 (키워드: {}) ===", keyword);
        
        // N+1 문제 방식 테스트
        long n1StartTime = System.currentTimeMillis();
        List<BookPerformanceDto> n1Result = searchBooksWithNPlus1(keyword);
        long n1EndTime = System.currentTimeMillis();
        long n1ExecutionTime = n1EndTime - n1StartTime;
        
        // 잠시 대기 (캐시 효과 방지)
        try {
            Thread.sleep(100);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        
        // 최적화 방식 테스트
        long optStartTime = System.currentTimeMillis();
        List<BookPerformanceDto> optResult = searchBooksOptimized(keyword);
        long optEndTime = System.currentTimeMillis();
        long optExecutionTime = optEndTime - optStartTime;
        
        // 결과 비교
        result.put("testType", "검색 기능");
        result.put("keyword", keyword);
        result.put("bookCount", n1Result.size());
        
        Map<String, Object> n1Stats = new HashMap<>();
        n1Stats.put("executionTime", n1ExecutionTime);
        n1Stats.put("avgTimePerBook", n1Result.size() > 0 ? n1ExecutionTime / n1Result.size() : 0);
        result.put("n1Problem", n1Stats);
        
        Map<String, Object> optStats = new HashMap<>();
        optStats.put("executionTime", optExecutionTime);
        optStats.put("avgTimePerBook", optResult.size() > 0 ? optExecutionTime / optResult.size() : 0);
        result.put("optimized", optStats);
        
        // 성능 개선율 계산
        double timeImprovement = n1ExecutionTime > 0 ? 
            ((double)(n1ExecutionTime - optExecutionTime) / n1ExecutionTime) * 100 : 0;
        
        Map<String, Object> improvement = new HashMap<>();
        improvement.put("timeImprovement", String.format("%.1f%%", timeImprovement));
        result.put("improvement", improvement);
        
        log.info("=== 검색 기능 성능 비교 결과 ===");
        log.info("N+1 방식: {}ms", n1ExecutionTime);
        log.info("최적화 방식: {}ms", optExecutionTime);
        log.info("성능 개선: {}% (시간)", String.format("%.1f", timeImprovement));
        
        return result;
    }
    
    // ==================== 관리자 대시보드 성능 테스트 ====================
    
    /**
     * 관리자 대시보드 - 상품 목록 조회 성능 테스트 (비최적화)
     * - 복합 필터링과 페이징을 사용하지 않는 방식
     */
    @GetMapping("/admin/books/non-optimized")
    public Map<String, Object> getAdminBooksNonOptimized(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String title,
            @RequestParam(required = false) String publisher,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) String bookStatus,
            @RequestParam(required = false) String sortBy,
            @RequestParam(defaultValue = "desc") String sortDir) {
        
        log.info("=== 관리자 상품 목록 조회 성능 테스트 (비최적화) 시작 ===");
        long startTime = System.currentTimeMillis();
        
        // 비최적화된 방식: 모든 데이터를 가져온 후 메모리에서 필터링
        List<Book> allBooks = bookRepository.findAll();
        
        // 메모리에서 필터링 (비효율적)
        List<Book> filteredBooks = allBooks.stream()
                .filter(book -> title == null || book.getTitle().contains(title))
                .filter(book -> publisher == null || book.getPublisher().contains(publisher))
                .filter(book -> categoryId == null || book.getCategory().getCategoryId().equals(categoryId))
                .filter(book -> bookStatus == null || book.getBookStatus().equals(bookStatus))
                .toList();
        
        // 메모리에서 정렬 (비효율적)
        if (sortBy != null) {
            filteredBooks = filteredBooks.stream()
                    .sorted((b1, b2) -> {
                        int result = 0;
                        switch (sortBy) {
                            case "title":
                                result = b1.getTitle().compareTo(b2.getTitle());
                                break;
                            case "price":
                                result = b1.getPrice().compareTo(b2.getPrice());
                                break;
                            case "registrationDate":
                                result = b1.getRegistrationDate().compareTo(b2.getRegistrationDate());
                                break;
                        }
                        return "desc".equals(sortDir) ? -result : result;
                    })
                    .toList();
        }
        
        // 메모리에서 페이징 (비효율적)
        int start = page * size;
        int end = Math.min(start + size, filteredBooks.size());
        List<Book> pagedBooks = filteredBooks.subList(start, end);
        
        long endTime = System.currentTimeMillis();
        long executionTime = endTime - startTime;
        
        Map<String, Object> result = new HashMap<>();
        result.put("testType", "관리자 상품 목록 조회 (비최적화)");
        result.put("executionTime", executionTime);
        result.put("totalBooks", allBooks.size());
        result.put("filteredBooks", filteredBooks.size());
        result.put("pagedBooks", pagedBooks.size());
        result.put("page", page);
        result.put("size", size);
        
        log.info("관리자 상품 목록 조회 (비최적화) - 실행 시간: {}ms, 전체: {}, 필터링: {}, 페이징: {}", 
                executionTime, allBooks.size(), filteredBooks.size(), pagedBooks.size());
        log.info("=== 관리자 상품 목록 조회 성능 테스트 (비최적화) 완료 ===");
        
        return result;
    }
    
    /**
     * 관리자 대시보드 - 상품 목록 조회 성능 테스트 (최적화)
     * - GROUP BY와 복합 필터링, 페이징을 활용한 최적화된 방식
     */
    @GetMapping("/admin/books/optimized")
    public Map<String, Object> getAdminBooksOptimized(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String title,
            @RequestParam(required = false) String publisher,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) String bookStatus,
            @RequestParam(required = false) String sortBy,
            @RequestParam(defaultValue = "desc") String sortDir) {
        
        log.info("=== 관리자 상품 목록 조회 성능 테스트 (최적화) 시작 ===");
        long startTime = System.currentTimeMillis();
        
        // 최적화된 방식: AdminService의 최적화된 메서드 사용
        AdminBookListRequest request = AdminBookListRequest.builder()
                .bookTitle(title)
                .publisher(publisher)
                .saleStatus(bookStatus)
                .sortBy(sortBy != null ? sortBy : "bookId")
                .sortDirection(sortDir != null ? sortDir : "desc")
                .page(page)
                .size(size)
                .build();
        
        var result = adminService.getBookList(request);
        
        long endTime = System.currentTimeMillis();
        long executionTime = endTime - startTime;
        
        Map<String, Object> performanceResult = new HashMap<>();
        performanceResult.put("testType", "관리자 상품 목록 조회 (최적화)");
        performanceResult.put("executionTime", executionTime);
        performanceResult.put("totalBooks", result.getTotalElements());
        performanceResult.put("filteredBooks", result.getContent().size());
        performanceResult.put("pagedBooks", result.getContent().size());
        performanceResult.put("page", page);
        performanceResult.put("size", size);
        performanceResult.put("totalPages", result.getTotalPages());
        
        log.info("관리자 상품 목록 조회 (최적화) - 실행 시간: {}ms, 전체: {}, 필터링: {}, 페이징: {}", 
                executionTime, result.getTotalElements(), result.getContent().size(), result.getContent().size());
        log.info("=== 관리자 상품 목록 조회 성능 테스트 (최적화) 완료 ===");
        
        return performanceResult;
    }
    
    /**
     * 관리자 대시보드 - 주문 목록 조회 성능 테스트 (비최적화)
     */
    @GetMapping("/admin/orders/non-optimized")
    public Map<String, Object> getAdminOrdersNonOptimized(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String memberName,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate) {
        
        log.info("=== 관리자 주문 목록 조회 성능 테스트 (비최적화) 시작 ===");
        long startTime = System.currentTimeMillis();
        
        // 비최적화된 방식: 모든 주문을 가져온 후 메모리에서 필터링
        List<Order> allOrders = orderRepository.findAll();
        
        // 메모리에서 필터링 (비효율적)
        List<Order> filteredOrders = allOrders.stream()
                .filter(order -> memberName == null || order.getMember().getName().contains(memberName))
                .filter(order -> startDate == null || order.getOrderDate().toString().contains(startDate))
                .filter(order -> endDate == null || order.getOrderDate().toString().contains(endDate))
                .toList();
        
        // 메모리에서 페이징 (비효율적)
        int start = page * size;
        int end = Math.min(start + size, filteredOrders.size());
        List<Order> pagedOrders = filteredOrders.subList(start, end);
        
        long endTime = System.currentTimeMillis();
        long executionTime = endTime - startTime;
        
        Map<String, Object> result = new HashMap<>();
        result.put("testType", "관리자 주문 목록 조회 (비최적화)");
        result.put("executionTime", executionTime);
        result.put("totalOrders", allOrders.size());
        result.put("filteredOrders", filteredOrders.size());
        result.put("pagedOrders", pagedOrders.size());
        result.put("page", page);
        result.put("size", size);
        
        log.info("관리자 주문 목록 조회 (비최적화) - 실행 시간: {}ms, 전체: {}, 필터링: {}, 페이징: {}", 
                executionTime, allOrders.size(), filteredOrders.size(), pagedOrders.size());
        log.info("=== 관리자 주문 목록 조회 성능 테스트 (비최적화) 완료 ===");
        
        return result;
    }
    
    /**
     * 관리자 대시보드 - 주문 목록 조회 성능 테스트 (최적화)
     */
    @GetMapping("/admin/orders/optimized")
    public Map<String, Object> getAdminOrdersOptimized(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String memberName,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate) {
        
        log.info("=== 관리자 주문 목록 조회 성능 테스트 (최적화) 시작 ===");
        long startTime = System.currentTimeMillis();
        
        // 최적화된 방식: AdminService의 최적화된 메서드 사용
        AdminOrderListRequest request = AdminOrderListRequest.builder()
                .memberName(memberName)
                .startDate(startDate != null ? java.time.LocalDate.parse(startDate) : null)
                .endDate(endDate != null ? java.time.LocalDate.parse(endDate) : null)
                .page(page)
                .size(size)
                .build();
        
        var result = adminService.getOrderList(request);
        
        long endTime = System.currentTimeMillis();
        long executionTime = endTime - startTime;
        
        Map<String, Object> performanceResult = new HashMap<>();
        performanceResult.put("testType", "관리자 주문 목록 조회 (최적화)");
        performanceResult.put("executionTime", executionTime);
        performanceResult.put("totalOrders", result.getTotalElements());
        performanceResult.put("filteredOrders", result.getContent().size());
        performanceResult.put("pagedOrders", result.getContent().size());
        performanceResult.put("page", page);
        performanceResult.put("size", size);
        performanceResult.put("totalPages", result.getTotalPages());
        
        log.info("관리자 주문 목록 조회 (최적화) - 실행 시간: {}ms, 전체: {}, 필터링: {}, 페이징: {}", 
                executionTime, result.getTotalElements(), result.getContent().size(), result.getContent().size());
        log.info("=== 관리자 주문 목록 조회 성능 테스트 (최적화) 완료 ===");
        
        return performanceResult;
    }
    
    /**
     * 관리자 대시보드 - 회원 목록 조회 성능 테스트 (비최적화)
     */
    @GetMapping("/admin/members/non-optimized")
    public Map<String, Object> getAdminMembersNonOptimized(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String name,
            @RequestParam(required = false) String email,
            @RequestParam(required = false) String memberId) {
        
        log.info("=== 관리자 회원 목록 조회 성능 테스트 (비최적화) 시작 ===");
        long startTime = System.currentTimeMillis();
        
        // 비최적화된 방식: 모든 회원을 가져온 후 메모리에서 필터링
        List<Member> allMembers = memberRepository.findAll();
        
        // 메모리에서 필터링 (비효율적)
        List<Member> filteredMembers = allMembers.stream()
                .filter(member -> name == null || member.getName().contains(name))
                .filter(member -> email == null || member.getEmail().contains(email))
                .filter(member -> memberId == null || member.getMemberId().toString().contains(memberId))
                .toList();
        
        // 메모리에서 페이징 (비효율적)
        int start = page * size;
        int end = Math.min(start + size, filteredMembers.size());
        List<Member> pagedMembers = filteredMembers.subList(start, end);
        
        long endTime = System.currentTimeMillis();
        long executionTime = endTime - startTime;
        
        Map<String, Object> result = new HashMap<>();
        result.put("testType", "관리자 회원 목록 조회 (비최적화)");
        result.put("executionTime", executionTime);
        result.put("totalMembers", allMembers.size());
        result.put("filteredMembers", filteredMembers.size());
        result.put("pagedMembers", pagedMembers.size());
        result.put("page", page);
        result.put("size", size);
        
        log.info("관리자 회원 목록 조회 (비최적화) - 실행 시간: {}ms, 전체: {}, 필터링: {}, 페이징: {}", 
                executionTime, allMembers.size(), filteredMembers.size(), pagedMembers.size());
        log.info("=== 관리자 회원 목록 조회 성능 테스트 (비최적화) 완료 ===");
        
        return result;
    }
    
    /**
     * 관리자 대시보드 - 회원 목록 조회 성능 테스트 (최적화)
     */
    @GetMapping("/admin/members/optimized")
    public Map<String, Object> getAdminMembersOptimized(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String name,
            @RequestParam(required = false) String email,
            @RequestParam(required = false) String memberId) {
        
        log.info("=== 관리자 회원 목록 조회 성능 테스트 (최적화) 시작 ===");
        long startTime = System.currentTimeMillis();
        
        // 최적화된 방식: AdminService의 최적화된 메서드 사용
        AdminMemberListRequest request = AdminMemberListRequest.builder()
                .memberName(name)
                .email(email)
                .memberId(memberId)
                .page(page)
                .size(size)
                .build();
        
        var result = adminService.getMemberList(request);
        
        long endTime = System.currentTimeMillis();
        long executionTime = endTime - startTime;
        
        Map<String, Object> performanceResult = new HashMap<>();
        performanceResult.put("testType", "관리자 회원 목록 조회 (최적화)");
        performanceResult.put("executionTime", executionTime);
        performanceResult.put("totalMembers", result.getTotalElements());
        performanceResult.put("filteredMembers", result.getContent().size());
        performanceResult.put("pagedMembers", result.getContent().size());
        performanceResult.put("page", page);
        performanceResult.put("size", size);
        performanceResult.put("totalPages", result.getTotalPages());
        
        log.info("관리자 회원 목록 조회 (최적화) - 실행 시간: {}ms, 전체: {}, 필터링: {}, 페이징: {}", 
                executionTime, result.getTotalElements(), result.getContent().size(), result.getContent().size());
        log.info("=== 관리자 회원 목록 조회 성능 테스트 (최적화) 완료 ===");
        
        return performanceResult;
    }
    
    /**
     * 관리자 대시보드 - 주문 목록 조회 성능 비교
     */
    @GetMapping("/admin/compare/orders")
    public Map<String, Object> compareAdminOrdersPerformance(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String memberName,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate) {
        
        Map<String, Object> result = new HashMap<>();
        
        log.info("=== 관리자 주문 목록 조회 성능 비교 테스트 시작 ===");
        
        // 비최적화 방식 테스트
        long n1StartTime = System.currentTimeMillis();
        Map<String, Object> n1Result = getAdminOrdersNonOptimized(page, size, memberName, startDate, endDate);
        long n1EndTime = System.currentTimeMillis();
        long n1ExecutionTime = n1EndTime - n1StartTime;
        
        // 잠시 대기 (캐시 효과 방지)
        try {
            Thread.sleep(100);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        
        // 최적화 방식 테스트
        long optStartTime = System.currentTimeMillis();
        Map<String, Object> optResult = getAdminOrdersOptimized(page, size, memberName, startDate, endDate);
        long optEndTime = System.currentTimeMillis();
        long optExecutionTime = optEndTime - optStartTime;
        
        // 결과 비교
        result.put("testType", "관리자 주문 목록 조회 성능 비교");
        result.put("filters", Map.of(
            "memberName", memberName != null ? memberName : "전체",
            "startDate", startDate != null ? startDate : "전체",
            "endDate", endDate != null ? endDate : "전체"
        ));
        result.put("pagination", Map.of("page", page, "size", size));
        
        Map<String, Object> n1Stats = new HashMap<>();
        n1Stats.put("executionTime", n1ExecutionTime);
        n1Stats.put("totalOrders", n1Result.get("totalOrders"));
        n1Stats.put("filteredOrders", n1Result.get("filteredOrders"));
        result.put("nonOptimized", n1Stats);
        
        Map<String, Object> optStats = new HashMap<>();
        optStats.put("executionTime", optExecutionTime);
        optStats.put("totalOrders", optResult.get("totalOrders"));
        optStats.put("filteredOrders", optResult.get("filteredOrders"));
        result.put("optimized", optStats);
        
        // 성능 개선율 계산
        double timeImprovement = n1ExecutionTime > 0 ? 
            ((double)(n1ExecutionTime - optExecutionTime) / n1ExecutionTime) * 100 : 0;
        
        Map<String, Object> improvement = new HashMap<>();
        improvement.put("timeImprovement", String.format("%.1f%%", timeImprovement));
        improvement.put("timeSaved", n1ExecutionTime - optExecutionTime);
        result.put("improvement", improvement);
        
        log.info("=== 관리자 주문 목록 조회 성능 비교 결과 ===");
        log.info("비최적화 방식: {}ms", n1ExecutionTime);
        log.info("최적화 방식: {}ms", optExecutionTime);
        log.info("성능 개선: {}% (시간)", String.format("%.1f", timeImprovement));
        
        return result;
    }
    
    /**
     * 관리자 대시보드 - 상품 목록 조회 성능 비교
     */
    @GetMapping("/admin/compare/books")
    public Map<String, Object> compareAdminBooksPerformance(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String title,
            @RequestParam(required = false) String publisher,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) String bookStatus,
            @RequestParam(required = false) String sortBy,
            @RequestParam(defaultValue = "desc") String sortDir) {
        
        Map<String, Object> result = new HashMap<>();
        
        log.info("=== 관리자 상품 목록 조회 성능 비교 테스트 시작 ===");
        
        // 비최적화 방식 테스트
        long n1StartTime = System.currentTimeMillis();
        Map<String, Object> n1Result = getAdminBooksNonOptimized(page, size, title, publisher, categoryId, bookStatus, sortBy, sortDir);
        long n1EndTime = System.currentTimeMillis();
        long n1ExecutionTime = n1EndTime - n1StartTime;
        
        // 잠시 대기 (캐시 효과 방지)
        try {
            Thread.sleep(100);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        
        // 최적화 방식 테스트
        long optStartTime = System.currentTimeMillis();
        Map<String, Object> optResult = getAdminBooksOptimized(page, size, title, publisher, categoryId, bookStatus, sortBy, sortDir);
        long optEndTime = System.currentTimeMillis();
        long optExecutionTime = optEndTime - optStartTime;
        
        // 결과 비교
        result.put("testType", "관리자 상품 목록 조회 성능 비교");
        result.put("filters", Map.of(
            "title", title != null ? title : "전체",
            "publisher", publisher != null ? publisher : "전체",
            "categoryId", categoryId != null ? categoryId : "전체",
            "bookStatus", bookStatus != null ? bookStatus : "전체"
        ));
        result.put("pagination", Map.of("page", page, "size", size));
        
        Map<String, Object> n1Stats = new HashMap<>();
        n1Stats.put("executionTime", n1ExecutionTime);
        n1Stats.put("totalBooks", n1Result.get("totalBooks"));
        n1Stats.put("filteredBooks", n1Result.get("filteredBooks"));
        result.put("nonOptimized", n1Stats);
        
        Map<String, Object> optStats = new HashMap<>();
        optStats.put("executionTime", optExecutionTime);
        optStats.put("totalBooks", optResult.get("totalBooks"));
        optStats.put("filteredBooks", optResult.get("filteredBooks"));
        result.put("optimized", optStats);
        
        // 성능 개선율 계산
        double timeImprovement = n1ExecutionTime > 0 ? 
            ((double)(n1ExecutionTime - optExecutionTime) / n1ExecutionTime) * 100 : 0;
        
        Map<String, Object> improvement = new HashMap<>();
        improvement.put("timeImprovement", String.format("%.1f%%", timeImprovement));
        improvement.put("timeSaved", n1ExecutionTime - optExecutionTime);
        result.put("improvement", improvement);
        
        log.info("=== 관리자 상품 목록 조회 성능 비교 결과 ===");
        log.info("비최적화 방식: {}ms", n1ExecutionTime);
        log.info("최적화 방식: {}ms", optExecutionTime);
        log.info("성능 개선: {}% (시간)", String.format("%.1f", timeImprovement));
        
        return result;
    }
    
    
    /**
     * 관리자 대시보드 - 회원 목록 조회 성능 비교
     */
    @GetMapping("/admin/compare/members")
    public Map<String, Object> compareAdminMembersPerformance(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String name,
            @RequestParam(required = false) String email,
            @RequestParam(required = false) String memberId) {
        
        Map<String, Object> result = new HashMap<>();
        
        log.info("=== 관리자 회원 목록 조회 성능 비교 테스트 시작 ===");
        
        // 비최적화 방식 테스트
        long n1StartTime = System.currentTimeMillis();
        Map<String, Object> n1Result = getAdminMembersNonOptimized(page, size, name, email, memberId);
        long n1EndTime = System.currentTimeMillis();
        long n1ExecutionTime = n1EndTime - n1StartTime;
        
        // 잠시 대기 (캐시 효과 방지)
        try {
            Thread.sleep(100);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        
        // 최적화 방식 테스트
        long optStartTime = System.currentTimeMillis();
        Map<String, Object> optResult = getAdminMembersOptimized(page, size, name, email, memberId);
        long optEndTime = System.currentTimeMillis();
        long optExecutionTime = optEndTime - optStartTime;
        
        // 결과 비교
        result.put("testType", "관리자 회원 목록 조회 성능 비교");
        result.put("filters", Map.of(
            "name", name != null ? name : "전체",
            "email", email != null ? email : "전체",
            "memberId", memberId != null ? memberId : "전체"
        ));
        result.put("pagination", Map.of("page", page, "size", size));
        
        Map<String, Object> n1Stats = new HashMap<>();
        n1Stats.put("executionTime", n1ExecutionTime);
        n1Stats.put("totalMembers", n1Result.get("totalMembers"));
        n1Stats.put("filteredMembers", n1Result.get("filteredMembers"));
        result.put("nonOptimized", n1Stats);
        
        Map<String, Object> optStats = new HashMap<>();
        optStats.put("executionTime", optExecutionTime);
        optStats.put("totalMembers", optResult.get("totalMembers"));
        optStats.put("filteredMembers", optResult.get("filteredMembers"));
        result.put("optimized", optStats);
        
        // 성능 개선율 계산
        double timeImprovement = n1ExecutionTime > 0 ? 
            ((double)(n1ExecutionTime - optExecutionTime) / n1ExecutionTime) * 100 : 0;
        
        Map<String, Object> improvement = new HashMap<>();
        improvement.put("timeImprovement", String.format("%.1f%%", timeImprovement));
        improvement.put("timeSaved", n1ExecutionTime - optExecutionTime);
        result.put("improvement", improvement);
        
        log.info("=== 관리자 회원 목록 조회 성능 비교 결과 ===");
        log.info("비최적화 방식: {}ms", n1ExecutionTime);
        log.info("최적화 방식: {}ms", optExecutionTime);
        log.info("성능 개선: {}% (시간)", String.format("%.1f", timeImprovement));
        
        return result;
    }
    
    /**
     * 관리자 대시보드 전체 성능 비교 (종합 테스트)
     */
    @GetMapping("/admin/compare/all")
    public Map<String, Object> compareAdminDashboardPerformance(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        
        Map<String, Object> result = new HashMap<>();
        
        log.info("=== 관리자 대시보드 전체 성능 비교 테스트 시작 ===");
        
        // 상품 목록 조회 성능 비교
        Map<String, Object> booksResult = compareAdminBooksPerformance(page, size, null, null, null, null, null, "desc");
        
        // 주문 목록 조회 성능 비교
        Map<String, Object> ordersResult = compareAdminOrdersPerformance(page, size, null, null, null);
        
        // 회원 목록 조회 성능 비교
        Map<String, Object> membersResult = compareAdminMembersPerformance(page, size, null, null, null);
        
        // 종합 결과
        result.put("testType", "관리자 대시보드 전체 성능 비교");
        result.put("booksPerformance", booksResult);
        result.put("ordersPerformance", ordersResult);
        result.put("membersPerformance", membersResult);
        
        // 전체 성능 개선율 계산
        @SuppressWarnings("unchecked")
        Map<String, Object> booksImprovementMap = (Map<String, Object>) booksResult.get("improvement");
        @SuppressWarnings("unchecked")
        Map<String, Object> ordersImprovementMap = (Map<String, Object>) ordersResult.get("improvement");
        @SuppressWarnings("unchecked")
        Map<String, Object> membersImprovementMap = (Map<String, Object>) membersResult.get("improvement");
        
        double booksImprovement = Double.parseDouble(booksImprovementMap.get("timeImprovement").toString().replace("%", ""));
        double ordersImprovement = Double.parseDouble(ordersImprovementMap.get("timeImprovement").toString().replace("%", ""));
        double membersImprovement = Double.parseDouble(membersImprovementMap.get("timeImprovement").toString().replace("%", ""));
        
        double avgImprovement = (booksImprovement + ordersImprovement + membersImprovement) / 3;
        
        Map<String, Object> overallImprovement = new HashMap<>();
        overallImprovement.put("averageImprovement", String.format("%.1f%%", avgImprovement));
        overallImprovement.put("booksImprovement", String.format("%.1f%%", booksImprovement));
        overallImprovement.put("ordersImprovement", String.format("%.1f%%", ordersImprovement));
        overallImprovement.put("membersImprovement", String.format("%.1f%%", membersImprovement));
        result.put("overallImprovement", overallImprovement);
        
        log.info("=== 관리자 대시보드 전체 성능 비교 결과 ===");
        log.info("상품 목록 개선율: {}%", String.format("%.1f", booksImprovement));
        log.info("주문 목록 개선율: {}%", String.format("%.1f", ordersImprovement));
        log.info("회원 목록 개선율: {}%", String.format("%.1f", membersImprovement));
        log.info("전체 평균 개선율: {}%", String.format("%.1f", avgImprovement));
        
        return result;
    }
    
    /**
     * Book 엔티티를 BookPerformanceDto로 변환
     */
    private List<BookPerformanceDto> convertToPerformanceDto(List<Book> books) {
        return books.stream()
                .map(this::convertToPerformanceDto)
                .toList();
    }
    
    /**
     * Book 엔티티를 BookPerformanceDto로 변환 (N+1 문제 발생용)
     * 연관 엔티티에 접근할 때 추가 쿼리가 발생합니다.
     */
    private List<BookPerformanceDto> convertToPerformanceDtoWithNPlus1(List<Book> books) {
        return books.stream()
                .map(this::convertToPerformanceDtoWithNPlus1)
                .toList();
    }
    
    /**
     * 단일 Book 엔티티를 BookPerformanceDto로 변환 (N+1 문제 발생용)
     */
    private BookPerformanceDto convertToPerformanceDtoWithNPlus1(Book book) {
        try {
            // 카테고리 정보 (N+1 문제 발생 - 별도 쿼리 실행)
            BookPerformanceDto.CategoryInfo categoryInfo = null;
            if (book.getCategory() != null) {
                var category = book.getCategory();
                categoryInfo = BookPerformanceDto.CategoryInfo.builder()
                        .categoryId(category.getCategoryId())
                        .categoryName(category.getCategoryName())
                        .level(category.getLevel())
                        .parentId(category.getParent() != null ? category.getParent().getCategoryId() : null)
                        .parentName(category.getParent() != null ? category.getParent().getCategoryName() : null)
                        .build();
            }
            
            // 저자 정보 (N+1 문제 발생 - 각 도서마다 별도 쿼리 실행)
            List<BookPerformanceDto.AuthorInfo> authors = book.getBookAuthors().stream()
                    .map(ba -> {
                        var author = ba.getAuthor();
                        return BookPerformanceDto.AuthorInfo.builder()
                                .authorId(author.getAuthorId())
                                .name(author.getName())
                                .description(author.getDescription())
                                .authorOrder(ba.getAuthorOrder())
                                .build();
                    })
                    .toList();
            
            // 재고 정보 (N+1 문제 발생 - 별도 쿼리 실행)
            BookPerformanceDto.StockInfo stockInfo = null;
            if (book.getStock() != null) {
                var stock = book.getStock();
                stockInfo = BookPerformanceDto.StockInfo.builder()
                        .stockId(stock.getStockId())
                        .quantity(stock.getQuantity())
                        .lastUpdated(stock.getLastUpdated())
                        .build();
            }
            
            return BookPerformanceDto.builder()
                    .bookId(book.getBookId())
                    .isbn(book.getIsbn())
                    .title(book.getTitle())
                    .description(book.getDescription())
                    .width(book.getWidth())
                    .height(book.getHeight())
                    .pageCount(book.getPageCount())
                    .thumbnailUrl(book.getThumbnailUrl())
                    .previewUrl(book.getPreviewUrl())
                    .ratingAvg(book.getRatingAvg())
                    .bookStatus(book.getBookStatus())
                    .registrationDate(book.getRegistrationDate())
                    .price(book.getPrice())
                    .publisher(book.getPublisher())
                    .salesCount(book.getSalesCount())
                    .monthlySales(book.getMonthlySales())
                    .lastSalesUpdate(book.getLastSalesUpdate())
                    .category(categoryInfo)
                    .authors(authors)
                    .stock(stockInfo)
                    .build();
        } catch (Exception e) {
            // 에러 발생 시 기본 정보만 포함한 DTO 반환
            log.error("DTO 변환 중 오류 발생: {}", e.getMessage());
            return BookPerformanceDto.builder()
                    .bookId(book.getBookId())
                    .title(book.getTitle())
                    .price(book.getPrice())
                    .build();
        }
    }
    
    /**
     * 단일 Book 엔티티를 BookPerformanceDto로 변환
     */
    private BookPerformanceDto convertToPerformanceDto(Book book) {
        try {
            // 카테고리 정보
            BookPerformanceDto.CategoryInfo categoryInfo = null;
            if (book.getCategory() != null) {
                var category = book.getCategory();
                categoryInfo = BookPerformanceDto.CategoryInfo.builder()
                        .categoryId(category.getCategoryId())
                        .categoryName(category.getCategoryName())
                        .level(category.getLevel())
                        .parentId(category.getParent() != null ? category.getParent().getCategoryId() : null)
                        .parentName(category.getParent() != null ? category.getParent().getCategoryName() : null)
                        .build();
            }
            
            // 저자 정보
            List<BookPerformanceDto.AuthorInfo> authors = book.getBookAuthors().stream()
                    .map(ba -> {
                        var author = ba.getAuthor();
                        return BookPerformanceDto.AuthorInfo.builder()
                                .authorId(author.getAuthorId())
                                .name(author.getName())
                                .description(author.getDescription())
                                .authorOrder(ba.getAuthorOrder())
                                .build();
                    })
                    .toList();
            
            // 재고 정보
            BookPerformanceDto.StockInfo stockInfo = null;
            if (book.getStock() != null) {
                var stock = book.getStock();
                stockInfo = BookPerformanceDto.StockInfo.builder()
                        .stockId(stock.getStockId())
                        .quantity(stock.getQuantity())
                        .lastUpdated(stock.getLastUpdated())
                        .build();
            }
            
            return BookPerformanceDto.builder()
                    .bookId(book.getBookId())
                    .isbn(book.getIsbn())
                    .title(book.getTitle())
                    .description(book.getDescription())
                    .width(book.getWidth())
                    .height(book.getHeight())
                    .pageCount(book.getPageCount())
                    .thumbnailUrl(book.getThumbnailUrl())
                    .previewUrl(book.getPreviewUrl())
                    .ratingAvg(book.getRatingAvg())
                    .bookStatus(book.getBookStatus())
                    .registrationDate(book.getRegistrationDate())
                    .price(book.getPrice())
                    .publisher(book.getPublisher())
                    .salesCount(book.getSalesCount())
                    .monthlySales(book.getMonthlySales())
                    .lastSalesUpdate(book.getLastSalesUpdate())
                    .category(categoryInfo)
                    .authors(authors)
                    .stock(stockInfo)
                    .build();
        } catch (Exception e) {
            // 에러 발생 시 기본 정보만 포함한 DTO 반환
            System.err.println("DTO 변환 중 오류 발생: " + e.getMessage());
            return BookPerformanceDto.builder()
                    .bookId(book.getBookId())
                    .title(book.getTitle())
                    .price(book.getPrice())
                    .build();
        }
    }
}
