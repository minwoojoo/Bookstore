package com.bookstore.bookstore.entity.book;

import jakarta.persistence.*;
import lombok.*;
import com.fasterxml.jackson.annotation.JsonIgnore;

@Entity
@Table(name = "book_author")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@IdClass(BookAuthorId.class)
public class BookAuthor {
    
    @Id
    @Column(name = "book_id")
    private Long bookId;
    
    @Id
    @Column(name = "author_id")
    private Long authorId;
    
    @Column(name = "author_order")
    private Integer authorOrder;
    
    // 책과의 관계
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "book_id", insertable = false, updatable = false)
    @JsonIgnore
    private Book book;
    
    // 저자와의 관계
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "author_id", insertable = false, updatable = false)
    private Author author;
}

