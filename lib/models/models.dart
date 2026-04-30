import 'package:flutter/material.dart';

class Book {
  final String id;
  final String title;
  final String author;
  final double price;
  final double originalPrice;
  final double rating;
  final int reviewCount;
  final String genre;
  final String synopsis;
  final String format;
  final int pages;
  final String language;
  final String publisher;
  final String releasedDate;
  final String isbn;
  final String fileSize;
  final List<String> tags;
  final bool isSoldOut;
  final bool isOnSale;
  final Color coverColor;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.price,
    this.originalPrice = 0,
    required this.rating,
    required this.reviewCount,
    required this.genre,
    required this.synopsis,
    this.format = 'E-book',
    this.pages = 312,
    this.language = 'Indonesia',
    this.publisher = 'Gramedia Pustaka',
    this.releasedDate = 'Feb 14, 2023',
    this.isbn = '9786020650123',
    this.fileSize = '12.5 MB',
    this.tags = const [],
    this.isSoldOut = false,
    this.isOnSale = false,
    this.coverColor = const Color(0xFFE8E0F5),
  });
}

class Review {
  final String name;
  final String avatarColor;
  final double rating;
  final String date;
  final String comment;

  const Review({
    required this.name,
    required this.avatarColor,
    required this.rating,
    required this.date,
    required this.comment,
  });
}

class CartItem {
  final Book book;
  int quantity;
  bool isChecked;

  CartItem({required this.book, this.quantity = 1, this.isChecked = true});

  double get totalPrice => book.price * quantity;
}

class OrderHistory {
  final String orderId;
  final String date;
  final String status;
  final String mainBookTitle;
  final int itemCount;
  final double total;

  const OrderHistory({
    required this.orderId,
    required this.date,
    required this.status,
    required this.mainBookTitle,
    required this.itemCount,
    required this.total,
  });
}

class AppData {
  static const List<Book> books = [
    Book(id: 'b1', title: 'The Midnight Library', author: 'Matt Haig', price: 120000, originalPrice: 120000,
      rating: 4.5, reviewCount: 128, genre: 'Fiction',
      synopsis: 'Between life and death there is a library, and within that library, the shelves go on forever. Every book provides a chance to try another life you could have lived. To see how things would be if you had made other choices...\n\nNora Seed finds herself faced with the possibility of changing her life for a new one, following a different career, undoing old breakups, or realizing her dreams.',
      tags: ['Bestseller', 'Philosophical', 'Time Travel', 'Mental Health'], isOnSale: true, coverColor: Color(0xFFDDD5EE)),
    Book(id: 'b2', title: 'Stellar Echoes', author: 'Elena Rigby', price: 89000,
      rating: 4.8, reviewCount: 94, genre: 'Fiction',
      synopsis: 'A young astronomer discovers signals from a distant star that seem to carry messages — messages that change everything she thought she knew about the universe and her place in it.',
      tags: ['Sci-fi', 'Space', 'Mystery'], coverColor: Color(0xFFE5E0F5)),
    Book(id: 'b3', title: 'Quiet Minds', author: 'Marcus Aurelius', price: 115000,
      rating: 4.9, reviewCount: 210, genre: 'Self-help',
      synopsis: 'A modern retelling of stoic philosophy adapted for the challenges of contemporary life. Learn to quiet the noise and find clarity in chaos.',
      tags: ['Philosophy', 'Stoicism', 'Mindfulness'], coverColor: Color(0xFFECE5F5)),
    Book(id: 'b4', title: 'The Hidden Garden', author: 'T.S. Elliott', price: 142000,
      rating: 4.7, reviewCount: 67, genre: 'Fiction',
      synopsis: 'Behind an old iron gate lies a garden that should not exist. When Lily finds the key, she steps into a world where time moves differently and every flower tells a story.',
      tags: ['Fantasy', 'Mystery', 'Nature'], coverColor: Color(0xFFD8D0EC)),
    Book(id: 'b5', title: 'Atomic Habits', author: 'James Clear', price: 180000,
      rating: 4.9, reviewCount: 3200, genre: 'Self-help',
      synopsis: 'No matter your goals, Atomic Habits offers a proven framework for improving every day. James Clear reveals practical strategies that will teach you exactly how to form good habits, break bad ones.',
      tags: ['Productivity', 'Habits', 'Self-improvement'], coverColor: Color(0xFFDFD8EE)),
    Book(id: 'b6', title: 'Alchemist', author: 'Paulo Coelho', price: 95000,
      rating: 4.8, reviewCount: 5100, genre: 'Fiction',
      synopsis: 'A young Andalusian shepherd in his journey to the pyramids of Egypt after having a recurring dream of finding a treasure there, and along the way his life intersects with that of a mysterious alchemist.',
      tags: ['Spiritual', 'Adventure', 'Classic'], coverColor: Color(0xFFE8E0F5)),
    Book(id: 'b7', title: 'The Great Gatsby', author: 'F. Scott Fitzgerald', price: 125000,
      rating: 4.8, reviewCount: 890, genre: 'Fiction',
      synopsis: 'Set in the Jazz Age on Long Island, the novel depicts narrator Nick Carraway\'s interactions with mysterious millionaire Jay Gatsby and Gatsby\'s obsession with the beautiful former debutante Daisy Buchanan.',
      tags: ['Classic', 'Drama', 'Romance'], coverColor: Color(0xFFE5DFF0)),
    Book(id: 'b8', title: '1984', author: 'George Orwell', price: 110000,
      rating: 4.9, reviewCount: 2300, genre: 'Fiction',
      synopsis: 'A dystopian social science fiction novel and cautionary tale about the dangers of totalitarianism. The story follows Winston Smith as he navigates a society of omnipresent surveillance.',
      tags: ['Dystopia', 'Classic', 'Political'], isSoldOut: true, coverColor: Color(0xFFDDD5EB)),
    Book(id: 'b9', title: 'Pride and Prejudice', author: 'Jane Austen', price: 145000,
      rating: 4.7, reviewCount: 1800, genre: 'Fiction',
      synopsis: 'The story follows Elizabeth Bennet as she deals with issues of manners, upbringing, morality, education, and marriage in the society of the landed gentry of the British Regency.',
      tags: ['Classic', 'Romance', 'Drama'], coverColor: Color(0xFFE0D8F0)),
    Book(id: 'b10', title: 'Little Women', author: 'Louisa May Alcott', price: 160000,
      rating: 4.9, reviewCount: 1400, genre: 'Fiction',
      synopsis: 'Meg, Jo, Beth, and Amy. The story of the March sisters growing up during the Civil War era, navigating love, loss, and the pursuit of their individual dreams.',
      tags: ['Classic', 'Family', 'Coming-of-age'], coverColor: Color(0xFFE8E0F5)),
  ];

