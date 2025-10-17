package com.bookstore.bookstore.entity.book;

import jakarta.persistence.*;
import lombok.*;
import com.fasterxml.jackson.annotation.JsonIgnore;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "author")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Author {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "author_id")
    private Long authorId;
    
    @Column(name = "name", nullable = false, length = 100)
    private String name;
    
    @Column(name = "description", columnDefinition = "TEXT")
    private String description;
    
    // 저자가 집필한 책들 (중간 테이블을 통한 관계)
    @OneToMany(mappedBy = "author")
    @Builder.Default
    @JsonIgnore
    private List<BookAuthor> bookAuthors = new ArrayList<>();
}

