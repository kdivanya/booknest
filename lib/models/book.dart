class Book {
  final String id;
  final String title;
  final String author;
  final double price;
  final double rating;
  final int reviewCount;
  final String coverEmoji;
  final int coverColorIndex;
  final String genre;
  final String synopsis;
  final bool isEbook;
  final bool isPhysical;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.coverEmoji,
    required this.coverColorIndex,
    required this.genre,
    required this.synopsis,
    this.isEbook = true,
    this.isPhysical = true,
  });
}

class DummyBooks {
  static const List<Book> trending = [
    Book(
      id: 't1',
      title: 'The Midnight Library',
      author: 'Matt Haig',
      price: 85000,
      rating: 4.8,
      reviewCount: 1200,
      coverEmoji: '📖',
      coverColorIndex: 0,
      genre: 'Fiction',
      synopsis:
          'Somewhere out of time, there is a library with infinite books. Each book offers a chance to try another version of your life. Between life and death, Nora Seed finds herself in this magical place.',
    ),
    Book(
      id: 't2',
      title: 'Deep Blue Ocean',
      author: 'S. Clearwater',
      price: 70000,
      rating: 4.5,
      reviewCount: 870,
      coverEmoji: '🌊',
      coverColorIndex: 1,
      genre: 'Adventure',
      synopsis:
          'A breathtaking journey across uncharted seas where one sailor discovers secrets buried beneath the waves for centuries.',
    ),
    Book(
      id: 't3',
      title: 'Green Therapy',
      author: 'A. Nature',
      price: 60000,
      rating: 4.7,
      reviewCount: 950,
      coverEmoji: '🌿',
      coverColorIndex: 2,
      genre: 'Self-Help',
      synopsis:
          'How spending time in nature can heal the mind, reduce stress, and unlock a calmer, more focused version of yourself.',
    ),
    Book(
      id: 't4',
      title: 'Sunrise Mind',
      author: 'L. Morning',
      price: 75000,
      rating: 4.6,
      reviewCount: 740,
      coverEmoji: '☀️',
      coverColorIndex: 3,
      genre: 'Self-Help',
      synopsis:
          'Start every morning with intention. This guide walks you through simple habits that transform your mindset before the day begins.',
    ),
    Book(
      id: 't5',
      title: 'Paper Stars',
      author: 'J. Origami',
      price: 55000,
      rating: 4.4,
      reviewCount: 620,
      coverEmoji: '⭐',
      coverColorIndex: 4,
      genre: 'Romance',
      synopsis:
          'Two strangers leave each other paper cranes in a library. As the notes grow longer, their worlds quietly collide.',
    ),
  ];

  static const List<Book> recommended = [
    Book(
      id: 'r1',
      title: 'Cozy Corner',
      author: 'M. Blanket',
      price: 65000,
      rating: 4.9,
      reviewCount: 1500,
      coverEmoji: '🧸',
      coverColorIndex: 4,
      genre: 'Fiction',
      synopsis:
          'A warm, gentle story about finding community in the most unexpected of places — a tiny bookshop at the end of the world.',
    ),
    Book(
      id: 'r2',
      title: 'The Last Letter',
      author: 'E. Prose',
      price: 80000,
      rating: 4.7,
      reviewCount: 1100,
      coverEmoji: '✉️',
      coverColorIndex: 1,
      genre: 'Romance',
      synopsis:
          'A box of unsent letters reveals a decades-long love story that will make you believe in second chances.',
    ),
    Book(
      id: 'r3',
      title: 'Mind Garden',
      author: 'P. Thought',
      price: 50000,
      rating: 4.5,
      reviewCount: 680,
      coverEmoji: '🧠',
      coverColorIndex: 5,
      genre: 'Self-Help',
      synopsis:
          'Prune your thoughts, plant better habits. A practical guide to mental clarity through mindful daily practices.',
    ),
  ];

