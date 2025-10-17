#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
카테고리별 도서 조회 성능 분석 스크립트
"""

import sys
import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from datetime import datetime

def analyze_category_performance(category_id, n1_file, opt_file):
    """카테고리별 성능 분석"""
    
    # N+1 문제 방식 결과 읽기
    n1_times = []
    try:
        with open(n1_file, 'r') as f:
            for line in f:
                line = line.strip()
                if line and line.replace('.', '').isdigit():
                    n1_times.append(float(line) * 1000)  # 초를 밀리초로 변환
    except FileNotFoundError:
        print(f"파일을 찾을 수 없습니다: {n1_file}")
        return
    
    # 최적화 방식 결과 읽기
    opt_times = []
    try:
        with open(opt_file, 'r') as f:
            for line in f:
                line = line.strip()
                if line and line.replace('.', '').isdigit():
                    opt_times.append(float(line) * 1000)  # 초를 밀리초로 변환
    except FileNotFoundError:
        print(f"파일을 찾을 수 없습니다: {opt_file}")
        return
    
    if not n1_times or not opt_times:
        print(f"카테고리 {category_id}: 유효한 데이터가 없습니다.")
        return
    
    # 통계 계산
    n1_avg = np.mean(n1_times)
    opt_avg = np.mean(opt_times)
    improvement = ((n1_avg - opt_avg) / n1_avg) * 100 if n1_avg > 0 else 0
    
    # 도서 수 추정 (실제로는 API에서 가져와야 함)
    book_count = len(n1_times) * 10  # 추정치
    
    # 결과를 CSV에 추가
    result_line = f"{category_id},{book_count},{n1_avg:.2f},{opt_avg:.2f},{improvement:.1f},N+1,Optimized\n"
    
    with open('category-performance-results.csv', 'a') as f:
        f.write(result_line)
    
    print(f"카테고리 {category_id}: N+1={n1_avg:.2f}ms, 최적화={opt_avg:.2f}ms, 개선율={improvement:.1f}%")

def create_performance_charts():
    """성능 차트 생성"""
    
    try:
        # CSV 파일 읽기
        df = pd.read_csv('category-performance-results.csv')
        
        # 한글 폰트 설정
        plt.rcParams['font.family'] = 'Malgun Gothic'
        plt.rcParams['axes.unicode_minus'] = False
        
        # 1. 응답 시간 비교 차트
        fig, axes = plt.subplots(2, 2, figsize=(15, 12))
        
        # 카테고리별 응답 시간 비교
        x = range(len(df))
        width = 0.35
        
        axes[0, 0].bar([i - width/2 for i in x], df['N+1_응답시간(ms)'], width, label='N+1 문제', alpha=0.8)
        axes[0, 0].bar([i + width/2 for i in x], df['최적화_응답시간(ms)'], width, label='최적화', alpha=0.8)
        axes[0, 0].set_xlabel('카테고리 ID')
        axes[0, 0].set_ylabel('응답 시간 (ms)')
        axes[0, 0].set_title('카테고리별 응답 시간 비교')
        axes[0, 0].legend()
        axes[0, 0].set_xticks(x)
        axes[0, 0].set_xticklabels(df['카테고리ID'])
        
        # 성능 개선율 차트
        colors = ['green' if x > 0 else 'red' for x in df['성능개선율(%)']]
        axes[0, 1].bar(df['카테고리ID'], df['성능개선율(%)'], color=colors, alpha=0.7)
        axes[0, 1].set_xlabel('카테고리 ID')
        axes[0, 1].set_ylabel('성능 개선율 (%)')
        axes[0, 1].set_title('카테고리별 성능 개선율')
        axes[0, 1].axhline(y=0, color='black', linestyle='-', alpha=0.3)
        
        # 도서 수별 성능 비교
        axes[1, 0].scatter(df['도서수'], df['N+1_응답시간(ms)'], label='N+1 문제', alpha=0.7, s=60)
        axes[1, 0].scatter(df['도서수'], df['최적화_응답시간(ms)'], label='최적화', alpha=0.7, s=60)
        axes[1, 0].set_xlabel('도서 수')
        axes[1, 0].set_ylabel('응답 시간 (ms)')
        axes[1, 0].set_title('도서 수별 성능 비교')
        axes[1, 0].legend()
        
        # 성능 개선율 분포
        axes[1, 1].hist(df['성능개선율(%)'], bins=10, alpha=0.7, color='skyblue', edgecolor='black')
        axes[1, 1].set_xlabel('성능 개선율 (%)')
        axes[1, 1].set_ylabel('빈도')
        axes[1, 1].set_title('성능 개선율 분포')
        
        plt.tight_layout()
        plt.savefig('category-performance-charts.png', dpi=300, bbox_inches='tight')
        print("차트가 category-performance-charts.png로 저장되었습니다.")
        
        # 2. 상세 분석 리포트 생성
        create_detailed_report(df)
        
    except FileNotFoundError:
        print("category-performance-results.csv 파일을 찾을 수 없습니다.")
    except Exception as e:
        print(f"차트 생성 중 오류 발생: {e}")

def create_detailed_report(df):
    """상세 분석 리포트 생성"""
    
    report = f"""
