package com.bookstore.bookstore.entity.etc;

import com.bookstore.bookstore.entity.book.Book;
import com.bookstore.bookstore.entity.customer.Member;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

/**
 * 최근 본 상품 엔티티
 */
@Entity
@Table(name = "recent_view")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RecentView {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "recent_view_id")
    private Long recentViewId;
    
    @Column(name = "member_id", nullable = false)
    private Long memberId;
    
    @Column(name = "book_id", nullable = false)
    private Long bookId;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "member_id", insertable = false, updatable = false)
    private Member member;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "book_id", insertable = false, updatable = false)
    private Book book;
    
    @CreationTimestamp
    @Column(name = "viewed_time", nullable = false, updatable = false)
    private LocalDateTime viewedTime;
}
