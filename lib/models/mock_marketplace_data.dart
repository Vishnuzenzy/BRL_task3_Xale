class MockListing {
  final String title;
  final String price;
  final String description;
  final String imageUrl;
  final String category;
  final String sellerName;
  final String sellerId;

  const MockListing({
    required this.title,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.category,
    this.sellerName = 'Verified AKGEC Student',
    this.sellerId = 'mock_seller',
  });
}

const List<Map<String, String>> kCategories = [
  {
    'name': 'All',
    'img': 'https://images.unsplash.com/photo-1472851294608-062f824d29cc?auto=format&fit=crop&w=300&q=80', // Shopping/Store image
  },
  {
    'name': 'Watches',
    'img': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=300&q=80', // Watch image
  },
  {
    'name': 'Mobiles',
    'img': 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=300&q=80',
  },
  {
    'name': 'Bikes',
    'img': 'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?auto=format&fit=crop&w=300&q=80',
  },
  {
    'name': 'Laptops',
    'img': 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=300&q=80',
  },
  {
    'name': 'Books',
    'img': 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&w=300&q=80',
  },
  {
    'name': 'Audio',
    'img': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=300&q=80',
  },
  {
    'name': 'Furniture',
    'img': 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=300&q=80',
  },
];

const List<MockListing> kFeaturedSpotlight = [
  MockListing(
    title: 'Boat Airdopes Pro',
    price: '1,000',
    category: 'Audio',
    imageUrl: 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?auto=format&fit=crop&w=600&q=80',
    description: 'Active Noise Cancellation (ANC), 42 hours battery backup. Original box & cable available.',
  ),
  MockListing(
    title: 'Noise ColorFit Pulse 2',
    price: '1,200',
    category: 'Watches',
    imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=600&q=80',
    description: '1.8-inch display, Bluetooth calling, heart rate & SpO2 tracking. Extra silicone strap free.',
  ),
  MockListing(
    title: 'Casio FX-991EX Calc',
    price: '650',
    category: 'Books',
    imageUrl: 'https://images.unsplash.com/photo-1587145820266-a5951ee6f620?auto=format&fit=crop&w=600&q=80',
    description: 'Original scientific calculator allowed in semester exams. Working 100%.',
  ),
  MockListing(
    title: 'Hero Sprint Cycle',
    price: '3,200',
    category: 'Bikes',
    imageUrl: 'https://images.unsplash.com/photo-1485965120184-e220f721d03e?auto=format&fit=crop&w=600&q=80',
    description: '21-Speed geared cycle with dual disc brakes. Smooth tyres, number lock included.',
  ),
];

const List<MockListing> kCategoryMockItems = [
  // WATCHES
  MockListing(
    title: 'Noise ColorFit Pro 4 Max',
    price: '1,500',
    category: 'Watches',
    imageUrl: 'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=600&q=80',
    description: 'BT Calling, metallic finish, 7 days battery. Perfect condition, used only 2 months.',
  ),
  MockListing(
    title: 'boAt Wave Call Smartwatch',
    price: '900',
    category: 'Watches',
    imageUrl: 'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=600&q=80',
    description: 'HD curved display, 150+ watch faces, IP68 water resistant. Bill & magnetic charger available.',
  ),
  // MOBILES
  MockListing(
    title: 'iPhone 13 (128GB, Midnight)',
    price: '34,500',
    category: 'Mobiles',
    imageUrl: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=600&q=80',
    description: '88% battery health, original box and bill available. Hand-to-hand deal near campus canteen.',
  ),
  MockListing(
    title: 'Samsung Galaxy S21 FE 5G',
    price: '17,500',
    category: 'Mobiles',
    imageUrl: 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=600&q=80',
    description: '8GB/128GB Snapdragon 888, 120Hz AMOLED. Comes with 25W original charger.',
  ),
  // BIKES
  MockListing(
    title: 'Hero Sprint Pro Geared Cycle',
    price: '3,200',
    category: 'Bikes',
    imageUrl: 'https://images.unsplash.com/photo-1485965120184-e220f721d03e?auto=format&fit=crop&w=600&q=80',
    description: 'Dual disc brakes, front suspension working smoothly. Best for campus rounds.',
  ),
  MockListing(
    title: 'Btwin MyBike Hybrid Cycle',
    price: '2,600',
    category: 'Bikes',
    imageUrl: 'https://images.unsplash.com/photo-1532298229144-0ec0c57515c7?auto=format&fit=crop&w=600&q=80',
    description: 'Decathlon Btwin cycle in mint condition. Lightweight steel frame, low maintenance.',
  ),
  // LAPTOPS
  MockListing(
    title: 'HP Pavilion Gaming (Ryzen 5)',
    price: '38,000',
    category: 'Laptops',
    imageUrl: 'https://images.unsplash.com/photo-1603302576837-37561b2e2302?auto=format&fit=crop&w=600&q=80',
    description: '16GB RAM, 512GB SSD, GTX 1650 4GB Graphics. Runs Android Studio effortlessly.',
  ),
  MockListing(
    title: 'Dell Inspiron 15 (i5 11th Gen)',
    price: '26,500',
    category: 'Laptops',
    imageUrl: 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=600&q=80',
    description: 'Coding laptop with 8GB RAM, 512GB SSD. Backlit keyboard, 5+ hours battery backup.',
  ),
  // BOOKS
  MockListing(
    title: 'B.Tech CSE/AIML 2nd Year Combo',
    price: '450',
    category: 'Books',
    imageUrl: 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&w=600&q=80',
    description: 'Full set of 2nd Year books + Quantum guides. Clean condition.',
  ),
  // AUDIO
  MockListing(
    title: 'Sony WH-CH520 Headphones',
    price: '2,400',
    category: 'Audio',
    imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=600&q=80',
    description: '50 hours battery life, multipoint Bluetooth connection.',
  ),
  // FURNITURE
  MockListing(
    title: 'Foldable Wooden Laptop Bed Table',
    price: '350',
    category: 'Furniture',
    imageUrl: 'https://images.unsplash.com/photo-1518455027359-f3f8164ba6bd?auto=format&fit=crop&w=600&q=80',
    description: 'Sturdy wooden table with cup holder and tablet slot.',
  ),
];