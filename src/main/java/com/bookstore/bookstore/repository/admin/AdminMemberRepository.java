package com.bookstore.bookstore.repository.admin;

import com.bookstore.bookstore.dto.admin.AdminMemberListRequest;
import com.bookstore.bookstore.entity.customer.Member;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.List;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 관리자 회원 관리 리포지토리
 */
@Repository
public interface AdminMemberRepository extends JpaRepository<Member, Long> {
    
    /**
     * 필터 조건에 따른 회원 목록 조회
     */
    @Query("SELECT DISTINCT m FROM Member m " +
           "LEFT JOIN FETCH m.addresses " +
           "WHERE (:memberId IS NULL OR m.memberId = :memberId) " +
           "AND (:memberStatus IS NULL OR m.status = :memberStatus) " +
           "AND (:email IS NULL OR LOWER(m.email) LIKE LOWER(CONCAT('%', :email, '%'))) " +
           "AND (:startDate IS NULL OR m.registrationDate >= :startDate) " +
           "AND (:endDate IS NULL OR m.registrationDate <= :endDate) " +
           "AND (:memberGrade IS NULL OR m.memberGrade = :memberGrade) " +
           "AND (:memberName IS NULL OR LOWER(m.name) LIKE LOWER(CONCAT('%', :memberName, '%')))")
    Page<Member> findMembersWithFilters(
            @Param("memberId") String memberId,
            @Param("memberStatus") String memberStatus,
            @Param("email") String email,
            @Param("startDate") LocalDateTime startDate,
            @Param("endDate") LocalDateTime endDate,
            @Param("memberGrade") String memberGrade,
            @Param("memberName") String memberName,
            Pageable pageable);
    
    /**
     * AdminMemberListRequest를 사용한 회원 목록 조회
     */
    default Page<Member> findMembersWithFilters(AdminMemberListRequest request, Pageable pageable) {
        // LocalDate를 LocalDateTime으로 변환
        LocalDateTime startDate = request.getStartDate() != null ? 
            request.getStartDate().atStartOfDay() : null;
        LocalDateTime endDate = request.getEndDate() != null ? 
            request.getEndDate().plusDays(1).atStartOfDay() : null;
            
        return findMembersWithFilters(
                request.getMemberId(),
                request.getMemberStatus(),
                request.getEmail(),
                startDate,
                endDate,
                request.getMemberGrade(),
                request.getMemberName(),
                pageable
        );
    }
    
    /**
     * 회원 상세 조회 (연관 엔티티 포함)
     */
    @Query("SELECT m FROM Member m " +
           "LEFT JOIN FETCH m.addresses " +
           "WHERE m.memberId = :memberId")
    Optional<Member> findByIdWithDetails(@Param("memberId") Long memberId);
    
    /**
     * 회원 상태별 회원 수 조회
     */
    @Query("SELECT m.status, COUNT(m) FROM Member m GROUP BY m.status")
    Object[][] countByStatus();
    
    /**
     * 회원 등급별 회원 수 조회
     */
    @Query("SELECT m.memberGrade, COUNT(m) FROM Member m GROUP BY m.memberGrade")
    Object[][] countByGrade();
    
    /**
     * 월별 회원 가입 수 조회
     */
    @Query("SELECT FUNCTION('YEAR', m.registrationDate), FUNCTION('MONTH', m.registrationDate), COUNT(m) " +
           "FROM Member m " +
           "WHERE m.registrationDate >= :startDate " +
           "GROUP BY FUNCTION('YEAR', m.registrationDate), FUNCTION('MONTH', m.registrationDate) " +
           "ORDER BY FUNCTION('YEAR', m.registrationDate), FUNCTION('MONTH', m.registrationDate)")
    Object[][] countByMonth(@Param("startDate") LocalDateTime startDate);
    
    /**
     * 최근 가입한 회원 목록
     */
    @Query("SELECT m FROM Member m ORDER BY m.registrationDate DESC")
    Page<Member> findRecentMembers(Pageable pageable);
    
    /**
     * 장기 미접속 회원 목록 (30일 이상)
     */
    @Query("SELECT m FROM Member m " +
           "WHERE m.registrationDate < :cutoffDate " +
           "ORDER BY m.registrationDate ASC")
    Page<Member> findInactiveMembers(@Param("cutoffDate") LocalDateTime cutoffDate, Pageable pageable);
    
    /**
     * 회원별 주문 통계
     */
    @Query("SELECT m.memberId, m.name, m.email, COUNT(o), COALESCE(SUM(o.finalPaymentAmount), 0) " +
           "FROM Member m LEFT JOIN Order o ON m.memberId = o.memberId " +
           "WHERE o.orderDate >= :startDate OR o.orderDate IS NULL " +
           "GROUP BY m.memberId, m.name, m.email " +
           "ORDER BY COALESCE(SUM(o.finalPaymentAmount), 0) DESC")
    Object[][] getMemberOrderStats(@Param("startDate") LocalDateTime startDate);
    
    /**
     * 활성 회원 수 조회 (최근 30일 내 활동)
     */
    @Query("SELECT COUNT(DISTINCT m.memberId) FROM Member m " +
           "LEFT JOIN Order o ON m.memberId = o.memberId " +
           "WHERE o.orderDate >= :cutoffDate")
    Long countActiveMembers(@Param("cutoffDate") LocalDateTime cutoffDate);
    
    /**
     * 최근 회원 조회 (최대 3개)
     */
    List<Member> findTop3ByOrderByRegistrationDateDesc();
}
