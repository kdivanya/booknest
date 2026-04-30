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
      tags: ['Bestseller', 'Philosophical', 'Time Travel', 'Mental Health'], isOnSale: true),
  Book(id: '2', title: 'Stellar Echoes', author: 'Elena Rigby', genre: 'Fiction',
      price: 89000, rating: 4.8, reviewCount: 94,
      synopsis: 'A sweeping science fiction saga about humanity\'s first contact with an alien civilization hidden in the echoes of dying stars.',
      pages: 428, tags: ['Sci-fi', 'Space', 'Adventure']),
  Book(id: '3', title: 'Quiet Minds', author: 'Marcus Aurelius', genre: 'Self-help',
      price: 115000, rating: 4.9, reviewCount: 210,
      synopsis: 'A modern guide to stoic philosophy and mindfulness, drawing on ancient wisdom to navigate the noise of contemporary life.',
      pages: 256, tags: ['Philosophy', 'Mindfulness', 'Stoicism']),
  Book(id: '4', title: 'The Hidden Garden', author: 'T.S. Elliott', genre: 'Fiction',
      price: 142000, rating: 4.6, reviewCount: 87,
      synopsis: 'A magical realist tale about a woman who discovers a hidden garden that reflects the emotional landscape of all who enter it.',
      format: 'Physical', pages: 380, tags: ['Magical Realism', 'Nature', 'Mystery']),
  Book(id: '5', title: 'Atomic Habits', author: 'James Clear', genre: 'Non-fiction',
      price: 180000, rating: 4.9, reviewCount: 3200,
      synopsis: 'A proven framework for building good habits and breaking bad ones. Learn how tiny changes lead to remarkable results.',
      pages: 320, tags: ['Habits', 'Productivity', 'Self-improvement']),
  Book(id: '6', title: 'Alchemist', author: 'Paulo Coelho', genre: 'Fiction',
      price: 95000, rating: 4.7, reviewCount: 5100,
      synopsis: 'A young Andalusian shepherd embarks on a journey to the Egyptian pyramids after having a recurring dream of finding a treasure there.',
      pages: 208, tags: ['Inspirational', 'Adventure', 'Philosophy']),
  Book(id: '7', title: 'The Great Gatsby', author: 'F. Scott Fitzgerald', genre: 'Fiction',
      price: 125000, rating: 4.8, reviewCount: 2400,
      synopsis: 'Set in the Jazz Age on Long Island, the novel depicts narrator Nick Carraway\'s interactions with mysterious millionaire Jay Gatsby.',
      format: 'Physical', pages: 180, tags: ['Classic', 'American Literature', 'Drama']),
  Book(id: '8', title: '1984', author: 'George Orwell', genre: 'Fiction',
      price: 110000, rating: 4.9, reviewCount: 6700,
      synopsis: 'A dystopian social science fiction novel and cautionary tale about the dangers of totalitarianism.',
      format: 'Physical', pages: 328, tags: ['Dystopia', 'Classic', 'Political'], isSoldOut: true),
  Book(id: '9', title: 'Pride and Prejudice', author: 'Jane Austen', genre: 'Fiction',
      price: 145000, rating: 4.7, reviewCount: 4300,
      synopsis: 'A romantic novel of manners that follows the character development of Elizabeth Bennet, the dynamic protagonist.',
      pages: 432, tags: ['Classic', 'Romance', 'Literature']),
  Book(id: '10', title: 'Little Women', author: 'Louisa May Alcott', genre: 'Fiction',
      price: 160000, rating: 4.9, reviewCount: 3800,
      synopsis: 'Following the lives of the four March sisters—Meg, Jo, Beth, and Amy—detailing their passage from childhood to womanhood.',
      format: 'Physical', pages: 449, tags: ['Classic', 'Coming-of-age', 'Family']),
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