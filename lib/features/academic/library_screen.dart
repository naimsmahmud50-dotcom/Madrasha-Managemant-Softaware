import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import '../../core/widgets/bounce_wrapper.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  int _selectedCategoryIndex = 0;
  final List<String> _categories = ['All Books', 'Tafseer', 'Hadith', 'Fiqh', 'Seerah', 'Aqeedah'];

  final List<Map<String, dynamic>> _books = [
    {'title': 'Tafseer Ibn Kathir', 'author': 'Imam Ibn Kathir', 'category': 'Tafseer', 'color': Colors.green.shade600},
    {'title': 'Sahih Al-Bukhari', 'author': 'Imam Bukhari', 'category': 'Hadith', 'color': Color(0xFF0EA5E9)},
    {'title': 'Al-Hidayah (Fiqh)', 'author': 'Burhan al-Din al-Marghinani', 'category': 'Fiqh', 'color': AppTheme.primaryBrand},
    {'title': 'Ar-Raheeq Al-Makhtum', 'author': 'Safiur Rahman Mubarakpuri', 'category': 'Seerah', 'color': Colors.orange.shade500},
    {'title': 'Kitab At-Tawheed', 'author': 'Muhammad bin Abdul Wahhab', 'category': 'Aqeedah', 'color': Colors.blue.shade600},
    {'title': 'Riyad as-Salihin', 'author': 'Imam Nawawi', 'category': 'Hadith', 'color': Color(0xFF0EA5E9)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50, // Very soft green reading theme
      appBar: AppBar(
        title: const Text('Maktabah (E-Library)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.green.shade900, // Deep Emerald
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(icon: const Icon(Icons.search_rounded), onPressed: () {}),
          IconButton(icon: const Icon(Icons.bookmark_rounded), onPressed: () {}),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryBar(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text('Recommended Reading', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green.shade900)),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.65,
              ),
              itemCount: _books.length,
              itemBuilder: (context, index) {
                final book = _books[index];
                return _buildBookCard(book);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBar() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          bool isSelected = _selectedCategoryIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategoryIndex = index),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? Colors.green.shade900 : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: isSelected ? Colors.green.shade900 : Colors.grey.shade300),
                boxShadow: isSelected ? [BoxShadow(color: Colors.green.shade900.withValues(alpha: 0.3), blurRadius: 8, offset: Offset(0, 4))] : null,
              ),
              child: Text(
                _categories[index],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBookCard(Map<String, dynamic> book) {
    Color themeColor = book['color'];
    return BounceWrapper(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [themeColor, themeColor.withValues(alpha: 0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                ),
                child: Center(
                  child: Icon(Icons.menu_book_rounded, size: 50, color: Colors.white.withValues(alpha: 0.8)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: themeColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                    child: Text(book['category'], style: TextStyle(color: themeColor, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),
                  Text(book['title'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textPrimary), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(book['author'], style: TextStyle(fontSize: 11, color: Colors.grey.shade600), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