  static List<Book> search(String query) {
    final q = query.toLowerCase();
    return books.where((b) =>
      b.title.toLowerCase().contains(q) ||
      b.author.toLowerCase().contains(q) ||
      b.genre.toLowerCase().contains(q) ||
      b.tags.any((t) => t.toLowerCase().contains(q))
    ).toList();
  }

  static const List<Review> reviews = [
    Review(name: 'Elena Sophia', avatarColor: '#C5AEF0', rating: 5, date: 'Oct 12, 2023',
      comment: 'An absolutely breathtaking read. It made me reflect so much on my own choices. The prose is beautiful and the concept is very original.'),
    Review(name: 'Marcus Julian', avatarColor: '#AEB8F0', rating: 4, date: 'Sep 28, 2023',
      comment: 'Loved the first half, but felt the pacing slowed down a bit towards the end. Still, a very cozy and philosophical journey.'),
    Review(name: 'Sarah Lin', avatarColor: '#F0AEC5', rating: 5, date: 'Sep 15, 2023',
      comment: "I couldn't put it down! Nora is such a relatable character. A must-read for anyone feeling a bit lost in life."),
  ];

  static const List<OrderHistory> orders = [
    OrderHistory(orderId: 'FL-A8F9D2E1', date: 'Today, 10:45 AM', status: 'Shipping',
      mainBookTitle: 'The Midnight Library', itemCount: 2, total: 235000),
    OrderHistory(orderId: 'FL-C7B2E4X9', date: '14 May 2024, 02:15 PM', status: 'Completed',
      mainBookTitle: 'Stellar Echoes', itemCount: 1, total: 89000),
    OrderHistory(orderId: 'FL-J9K1M4Y2', date: '10 May 2024, 11:20 AM', status: 'Completed',
      mainBookTitle: 'Quiet Minds', itemCount: 1, total: 115000),
  ];
}

// Global singleton cart store
class CartStore {
  static final CartStore _instance = CartStore._internal();
  factory CartStore() => _instance;
  CartStore._internal();

  final List<CartItem> items = [];
  final List<Book> wishlist = [];

  void addToCart(Book book) {
    final existing = items.where((c) => c.book.id == book.id).toList();
    if (existing.isNotEmpty) {
      existing.first.quantity++;
    } else {
      items.add(CartItem(book: book));
    }
  }

  void removeFromCart(String id) => items.removeWhere((c) => c.book.id == id);
  void clearCart() => items.clear();

  void increment(String id) {
    final item = items.where((c) => c.book.id == id).toList();
    if (item.isNotEmpty) item.first.quantity++;
  }

  void decrement(String id) {
    final item = items.where((c) => c.book.id == id).toList();
    if (item.isNotEmpty) {
      if (item.first.quantity > 1) {
        item.first.quantity--;
      } else {
        removeFromCart(id);
      }
    }
  }

  bool isInWishlist(String id) => wishlist.any((b) => b.id == id);

  void toggleWishlist(Book book) {
    if (isInWishlist(book.id)) {
      wishlist.removeWhere((b) => b.id == book.id);
    } else {
      wishlist.add(book);
    }
  }

  double get subtotal => items.where((c) => c.isChecked).fold(0, (sum, c) => sum + c.totalPrice);
  int get checkedCount => items.where((c) => c.isChecked).length;
  int get totalItemCount => items.fold(0, (sum, c) => sum + c.quantity);
}
