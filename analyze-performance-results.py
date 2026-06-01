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
import re

def load_jmeter_results(file_path):
    """JMeter 결과 파일 로드"""
    try:
        df = pd.read_csv(file_path, sep=',')
        df['success'] = df['success'].astype(str).str.lower() == 'true'
        return df
    except Exception as e:
        print(f"파일 로드 오류 ({file_path}): {e}")
        return None

def load_comparison_results(nplus1_file, optimized_file):
    """N+1 결과와 최적화 결과 파일 로드"""
    nplus1_df = load_jmeter_results(nplus1_file)
    optimized_df = load_jmeter_results(optimized_file)

    if nplus1_df is None or optimized_df is None:
        return None

    nplus1_df = nplus1_df.copy()
    optimized_df = optimized_df.copy()
    nplus1_df['scenario'] = 'N+1 Problem'
    optimized_df['scenario'] = 'Optimized'
    nplus1_df['endpoint'] = nplus1_df['label'].apply(normalize_endpoint_label)
    optimized_df['endpoint'] = optimized_df['label'].apply(normalize_endpoint_label)

    return pd.concat([nplus1_df, optimized_df], ignore_index=True)

def normalize_endpoint_label(label):
    """비교가 가능하도록 라벨에서 시나리오 접두어를 제거"""
    label = str(label)
    label = re.sub(r'^(N\+1 Problem|Optimized)\s*-\s*', '', label, flags=re.IGNORECASE)
    return label.strip()

def calculate_stats(df):
    """응답 시간과 오류율 통계 계산"""
    total = len(df)
    errors = len(df[df['success'] == False])
    elapsed_sum_seconds = df['elapsed'].sum() / 1000

    return {
        'count': total,
        'avg': df['elapsed'].mean(),
        'median': df['elapsed'].median(),
        'p95': df['elapsed'].quantile(0.95),
        'max': df['elapsed'].max(),
        'min': df['elapsed'].min(),
        'throughput': total / elapsed_sum_seconds if elapsed_sum_seconds > 0 else 0,
        'errors': errors,
        'error_rate': (errors / total) * 100 if total > 0 else 0,
    }

def improvement_percent(before, after):
    """값이 낮을수록 좋은 지표의 개선율"""
    if before == 0:
        return 0
    return ((before - after) / before) * 100

def throughput_improvement_percent(before, after):
    """값이 높을수록 좋은 처리량 개선율"""
    if before == 0:
        return 0
    return ((after - before) / before) * 100

def print_stats(name, stats):
    print(f"{name}:")
    print(f"  - 요청 수: {stats['count']}")
    print(f"  - 평균: {stats['avg']:.2f}ms")
    print(f"  - 중간값: {stats['median']:.2f}ms")
    print(f"  - 95%ile: {stats['p95']:.2f}ms")
    print(f"  - 최소/최대: {stats['min']:.2f}ms / {stats['max']:.2f}ms")
    print(f"  - 처리량: {stats['throughput']:.2f} requests/sec")
    print(f"  - 오류율: {stats['error_rate']:.2f}% ({stats['errors']}/{stats['count']})")

