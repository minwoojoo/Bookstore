@echo off
echo ========================================
echo JMeter 성능 테스트 실행 스크립트
echo ========================================

REM JMeter 설치 경로 설정 (실제 설치 경로로 변경 필요)
set JMETER_HOME=C:\apache-jmeter-5.6.2
set JMETER_BIN=%JMETER_HOME%\bin

REM 테스트 계획 파일 경로
set TEST_PLAN=jmeter-test-plan.jmx

REM 결과 파일 경로
set RESULT_FILE=performance-test-results.jtl
set REPORT_DIR=performance-report

echo.
echo 1. 애플리케이션 실행 확인...
echo    http://localhost:8080/api/performance/books/n-plus-1
echo    http://localhost:8080/api/performance/books/optimized
echo.
echo 2. JMeter 테스트 실행 중...
echo.

REM JMeter 실행
"%JMETER_BIN%\jmeter.bat" -n -t %TEST_PLAN% -l %RESULT_FILE% -e -o %REPORT_DIR%

echo.
echo ========================================
echo 테스트 완료!
echo ========================================
echo.
echo 결과 파일:
echo - %RESULT_FILE% (원시 데이터)
echo - %REPORT_DIR%\ (HTML 리포트)
echo.
echo 결과 분석:
echo 1. %REPORT_DIR%\index.html 파일을 브라우저에서 열어보세요
echo 2. 응답 시간, 처리량, 오류율 등을 비교해보세요
echo.

pause
