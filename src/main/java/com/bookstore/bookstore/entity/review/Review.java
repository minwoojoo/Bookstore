package com.bookstore.bookstore.entity.review;

import com.bookstore.bookstore.entity.book.Book;
import com.bookstore.bookstore.entity.customer.Member;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "review")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Review {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "review_id")
    private Long reviewId;
    
    @Column(name = "rating", nullable = false)
    private Integer rating;
    
    @Column(name = "content", columnDefinition = "TEXT")
    private String content;
    
    @Column(name = "created_date")
    private LocalDateTime createdDate;
    
    // 책과의 관계
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "book_id", nullable = false)
    private Book book;
    
    // 회원과의 관계
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "member_id", nullable = false)
    private Member member;
    
    @PrePersist
    public void prePersist() {
        this.createdDate = LocalDateTime.now();
    }
}

