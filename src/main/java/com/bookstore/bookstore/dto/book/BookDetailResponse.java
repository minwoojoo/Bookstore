package com.bookstore.bookstore.dto.book;

import com.bookstore.bookstore.entity.book.Book;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.stream.Collectors;

/**
 * 도서 상세 정보 응답 DTO
 */
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class BookDetailResponse {
    
    private Long bookId;
    private String title;
    private String authors;
    private String publisher;
    private BigDecimal price;
    private String thumbnailUrl;
    private String description;
    
    // 상세 정보
    private String isbn;
    private String registrationDate;
    private Integer pageCount;
    private Integer width;
    private Integer height;
    
    // 평점 및 판매 정보
    private BigDecimal ratingAvg;
    private Integer salesCount;
    private Integer monthlySales;
    
    // 재고 정보
    private Integer stockQuantity;
    private String bookStatus;
    
    /**
     * Book 엔티티를 BookDetailResponse로 변환
     */
    public static BookDetailResponse from(Book book) {
        // 저자 정보 추출
        String authors = book.getBookAuthors().stream()
                .map(bookAuthor -> bookAuthor.getAuthor().getName())
                .collect(Collectors.joining(", "));
        
        // 등록일 포맷팅
        String registrationDate = null;
        if (book.getRegistrationDate() != null) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy년 MM월 dd일");
            registrationDate = book.getRegistrationDate().format(formatter);
        }
        
        // 재고 정보
        Integer stockQuantity = null;
        if (book.getStock() != null) {
            stockQuantity = book.getStock().getQuantity();
        }
        
        return BookDetailResponse.builder()
                .bookId(book.getBookId())
                .title(book.getTitle())
                .authors(authors)
                .publisher(book.getPublisher())
                .price(book.getPrice())
                .thumbnailUrl(book.getThumbnailUrl())
                .description(book.getDescription())
                .isbn(book.getIsbn())
                .registrationDate(registrationDate)
                .pageCount(book.getPageCount())
                .width(book.getWidth())
                .height(book.getHeight())
                .ratingAvg(book.getRatingAvg())
                .salesCount(book.getSalesCount())
                .monthlySales(book.getMonthlySales())
                .stockQuantity(stockQuantity)
                .bookStatus(book.getBookStatus())
                .build();
    }
    
    /**
     * 크기 정보 문자열 (가로 x 세로)
     */
    public String getSizeInfo() {
        if (width != null && height != null) {
            return width + " x " + height + " mm";
        }
        return "정보 없음";
    }
    
    /**
     * 할인가 계산 (10% 할인)
     */
    public BigDecimal getDiscountPrice() {
        if (price != null) {
            return price.multiply(BigDecimal.valueOf(0.9));
        }
        return BigDecimal.ZERO;
    }
    
    /**
     * 할인 금액 계산
     */
    public BigDecimal getDiscountAmount() {
        if (price != null) {
            return price.multiply(BigDecimal.valueOf(0.1));
        }
        return BigDecimal.ZERO;
    }
    
    /**
     * 적립 포인트 계산 (5%)
     */
    public Integer getRewardPoints() {
        if (price != null) {
            return price.multiply(BigDecimal.valueOf(0.05)).intValue();
        }
        return 0;
    }
}

