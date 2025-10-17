#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
고급 카테고리별 도서 조회 성능 테스트
- 다양한 부하 조건에서의 성능 측정
- 동시 사용자 시뮬레이션
- 메모리 사용량 모니터링
"""

import requests
import time
import threading
import psutil
import json
from datetime import datetime
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from concurrent.futures import ThreadPoolExecutor, as_completed
import statistics

class CategoryPerformanceTester:
    def __init__(self, base_url="http://localhost:8080"):
        self.base_url = base_url
        self.results = []
        self.memory_usage = []
        
    def get_available_categories(self):
        """사용 가능한 카테고리 목록 조회"""
        try:
            response = requests.get(f"{self.base_url}/api/performance/debug/database-status")
            if response.status_code == 200:
                data = response.json()
                return data.get('categoriesWithBooks', [])
            return []
        except Exception as e:
            print(f"카테고리 목록 조회 실패: {e}")
            return []
    
    def test_single_request(self, category_id, test_type="n-plus-1"):
        """단일 요청 테스트"""
        start_time = time.time()
        start_memory = psutil.Process().memory_info().rss / 1024 / 1024  # MB
        
        try:
            if test_type == "n-plus-1":
                url = f"{self.base_url}/api/performance/books/category/{category_id}/n-plus-1"
            else:
                url = f"{self.base_url}/api/performance/books/category/{category_id}/optimized"
            
            response = requests.get(url, timeout=30)
            end_time = time.time()
            end_memory = psutil.Process().memory_info().rss / 1024 / 1024  # MB
            
            response_time = (end_time - start_time) * 1000  # ms
            memory_used = end_memory - start_memory
            
            return {
                'category_id': category_id,
                'test_type': test_type,
                'response_time': response_time,
                'memory_used': memory_used,
                'status_code': response.status_code,
                'success': response.status_code == 200,
                'book_count': len(response.json()) if response.status_code == 200 else 0,
                'timestamp': datetime.now()
            }
        except Exception as e:
            return {
                'category_id': category_id,
                'test_type': test_type,
                'response_time': 0,
                'memory_used': 0,
                'status_code': 0,
                'success': False,
                'book_count': 0,
                'error': str(e),
                'timestamp': datetime.now()
            }
    
    def test_concurrent_requests(self, category_id, concurrent_users=10, requests_per_user=5):
        """동시 사용자 테스트"""
        print(f"카테고리 {category_id} 동시 사용자 테스트 시작 (사용자: {concurrent_users}, 요청/사용자: {requests_per_user})")
        
        def user_simulation():
            user_results = []
            for _ in range(requests_per_user):
                # N+1 문제 방식
                n1_result = self.test_single_request(category_id, "n-plus-1")
                user_results.append(n1_result)
                
                # 최적화 방식
                opt_result = self.test_single_request(category_id, "optimized")
                user_results.append(opt_result)
                
                # 요청 간 간격
                time.sleep(0.1)
            
            return user_results
        
        # 동시 실행
        with ThreadPoolExecutor(max_workers=concurrent_users) as executor:
            futures = [executor.submit(user_simulation) for _ in range(concurrent_users)]
            
            all_results = []
            for future in as_completed(futures):
                try:
                    user_results = future.result()
                    all_results.extend(user_results)
                except Exception as e:
                    print(f"사용자 시뮬레이션 오류: {e}")
        
        return all_results
    
    def test_load_scenarios(self, category_ids, scenarios):
        """다양한 부하 시나리오 테스트"""
        all_results = []
        
        for scenario_name, config in scenarios.items():
            print(f"\n=== {scenario_name} 시나리오 테스트 ===")
            
            for category_id in category_ids:
                print(f"카테고리 {category_id} 테스트 중...")
                
                # 동시 사용자 테스트
                concurrent_results = self.test_concurrent_requests(
                    category_id,
                    config['concurrent_users'],
                    config['requests_per_user']
                )
                
                # 시나리오 정보 추가
                for result in concurrent_results:
                    result['scenario'] = scenario_name
                    result['concurrent_users'] = config['concurrent_users']
                    result['requests_per_user'] = config['requests_per_user']
                
                all_results.extend(concurrent_results)
                
                # 시나리오 간 간격
                time.sleep(config.get('delay', 2))
        
        return all_results
    
    def analyze_results(self, results):
        """결과 분석"""
        if not results:
            print("분석할 결과가 없습니다.")
            return
        
        df = pd.DataFrame(results)
        
        print("\n" + "="*60)
        print("성능 테스트 결과 분석")
        print("="*60)
        
        # 기본 통계
        print(f"\n1. 전체 테스트 수: {len(df)}")
        print(f"   - 성공: {len(df[df['success'] == True])}")
        print(f"   - 실패: {len(df[df['success'] == False])}")
        
        # 테스트 타입별 분석
        for test_type in df['test_type'].unique():
            type_data = df[df['test_type'] == test_type]
            if len(type_data) > 0:
                print(f"\n2. {test_type} 방식:")
                print(f"   - 평균 응답 시간: {type_data['response_time'].mean():.2f}ms")
                print(f"   - 중간값 응답 시간: {type_data['response_time'].median():.2f}ms")
                print(f"   - 95%ile 응답 시간: {type_data['response_time'].quantile(0.95):.2f}ms")
                print(f"   - 최대 응답 시간: {type_data['response_time'].max():.2f}ms")
                print(f"   - 평균 메모리 사용량: {type_data['memory_used'].mean():.2f}MB")
        
        # 카테고리별 분석
        print(f"\n3. 카테고리별 성능:")
        category_stats = df.groupby(['category_id', 'test_type'])['response_time'].agg(['mean', 'std', 'count']).round(2)
        print(category_stats)
        
        # 시나리오별 분석
        if 'scenario' in df.columns:
            print(f"\n4. 시나리오별 성능:")
            scenario_stats = df.groupby(['scenario', 'test_type'])['response_time'].agg(['mean', 'std']).round(2)
            print(scenario_stats)
        
        # 성능 개선율 계산
        self.calculate_improvement_rates(df)
        
        # 차트 생성
        self.create_performance_charts(df)
        
        return df
    
    def calculate_improvement_rates(self, df):
        """성능 개선율 계산"""
        print(f"\n5. 성능 개선율 분석:")
        
        # 카테고리별 개선율 계산
        for category_id in df['category_id'].unique():
            cat_data = df[df['category_id'] == category_id]
            n1_data = cat_data[cat_data['test_type'] == 'n-plus-1']
            opt_data = cat_data[cat_data['test_type'] == 'optimized']
            
            if len(n1_data) > 0 and len(opt_data) > 0:
                n1_avg = n1_data['response_time'].mean()
                opt_avg = opt_data['response_time'].mean()
                improvement = ((n1_avg - opt_avg) / n1_avg) * 100 if n1_avg > 0 else 0
                
                print(f"   카테고리 {category_id}: {improvement:.1f}% 개선 ({n1_avg:.2f}ms → {opt_avg:.2f}ms)")
    
    def create_performance_charts(self, df):
        """성능 차트 생성"""
        try:
            # 한글 폰트 설정
            plt.rcParams['font.family'] = 'Malgun Gothic'
            plt.rcParams['axes.unicode_minus'] = False
            
            fig, axes = plt.subplots(2, 2, figsize=(15, 12))
            
            # 1. 응답 시간 분포
            for test_type in df['test_type'].unique():
                type_data = df[df['test_type'] == test_type]
                axes[0, 0].hist(type_data['response_time'], alpha=0.7, label=test_type, bins=20)
            axes[0, 0].set_xlabel('응답 시간 (ms)')
            axes[0, 0].set_ylabel('빈도')
            axes[0, 0].set_title('응답 시간 분포')
            axes[0, 0].legend()
            
            # 2. 카테고리별 평균 응답 시간
            category_means = df.groupby(['category_id', 'test_type'])['response_time'].mean().unstack()
            category_means.plot(kind='bar', ax=axes[0, 1])
            axes[0, 1].set_xlabel('카테고리 ID')
            axes[0, 1].set_ylabel('평균 응답 시간 (ms)')
            axes[0, 1].set_title('카테고리별 평균 응답 시간')
            axes[0, 1].legend()
            
            # 3. 메모리 사용량
            for test_type in df['test_type'].unique():
                type_data = df[df['test_type'] == test_type]
                axes[1, 0].scatter(type_data['response_time'], type_data['memory_used'], 
                                 alpha=0.6, label=test_type)
            axes[1, 0].set_xlabel('응답 시간 (ms)')
            axes[1, 0].set_ylabel('메모리 사용량 (MB)')
            axes[1, 0].set_title('응답 시간 vs 메모리 사용량')
            axes[1, 0].legend()
            
            # 4. 시간별 성능 추이
            df['hour'] = df['timestamp'].dt.hour
            hourly_means = df.groupby(['hour', 'test_type'])['response_time'].mean().unstack()
            hourly_means.plot(ax=axes[1, 1])
            axes[1, 1].set_xlabel('시간 (시)')
            axes[1, 1].set_ylabel('평균 응답 시간 (ms)')
            axes[1, 1].set_title('시간별 성능 추이')
            axes[1, 1].legend()
            
            plt.tight_layout()
            plt.savefig('advanced-category-performance-charts.png', dpi=300, bbox_inches='tight')
            print("\n차트가 advanced-category-performance-charts.png로 저장되었습니다.")
            
        except Exception as e:
            print(f"차트 생성 중 오류 발생: {e}")
    
    def run_comprehensive_test(self):
        """종합 성능 테스트 실행"""
        print("=== 카테고리별 도서 조회 종합 성능 테스트 시작 ===")
        
        # 1. 사용 가능한 카테고리 조회
        categories = self.get_available_categories()
        if not categories:
            print("사용 가능한 카테고리가 없습니다.")
            return
        
        print(f"테스트할 카테고리: {categories}")
        
        # 2. 테스트 시나리오 정의
        scenarios = {
            '경량 부하': {
                'concurrent_users': 5,
                'requests_per_user': 3,
                'delay': 1
            },
            '중간 부하': {
                'concurrent_users': 10,
                'requests_per_user': 5,
                'delay': 2
            },
            '고부하': {
                'concurrent_users': 20,
                'requests_per_user': 10,
                'delay': 3
            }
        }
        
        # 3. 테스트 실행
        results = self.test_load_scenarios(categories[:5], scenarios)  # 처음 5개 카테고리만 테스트
        
        # 4. 결과 분석
        df = self.analyze_results(results)
        
        # 5. 결과 저장
        if df is not None:
            df.to_csv('advanced-category-performance-results.csv', index=False, encoding='utf-8-sig')
            print(f"\n결과가 advanced-category-performance-results.csv로 저장되었습니다.")
        
        print("\n=== 종합 성능 테스트 완료 ===")

def main():
    """메인 실행 함수"""
    tester = CategoryPerformanceTester()
    tester.run_comprehensive_test()

if __name__ == "__main__":
    main()
