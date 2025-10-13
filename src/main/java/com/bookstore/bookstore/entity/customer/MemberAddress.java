package com.bookstore.bookstore.entity.customer;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "member_address")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MemberAddress {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "address_id")
    private Long addressId;
    
    @Column(name = "post_code", length = 10)
    private String postCode;
    
    @Column(name = "address_name", length = 100)
    private String addressName;
    
    @Column(name = "address_basic", length = 500)
    private String addressBasic;
    
    @Column(name = "address_detail", length = 500)
    private String addressDetail;
    
    // 회원과의 관계
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "member_id", nullable = false)
    private Member member;
}

