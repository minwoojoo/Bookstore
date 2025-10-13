package com.bookstore.bookstore.service.customer;

import com.bookstore.bookstore.dto.customer.MemberResponse;
import com.bookstore.bookstore.dto.customer.SignupRequest;
import com.bookstore.bookstore.entity.customer.Member;
import com.bookstore.bookstore.entity.customer.MemberAddress;
import com.bookstore.bookstore.repository.customer.MemberRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 인증 관련 비즈니스 로직 서비스
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class AuthService {
    
    private final MemberRepository memberRepository;
    private final PasswordEncoder passwordEncoder;
    
    /**
     * 회원가입
     * 
     * @param request 회원가입 요청 DTO
     * @return 생성된 회원 정보
     * @throws IllegalArgumentException 중복된 아이디 또는 이메일
     */
    @Transactional
    public MemberResponse signup(SignupRequest request) {
        log.info("회원가입 시도: userId = {}", request.getUserId());
        
        // 1. 비밀번호 일치 확인
        if (!request.isPasswordMatching()) {
            throw new IllegalArgumentException("비밀번호가 일치하지 않습니다.");
        }
        
        // 2. 아이디 중복 확인
        if (memberRepository.existsByUserId(request.getUserId())) {
            log.warn("이미 존재하는 아이디: {}", request.getUserId());
            throw new IllegalArgumentException("이미 사용 중인 아이디입니다.");
        }
        
        // 3. 이메일 중복 확인
        if (memberRepository.existsByEmail(request.getEmail())) {
            log.warn("이미 존재하는 이메일: {}", request.getEmail());
            throw new IllegalArgumentException("이미 사용 중인 이메일입니다.");
        }
        
        // 4. Member 엔티티 생성
        Member member = Member.builder()
            .userId(request.getUserId())
            .password(passwordEncoder.encode(request.getPassword())) // 비밀번호 암호화
            .name(request.getName())
            .email(request.getEmail())
            .phone(request.getPhone())
            .memberGrade("BRONZE")  // 기본 등급
            .status("ACTIVE")       // 활성 상태
            .registrationDate(LocalDateTime.now())
            .build();
        
        // 5. 데이터베이스에 저장
        Member savedMember = memberRepository.save(member);
        
        // 6. 회원 주소 저장 (별도 테이블)
        if (request.getPostCode() != null && request.getAddressBasic() != null) {
            saveMemberAddress(savedMember, request);
            // cascade 설정으로 주소도 함께 저장
            memberRepository.save(savedMember);
        }
        
        log.info("회원가입 성공: userId = {}, memberId = {}", 
                 savedMember.getUserId(), savedMember.getMemberId());
        
        // 7. Response DTO로 변환하여 반환
        return MemberResponse.builder()
            .memberId(savedMember.getMemberId())
            .userId(savedMember.getUserId())
            .name(savedMember.getName())
            .email(savedMember.getEmail())
            .phone(savedMember.getPhone())
            .memberGrade(savedMember.getMemberGrade())
            .status(savedMember.getStatus())
            .registrationDate(savedMember.getRegistrationDate())
            .lastLogin(savedMember.getLastLogin())
            .addresses(List.of()) // 회원가입 시에는 주소 목록 불필요
            .build();
    }
    
    /**
     * 아이디 중복 확인
     * 
     * @param userId 확인할 사용자 ID
     * @return true: 사용 가능, false: 이미 사용 중
     */
    @Transactional(readOnly = true)
    public boolean isUserIdAvailable(String userId) {
        return !memberRepository.existsByUserId(userId);
    }
    
    /**
     * 이메일 중복 확인
     * 
     * @param email 확인할 이메일
     * @return true: 사용 가능, false: 이미 사용 중
     */
    @Transactional(readOnly = true)
    public boolean isEmailAvailable(String email) {
        return !memberRepository.existsByEmail(email);
    }
    
    /**
     * 최종 로그인 시간 업데이트
     * 
     * @param userId 사용자 ID
     */
    @Transactional
    public void updateLastLogin(String userId) {
        Member member = memberRepository.findByUserId(userId)
            .orElseThrow(() -> new IllegalArgumentException("회원을 찾을 수 없습니다."));
        
        member.setLastLogin(LocalDateTime.now());
        memberRepository.save(member);
        
        log.info("최종 로그인 시간 업데이트: userId = {}", userId);
    }
    
    /**
     * 회원 주소 저장
     * 
     * @param member 회원 엔티티
     * @param request 회원가입 요청 DTO
     */
    private void saveMemberAddress(Member member, SignupRequest request) {
        MemberAddress address = MemberAddress.builder()
            .member(member)
            .postCode(request.getPostCode())
            .addressName(request.getAddressName() != null ? request.getAddressName() : "기본 주소")
            .addressBasic(request.getAddressBasic())
            .addressDetail(request.getAddressDetail())
            .build();
        
        // Member의 addresses 리스트에 추가
        member.getAddresses().add(address);
        
        log.info("회원 주소 저장: memberId = {}, postCode = {}", member.getMemberId(), request.getPostCode());
    }
    
    /**
     * 이름과 이메일로 회원 찾기 (비밀번호 찾기용)
     */
    public Member findMemberByNameAndEmail(String name, String email) {
        log.info("회원 조회 시도: name = {}, email = {}", name, email);
        
        Member member = memberRepository.findByEmail(email)
            .orElseThrow(() -> new IllegalArgumentException("해당 이메일로 가입된 회원이 없습니다."));
        
        if (!member.getName().equals(name)) {
            throw new IllegalArgumentException("이름과 이메일 정보가 일치하지 않습니다.");
        }
        
        log.info("회원 조회 성공: memberId = {}", member.getMemberId());
        return member;
    }
    
    /**
     * 비밀번호 재설정
     */
    public void resetPassword(String email, String newPassword) {
        log.info("비밀번호 재설정 시도: email = {}", email);
        
        Member member = memberRepository.findByEmail(email)
            .orElseThrow(() -> new IllegalArgumentException("해당 이메일로 가입된 회원이 없습니다."));
        
        // 비밀번호 암호화 및 변경
        String encodedPassword = passwordEncoder.encode(newPassword);
        member.changePassword(encodedPassword);
        
        memberRepository.save(member);
        
        log.info("비밀번호 재설정 완료: memberId = {}", member.getMemberId());
    }
}
