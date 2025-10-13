package com.bookstore.bookstore.entity.etc;

import com.bookstore.bookstore.entity.book.Book;
import com.bookstore.bookstore.entity.customer.Member;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "access_log")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AccessLog {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "log_id")
    private Long logId;
    
    @Column(name = "accessed_url", length = 500)
    private String accessedUrl;
    
    @Column(name = "accessed_date")
    private LocalDateTime accessedDate;
    
    // 회원과의 관계
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "member_id")
    private Member member;
    
    // 책과의 관계 (어떤 책을 조회했는지)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "book_id")
    private Book book;
    
    @PrePersist
    public void prePersist() {
        this.accessedDate = LocalDateTime.now();
    }
}

