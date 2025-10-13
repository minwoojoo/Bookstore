# 온라인 서점 웹 애플리케이션

Spring Boot 기반의 온라인 서점 웹 애플리케이션입니다. 도서 구매, 장바구니, 주문 관리, 리뷰 시스템, 관리자 기능을 제공합니다.

## 🚀 애플리케이션 실행 절차

### 1. 사전 요구사항
- **Java 17** 이상
- **Gradle 7.0** 이상
- **MySQL 8.0** 이상
- **Docker** (선택사항)

### 2. Docker를 이용한 실행 (권장)

#### Docker Compose를 사용한 자동 설정
```bash
# 프로젝트 루트 디렉토리에서 실행
docker-compose up -d
```

이 방법을 사용하면:
- ✅ **MySQL 데이터베이스 자동 생성**
- ✅ **엔티티 테이블 자동 생성** (JPA DDL Auto)
- ✅ **초기 데이터 자동 삽입** (CommandLineRunner)
- ✅ **관리자 계정 자동 생성** (admin/admin1234!)

#### 수동 설정 (Docker 없이)

##### 데이터베이스 설정
```sql
-- MySQL에서 데이터베이스 생성
CREATE DATABASE bookstore CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

##### 애플리케이션 설정
```yaml
# src/main/resources/application.yml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/bookstore?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
    username: your_username
    password: your_password
  jpa:
    hibernate:
      ddl-auto: update
    show-sql: true
```

##### 애플리케이션 실행
```bash
# 프로젝트 루트 디렉토리에서 실행
./gradlew bootRun

# 또는 Windows에서
gradlew.bat bootRun
```

### 3. 접속 확인
- **메인 페이지**: http://localhost:8080
- **관리자 페이지**: http://localhost:8080/admin

### 4. 자동 초기화 기능

#### 데이터베이스 자동 생성
- **JPA DDL Auto**: `hibernate.ddl-auto: update` 설정으로 엔티티 기반 테이블 자동 생성
- **테이블 구조**: Book, Category, Author, Member, Order, OrderItem, Payment, Review 등

#### 초기 데이터 자동 삽입
애플리케이션 시작 시 다음 데이터가 자동으로 삽입됩니다:

##### 1. 카테고리 데이터 (`CategoryInitializer`)
- 소설, 에세이, 자기계발, 경제경영, 인문학, 과학, 예술, 여행 등

##### 2. 저자 데이터 (`AuthorInitializer`)
- 각 카테고리별 대표 저자들 (김영하, 이외수, 정유정, 김훈 등)

##### 3. 도서 데이터 (`BookInitializer`)
- 각 카테고리별 대표 도서들 (총 50여권)
- ISBN, 제목, 출판사, 가격, 설명, 썸네일 등 완전한 정보

##### 4. 회원 데이터 (`MemberInitializer`)
- 테스트용 회원 계정들 (일반 회원, VIP 회원 등)

##### 5. 리뷰 데이터 (`ReviewInitializer`)
- 도서별 샘플 리뷰 데이터

##### 6. 관리자 계정 (`AdminInitializer`)
- **로그인 ID**: `admin`
- **비밀번호**: `admin1234!` (BCrypt 해시)
- **역할**: `ADMIN`

#### 초기화 로그 확인
애플리케이션 시작 시 다음과 같은 로그가 출력됩니다:
```
관리자 계정 'admin'이 성공적으로 생성되었습니다.
카테고리 데이터 초기화 완료: 8개 카테고리
저자 데이터 초기화 완료: 25명
도서 데이터 초기화 완료: 50권
회원 데이터 초기화 완료: 10명
리뷰 데이터 초기화 완료: 100개
```

## 🔐 관리자 페이지 접속 방법

### 관리자 계정 정보
- **로그인 ID**: `admin`
- **비밀번호**: `admin1234!`

### 접속 절차
1. 브라우저에서 `http://localhost:8080/admin` 접속
2. 자동으로 로그인 페이지로 리다이렉트됨
3. 관리자 계정으로 로그인
4. 관리자 대시보드 접근

