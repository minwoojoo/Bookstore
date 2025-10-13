package com.bookstore.bookstore.entity.customer;

import com.bookstore.bookstore.entity.etc.AccessLog;
import com.bookstore.bookstore.entity.order.Cart;
import com.bookstore.bookstore.entity.order.Order;
import com.bookstore.bookstore.entity.review.Review;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "member")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Member {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "member_id")
    private Long memberId;
    
    @Column(name = "user_id", nullable = false, unique = true, length = 50)
    private String userId;
    
    @Column(name = "password", nullable = false, length = 255)
    private String password;
    
    @Column(name = "name", nullable = false, length = 100)
    private String name;
    
    @Column(name = "email", nullable = false, length = 200)
    private String email;
    
    @Column(name = "phone", length = 50)
    private String phone;
    
    @Column(name = "member_grade", length = 50)
    private String memberGrade;
    
    @Column(name = "status", length = 50)
    private String status;
    
    @Column(name = "registration_date")
    private LocalDateTime registrationDate;
    
    @Column(name = "last_login")
    private LocalDateTime lastLogin;
    
    // 회원 주소록과의 관계
    @OneToMany(mappedBy = "member", cascade = CascadeType.ALL)
    @Builder.Default
    private List<MemberAddress> addresses = new ArrayList<>();
    
    // 주문과의 관계
    @OneToMany(mappedBy = "member")
    @Builder.Default
    private List<Order> orders = new ArrayList<>();
    
    // 장바구니와의 관계
    @OneToMany(mappedBy = "member")
    @Builder.Default
    private List<Cart> carts = new ArrayList<>();
    
    // 리뷰와의 관계
    @OneToMany(mappedBy = "member")
    @Builder.Default
    private List<Review> reviews = new ArrayList<>();
    
    // 접속 로그와의 관계
    @OneToMany(mappedBy = "member")
    @Builder.Default
    private List<AccessLog> accessLogs = new ArrayList<>();
    
    @PrePersist
    public void prePersist() {
        this.registrationDate = LocalDateTime.now();
        if (this.status == null) {
            this.status = "ACTIVE";
        }
        if (this.memberGrade == null) {
            this.memberGrade = "BRONZE";
        }
    }
    
    /**
     * 비밀번호 변경
     */
    public void changePassword(String newPassword) {
        this.password = newPassword;
    }
}

