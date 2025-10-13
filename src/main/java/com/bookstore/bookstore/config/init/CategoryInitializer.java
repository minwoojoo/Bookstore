package com.bookstore.bookstore.config.init;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

@Slf4j
@Component
@Order(Ordered.HIGHEST_PRECEDENCE) // 가장 먼저 실행
@RequiredArgsConstructor
public class CategoryInitializer implements ApplicationRunner {

    private final DataSource dataSource;

    @Override
    @Transactional
    public void run(ApplicationArguments args) {
        log.info("[Init] CategoryInitializer start");

        try {
            // 직접 SQL 실행
            try (Connection c = dataSource.getConnection();
                 Statement st = c.createStatement()) {
                
                log.info("[Init] Executing category seed SQL directly...");
                
                // 1. 최상위 카테고리
                st.executeUpdate("INSERT IGNORE INTO category (category_id, parent_id, category_name, level) VALUES (1, NULL, '도서', 1)");
                
                // 2. 대분류 카테고리
                st.executeUpdate("INSERT IGNORE INTO category (category_id, parent_id, category_name, level) VALUES " +
                    "(2, 1, '건강/취미', 2), (3, 1, '경제/경영', 2), (4, 1, '소설/시/희곡', 2), " +
                    "(5, 1, '역사', 2), (6, 1, '인문', 2), (7, 1, '자기계발', 2)");
                
                // 3. 중분류 카테고리
                st.executeUpdate("INSERT IGNORE INTO category (category_id, parent_id, category_name, level) VALUES " +
                    "(8, 2, '식단/건강 레시피', 3), (9, 2, '운동/체형 교정', 3), (10, 2, '심리/힐링', 3), (11, 2, '취미/실용 기술', 3), " +
                    "(12, 3, '재테크/투자', 3), (13, 3, '마케팅/세일즈', 3), (14, 3, '경영일반', 3), (15, 3, '성공/처세', 3), " +
                    "(16, 4, '한국 소설', 3), (17, 4, '외국 소설 (번역)', 3), (18, 4, '시/에세이', 3), (19, 4, '장르 소설', 3), " +
                    "(20, 5, '세계사/인류 문명', 3), (21, 5, '한국사', 3), (22, 5, '역사 인물/문화사', 3), (23, 5, '전쟁사/지리 역사', 3), " +
                    "(24, 6, '심리학', 3), (25, 6, '철학', 3), (26, 6, '종교/신화', 3), (27, 6, '인류학/사회학', 3), " +
                    "(28, 7, '습관/시간 관리', 3), (29, 7, '인간관계/소통', 3), (30, 7, '마인드셋/성장', 3), (31, 7, '직업/경력 개발', 3)");
                
                log.info("[Init] Category seed SQL executed successfully");
            }

            try (Connection c = dataSource.getConnection();
                 Statement st = c.createStatement();
                 ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM category")) {
                if (rs.next()) {
                    log.info("[Init] category rows now: {}", rs.getInt(1));
                }
            } catch (Exception e) {
                log.warn("[Init] category count failed", e);
            }

            log.info("[Init] CategoryInitializer done");
        } catch (Exception e) {
            log.error("[Init] CategoryInitializer failed", e);
        }
    }
}

