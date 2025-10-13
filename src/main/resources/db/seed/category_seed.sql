-- 카테고리 초기 데이터
-- 중복 삽입 방지를 위해 INSERT IGNORE 사용

-- 1. 최상위 카테고리 (Level 1)
-- category_id = 1
INSERT IGNORE INTO category (category_id, parent_id, category_name, level)
VALUES (1, NULL, '도서', 1);

-- 2. 대분류 카테고리 (Level 2, parent_id = 1)
-- category_id = 2부터 7까지 할당
INSERT IGNORE INTO category (category_id, parent_id, category_name, level)
VALUES
    (2, 1, '건강/취미', 2),
    (3, 1, '경제/경영', 2),
    (4, 1, '소설/시/희곡', 2),
    (5, 1, '역사', 2),
    (6, 1, '인문', 2),
    (7, 1, '자기계발', 2);

-- 3. '건강/취미'의 중분류 카테고리 (Level 3, parent_id = 2)
-- category_id = 8부터 11까지 할당
INSERT IGNORE INTO category (category_id, parent_id, category_name, level)
VALUES
    (8, 2, '식단/건강 레시피', 3),
    (9, 2, '운동/체형 교정', 3),
    (10, 2, '심리/힐링', 3),
    (11, 2, '취미/실용 기술', 3);

-- 4. '경제/경영'의 중분류 카테고리 (Level 3, parent_id = 3)
-- category_id = 12부터 15까지 할당
INSERT IGNORE INTO category (category_id, parent_id, category_name, level)
VALUES
    (12, 3, '재테크/투자', 3),
    (13, 3, '마케팅/세일즈', 3),
    (14, 3, '경영일반', 3),
    (15, 3, '성공/처세', 3);

-- 5. '소설/시/희곡'의 중분류 카테고리 (Level 3, parent_id = 4)
-- category_id = 16부터 19까지 할당
INSERT IGNORE INTO category (category_id, parent_id, category_name, level)
VALUES
    (16, 4, '한국 소설', 3),
    (17, 4, '외국 소설 (번역)', 3),
    (18, 4, '시/에세이', 3),
    (19, 4, '장르 소설', 3);

-- 6. '역사'의 중분류 카테고리 (Level 3, parent_id = 5)
-- category_id = 20부터 23까지 할당
INSERT IGNORE INTO category (category_id, parent_id, category_name, level)
VALUES
    (20, 5, '세계사/인류 문명', 3),
    (21, 5, '한국사', 3),
    (22, 5, '역사 인물/문화사', 3),
    (23, 5, '전쟁사/지리 역사', 3);

-- 7. '인문'의 중분류 카테고리 (Level 3, parent_id = 6)
-- category_id = 24부터 27까지 할당
INSERT IGNORE INTO category (category_id, parent_id, category_name, level)
VALUES
    (24, 6, '심리학', 3),
    (25, 6, '철학', 3),
    (26, 6, '종교/신화', 3),
    (27, 6, '인류학/사회학', 3);

-- 8. '자기계발'의 중분류 카테고리 (Level 3, parent_id = 7)
-- category_id = 28부터 31까지 할당
INSERT IGNORE INTO category (category_id, parent_id, category_name, level)
VALUES
    (28, 7, '습관/시간 관리', 3),
    (29, 7, '인간관계/소통', 3),
    (30, 7, '마인드셋/성장', 3),
    (31, 7, '직업/경력 개발', 3);

