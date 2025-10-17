#!/usr/bin/env python3
"""
JMeter 성능 테스트 결과 분석 스크립트
N+1 문제 해결 효과를 정량적으로 측정
"""

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np
from pathlib import Path
import argparse

def load_jmeter_results(file_path):
    """JMeter 결과 파일 로드"""
    try:
        df = pd.read_csv(file_path, sep=',')
        return df
    except Exception as e:
        print(f"파일 로드 오류: {e}")
        return None

def analyze_performance(df):
    """성능 분석"""
    if df is None:
        return
    
    # 기본 통계
    print("=" * 60)
    print("성능 테스트 결과 분석")
    print("=" * 60)
    
    # 테스트별 그룹화
    n_plus_1_tests = df[df['label'].str.contains('N\+1|n-plus-1', case=False, na=False)]
    optimized_tests = df[df['label'].str.contains('Optimized|optimized', case=False, na=False)]
    
    print(f"\n1. 전체 테스트 수: {len(df)}")
    print(f"   - N+1 문제 발생 방식: {len(n_plus_1_tests)}")
    print(f"   - LEFT JOIN FETCH 최적화 방식: {len(optimized_tests)}")
    
    # 응답 시간 분석
    print(f"\n2. 응답 시간 분석 (밀리초)")
    print("-" * 40)
    
    if not n_plus_1_tests.empty:
        n1_avg = n_plus_1_tests['elapsed'].mean()
        n1_median = n_plus_1_tests['elapsed'].median()
        n1_95th = n_plus_1_tests['elapsed'].quantile(0.95)
        n1_max = n_plus_1_tests['elapsed'].max()
        
        print(f"N+1 문제 발생 방식:")
        print(f"  - 평균: {n1_avg:.2f}ms")
        print(f"  - 중간값: {n1_median:.2f}ms")
        print(f"  - 95%ile: {n1_95th:.2f}ms")
        print(f"  - 최대값: {n1_max:.2f}ms")
    
    if not optimized_tests.empty:
        opt_avg = optimized_tests['elapsed'].mean()
        opt_median = optimized_tests['elapsed'].median()
        opt_95th = optimized_tests['elapsed'].quantile(0.95)
        opt_max = optimized_tests['elapsed'].max()
        
        print(f"\nLEFT JOIN FETCH 최적화 방식:")
        print(f"  - 평균: {opt_avg:.2f}ms")
        print(f"  - 중간값: {opt_median:.2f}ms")
        print(f"  - 95%ile: {opt_95th:.2f}ms")
        print(f"  - 최대값: {opt_max:.2f}ms")
    
    # 성능 개선율 계산
    if not n_plus_1_tests.empty and not optimized_tests.empty:
        print(f"\n3. 성능 개선 효과")
        print("-" * 40)
        
        avg_improvement = ((n1_avg - opt_avg) / n1_avg) * 100
        median_improvement = ((n1_median - opt_median) / n1_median) * 100
        max_improvement = ((n1_max - opt_max) / n1_max) * 100
        
        print(f"평균 응답 시간 개선: {avg_improvement:.1f}%")
        print(f"중간값 응답 시간 개선: {median_improvement:.1f}%")
        print(f"최대 응답 시간 개선: {max_improvement:.1f}%")
        
        # 처리량 분석
        n1_throughput = len(n_plus_1_tests) / (n_plus_1_tests['elapsed'].sum() / 1000)
        opt_throughput = len(optimized_tests) / (optimized_tests['elapsed'].sum() / 1000)
        throughput_improvement = ((opt_throughput - n1_throughput) / n1_throughput) * 100
        
        print(f"\n처리량 개선:")
        print(f"  - N+1 방식: {n1_throughput:.2f} requests/sec")
        print(f"  - 최적화 방식: {opt_throughput:.2f} requests/sec")
        print(f"  - 처리량 개선: {throughput_improvement:.1f}%")
    
    # 오류율 분석
    print(f"\n4. 오류율 분석")
    print("-" * 40)
    
    if not n_plus_1_tests.empty:
        n1_errors = len(n_plus_1_tests[n_plus_1_tests['success'] == False])
        n1_error_rate = (n1_errors / len(n_plus_1_tests)) * 100
        print(f"N+1 문제 발생 방식: {n1_error_rate:.2f}% ({n1_errors}/{len(n_plus_1_tests)})")
    
    if not optimized_tests.empty:
        opt_errors = len(optimized_tests[optimized_tests['success'] == False])
        opt_error_rate = (opt_errors / len(optimized_tests)) * 100
        print(f"LEFT JOIN FETCH 최적화 방식: {opt_error_rate:.2f}% ({opt_errors}/{len(optimized_tests)})")