def analyze_performance(df, nplus1_file, optimized_file):
    """성능 분석"""
    if df is None:
        return

    print("=" * 60)
    print("JMeter 성능 테스트 결과 비교")
    print("=" * 60)
    print(f"N+1 결과 파일: {nplus1_file}")
    print(f"최적화 결과 파일: {optimized_file}")
    
    n_plus_1_tests = df[df['scenario'] == 'N+1 Problem']
    optimized_tests = df[df['scenario'] == 'Optimized']
    n1_stats = calculate_stats(n_plus_1_tests)
    opt_stats = calculate_stats(optimized_tests)
    
    print(f"\n1. 전체 테스트 수: {len(df)}")
    print(f"   - N+1 문제 발생 방식: {n1_stats['count']}")
    print(f"   - LEFT JOIN FETCH 최적화 방식: {opt_stats['count']}")
    
    # 응답 시간 분석
    print(f"\n2. 전체 성능 비교")
    print("-" * 40)
    print_stats("N+1 문제 발생 방식", n1_stats)
    print()
    print_stats("LEFT JOIN FETCH 최적화 방식", opt_stats)

    print(f"\n3. 개선 효과")
    print("-" * 40)
    print(f"평균 응답 시간 개선: {improvement_percent(n1_stats['avg'], opt_stats['avg']):.1f}%")
    print(f"중간값 응답 시간 개선: {improvement_percent(n1_stats['median'], opt_stats['median']):.1f}%")
    print(f"95%ile 응답 시간 개선: {improvement_percent(n1_stats['p95'], opt_stats['p95']):.1f}%")
    print(f"최대 응답 시간 개선: {improvement_percent(n1_stats['max'], opt_stats['max']):.1f}%")
    print(f"처리량 개선: {throughput_improvement_percent(n1_stats['throughput'], opt_stats['throughput']):.1f}%")
    print(f"오류율 변화: {n1_stats['error_rate']:.2f}% -> {opt_stats['error_rate']:.2f}%")

    print(f"\n4. 엔드포인트별 비교")
    print("-" * 40)
    for endpoint in sorted(df['endpoint'].dropna().unique()):
        n1_endpoint = n_plus_1_tests[n_plus_1_tests['endpoint'] == endpoint]
        opt_endpoint = optimized_tests[optimized_tests['endpoint'] == endpoint]
        if n1_endpoint.empty or opt_endpoint.empty:
            continue

        n1_endpoint_stats = calculate_stats(n1_endpoint)
        opt_endpoint_stats = calculate_stats(opt_endpoint)
        print(f"{endpoint}:")
        print(f"  - 평균: {n1_endpoint_stats['avg']:.2f}ms -> {opt_endpoint_stats['avg']:.2f}ms "
              f"({improvement_percent(n1_endpoint_stats['avg'], opt_endpoint_stats['avg']):.1f}% 개선)")
        print(f"  - 95%ile: {n1_endpoint_stats['p95']:.2f}ms -> {opt_endpoint_stats['p95']:.2f}ms "
              f"({improvement_percent(n1_endpoint_stats['p95'], opt_endpoint_stats['p95']):.1f}% 개선)")
        print(f"  - 오류율: {n1_endpoint_stats['error_rate']:.2f}% -> {opt_endpoint_stats['error_rate']:.2f}%")

def create_visualization(df, output_dir="performance-charts"):
    """시각화 생성"""
    if df is None:
        return
    
    # 출력 디렉토리 생성
    Path(output_dir).mkdir(exist_ok=True)
    
    # 한글 폰트 설정
    plt.rcParams['font.family'] = 'DejaVu Sans'
    plt.rcParams['axes.unicode_minus'] = False
    
    n_plus_1_tests = df[df['scenario'] == 'N+1 Problem']
    optimized_tests = df[df['scenario'] == 'Optimized']
    
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
        sns.boxplot(data=df, x='scenario', y='elapsed', order=['N+1 Problem', 'Optimized'])
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
    plt.close()
    
    print(f"\n시각화 차트가 '{output_dir}/performance_analysis.png'에 저장되었습니다.")

def main():
    parser = argparse.ArgumentParser(description='JMeter N+1/최적화 성능 테스트 결과 비교')
    parser.add_argument('--nplus1', default='performance-results-nplus1.jtl',
                       help='N+1 방식 JMeter 결과 파일 경로')
    parser.add_argument('--optimized', default='performance-results-optimized.jtl',
                       help='최적화 방식 JMeter 결과 파일 경로')
    parser.add_argument('--output', '-o', default='performance-charts',
                       help='차트 출력 디렉토리')
    parser.add_argument('--no-chart', action='store_true',
                       help='차트 생성 안함')
    
    args = parser.parse_args()
    
    df = load_comparison_results(args.nplus1, args.optimized)
    
    if df is not None:
        analyze_performance(df, args.nplus1, args.optimized)
        
        if not args.no_chart:
            create_visualization(df, args.output)
    else:
        print("결과 파일을 로드할 수 없습니다.")

if __name__ == "__main__":
    main()
