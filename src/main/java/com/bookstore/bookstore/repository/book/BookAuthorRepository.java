package com.bookstore.bookstore.repository.book;

import com.bookstore.bookstore.entity.book.BookAuthor;
import com.bookstore.bookstore.entity.book.BookAuthorId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * BookAuthor 엔티티 Repository
 */
@Repository
public interface BookAuthorRepository extends JpaRepository<BookAuthor, BookAuthorId> {
    
    /**
     * 특정 책의 저자 목록 조회
     */
    List<BookAuthor> findByBookId(Long bookId);
    
    /**
     * 특정 저자의 책 목록 조회
     */
    List<BookAuthor> findByAuthorId(Long authorId);
    
    /**
     * 특정 책의 저자 삭제
     */
    void deleteByBookId(Long bookId);
}
