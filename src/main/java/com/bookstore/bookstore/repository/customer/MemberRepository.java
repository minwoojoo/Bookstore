package com.bookstore.bookstore.repository.customer;

import com.bookstore.bookstore.entity.customer.Member;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

/**
 * Member 엔티티 Repository
 */
@Repository
public interface MemberRepository extends JpaRepository<Member, Long> {
    
    /**
     * 사용자 ID로 회원 조회
     */
    Optional<Member> findByUserId(String userId);
    
    /**
     * 이메일로 회원 조회
     */
    Optional<Member> findByEmail(String email);
    
    /**
     * 사용자 ID 중복 확인
     */
    boolean existsByUserId(String userId);
    
    /**
     * 이메일 중복 확인
     */
    boolean existsByEmail(String email);
    
    /**
     * 회원 ID로 주소와 함께 조회 (Fetch Join)
     */
    @Query("SELECT m FROM Member m LEFT JOIN FETCH m.addresses WHERE m.memberId = :memberId")
    Optional<Member> findByIdWithAddresses(@Param("memberId") Long memberId);
}
