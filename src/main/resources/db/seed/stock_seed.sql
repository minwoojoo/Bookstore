-- ==========================================================
-- stock 테이블 데이터
-- ==========================================================
-- 기존 도서들 (1-200)의 재고 설정
INSERT IGNORE INTO stock (book_id, quantity, last_updated) 
SELECT book_id, FLOOR(10 + RAND() * 100), NOW() 
FROM book 
WHERE book_id BETWEEN 1 AND 200;

-- 새로 추가된 도서들 (201-220)의 재고 설정
INSERT IGNORE INTO stock (book_id, quantity, last_updated) 
SELECT book_id, FLOOR(20 + RAND() * 80), NOW() 
FROM book 
WHERE book_id BETWEEN 201 AND 220;
