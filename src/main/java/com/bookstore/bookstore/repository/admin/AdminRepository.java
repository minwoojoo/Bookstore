package com.bookstore.bookstore.repository.admin;

import com.bookstore.bookstore.entity.customer.Admin;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

/**
 * 관리자 리포지토리
 */
@Repository
public interface AdminRepository extends JpaRepository<Admin, Long> {
    
    /**
     * 로그인 ID로 관리자 조회
     */
    Optional<Admin> findByLoginId(String loginId);
    
    /**
     * 활성 상태인 관리자 조회
     */
    Optional<Admin> findByLoginIdAndIsActiveTrue(String loginId);
    
    /**
     * 로그인 ID 존재 여부 확인
     */
    boolean existsByLoginId(String loginId);
}
