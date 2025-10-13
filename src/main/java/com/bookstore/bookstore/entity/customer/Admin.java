package com.bookstore.bookstore.entity.customer;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "admin")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Admin {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "admin_id")
    private Long adminId;
    
    @Column(name = "login_id", nullable = false, unique = true, length = 50)
    private String loginId;
    
    @Column(name = "password", nullable = false, length = 255)
    private String password;
    
    @Column(name = "name", nullable = false, length = 100)
    private String name;
    
    @Column(name = "role", length = 50)
    private String role;
    
    @Column(name = "is_active")
    private Boolean isActive;
    
    @Column(name = "created_date")
    private LocalDateTime createdDate;
    
    @Column(name = "last_login_date")
    private LocalDateTime lastLoginDate;
    
    @PrePersist
    public void prePersist() {
        this.createdDate = LocalDateTime.now();
        if (this.isActive == null) {
            this.isActive = true;
        }
        if (this.role == null) {
            this.role = "ADMIN";
        }
    }
    
    // 로그인 시 마지막 로그인 시간 업데이트
    public void updateLastLogin() {
        this.lastLoginDate = LocalDateTime.now();
    }
    
    // 계정 활성화
    public void activate() {
        this.isActive = true;
    }
    
    // 계정 비활성화
    public void deactivate() {
        this.isActive = false;
    }
}