  static const Map<String, List<Book>> byGenre = {
    'Romance': [
      Book(
        id: 'ro1',
        title: 'Love in Bloom',
        author: 'C. Rose',
        price: 72000,
        rating: 4.6,
        reviewCount: 890,
        coverEmoji: '💕',
        coverColorIndex: 4,
        genre: 'Romance',
        synopsis: 'A florist and an architect fall in love while restoring an old garden.',
      ),
      Book(
        id: 'ro2',
        title: 'Spring Letters',
        author: 'M. Petal',
        price: 68000,
        rating: 4.4,
        reviewCount: 560,
        coverEmoji: '🌸',
        coverColorIndex: 0,
        genre: 'Romance',
        synopsis: 'Letters written across seasons become the foundation of an unexpected love.',
      ),
      Book(
        id: 'ro3',
        title: 'Paper Stars',
        author: 'J. Origami',
        price: 55000,
        rating: 4.4,
        reviewCount: 620,
        coverEmoji: '⭐',
        coverColorIndex: 1,
        genre: 'Romance',
        synopsis: 'Two strangers leave each other paper cranes in a library.',
      ),
    ],
    'Thriller': [
      Book(
        id: 'th1',
        title: 'Dark Night Falls',
        author: 'R. Shadow',
        price: 90000,
        rating: 4.7,
        reviewCount: 1300,
        coverEmoji: '🔪',
        coverColorIndex: 5,
        genre: 'Thriller',
        synopsis: 'A detective is called to a remote island. No one leaves until the killer is found.',
      ),
      Book(
        id: 'th2',
        title: 'The Watcher',
        author: 'K. Eyes',
        price: 85000,
        rating: 4.5,
        reviewCount: 970,
        coverEmoji: '👁️',
        coverColorIndex: 1,
        genre: 'Thriller',
        synopsis: 'She knows someone is watching. But she never imagined it would lead here.',
      ),
      Book(
        id: 'th3',
        title: 'Vanished at Dawn',
        author: 'P. Mystery',
        price: 78000,
        rating: 4.3,
        reviewCount: 740,
        coverEmoji: '🌫️',
        coverColorIndex: 5,
        genre: 'Thriller',
        synopsis: 'A small town. A missing girl. And a truth nobody wants to uncover.',
      ),
    ],
    'Self-Help': [
      Book(
        id: 'sh1',
        title: 'Green Therapy',
        author: 'A. Nature',
        price: 60000,
        rating: 4.7,
        reviewCount: 950,
        coverEmoji: '🌿',
        coverColorIndex: 2,
        genre: 'Self-Help',
        synopsis: 'How spending time in nature can heal the mind and reduce stress.',
      ),
      Book(
        id: 'sh2',
        title: 'Sunrise Mind',
        author: 'L. Morning',
        price: 75000,
        rating: 4.6,
        reviewCount: 740,
        coverEmoji: '☀️',
        coverColorIndex: 3,
        genre: 'Self-Help',
        synopsis: 'Simple morning habits that transform your mindset before the day begins.',
      ),
      Book(
        id: 'sh3',
        title: 'Mind Garden',
        author: 'P. Thought',
        price: 50000,
        rating: 4.5,
        reviewCount: 680,
        coverEmoji: '🧠',
        coverColorIndex: 5,
        genre: 'Self-Help',
        synopsis: 'A practical guide to mental clarity through mindful daily practices.',
      ),
    ],
    'Fiction': [
      Book(
        id: 'fi1',
        title: 'The Midnight Library',
        author: 'Matt Haig',
        price: 85000,
        rating: 4.8,
        reviewCount: 1200,
        coverEmoji: '📖',
        coverColorIndex: 0,
        genre: 'Fiction',
        synopsis: 'Between life and death, Nora Seed finds herself in a magical library with infinite books.',
      ),
      Book(
        id: 'fi2',
        title: 'Cozy Corner',
        author: 'M. Blanket',
        price: 65000,
        rating: 4.9,
        reviewCount: 1500,
        coverEmoji: '🧸',
        coverColorIndex: 4,
        genre: 'Fiction',
        synopsis: 'A warm story about finding community in a tiny bookshop at the end of the world.',
      ),
    ],
  };
}