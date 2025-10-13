-- MySQL 초기화 스크립트
-- 데이터베이스 생성 및 문자셋 설정

SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- 데이터베이스가 없으면 생성
CREATE DATABASE IF NOT EXISTS bookstore 
  CHARACTER SET utf8mb4 
  COLLATE utf8mb4_unicode_ci;

-- 사용자 권한 설정
GRANT ALL PRIVILEGES ON bookstore.* TO 'bookstore'@'%';
FLUSH PRIVILEGES;

USE bookstore;

-- Docker용 초기화 스크립트
-- 카테고리 데이터는 Spring Boot의 CategoryInitializer에서 자동 삽입됨

-- 관리자 테이블 생성
CREATE TABLE IF NOT EXISTS admin (
    admin_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    login_id VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_date DATETIME NOT NULL,
    last_login_date DATETIME NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;