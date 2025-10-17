package com.bookstore.bookstore.repository.book;

import com.bookstore.bookstore.entity.book.Book;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BookRepository extends JpaRepository<Book, Long> {
    
    /**
     * 특정 카테고리의 책 목록 조회 (저자, 카테고리, 재고 정보 포함)
     */
    @Query("SELECT DISTINCT b FROM Book b " +
           "LEFT JOIN FETCH b.bookAuthors ba " +
           "LEFT JOIN FETCH ba.author " +
           "LEFT JOIN FETCH b.category " +
           "LEFT JOIN FETCH b.stock " +
           "WHERE b.category.categoryId = :categoryId")
    List<Book> findByCategoryCategoryId(@Param("categoryId") Long categoryId);
    
    /**
     * 전체 책 목록 조회 (저자, 카테고리, 재고 정보 포함)
     */
    @Query("SELECT DISTINCT b FROM Book b " +
           "LEFT JOIN FETCH b.bookAuthors ba " +
           "LEFT JOIN FETCH ba.author " +
           "LEFT JOIN FETCH b.category " +
           "LEFT JOIN FETCH b.stock " +
           "ORDER BY b.bookId DESC")
    List<Book> findAllWithAuthors();
    
    /**
     * 키워드로 책 검색 (제목, 출판사, 저자명)
     */
    @Query("SELECT DISTINCT b FROM Book b " +
           "LEFT JOIN FETCH b.bookAuthors ba " +
           "LEFT JOIN FETCH ba.author a " +
           "LEFT JOIN FETCH b.category " +
           "LEFT JOIN FETCH b.stock " +
           "WHERE LOWER(b.title) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
           "   OR LOWER(b.publisher) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
           "   OR LOWER(a.name) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
           "ORDER BY b.bookId DESC")
    List<Book> searchBooks(@Param("keyword") String keyword);
    
    /**
     * 월간 베스트셀러 조회 (상위 10개)
     */
    @Query("SELECT DISTINCT b FROM Book b " +
           "LEFT JOIN FETCH b.bookAuthors ba " +
           "LEFT JOIN FETCH ba.author " +
           "WHERE b.monthlySales > 0 " +
           "ORDER BY b.monthlySales DESC, b.salesCount DESC")
    List<Book> findMonthlyBestsellers();
    
    /**
     * 도서 상세 정보 조회 (저자, 재고 정보 포함)
     */
    @Query("SELECT DISTINCT b FROM Book b " +
           "LEFT JOIN FETCH b.bookAuthors ba " +
           "LEFT JOIN FETCH ba.author " +
           "LEFT JOIN FETCH b.stock " +
           "WHERE b.bookId = :bookId")
    Book findByIdWithDetails(@Param("bookId") Long bookId);
    
    /**
     * 특정 카테고리의 책 수 조회
     */
    long countByCategoryCategoryId(Long categoryId);
    
    /**
     * 전체 책 수 조회 (JpaRepository의 count() 메서드 사용)
     * 이미 상속받아서 사용 가능
     */



    // ===== N+1 문제 발생하는 기존 방식 메서드들 (성능 테스트용) =====
    
    /**
     * N+1 문제 발생: 기본 JPA 메서드로 전체 도서 조회 (연관 엔티티 지연 로딩)
     * 성능 테스트를 위해 추가된 메서드
     */
    // findAll() 메서드는 이미 JpaRepository에서 상속받음
    
    /**
     * N+1 문제 발생: 기본 JPA 메서드로 카테고리별 도서 조회 (연관 엔티티 지연 로딩)
     * 성능 테스트를 위해 추가된 메서드
     */
    List<Book> findByCategoryCategoryIdOrderByBookIdDesc(Long categoryId);
    
    
    /**
     * N+1 문제 발생: 기본 쿼리로 카테고리별 도서 조회 (연관 엔티티 지연 로딩)
     * 성능 테스트를 위해 추가된 메서드
     * 이 메서드는 연관 엔티티를 fetch하지 않아서 N+1 문제가 발생합니다.
     */
    @Query("SELECT b FROM Book b WHERE b.category.categoryId = :categoryId ORDER BY b.bookId DESC")
    List<Book> findBooksByCategoryIdNPlus1(@Param("categoryId") Long categoryId);
    
    /**
     * N+1 문제 발생: 기본 JPA 메서드로 도서 검색 (연관 엔티티 지연 로딩)
     * 성능 테스트를 위해 추가된 메서드
     */
    List<Book> findByTitleContainingIgnoreCaseOrPublisherContainingIgnoreCaseOrderByBookIdDesc(String title, String publisher);
    
    /**
     * N+1 문제 발생: 기본 쿼리로 도서 검색 (연관 엔티티 지연 로딩)
     * 성능 테스트를 위해 추가된 메서드
     * 이 메서드는 연관 엔티티를 fetch하지 않아서 N+1 문제가 발생합니다.
     */
    @Query("SELECT b FROM Book b WHERE LOWER(b.title) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
           "   OR LOWER(b.publisher) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
           "ORDER BY b.bookId DESC")
    List<Book> searchBooksNPlus1(@Param("keyword") String keyword);
}


