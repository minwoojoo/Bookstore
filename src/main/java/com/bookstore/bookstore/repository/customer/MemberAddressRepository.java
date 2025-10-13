package com.bookstore.bookstore.repository.customer;

import com.bookstore.bookstore.entity.customer.MemberAddress;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * 회원 주소 정보 Repository
 */
@Repository
public interface MemberAddressRepository extends JpaRepository<MemberAddress, Long> {
    
    /**
     * 회원 ID로 주소 목록 조회
     * 
     * @param memberId 회원 ID
     * @return 주소 목록
     */
    List<MemberAddress> findByMemberMemberId(Long memberId);
    
    /**
     * 회원 ID와 주소 ID로 주소 조회
     * 
     * @param memberId 회원 ID
     * @param addressId 주소 ID
     * @return 주소 정보 (Optional)
     */
    java.util.Optional<MemberAddress> findByMemberMemberIdAndAddressId(Long memberId, Long addressId);
}
