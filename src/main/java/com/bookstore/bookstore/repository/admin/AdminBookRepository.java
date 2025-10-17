package com.bookstore.bookstore.repository.admin;

import com.bookstore.bookstore.dto.admin.AdminBookListRequest;
import com.bookstore.bookstore.entity.book.Book;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.List;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 관리자 상품 관리 리포지토리
 */
@Repository
public interface AdminBookRepository extends JpaRepository<Book, Long> {
    
    /**
     * 필터 조건에 따른 상품 목록 조회 (페이징용)
     */
    @Query("SELECT b FROM Book b " +
           "WHERE (:bookTitle IS NULL OR LOWER(b.title) LIKE LOWER(CONCAT('%', :bookTitle, '%'))) " +
           "AND (:publisher IS NULL OR LOWER(b.publisher) LIKE LOWER(CONCAT('%', :publisher, '%'))) " +
           "AND (:author IS NULL OR b.bookId IN (SELECT DISTINCT ba.book.bookId FROM BookAuthor ba JOIN ba.author a WHERE LOWER(a.name) LIKE LOWER(CONCAT('%', :author, '%')))) " +
           "AND (:minStock IS NULL OR (b.stock IS NOT NULL AND b.stock.quantity >= :minStock)) " +
           "AND (:maxStock IS NULL OR (b.stock IS NOT NULL AND b.stock.quantity <= :maxStock)) " +
           "AND (:saleStatus IS NULL OR b.bookStatus = :saleStatus) " +
           "AND (:startDate IS NULL OR b.registrationDate >= :startDate) " +
           "AND (:endDate IS NULL OR b.registrationDate <= :endDate)")
    Page<Book> findBooksWithFilters(
            @Param("bookTitle") String bookTitle,
            @Param("publisher") String publisher,
            @Param("author") String author,
            @Param("minStock") Integer minStock,
            @Param("maxStock") Integer maxStock,
            @Param("saleStatus") String saleStatus,
            @Param("startDate") LocalDateTime startDate,
            @Param("endDate") LocalDateTime endDate,
            Pageable pageable);
    
    
    /**
     * AdminBookListRequest를 사용한 상품 목록 조회
     */
    default Page<Book> findBooksWithFilters(AdminBookListRequest request, Pageable pageable) {
        // LocalDate를 LocalDateTime으로 변환
        LocalDateTime startDate = request.getStartDate() != null ? 
            request.getStartDate().atStartOfDay() : null;
        LocalDateTime endDate = request.getEndDate() != null ? 
            request.getEndDate().plusDays(1).atStartOfDay() : null;
            
        return findBooksWithFilters(
                request.getBookTitle(),
                request.getPublisher(),
                request.getAuthor(),
                request.getMinStock(),
                request.getMaxStock(),
                request.getSaleStatus(),
                startDate,
                endDate,
                pageable
        );
    }
    
    /**
     * 상품 상세 조회 (연관 엔티티 포함)
     */
    @Query("SELECT b FROM Book b " +
           "LEFT JOIN FETCH b.bookAuthors ba " +
           "LEFT JOIN FETCH ba.author " +
           "LEFT JOIN FETCH b.category " +
           "LEFT JOIN FETCH b.stock " +
           "WHERE b.bookId = :bookId")
    Optional<Book> findByIdWithDetails(@Param("bookId") Long bookId);
    
    /**
     * 판매상태별 상품 수 조회
     */
    @Query("SELECT b.bookStatus, COUNT(b) FROM Book b GROUP BY b.bookStatus")
    Object[][] countBySaleStatus();
    
    /**
     * 카테고리별 상품 수 조회
     */
    @Query("SELECT c.categoryName, COUNT(b) FROM Book b LEFT JOIN b.category c GROUP BY c.categoryName")
    Object[][] countByCategory();
    
    /**
     * 월별 상품 등록 수 조회
     */
    @Query("SELECT FUNCTION('YEAR', b.registrationDate), FUNCTION('MONTH', b.registrationDate), COUNT(b) " +
           "FROM Book b " +
           "WHERE b.registrationDate >= :startDate " +
           "GROUP BY FUNCTION('YEAR', b.registrationDate), FUNCTION('MONTH', b.registrationDate) " +
           "ORDER BY FUNCTION('YEAR', b.registrationDate), FUNCTION('MONTH', b.registrationDate)")
    Object[][] countByMonth(@Param("startDate") LocalDateTime startDate);
    
    /**
     * 특정 판매 상태의 도서 수 조회
     */
    @Query("SELECT COUNT(b) FROM Book b WHERE b.bookStatus = :status")
    Long countByBookStatus(@Param("status") String status);
    
    /**
     * 재고 부족 도서 수 조회 (지정된 수량 이하)
     */
    @Query("SELECT COUNT(b) FROM Book b WHERE b.stock IS NOT NULL AND b.stock.quantity <= :quantity")
    Long countLowStockBooks(@Param("quantity") Integer quantity);
    
    /**
     * 재고 부족 도서 조회 (지정된 수량 이하, 최대 개수)
     */
    @Query("SELECT b FROM Book b " +
           "LEFT JOIN FETCH b.stock s " +
           "WHERE s IS NOT NULL AND s.quantity <= :quantity " +
           "ORDER BY s.quantity ASC")
    List<Book> findLowStockBooks(@Param("quantity") Integer quantity, @Param("limit") int limit);
}
