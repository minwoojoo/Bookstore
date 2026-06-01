@echo off
setlocal

cd /d "%~dp0"

echo ========================================
echo JMeter Performance Test
echo ========================================

set "JMETER_HOME=C:\apache-jmeter-5.6.3"
set "JMETER_BIN=%JMETER_HOME%\bin\"
set "SCENARIO=%~1"

if "%SCENARIO%"=="" (
  echo Usage: run-performance-test.bat nplus1 ^| optimized
  echo.
  echo Run nplus1 first, restart the Spring Boot server, then run optimized.
  exit /b 1
)

if /i "%SCENARIO%"=="nplus1" (
  set "TEST_PLAN=jmeter-test-plan-nplus1.jmx"
  set "RESULT_FILE=performance-results-nplus1.jtl"
  set "REPORT_DIR=performance-report-nplus1"
) else if /i "%SCENARIO%"=="optimized" (
  set "TEST_PLAN=jmeter-test-plan-optimized.jmx"
  set "RESULT_FILE=performance-results-optimized.jtl"
  set "REPORT_DIR=performance-report-optimized"
) else (
  echo Unknown scenario: %SCENARIO%
  echo Usage: run-performance-test.bat nplus1 ^| optimized
  exit /b 1
)

if not exist "%JMETER_HOME%\bin\jmeter.bat" (
  echo JMeter was not found: %JMETER_HOME%\bin\jmeter.bat
  exit /b 1
)

echo.
echo 1. Check that the application is running:
if /i "%SCENARIO%"=="nplus1" (
  echo    http://localhost:8080/api/performance/books/n-plus-1
) else (
  echo    http://localhost:8080/api/performance/books/optimized
)
echo.
echo 2. Running JMeter test: %SCENARIO%
echo.

if exist "%RESULT_FILE%" del /f /q "%RESULT_FILE%"
if exist "%REPORT_DIR%" (
  echo Removing existing report directory: %REPORT_DIR%
  rmdir /s /q "%REPORT_DIR%"
)

if exist "%REPORT_DIR%" (
  echo.
  echo Could not remove %REPORT_DIR%.
  echo Close any browser or editor using files in that directory and try again.
  exit /b 1
)

call "%JMETER_HOME%\bin\jmeter.bat" -n -t "%TEST_PLAN%" -l "%RESULT_FILE%" -e -o "%REPORT_DIR%"
if errorlevel 1 (
  echo.
  echo JMeter test failed.
  exit /b %ERRORLEVEL%
)

echo.
echo ========================================
echo Test complete.
echo ========================================
echo.
echo Result files:
echo - %RESULT_FILE%
echo - %REPORT_DIR%\
echo.
echo Open %REPORT_DIR%\index.html to review response time, throughput, and error rate.

endlocal
