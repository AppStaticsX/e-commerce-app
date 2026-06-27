import 'models/product.dart';

final List<Product> mockProducts = [
  const Product(
    id: '1',
    name: 'Modern Light Clothes',
    category: 'T-Shirt',
    gender: 'Men',
    price: 212.99,
    rating: 5.0,
    reviewsCount: 120,
    description:
        'A modern light t-shirt perfect for casual outings. Its simple and elegant shape makes it perfect for those of you who want minimalist clothes. Crafted from the finest, ethically-sourced cotton, this piece ensures maximum breathability and comfort throughout your day. The subtle stitching details add a touch of refined craftsmanship, while the relaxed fit allows for unrestricted movement. Whether you are heading out for a weekend brunch, relaxing at home, or running errands, this versatile top effortlessly adapts to your lifestyle, making it an indispensable addition to your everyday wardrobe.',
    imageUrl:
        'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    sizes: ['S', 'M', 'L', 'XL'],
    colors: [
      ProductColor(code: '#808080', name: 'Light Grey'),
      ProductColor(code: '#333333', name: 'Dark Grey'),
      ProductColor(code: '#000000', name: 'Black'),
    ],
  ),
  const Product(
    id: '2',
    name: 'Light Dress Bless',
    category: 'Dress modern',
    gender: 'Women',
    price: 162.99,
    oldPrice: 190.99,
    rating: 5.0,
    reviewsCount: 7932,
    description:
        'Its simple and elegant shape makes it perfect for those of you who like you who want minimalist clothes. Made from premium materials. This exquisite dress features a gently flowing silhouette that flatters any figure while providing an air of sophisticated grace. The lightweight fabric drapes beautifully, making it an ideal choice for warm weather events or elegant evening gatherings. With careful attention to detail, from the reinforced seams to the delicate hemline, it combines durability with high fashion, ensuring you look stunning and feel completely comfortable no matter the occasion.',
    imageUrl:
        'https://images.unsplash.com/photo-1539008835657-9e8e9680c956?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    sizes: ['S', 'M', 'L', 'XL'],
    colors: [
      ProductColor(code: '#808080', name: 'Light Grey'),
      ProductColor(code: '#333333', name: 'Dark Grey'),
      ProductColor(code: '#000000', name: 'Black'),
    ],
  ),
  const Product(
    id: '3',
    name: 'Elegant Black Shades',
    category: 'Accessories',
    gender: 'All',
    price: 89.99,
    rating: 4.8,
    reviewsCount: 450,
    description:
        'Stylish sunglasses for modern daily life. These elegant black shades are meticulously designed to provide both exceptional style and superior eye protection. Featuring polarized lenses that dramatically reduce glare and block harmful UV rays, they ensure your vision remains crystal clear even on the brightest days. The lightweight yet highly durable frame offers a comfortable fit for extended wear, effortlessly complementing any outfit. Perfect for driving, beach days, or simply adding a touch of mystery to your everyday look, these sunglasses are the ultimate accessory for the fashion-conscious.',
    imageUrl:
        'https://images.unsplash.com/photo-1511499767150-a48a237f0083?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
  ),
  const Product(
    id: '4',
    name: 'Casual Yellow Top',
    category: 'T-Shirt',
    gender: 'Women',
    price: 120.50,
    rating: 4.5,
    reviewsCount: 300,
    description:
        'Perfect for sunny days, comfortable and light. This vibrant casual yellow top brings a cheerful pop of color to your wardrobe, effortlessly brightening your mood and your outfit. Designed with a relaxed, breezy fit, it allows for optimal air circulation, keeping you cool during the hottest summer months. The premium blend fabric feels incredibly soft against the skin and resists wrinkling, ensuring you maintain a polished appearance all day long. Pair it with your favorite denim shorts, skirts, or tailored trousers for a versatile, stylish look that seamlessly transitions from day to night.',
    imageUrl:
        'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    sizes: ['S', 'M', 'L'],
  ),
  const Product(
    id: '5',
    name: 'Denim Classic Jacket',
    category: 'Jacket',
    gender: 'Men',
    price: 250.00,
    rating: 4.9,
    reviewsCount: 1500,
    description:
        'Classic denim jacket that never goes out of style. This wardrobe staple is expertly crafted from heavy-duty, high-quality denim that promises to withstand the test of time and only gets better with age. Featuring traditional metallic button closures, multiple functional pockets, and a timeless collar design, it delivers both rugged durability and effortless cool. The versatile medium wash pairs perfectly with virtually anything in your closet, making it the ultimate layering piece for chilly evenings, casual weekend outings, or adding a stylish edge to a simple dress or t-shirt ensemble.',
    imageUrl:
        'https://images.unsplash.com/photo-1523625926628-22f3e82b7db5?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    sizes: ['M', 'L', 'XL'],
  ),
];

final List<String> mockCategories = [
  'All Items',
  'T-Shirt',
  'Dress',
  'Pants',
  'Accessories',
  'Shocks',
];
