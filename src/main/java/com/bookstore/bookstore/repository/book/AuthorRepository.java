package com.bookstore.bookstore.repository.book;

import com.bookstore.bookstore.entity.book.Author;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

/**
 * Author 엔티티 Repository
 */
@Repository
public interface AuthorRepository extends JpaRepository<Author, Long> {
    
    /**
     * 저자 이름으로 조회
     */
    Optional<Author> findByName(String name);
    
    /**
     * 저자 이름 존재 여부 확인
     */
    boolean existsByName(String name);
}