def create_visualization(df, output_dir="performance-charts"):
    """시각화 생성"""
    if df is None:
        return
    
    # 출력 디렉토리 생성
    Path(output_dir).mkdir(exist_ok=True)
    
    # 한글 폰트 설정
    plt.rcParams['font.family'] = 'DejaVu Sans'
    plt.rcParams['axes.unicode_minus'] = False
    
    # 테스트별 그룹화
    n_plus_1_tests = df[df['label'].str.contains('N\+1|n-plus-1', case=False, na=False)]
    optimized_tests = df[df['label'].str.contains('Optimized|optimized', case=False, na=False)]
    
    # 1. 응답 시간 분포 비교
    plt.figure(figsize=(12, 8))
    
    plt.subplot(2, 2, 1)
    if not n_plus_1_tests.empty and not optimized_tests.empty:
        plt.hist(n_plus_1_tests['elapsed'], bins=30, alpha=0.7, label='N+1 Problem', color='red')
        plt.hist(optimized_tests['elapsed'], bins=30, alpha=0.7, label='Optimized', color='blue')
        plt.xlabel('Response Time (ms)')
        plt.ylabel('Frequency')
        plt.title('Response Time Distribution')
        plt.legend()
        plt.grid(True, alpha=0.3)
    
    # 2. 응답 시간 박스플롯
    plt.subplot(2, 2, 2)
    if not n_plus_1_tests.empty and not optimized_tests.empty:
        data_to_plot = [n_plus_1_tests['elapsed'], optimized_tests['elapsed']]
        labels = ['N+1 Problem', 'Optimized']
        plt.boxplot(data_to_plot, labels=labels)
        plt.ylabel('Response Time (ms)')
        plt.title('Response Time Box Plot')
        plt.grid(True, alpha=0.3)
    
    # 3. 시간별 응답 시간 추이
    plt.subplot(2, 2, 3)
    if not n_plus_1_tests.empty:
        plt.plot(n_plus_1_tests.index, n_plus_1_tests['elapsed'], 'r-', alpha=0.7, label='N+1 Problem')
    if not optimized_tests.empty:
        plt.plot(optimized_tests.index, optimized_tests['elapsed'], 'b-', alpha=0.7, label='Optimized')
    plt.xlabel('Test Number')
    plt.ylabel('Response Time (ms)')
    plt.title('Response Time Over Time')
    plt.legend()
    plt.grid(True, alpha=0.3)
    
    # 4. 성능 개선 요약
    plt.subplot(2, 2, 4)
    if not n_plus_1_tests.empty and not optimized_tests.empty:
        metrics = ['Average', 'Median', '95th Percentile']
        n1_values = [n_plus_1_tests['elapsed'].mean(), 
                    n_plus_1_tests['elapsed'].median(), 
                    n_plus_1_tests['elapsed'].quantile(0.95)]
        opt_values = [optimized_tests['elapsed'].mean(), 
                     optimized_tests['elapsed'].median(), 
                     optimized_tests['elapsed'].quantile(0.95)]
        
        x = np.arange(len(metrics))
        width = 0.35
        
        plt.bar(x - width/2, n1_values, width, label='N+1 Problem', color='red', alpha=0.7)
        plt.bar(x + width/2, opt_values, width, label='Optimized', color='blue', alpha=0.7)
        
        plt.xlabel('Metrics')
        plt.ylabel('Response Time (ms)')
        plt.title('Performance Comparison')
        plt.xticks(x, metrics)
        plt.legend()
        plt.grid(True, alpha=0.3)
    
    plt.tight_layout()
    plt.savefig(f'{output_dir}/performance_analysis.png', dpi=300, bbox_inches='tight')
    plt.show()
    
    print(f"\n시각화 차트가 '{output_dir}/performance_analysis.png'에 저장되었습니다.")

def main():
    parser = argparse.ArgumentParser(description='JMeter 성능 테스트 결과 분석')
    parser.add_argument('--file', '-f', default='performance-test-results.jtl', 
                       help='JMeter 결과 파일 경로')
    parser.add_argument('--output', '-o', default='performance-charts',
                       help='차트 출력 디렉토리')
    parser.add_argument('--no-chart', action='store_true',
                       help='차트 생성 안함')
    
    args = parser.parse_args()
    
    # 결과 파일 로드
    df = load_jmeter_results(args.file)
    
    if df is not None:
        # 성능 분석
        analyze_performance(df)
        
        # 시각화 생성
        if not args.no_chart:
            create_visualization(df, args.output)
    else:
        print("결과 파일을 로드할 수 없습니다.")

if __name__ == "__main__":
    main()
