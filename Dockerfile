# 1단계: 빌드 단계
FROM gradle:8.5-jdk21 AS build

WORKDIR /app

# Gradle 파일 복사
COPY build.gradle settings.gradle ./
COPY gradle ./gradle
COPY gradlew ./

# 의존성 다운로드 (캐싱 활용)
RUN gradle dependencies --no-daemon || return 0

# 소스 코드 복사
COPY src ./src

# 애플리케이션 빌드 (테스트 제외)
RUN gradle clean build -x test --no-daemon

# 2단계: 실행 단계
FROM eclipse-temurin:21-jre-jammy

WORKDIR /app

# 빌드된 JAR 파일 복사
COPY --from=build /app/build/libs/*.jar app.jar

# 포트 노출
EXPOSE 8080

# 애플리케이션 실행
ENTRYPOINT ["java", "-jar", "app.jar"]
