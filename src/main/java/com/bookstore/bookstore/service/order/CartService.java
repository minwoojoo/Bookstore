package com.bookstore.bookstore.service.order;

import com.bookstore.bookstore.dto.order.CartItemResponse;
import com.bookstore.bookstore.entity.book.Book;
import com.bookstore.bookstore.entity.customer.Member;
import com.bookstore.bookstore.entity.order.Cart;
import com.bookstore.bookstore.entity.order.CartItem;
import com.bookstore.bookstore.repository.book.BookRepository;
import com.bookstore.bookstore.repository.customer.MemberRepository;
import com.bookstore.bookstore.repository.order.CartItemRepository;
import com.bookstore.bookstore.repository.order.CartRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional(readOnly = true)
public class CartService {
    
    private final CartRepository cartRepository;
    private final CartItemRepository cartItemRepository;
    private final MemberRepository memberRepository;
    private final BookRepository bookRepository;
    
    /**
     * 회원의 장바구니 아이템 목록 조회
     */
    @Transactional(readOnly = true)
    public List<CartItemResponse> getCartItems(Long memberId) {
        Optional<Cart> cartOpt = cartRepository.findByMemberIdWithItems(memberId);
        
        if (cartOpt.isEmpty()) {
            log.info("장바구니가 비어있음: memberId={}", memberId);
            return List.of();
        }
        
        Cart cart = cartOpt.get();
        
        // bookAuthors를 명시적으로 초기화 (lazy loading)
        cart.getCartItems().forEach(item -> {
            item.getBook().getBookAuthors().size(); // lazy loading 트리거
        });
        
        log.info("장바구니 조회 완료: memberId={}, 아이템 수={}", memberId, cart.getCartItems().size());
        
        return CartItemResponse.fromList(cart.getCartItems());
    }
    
    /**
     * 장바구니에 상품 추가
     */
    @Transactional
    public void addToCart(Long memberId, Long bookId, int quantity) {
        // 회원 조회
        Member member = memberRepository.findById(memberId)
                .orElseThrow(() -> new IllegalArgumentException("회원을 찾을 수 없습니다: " + memberId));
        
        // 책 조회
        Book book = bookRepository.findById(bookId)
                .orElseThrow(() -> new IllegalArgumentException("도서를 찾을 수 없습니다: " + bookId));
        
        // 장바구니 조회 또는 생성
        Cart cart = cartRepository.findByMemberIdWithItems(memberId)
                .orElseGet(() -> {
                    Cart newCart = Cart.builder()
                            .member(member)
                            .build();
                    return cartRepository.save(newCart);
                });
        
        // 이미 장바구니에 있는 책인지 확인
        Optional<CartItem> existingItemOpt = cartItemRepository.findByCartIdAndBookId(cart.getCartId(), bookId);
        
        if (existingItemOpt.isPresent()) {
            // 이미 있으면 수량 증가
            CartItem existingItem = existingItemOpt.get();
            existingItem.increaseQuantity(quantity);
            log.info("장바구니 수량 증가: bookId={}, 기존 수량 + {} = {}", bookId, quantity, existingItem.getQuantity());
        } else {
            // 없으면 새로 추가
            CartItem newItem = CartItem.builder()
                    .cart(cart)
                    .book(book)
                    .isbn(book.getIsbn())
                    .quantity(quantity)
                    .build();
            cart.getCartItems().add(newItem);
            cartItemRepository.save(newItem);
            log.info("장바구니에 추가: bookId={}, quantity={}", bookId, quantity);
        }
    }
    
    /**
     * 장바구니 아이템 수량 변경
     */
    @Transactional
    public void updateQuantity(Long cartItemId, int quantity) {
        CartItem cartItem = cartItemRepository.findById(cartItemId)
                .orElseThrow(() -> new IllegalArgumentException("장바구니 아이템을 찾을 수 없습니다: " + cartItemId));
        
        if (quantity <= 0) {
            throw new IllegalArgumentException("수량은 1 이상이어야 합니다.");
        }
        
        cartItem.setQuantity(quantity);
        log.info("장바구니 수량 변경: cartItemId={}, quantity={}", cartItemId, quantity);
    }
    
    /**
     * 장바구니 아이템 삭제 (단일)
     */
    @Transactional
    public void removeItem(Long cartItemId) {
        cartItemRepository.deleteById(cartItemId);
        log.info("장바구니 아이템 삭제: cartItemId={}", cartItemId);
    }
    
    /**
     * 장바구니 아이템 삭제 (다중)
     */
    @Transactional
    public void removeItems(List<Long> cartItemIds) {
        cartItemRepository.deleteByCartItemIdIn(cartItemIds);
        log.info("장바구니 아이템 삭제: {} 개", cartItemIds.size());
    }
    
    /**
     * 장바구니 전체 비우기
     */
    @Transactional
    public void clearCart(Long memberId) {
        Optional<Cart> cartOpt = cartRepository.findByMemberIdWithItems(memberId);
        if (cartOpt.isPresent()) {
            Cart cart = cartOpt.get();
            cart.getCartItems().clear();
            log.info("장바구니 전체 삭제: memberId={}", memberId);
        }
    }
}

