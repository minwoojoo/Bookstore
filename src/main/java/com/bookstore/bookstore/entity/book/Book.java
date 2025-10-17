package com.bookstore.bookstore.entity.book;

import com.bookstore.bookstore.entity.customer.Admin;
import com.bookstore.bookstore.entity.etc.AccessLog;
import com.bookstore.bookstore.entity.order.CartItem;
import com.bookstore.bookstore.entity.order.OrderItem;
import com.bookstore.bookstore.entity.review.Review;
import jakarta.persistence.*;
import lombok.*;
import com.fasterxml.jackson.annotation.JsonIgnore;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "book")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Book {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "book_id")
    private Long bookId;
    
    @Column(name = "isbn", nullable = false, unique = true, length = 20)
    private String isbn;
    
    @Column(name = "title", nullable = false, length = 500)
    private String title;
    
    @Column(name = "description", columnDefinition = "TEXT")
    private String description;
    
    @Column(name = "width")
    private Integer width;
    
    @Column(name = "height")
    private Integer height;
    
    @Column(name = "page_count")
    private Integer pageCount;
    
    @Column(name = "thumbnail_url", length = 500)
    private String thumbnailUrl;
    
    @Column(name = "preview_url", length = 500)
    private String previewUrl;
    
    @Column(name = "rating_avg", precision = 3, scale = 2)
    private BigDecimal ratingAvg;
    
    @Column(name = "book_status", length = 50)
    private String bookStatus;
    
    @Column(name = "registration_date")
    private LocalDateTime registrationDate;
    
    @Column(name = "price", precision = 10, scale = 2)
    private BigDecimal price;
    
    @Column(name = "publisher", length = 200)
    private String publisher;
    
    @Column(name = "sales_count")
    private Integer salesCount;
    
    @Column(name = "monthly_sales")
    private Integer monthlySales;
    
    @Column(name = "last_sales_update")
    private LocalDateTime lastSalesUpdate;
    
    // 카테고리와의 관계
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id")
    private Category category;
    
    // 생성 관리자와의 관계
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "created_admin_id")
    private Admin createdAdmin;
    
    // 수정 관리자와의 관계
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "updated_admin_id")
    private Admin updatedAdmin;
    
    // 재고와의 관계 (1:1)
    @OneToOne(mappedBy = "book", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Stock stock;
    
    // 저자와의 관계 (중간 테이블)
    @OneToMany(mappedBy = "book", cascade = CascadeType.ALL)
    @Builder.Default
    private List<BookAuthor> bookAuthors = new ArrayList<>();
    
    // 리뷰와의 관계
    @OneToMany(mappedBy = "book")
    @Builder.Default
    @JsonIgnore
    private List<Review> reviews = new ArrayList<>();
    
    // 장바구니 아이템과의 관계
    @OneToMany(mappedBy = "book")
    @Builder.Default
    @JsonIgnore
    private List<CartItem> cartItems = new ArrayList<>();
    
    // 주문 아이템과의 관계 (ERD 설계에 따라 book_id로 참조)
    @OneToMany(mappedBy = "book")
    @Builder.Default
    @JsonIgnore
    private List<OrderItem> orderItems = new ArrayList<>();
    
    // 접속 로그와의 관계 (이 책이 조회된 기록)
    @OneToMany(mappedBy = "book")
    @Builder.Default
    @JsonIgnore
    private List<AccessLog> accessLogs = new ArrayList<>();
    
    @PrePersist
    public void prePersist() {
        this.registrationDate = LocalDateTime.now();
        if (this.salesCount == null) {
            this.salesCount = 0;
        }
        if (this.monthlySales == null) {
            this.monthlySales = 0;
        }
    }
    
    // 책 수정 시 수정 관리자 업데이트
    public void updateByAdmin(Admin admin) {
        this.updatedAdmin = admin;
    }
    
    /**
     * 판매량 증가
     */
    public void increaseSalesCount(int quantity) {
        this.salesCount = (this.salesCount == null ? 0 : this.salesCount) + quantity;
        this.monthlySales = (this.monthlySales == null ? 0 : this.monthlySales) + quantity;
        this.lastSalesUpdate = LocalDateTime.now();
    }
    
    /**
     * 월간 판매량 초기화 (매월 1일 실행)
     */
    public void resetMonthlySales() {
        this.monthlySales = 0;
        this.lastSalesUpdate = LocalDateTime.now();
    }
}