## 📊 관리자 페이지 구현 기능(사용자 기능은 모두 구현)

### ✅ 완전 구현된 기능

#### 1. 상품 관리 (`/admin/books`)
- **상품 목록 조회** ✅
  - ISBN, 제목, 출판사, 저자 정보
  - 가격, 재고, 판매상태 (bookStatus)
  - 평점 (ratingAvg), 리뷰 수, 카테고리
  - 등록일 (registrationDate), 썸네일 이미지

- **필터링 및 검색** ✅
  - 제목, 출판사, 저자별 검색


### 🚧 부분 구현된 기능 (UI만 구현)

#### 2. 대시보드 (`/admin`)
- **기본 UI 구조** 🚧
  - 관리자 메인 페이지 레이아웃
  - 네비게이션 메뉴 (상품, 주문, 회원 관리)
  - 통계 정보 표시 영역 (데이터 연동 미완성)



### 📋 구현 상태 요약

| 기능 | 상태 | 설명 |
|------|------|------|
| **상품 관리** | ✅ 완료 | 목록 조회, 상세 조회, 필터링/검색 모두 구현 |
| **대시보드** | 🚧 UI만 | 기본 레이아웃과 메뉴 구조만 구현 |
| **주문 관리** | 🚧 UI만 | 페이지 레이아웃과 필터 UI만 구현 |
| **회원 관리** | 🚧 UI만 | 페이지 레이아웃과 필터 UI만 구현 |
| **통계 기능** | ❌ 미구현 | 데이터 연동 및 통계 계산 미구현 |

### 🔧 향후 개발 예정 기능

#### 주문 관리 완성
- 주문 목록 데이터 연동
- 주문 상세 정보 조회
- 주문 상태 변경 기능
- 주문 필터링 및 검색

#### 회원 관리 완성
- 회원 목록 데이터 연동
- 회원 상세 정보 조회
- 회원 상태 관리
- 회원 통계 계산

#### 대시보드 완성
- 실시간 통계 데이터 연동
- 차트 및 그래프 표시
- 최근 활동 현황

## 🛠️ 기술 스택

### Backend
- **Spring Boot 3.5.6**
- **Spring Security 6.2.11**
- **Spring Data JPA**
- **MySQL 8.0**
- **Hibernate 6.6.29**

### Frontend
- **JSP (JavaServer Pages)**
- **Bootstrap 5**
- **JavaScript (ES6+)**
- **jQuery**

### 기타
- **Lombok**
- **Gradle**
- **Toss Payments API** (결제 시스템)

## 📁 프로젝트 구조

```
src/main/java/com/bookstore/bookstore/
├── config/init/          # 데이터 초기화
├── controller/           # 컨트롤러
│   ├── admin/           # 관리자 컨트롤러
│   ├── book/            # 도서 컨트롤러
│   ├── customer/        # 회원 컨트롤러
│   └── order/           # 주문 컨트롤러
├── dto/                 # 데이터 전송 객체
├── entity/              # JPA 엔티티
├── repository/          # 데이터 접근 계층
├── security/            # 보안 설정
└── service/             # 비즈니스 로직

src/main/webapp/WEB-INF/views/
├── admin/               # 관리자 페이지
├── auth/                # 인증 페이지
├── book/                # 도서 페이지
├── customer/            # 회원 페이지
└── order/               # 주문 페이지
```

## 🔧 주요 기능

### 일반 사용자 기능
- 회원가입, 로그인, 비밀번호 찾기
- 도서 목록 조회, 상세 정보, 검색
- 장바구니 관리
- 주문 및 결제 (Toss Payments)
- 리뷰 작성 및 삭제
- 마이페이지

### 관리자 기능
- 상품 관리 (등록, 수정, 삭제, 재고 관리)
- 주문 관리 (조회, 상태 변경)
- 회원 관리 (조회, 상태 관리)
- 통계 및 분석

## 📝 라이선스

이 프로젝트는 MIT 라이선스 하에 있습니다.