# 카테고리별 도서 조회 성능 분석 리포트

생성 시간: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}

## 전체 통계

- 테스트된 카테고리 수: {len(df)}
- 평균 N+1 응답 시간: {df['N+1_응답시간(ms)'].mean():.2f}ms
- 평균 최적화 응답 시간: {df['최적화_응답시간(ms)'].mean():.2f}ms
- 전체 평균 성능 개선율: {df['성능개선율(%)'].mean():.1f}%

## 성능 개선 효과

- 최대 개선율: {df['성능개선율(%)'].max():.1f}% (카테고리 {df.loc[df['성능개선율(%)'].idxmax(), '카테고리ID']})
- 최소 개선율: {df['성능개선율(%)'].min():.1f}% (카테고리 {df.loc[df['성능개선율(%)'].idxmin(), '카테고리ID']})
- 개선된 카테고리 수: {len(df[df['성능개선율(%)'] > 0])}개
- 성능 저하된 카테고리 수: {len(df[df['성능개선율(%)'] < 0])}개

## 상위 성능 개선 카테고리 (Top 5)

"""
    
    top_improvements = df.nlargest(5, '성능개선율(%)')
    for idx, row in top_improvements.iterrows():
        report += f"- 카테고리 {row['카테고리ID']}: {row['성능개선율(%)']:.1f}% 개선 ({row['N+1_응답시간(ms)']:.2f}ms → {row['최적화_응답시간(ms)']:.2f}ms)\n"
    
    report += f"""
## 하위 성능 개선 카테고리 (Bottom 5)

"""
    
    bottom_improvements = df.nsmallest(5, '성능개선율(%)')
    for idx, row in bottom_improvements.iterrows():
        report += f"- 카테고리 {row['카테고리ID']}: {row['성능개선율(%)']:.1f}% 개선 ({row['N+1_응답시간(ms)']:.2f}ms → {row['최적화_응답시간(ms)']:.2f}ms)\n"
    
    report += f"""
## 권장사항

1. **높은 개선 효과를 보인 카테고리**: LEFT JOIN FETCH 최적화를 적극 활용
2. **낮은 개선 효과를 보인 카테고리**: 추가적인 쿼리 최적화 검토 필요
3. **성능 저하를 보인 카테고리**: 쿼리 실행 계획 재검토 및 인덱스 최적화 필요

## 상세 데이터

| 카테고리ID | 도서수 | N+1 응답시간(ms) | 최적화 응답시간(ms) | 성능개선율(%) |
|-----------|--------|------------------|---------------------|---------------|
"""
    
    for idx, row in df.iterrows():
        report += f"| {row['카테고리ID']} | {row['도서수']} | {row['N+1_응답시간(ms)']:.2f} | {row['최적화_응답시간(ms)']:.2f} | {row['성능개선율(%)']:.1f} |\n"
    
    # 리포트 저장
    with open('category-performance-report.md', 'w', encoding='utf-8') as f:
        f.write(report)
    
    print("상세 리포트가 category-performance-report.md로 저장되었습니다.")

if __name__ == "__main__":
    if len(sys.argv) == 4:
        # 개별 카테고리 분석
        category_id = sys.argv[1]
        n1_file = sys.argv[2]
        opt_file = sys.argv[3]
        analyze_category_performance(category_id, n1_file, opt_file)
    else:
        # 전체 차트 생성
        create_performance_charts()
