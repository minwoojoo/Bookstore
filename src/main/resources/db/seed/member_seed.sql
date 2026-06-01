-- 회원 더미 데이터 생성
-- 중복 삽입 방지를 위해 INSERT IGNORE 사용

-- 회원 더미 데이터 (20명)
-- 비밀번호: user1234! (BCrypt 해시값)
INSERT IGNORE INTO member (member_id, user_id, password, name, email, phone, member_grade, status, registration_date, last_login)
VALUES
    (1, 'user1', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', '김독자', 'user1@example.com', '010-1234-5678', 'GOLD', 'ACTIVE', '2024-01-15 10:30:00', '2024-12-15 14:20:00'),
    (2, 'user2', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', '이책사', 'user2@example.com', '010-2345-6789', 'SILVER', 'ACTIVE', '2024-02-20 11:15:00', '2024-12-14 16:45:00'),
    (3, 'user3', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', '박리뷰', 'user3@example.com', '010-3456-7890', 'BRONZE', 'ACTIVE', '2024-03-10 09:30:00', '2024-12-13 20:10:00'),
    (4, 'user4', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', '최평점', 'user4@example.com', '010-4567-8901', 'GOLD', 'ACTIVE', '2024-01-25 14:20:00', '2024-12-15 11:30:00'),
    (5, 'user5', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', '정서평', 'user5@example.com', '010-5678-9012', 'SILVER', 'ACTIVE', '2024-04-05 16:45:00', '2024-12-12 18:20:00'),
    (6, 'user6', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', '한독서', 'user6@example.com', '010-6789-0123', 'BRONZE', 'ACTIVE', '2024-05-12 13:10:00', '2024-12-11 15:40:00'),
    (7, 'user7', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', '윤책벌', 'user7@example.com', '010-7890-1234', 'GOLD', 'ACTIVE', '2024-02-28 12:30:00', '2024-12-10 19:15:00'),
    (8, 'user8', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', '강리더', 'user8@example.com', '010-8901-2345', 'SILVER', 'ACTIVE', '2024-06-15 10:45:00', '2024-12-09 17:30:00'),
    (9, 'user9', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', '조독서', 'user9@example.com', '010-9012-3456', 'BRONZE', 'ACTIVE', '2024-07-20 15:20:00', '2024-12-08 14:50:00'),
    (10, 'user10', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', '임서평', 'user10@example.com', '010-0123-4567', 'GOLD', 'ACTIVE', '2024-03-15 11:40:00', '2024-12-07 16:25:00'),
    (11, 'user11', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', '백책사', 'user11@example.com', '010-1234-5679', 'SILVER', 'ACTIVE', '2024-08-10 09:15:00', '2024-12-06 13:40:00'),
    (12, 'user12', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', '송리뷰', 'user12@example.com', '010-2345-6780', 'BRONZE', 'ACTIVE', '2024-09-05 14:30:00', '2024-12-05 12:15:00'),
    (13, 'user13', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', '홍평점', 'user13@example.com', '010-3456-7891', 'GOLD', 'ACTIVE', '2024-04-20 16:20:00', '2024-12-04 18:45:00'),
    (14, 'user14', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', '유독자', 'user14@example.com', '010-4567-8902', 'SILVER', 'ACTIVE', '2024-10-12 12:10:00', '2024-12-03 15:30:00'),
    (15, 'user15', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', '오책벌', 'user15@example.com', '010-5678-9013', 'BRONZE', 'ACTIVE', '2024-11-08 13:45:00', '2024-12-02 11:20:00'),
    (16, 'user16', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', '신서평', 'user16@example.com', '010-6789-0124', 'GOLD', 'ACTIVE', '2024-05-30 10:25:00', '2024-12-01 19:10:00'),
    (17, 'user17', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', '권독서', 'user17@example.com', '010-7890-1235', 'SILVER', 'ACTIVE', '2024-12-01 15:35:00', '2024-11-30 14:55:00'),
    (18, 'user18', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', '장책사', 'user18@example.com', '010-8901-2346', 'BRONZE', 'ACTIVE', '2024-06-25 11:50:00', '2024-11-29 16:40:00'),
    (19, 'user19', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', '서리뷰', 'user19@example.com', '010-9012-3457', 'GOLD', 'ACTIVE', '2024-08-15 14:15:00', '2024-11-28 17:25:00'),
    (20, 'user20', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', '안평점', 'user20@example.com', '010-0123-4568', 'SILVER', 'ACTIVE', '2024-09-30 16:40:00', '2024-11-27 13:15:00');
