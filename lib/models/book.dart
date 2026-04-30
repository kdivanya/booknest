import 'package:flutter/material.dart';

class Book {
  final String id;
  final String title;
  final String author;
  final String genre;
  final double price;
  final double? originalPrice;
  final double rating;
  final int reviewCount;
  final String synopsis;
  final String format;
  final int pages;
  final String language;
  final String publisher;
  final String releasedDate;
  final String isbn;
  final double fileSize;
  final List<String> tags;
  final bool isOnSale;
  final bool isSoldOut;
  final Color coverColor;
  final String coverUrl;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.synopsis,
    this.format = 'E-book',
    this.pages = 300,
    this.language = 'Indonesia',
    this.publisher = 'Gramedia Pustaka',
    this.releasedDate = 'Jan 1, 2023',
    this.isbn = '9786020650123',
    this.fileSize = 12.5,
    this.tags = const [],
    this.isOnSale = false,
    this.isSoldOut = false,
    required this.coverUrl,
    this.coverColor = const Color(0xFFE8DCCB),
  });
}

class Review {
  final String name;
  final String avatar;
  final int rating;
  final String date;
  final String text;
  const Review({
    required this.name,
    required this.avatar,
    required this.rating,
    required this.date,
    required this.text,
  });
}

const List<Review> dummyReviews = [
  Review(name: 'Elena Sophia', avatar: '👩', rating: 5, date: 'Oct 12, 2023',
      text: 'An absolutely breathtaking read. It made me reflect so much on my own choices. The prose is beautiful and the concept is very original.'),
  Review(name: 'Marcus Julian', avatar: '👨', rating: 4, date: 'Sep 28, 2023',
      text: 'Loved the first half, but felt the pacing slowed down a bit towards the end. Still, a very cozy and philosophical journey.'),
  Review(name: 'Sarah Lin', avatar: '👩‍🦱', rating: 5, date: 'Sep 15, 2023',
      text: "I couldn't put it down! Nora is such a relatable character. A must-read for anyone feeling a bit lost in life."),
];

const List<Book> allBooks = [
  Book(id: '1', title: 'The Midnight Library', author: 'Matt Haig', genre: 'Fiction',
      price: 120000, originalPrice: 150000, rating: 4.5, reviewCount: 128,
      synopsis: 'Between life and death there is a library, and within that library, the shelves go on forever. Every book provides a chance to try another life you could have lived.\n\nNora Seed finds herself faced with the possibility of changing her life for a new one, following a different career, undoing old breakups, or realizing her dreams.',
      format: 'E-book', pages: 312, publisher: 'Gramedia Pustaka', releasedDate: 'Feb 14, 2023',
      isbn: '9786020650123', fileSize: 12.5,
      tags: ['Bestseller', 'Philosophical', 'Time Travel', 'Mental Health'], isOnSale: true,
      coverUrl: 'https://covers.openlibrary.org/b/id/15164860-L.jpg'),
  Book(id: '2', title: 'A Little Life', author: 'Hanya Yanagihara', genre: 'Fiction',
      price: 89000, rating: 4.8, reviewCount: 94,
      synopsis: 'It focuses on Jude St. Francis, a brilliant lawyer haunted by severe, unrevealed childhood abuse and chronic pain. The story explores trauma, deep friendship, and the limits of love in overcoming profound psychological damage.',
      pages: 428, tags: ['Fiction', 'Drama', 'Contemporary'],
      coverUrl: 'https://covers.openlibrary.org/b/id/14841606-L.jpg'),
  Book(id: '3', title: 'Black Showman and the Murder in an Obscure Town', author: 'Keigo Higashino', genre: 'Self-help',
      price: 115000, rating: 4.9, reviewCount: 210,
      synopsis: 'A retired, respected teacher is found murdered in his home, leading his daughter and her uncle, Takeshi—a former "black magician" or "illusionist"—to investigate, as the police investigation stalls.',
      pages: 256, tags: ['Mystery', 'Thriller'],
      coverUrl: 'https://m.media-amazon.com/images/S/compressed.photo.goodreads.com/books/1639776770i/59842337.jpg'),
  Book(id: '4', title: 'Days at the Morisaki Bookshop', author: 'Satoshi Yagisawa', genre: 'Fiction',
      price: 142000, rating: 4.6, reviewCount: 87,
      synopsis: 'The moving international sensation about new beginnings, human connection, and the joy of reading. Hidden in Jimbocho, Tokyo, is a booklover\'s paradise. On a quiet corner in an old wooden building lies a shop filled with hundreds of second-hand books.',
      format: 'Physical', pages: 380, tags: ['Fiction', 'Contemporary', 'Romance'],
      coverUrl: 'https://m.media-amazon.com/images/S/compressed.photo.goodreads.com/books/1671208761i/62047992.jpg'),
  ];

class OrderHistory {
  final String orderId;
  final String date;
  final String status;
  final List<Book> books;
  final double total;
  const OrderHistory({
    required this.orderId, required this.date, required this.status,
    required this.books, required this.total,
  });
}

final List<OrderHistory> dummyOrders = [
  OrderHistory(orderId: 'FL-A8F9D2E1', date: 'Today, 10:45 AM', status: 'Shipping',
      books: [allBooks[0], allBooks[2]], total: 235000),
  OrderHistory(orderId: 'FL-C7B2E4X9', date: '14 May 2024, 02:15 PM', status: 'Completed',
      books: [allBooks[1]], total: 89000),
  OrderHistory(orderId: 'FL-J9K1M4Y2', date: '10 May 2024, 11:20 AM', status: 'Completed',
      books: [allBooks[2]], total: 115000),
];