package com.bookstore.bookstore.entity.book;

import lombok.*;

import java.io.Serializable;
import java.util.Objects;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
public class BookAuthorId implements Serializable {
    
    private Long bookId;
    private Long authorId;
}

