package com.bookstore.bookstore.service.customer;

import com.bookstore.bookstore.dto.customer.MemberAddressResponse;
import com.bookstore.bookstore.dto.customer.MemberResponse;
import com.bookstore.bookstore.entity.customer.Member;
import com.bookstore.bookstore.entity.customer.MemberAddress;
import com.bookstore.bookstore.repository.customer.MemberRepository;
import com.bookstore.bookstore.repository.customer.MemberAddressRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 회원 정보 관리 서비스
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class MemberService {
    
    private final MemberRepository memberRepository;
    private final MemberAddressRepository memberAddressRepository;
    
    /**
     * 회원 정보 조회
     * 
     * @param memberId 회원 ID
     * @return 회원 정보
     */
    @Transactional(readOnly = true)
    public MemberResponse getMemberInfo(Long memberId) {
        log.info("회원 정보 조회: memberId = {}", memberId);
        
        // Fetch Join으로 주소와 함께 조회
        Member member = memberRepository.findByIdWithAddresses(memberId)
            .orElseThrow(() -> new IllegalArgumentException("회원을 찾을 수 없습니다."));
        
        log.info("조회된 주소 개수: {}", member.getAddresses() != null ? member.getAddresses().size() : 0);
        
        // Entity → DTO 변환 (Service Layer에서 처리)
        List<MemberAddressResponse> addressResponses = member.getAddresses() != null ?
            member.getAddresses().stream()
                .map(address -> MemberAddressResponse.builder()
                    .addressId(address.getAddressId())
                    .postCode(address.getPostCode())
                    .addressName(address.getAddressName())
                    .addressBasic(address.getAddressBasic())
                    .addressDetail(address.getAddressDetail())
                    .build())
                .collect(Collectors.toList()) :
            List.of();
        
        return MemberResponse.builder()
            .memberId(member.getMemberId())
            .userId(member.getUserId())
            .name(member.getName())
            .email(member.getEmail())
            .phone(member.getPhone())
            .memberGrade(member.getMemberGrade())
            .status(member.getStatus())
            .registrationDate(member.getRegistrationDate())
            .lastLogin(member.getLastLogin())
            .addresses(addressResponses)
            .build();
    }
    
    /**
     * 사용자 정보 수정
     * 
     * @param memberId 회원 ID
     * @param name 이름
     * @param email 이메일
     * @param phone 전화번호
     */
    @Transactional
    public void updateMemberInfo(Long memberId, String name, String email, String phone) {
        log.info("사용자 정보 수정 시도: memberId = {}", memberId);
        
        Member member = memberRepository.findById(memberId)
            .orElseThrow(() -> new IllegalArgumentException("회원을 찾을 수 없습니다."));
        
        // 이름 수정
        if (name != null && !name.isEmpty()) {
            member.setName(name);
        }
        
        // 이메일 수정 (중복 체크)
        if (email != null && !email.isEmpty() && !email.equals(member.getEmail())) {
            if (memberRepository.findByEmail(email).isPresent()) {
                throw new IllegalArgumentException("이미 사용 중인 이메일입니다.");
            }
            member.setEmail(email);
        }
        
        // 전화번호 수정
        if (phone != null && !phone.isEmpty()) {
            member.setPhone(phone);
        }
        
        memberRepository.save(member);
        
        log.info("사용자 정보 수정 완료: memberId = {}", memberId);
    }
    
    /**
     * 주소 추가
     * 
     * @param memberId 회원 ID
     * @param addressName 주소명
     * @param postCode 우편번호
     * @param addressBasic 기본 주소
     * @param addressDetail 상세 주소
     * @return 추가된 주소 ID
     */
    @Transactional
    public Long addAddress(Long memberId, String addressName, String postCode, 
                          String addressBasic, String addressDetail) {
        log.info("주소 설정 시도: memberId = {}, addressName = {}", memberId, addressName);
        
        Member member = memberRepository.findById(memberId)
            .orElseThrow(() -> new IllegalArgumentException("회원을 찾을 수 없습니다."));
        
        if (addressName == null || addressName.trim().isEmpty()) {
            throw new IllegalArgumentException("주소명을 입력해주세요.");
        }
        
        if (postCode == null || postCode.trim().isEmpty()) {
            throw new IllegalArgumentException("우편번호를 입력해주세요.");
        }
        
        if (addressBasic == null || addressBasic.trim().isEmpty()) {
            throw new IllegalArgumentException("기본 주소를 입력해주세요.");
        }
        
        // 기존 주소가 있으면 모두 삭제 (주소는 하나만 유지)
        List<MemberAddress> existingAddresses = memberAddressRepository.findByMemberMemberId(memberId);
        if (!existingAddresses.isEmpty()) {
            log.info("기존 주소 {}개 삭제: memberId = {}", existingAddresses.size(), memberId);
            memberAddressRepository.deleteAll(existingAddresses);
        }
        
        MemberAddress address = MemberAddress.builder()
            .member(member)
            .addressName(addressName.trim())
            .postCode(postCode.trim())
            .addressBasic(addressBasic.trim())
            .addressDetail(addressDetail != null ? addressDetail.trim() : "")
            .build();
        
        // MemberAddress를 직접 저장
        MemberAddress savedAddress = memberAddressRepository.save(address);
        
        // 저장 후 addressId 확인
        Long savedAddressId = savedAddress.getAddressId();
        log.info("주소 설정 완료: memberId = {}, addressId = {}", memberId, savedAddressId);
        
        if (savedAddressId == null) {
            log.error("addressId가 null입니다. MemberAddress 저장 후 ID가 생성되지 않았습니다.");
            throw new RuntimeException("주소 저장 중 오류가 발생했습니다.");
        }
        
        return savedAddressId;
    }
    
    /**
     * 주소 수정
     * 
     * @param memberId 회원 ID
     * @param addressId 주소 ID
     * @param addressName 주소명
     * @param postCode 우편번호
     * @param addressBasic 기본 주소
     * @param addressDetail 상세 주소
     */
    @Transactional
    public void updateAddress(Long memberId, Long addressId, String addressName, 
                             String postCode, String addressBasic, String addressDetail) {
        log.info("주소 수정 시도: memberId = {}, addressId = {}", memberId, addressId);
        
        MemberAddress address = memberAddressRepository.findByMemberMemberIdAndAddressId(memberId, addressId)
            .orElseThrow(() -> new IllegalArgumentException("주소를 찾을 수 없습니다."));
        
        if (addressName != null && !addressName.trim().isEmpty()) {
            address.setAddressName(addressName.trim());
        }
        
        if (postCode != null && !postCode.trim().isEmpty()) {
            address.setPostCode(postCode.trim());
        }
        
        if (addressBasic != null && !addressBasic.trim().isEmpty()) {
            address.setAddressBasic(addressBasic.trim());
        }
        
        if (addressDetail != null) {
            address.setAddressDetail(addressDetail.trim());
        }
        
        memberAddressRepository.save(address);
        
        log.info("주소 수정 완료: memberId = {}, addressId = {}", memberId, addressId);
    }
    
    /**
     * 주소 삭제
     * 
     * @param memberId 회원 ID
     * @param addressId 주소 ID
     */
    @Transactional
    public void deleteAddress(Long memberId, Long addressId) {
        log.info("주소 삭제 시도: memberId = {}, addressId = {}", memberId, addressId);
        
        MemberAddress address = memberAddressRepository.findByMemberMemberIdAndAddressId(memberId, addressId)
            .orElseThrow(() -> new IllegalArgumentException("주소를 찾을 수 없습니다."));
        
        memberAddressRepository.delete(address);
        
        log.info("주소 삭제 완료: memberId = {}, addressId = {}", memberId, addressId);
    }
}

