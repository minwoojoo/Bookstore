@echo off
echo ========================================
echo 카테고리별 도서 조회 성능 테스트
echo ========================================

REM 애플리케이션이 실행 중인지 확인
echo 1. 애플리케이션 상태 확인...
curl -s http://localhost:8080/api/performance/debug/database-status > nul
if %errorlevel% neq 0 (
    echo 오류: 애플리케이션이 실행되지 않았습니다.
    echo 먼저 애플리케이션을 실행해주세요.
    pause
    exit /b 1
)

echo 애플리케이션 실행 중 확인됨
echo.

REM 테스트할 카테고리 ID들 (실제 데이터에 따라 조정)
set CATEGORIES=8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31

echo 2. 카테고리별 성능 테스트 시작...
echo.

REM 결과 파일 초기화
echo 카테고리ID,도서수,N+1_응답시간(ms),최적화_응답시간(ms),성능개선율(%),N+1_쿼리수,최적화_쿼리수 > category-performance-results.csv

REM 각 카테고리별로 테스트 실행
for %%c in (%CATEGORIES%) do (
    echo 카테고리 %%c 테스트 중...
    
    REM N+1 문제 방식 테스트
    for /l %%i in (1,1,5) do (
        curl -s -w "%%{time_total}" -o nul "http://localhost:8080/api/performance/books/category/%%c/n-plus-1"
        echo.
    ) > temp_n1_%%c.txt
    
    REM 최적화 방식 테스트
    for /l %%i in (1,1,5) do (
        curl -s -w "%%{time_total}" -o nul "http://localhost:8080/api/performance/books/category/%%c/optimized"
        echo.
    ) > temp_opt_%%c.txt
    
    REM 결과 분석 및 CSV에 추가
    python analyze-category-performance.py %%c temp_n1_%%c.txt temp_opt_%%c.txt
)

echo.
echo 3. 테스트 완료!
echo 결과 파일: category-performance-results.csv
echo.

REM 임시 파일 정리
del temp_n1_*.txt
del temp_opt_*.txt

echo 결과 분석을 위해 category-performance-results.csv 파일을 확인하세요.
pause
