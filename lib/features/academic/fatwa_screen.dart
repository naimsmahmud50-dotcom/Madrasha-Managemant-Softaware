import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import '../../core/widgets/bounce_wrapper.dart';

class FatwaScreen extends StatefulWidget {
  const FatwaScreen({super.key});

  @override
  State<FatwaScreen> createState() => _FatwaScreenState();
}

class _FatwaScreenState extends State<FatwaScreen> {
  final List<Map<String, dynamic>> _fatwas = [
    {
      'question': 'What is the Nisab for Zakat on Gold and Silver this year?',
      'answer': 'The Nisab for gold is 87.48 grams (7.5 tolas) and for silver is 612.36 grams (52.5 tolas). If someone possesses this amount or its equivalent in cash/business assets for a full lunar year, 2.5% Zakat becomes obligatory.',
      'mufti': 'Mufti Tariq Jameel',
      'date': '20 Shaban, 1447',
      'category': 'Zakat',
      'isExpanded': false,
    },
    {
      'question': 'Can I pay my Fidya for missed fasts to build a mosque?',
      'answer': 'No. Fidya must be given to the poor and needy (eligible for Zakat). Building a mosque is considered Sadaqah Jariyah and cannot be funded using Fidya or Zakat money.',
      'mufti': 'Mufti Abdur Rahman',
      'date': '18 Shaban, 1447',
      'category': 'Sawm (Fasting)',
      'isExpanded': false,
    },
    {
      'question': 'Is it permissible to trade in Cryptocurrencies?',
      'answer': 'This is a contemporary issue with varying opinions. The majority of our Darul Ifta board advises caution. It is permissible if the specific coin has intrinsic utility and does not involve interest (Riba) or excessive uncertainty (Gharar). However, speculative day-trading is prohibited.',
      'mufti': 'Mufti Khalid Saifullah',
      'date': '10 Shaban, 1447',
      'category': 'Finance',
      'isExpanded': false,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('Darul Ifta (Fatwa)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        backgroundColor: Color(0xFF0F766E), // Teal 700
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(icon: Icon(Icons.search_rounded), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _fatwas.length,
              itemBuilder: (context, index) {
                return _buildFatwaCard(index);
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: Color(0xFF0F766E),
        icon: Icon(Icons.help_outline_rounded, color: Colors.white),
        label: Text('Ask a Question', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Color(0xFF0F766E),
      padding: EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Shariah Guidelines & Rulings', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Search from hundreds of answered queries or submit your own question to our panel of Muftis.', style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
          SizedBox(height: 20),
          // Categories
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildChip('All', true),
                _buildChip('Zakat', false),
                _buildChip('Sawm (Fasting)', false),
                _buildChip('Finance', false),
                _buildChip('Family', false),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildChip(String label, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? Colors.white : Colors.transparent),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Color(0xFF0F766E) : Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildFatwaCard(int index) {
    final fatwa = _fatwas[index];
    final isExpanded = fatwa['isExpanded'];

    return BounceWrapper(
      onTap: () {
        setState(() {
          _fatwas[index]['isExpanded'] = !isExpanded;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: Offset(0, 4))],
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
                    child: Text('Q', style: TextStyle(color: Color(0xFF16A34A), fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(fatwa['question'], style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary, height: 1.4)),
                  ),
                  SizedBox(width: 8),
                  Icon(isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded, color: Colors.grey.shade500),
                ],
              ),
            ),
            if (isExpanded) ...[
              Divider(height: 1, color: Colors.grey.shade100),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8)),
                          child: Text('A', style: TextStyle(color: Color(0xFF0F766E), fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(fatwa['answer'], style: TextStyle(fontSize: 14, color: Color(0xFF475569), height: 1.6)),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(Icons.verified_rounded, size: 16, color: Color(0xFF0F766E)),
                        SizedBox(width: 8),
                        Text('Answered by ${fatwa['mufti']}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F766E))),
                        Spacer(),
                        Text(fatwa['date'], style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                      ],
                    )
                  ],
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}

