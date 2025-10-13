package com.bookstore.bookstore.enums.customer;

/**
 * 중복 확인 필드 구분을 위한 Enum
 */
public enum CheckField {
    USER_ID("userId"),    // 사용자 ID
    EMAIL("email");       // 이메일
    
    private final String key;
    
    CheckField(String key) {
        this.key = key;
    }
    
    public String asKey() {
        return key;
    }
}

