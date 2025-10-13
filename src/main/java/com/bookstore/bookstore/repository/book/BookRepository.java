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
     * 특정 카테고리의 책 목록 조회 (저자 정보 포함)
     */
    @Query("SELECT DISTINCT b FROM Book b " +
           "LEFT JOIN FETCH b.bookAuthors ba " +
           "LEFT JOIN FETCH ba.author " +
           "WHERE b.category.categoryId = :categoryId")
    List<Book> findByCategoryCategoryId(@Param("categoryId") Long categoryId);
    
    /**
     * 전체 책 목록 조회 (저자 정보 포함)
     */
    @Query("SELECT DISTINCT b FROM Book b " +
           "LEFT JOIN FETCH b.bookAuthors ba " +
           "LEFT JOIN FETCH ba.author " +
           "ORDER BY b.bookId DESC")
    List<Book> findAllWithAuthors();
    
    /**
     * 키워드로 책 검색 (제목, 출판사, 저자명)
     */
    @Query("SELECT DISTINCT b FROM Book b " +
           "LEFT JOIN FETCH b.bookAuthors ba " +
           "LEFT JOIN FETCH ba.author a " +
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
}


