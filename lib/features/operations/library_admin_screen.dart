import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class LibraryAdminScreen extends StatefulWidget {
  const LibraryAdminScreen({super.key});

  @override
  State<LibraryAdminScreen> createState() => _LibraryAdminScreenState();
}

class _LibraryAdminScreenState extends State<LibraryAdminScreen> {
  final List<Map<String, dynamic>> _issuedBooks = [
    {
      'studentName': 'Abdullah Al Noman',
      'class': 'Class 8',
      'bookName': 'Tafseer Ibn Kathir (Vol 1)',
      'issueDate': '15 Shaban',
      'dueDate': '25 Shaban',
      'status': 'Overdue',
      'color': Colors.red.shade500
    },
    {
      'studentName': 'Abdur Rahman',
      'class': 'Hifz',
      'bookName': 'Riyad as-Salihin',
      'issueDate': '20 Shaban',
      'dueDate': '30 Shaban',
      'status': 'Issued',
      'color': Colors.blue.shade600
    },
    {
      'studentName': 'Hasan Mahmud',
      'class': 'Dawra-e-Hadith',
      'bookName': 'Sahih Al-Bukhari (Vol 3)',
      'issueDate': '18 Shaban',
      'dueDate': '28 Shaban',
      'status': 'Issued',
      'color': Colors.blue.shade600
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Library Admin', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        backgroundColor: AppTheme.primaryBrand, // Teal 600
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(icon: const Icon(Icons.qr_code_scanner_rounded), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _issuedBooks.length,
              itemBuilder: (context, index) {
                return _buildIssueCard(_issuedBooks[index]);
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppTheme.primaryBrand,
        icon: const Icon(Icons.menu_book_rounded, color: Colors.white),
        label: const Text('Issue Book', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: AppTheme.primaryBrand,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _buildStat('Total Books', '4,520')),
              Container(width: 1, height: 30, color: Colors.white24),
              Expanded(child: _buildStat('Issued', '142')),
              Container(width: 1, height: 30, color: Colors.white24),
              Expanded(child: _buildStat('Overdue', '15')),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search by Student or Book ID...',
                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 14),
                    prefixIcon: Icon(Icons.search_rounded, color: Colors.white.withValues(alpha: 0.8)),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.15),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStat(String title, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildIssueCard(Map<String, dynamic> book) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.person_rounded, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 6),
                  Text(book['studentName'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textPrimary)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: book['color'].withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(book['status'], style: TextStyle(color: book['color'], fontWeight: FontWeight.bold, fontSize: 10)),
              )
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 22),
            child: Text(book['class'], style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Icon(Icons.menu_book_rounded, color: AppTheme.primaryBrand, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(book['bookName'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF334155))),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text('Issued: ${book['issueDate']}', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                          const Spacer(),
                          Text('Due: ${book['dueDate']}', style: TextStyle(fontSize: 11, color: Colors.red.shade500, fontWeight: FontWeight.bold)),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}



