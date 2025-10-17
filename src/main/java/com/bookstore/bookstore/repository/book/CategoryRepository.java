package com.bookstore.bookstore.repository.book;

import com.bookstore.bookstore.entity.book.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CategoryRepository extends JpaRepository<Category, Long> {
    
    /**
     * 최상위 카테고리 조회 (parent_id가 NULL인 카테고리)
     */
    List<Category> findByParentIsNull();
    
    /**
     * 특정 레벨의 카테고리 조회
     */
    List<Category> findByLevel(Integer level);
    
    /**
     * 특정 부모 카테고리의 하위 카테고리 조회
     */
    List<Category> findByParentCategoryId(Long parentId);
    
    /**
     * Level 2 카테고리 조회 (대분류)
     */
    @Query("SELECT c FROM Category c WHERE c.level = 2 ORDER BY c.categoryId")
    List<Category> findLevel2Categories();
    
    /**
     * Level 2 카테고리 조회 (대분류) - 모든 카테고리
     * 건강/취미(2), 경제/경영(3), 소설/시/희곡(4), 역사(5), 인문(6), 자기계발(7)
     */
    @Query("SELECT c FROM Category c WHERE c.level = 2 ORDER BY c.categoryId")
    List<Category> findLevel2CategoriesWithBooks();
    
    /**
     * Level 3 카테고리 조회 (중분류) - 특정 부모 카테고리
     */
    @Query("SELECT c FROM Category c WHERE c.level = 3 AND c.parent.categoryId = :parentId ORDER BY c.categoryId")
    List<Category> findLevel3CategoriesByParent(Long parentId);
}

