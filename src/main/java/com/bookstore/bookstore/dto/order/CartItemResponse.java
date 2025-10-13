package com.bookstore.bookstore.dto.order;

import com.bookstore.bookstore.entity.order.CartItem;
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
public class CartItemResponse {
    
    private Long cartItemId;
    private Long bookId;
    private String title;
    private String authors;
    private String publisher;
    private String thumbnailUrl;
    private BigDecimal price;
    private Integer quantity;
    private BigDecimal subtotal; // 소계 (가격 × 수량)
    
    /**
     * CartItem 엔티티를 CartItemResponse DTO로 변환
     */
    public static CartItemResponse from(CartItem cartItem) {
        // 저자명 추출
        String authors = cartItem.getBook().getBookAuthors().stream()
                .map(bookAuthor -> bookAuthor.getAuthor().getName())
                .collect(Collectors.joining(", "));
        
        // 소계 계산
        BigDecimal subtotal = cartItem.getBook().getPrice()
                .multiply(BigDecimal.valueOf(cartItem.getQuantity()));
        
        return CartItemResponse.builder()
                .cartItemId(cartItem.getCartItemId())
                .bookId(cartItem.getBook().getBookId())
                .title(cartItem.getBook().getTitle())
                .authors(authors.isEmpty() ? "저자 미상" : authors)
                .publisher(cartItem.getBook().getPublisher())
                .thumbnailUrl(cartItem.getBook().getThumbnailUrl())
                .price(cartItem.getBook().getPrice())
                .quantity(cartItem.getQuantity())
                .subtotal(subtotal)
                .build();
    }
    
    /**
     * CartItem 리스트를 CartItemResponse 리스트로 변환
     */
    public static List<CartItemResponse> fromList(List<CartItem> cartItems) {
        return cartItems.stream()
                .map(CartItemResponse::from)
                .collect(Collectors.toList());
    }
}

