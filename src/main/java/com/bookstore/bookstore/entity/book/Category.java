package com.bookstore.bookstore.entity.book;

import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "category")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Category {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "category_id")
    private Long categoryId;
    
    @Column(name = "category_name", nullable = false, length = 100)
    private String categoryName;
    
    @Column(name = "level")
    private Integer level;
    
    // 자기 참조 관계 - 상위 카테고리
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_id")
    private Category parent;
    
    // 하위 카테고리 리스트
    @OneToMany(mappedBy = "parent", cascade = CascadeType.ALL)
    @Builder.Default
    private List<Category> children = new ArrayList<>();
    
    // 해당 카테고리에 속한 책들
    @OneToMany(mappedBy = "category")
    @Builder.Default
    private List<Book> books = new ArrayList<>();
}

