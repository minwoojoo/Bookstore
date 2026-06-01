#!/bin/bash

echo "========================================"
echo "JMeter 성능 테스트 실행 스크립트"
echo "========================================"

SCENARIO="$1"

if [ -z "$SCENARIO" ]; then
  echo "Usage: ./run-performance-test.sh nplus1 | optimized"
  echo ""
  echo "Run nplus1 first, restart the Spring Boot server, then run optimized."
  exit 1
fi

# JMeter 설치 경로 설정 (실제 설치 경로로 변경 필요)
JMETER_HOME="/opt/apache-jmeter-5.6.3"
JMETER_BIN="$JMETER_HOME/bin"

if [ "$SCENARIO" = "nplus1" ]; then
  TEST_PLAN="jmeter-test-plan-nplus1.jmx"
  RESULT_FILE="performance-results-nplus1.jtl"
  REPORT_DIR="performance-report-nplus1"
elif [ "$SCENARIO" = "optimized" ]; then
  TEST_PLAN="jmeter-test-plan-optimized.jmx"
  RESULT_FILE="performance-results-optimized.jtl"
  REPORT_DIR="performance-report-optimized"
else
  echo "Unknown scenario: $SCENARIO"
  echo "Usage: ./run-performance-test.sh nplus1 | optimized"
  exit 1
fi

echo ""
echo "1. 애플리케이션 실행 확인..."
if [ "$SCENARIO" = "nplus1" ]; then
  echo "   http://localhost:8080/api/performance/books/n-plus-1"
else
  echo "   http://localhost:8080/api/performance/books/optimized"
fi
echo ""
echo "2. JMeter 테스트 실행 중: $SCENARIO"
echo ""

rm -f "$RESULT_FILE"
rm -rf "$REPORT_DIR"

# JMeter 실행
"$JMETER_BIN/jmeter" -n -t "$TEST_PLAN" -l "$RESULT_FILE" -e -o "$REPORT_DIR"

echo ""
echo "========================================"
echo "테스트 완료!"
echo "========================================"
echo ""
echo "결과 파일:"
echo "- $RESULT_FILE (원시 데이터)"
echo "- $REPORT_DIR/ (HTML 리포트)"
echo ""
echo "결과 분석:"
echo "1. $REPORT_DIR/index.html 파일을 브라우저에서 열어보세요"
echo "2. 응답 시간, 처리량, 오류율 등을 비교해보세요"
echo ""

read -p "Press any key to continue..."
