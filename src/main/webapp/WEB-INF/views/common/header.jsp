<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<style>
    /* 상단바 */
    .top-bar {
        background: #333;
        color: white;
        padding: 8px 0;
        font-size: 12px;
    }
    .top-bar .container {
        max-width: 1200px;
        margin: 0 auto;
        display: flex;
        justify-content: flex-end;
        gap: 15px;
        padding: 0 20px;
    }
    .top-bar a {
        color: white;
        text-decoration: none;
    }
    .top-bar a:hover {
        text-decoration: underline;
    }
    .top-bar button:hover {
        opacity: 0.8;
    }
    
    /* 헤더 */
    header {
        background: white;
        border-bottom: 2px solid #0066cc;
        padding: 20px 0;
    }
    .header-container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 20px;
        display: flex;
        align-items: center;
        gap: 30px;
    }
    .logo {
        font-size: 28px;
        font-weight: bold;
        color: #0066cc;
        text-decoration: none;
    }
    .logo span {
        color: #333;
    }
    
    /* 검색창 */
    .search-box {
        flex: 1;
        display: flex;
        gap: 10px;
    }
    .search-box input {
        flex: 1;
        padding: 12px 15px;
        border: 2px solid #0066cc;
        border-radius: 4px;
        font-size: 14px;
    }
    .search-box button {
        padding: 12px 30px;
        background: #0066cc;
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-weight: bold;
    }
    .search-box button:hover {
        background: #0052a3;
    }
</style>

<!-- 상단바 -->
<div class="top-bar">
    <div class="container">
        <c:choose>
            <c:when test="${isAuthenticated}">
                <span>${userName}님</span>
                <span style="margin: 0 10px;">|</span>
                <form action="/auth/logout" method="post" style="display: inline; margin: 0;">
                    <button type="submit" style="background: none; border: none; color: white; cursor: pointer; text-decoration: none; font-size: 12px; padding: 0; font-family: inherit;">
                        로그아웃
                    </button>
                </form>
                <a href="/mypage">마이페이지</a>
                <a href="/order/history">주문내역</a>
                <a href="/cart">장바구니</a>
            </c:when>
            <c:otherwise>
                <a href="/auth/login">로그인</a>
                <a href="/auth/signup">회원가입</a>
                <a href="/mypage">마이페이지</a>
                <a href="/order/history">주문내역</a>
                <a href="/cart">장바구니</a>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- 헤더 -->
<header>
    <div class="header-container">
        <a href="/" class="logo">ONLINE <span>BOOKSTORE</span></a>
        <div class="search-box">
            <form action="/books/search" method="get" style="display: flex; flex: 1; gap: 10px;">
                <input type="text" name="keyword" placeholder="책 제목, 저자, 출판사를 검색해보세요" required>
                <button type="submit">검색</button>
            </form>
        </div>
    </div>
</header>
