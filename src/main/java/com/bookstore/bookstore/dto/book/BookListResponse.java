package com.bookstore.bookstore.dto.book;

import com.bookstore.bookstore.entity.book.Book;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class BookListResponse {
    
    private Long bookId;
    private String title;
    private String publisher;
    private BigDecimal price;
    private String thumbnailUrl;
    private String authors; // 저자명들을 ", "로 연결한 문자열
    private Integer salesCount; // 판매지수
    private Double averageRating; // 평균평점
    
    /**
     * Book 엔티티를 BookListResponse DTO로 변환
     */
    public static BookListResponse from(Book book) {
        // 저자명 추출
        String authors = book.getBookAuthors().stream()
                .map(bookAuthor -> bookAuthor.getAuthor().getName())
                .collect(Collectors.joining(", "));
        
        return BookListResponse.builder()
                .bookId(book.getBookId())
                .title(book.getTitle())
                .publisher(book.getPublisher())
                .price(book.getPrice())
                .thumbnailUrl(book.getThumbnailUrl())
                .authors(authors.isEmpty() ? "저자 미상" : authors)
                .salesCount(book.getSalesCount() != null ? book.getSalesCount() : 0)
                .averageRating(0.0) // 기본값으로 0.0 설정
                .build();
    }
    
    /**
     * Book 엔티티와 평균평점을 받아서 BookListResponse DTO로 변환
     */
    public static BookListResponse from(Book book, Double averageRating) {
        // 저자명 추출
        String authors = book.getBookAuthors().stream()
                .map(bookAuthor -> bookAuthor.getAuthor().getName())
                .collect(Collectors.joining(", "));
        
        return BookListResponse.builder()
                .bookId(book.getBookId())
                .title(book.getTitle())
                .publisher(book.getPublisher())
                .price(book.getPrice())
                .thumbnailUrl(book.getThumbnailUrl())
                .authors(authors.isEmpty() ? "저자 미상" : authors)
                .salesCount(book.getSalesCount() != null ? book.getSalesCount() : 0)
                .averageRating(averageRating != null ? averageRating : 0.0)
                .build();
    }
    
    /**
     * Book 엔티티 리스트를 BookListResponse 리스트로 변환
     */
    public static List<BookListResponse> fromList(List<Book> books) {
        return books.stream()
                .map(BookListResponse::from)
                .collect(Collectors.toList());
    }
    
    /**
     * Book 엔티티 리스트와 평균평점 맵을 받아서 BookListResponse 리스트로 변환
     */
    public static List<BookListResponse> fromListWithRatings(List<Book> books, java.util.Map<Long, Double> averageRatings) {
        return books.stream()
                .map(book -> {
                    Double rating = averageRatings.get(book.getBookId());
                    return BookListResponse.from(book, rating);
                })
                .collect(Collectors.toList());
    }
}

