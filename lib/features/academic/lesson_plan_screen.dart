import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class LessonPlanScreen extends StatefulWidget {
  const LessonPlanScreen({super.key});

  @override
  State<LessonPlanScreen> createState() => _LessonPlanScreenState();
}

class _LessonPlanScreenState extends State<LessonPlanScreen> {
  // Mock Data
  final Map<String, dynamic> _courseData = {
    'subject': 'Arabic Grammar (Nahw)',
    'class': 'Class 8 (Mutawassitah)',
    'progress': 0.65,
    'chapters': [
      {
        'title': 'Chapter 1: Kalimah & its Types',
        'status': 'COMPLETED',
        'topics': ['Ism (Noun)', 'Fi\'l (Verb)', 'Harf (Particle)'],
        'completedTopics': 3,
      },
      {
        'title': 'Chapter 2: Murakkab (Compounds)',
        'status': 'IN_PROGRESS',
        'topics': ['Murakkab Naqis', 'Murakkab Taam', 'Jumla Ismiyyah', 'Jumla Fi\'liyyah'],
        'completedTopics': 2,
      },
      {
        'title': 'Chapter 3: Mabni and Mu\'rab',
        'status': 'PENDING',
        'topics': ['Definition of Mabni', 'Definition of Mu\'rab', 'Types of Mu\'rab'],
        'completedTopics': 0,
      },
      {
        'title': 'Chapter 4: Marfoo\'aat',
        'status': 'PENDING',
        'topics': ['Faa\'il (Subject)', 'Naa\'ib Faa\'il', 'Mubtada & Khabar'],
        'completedTopics': 0,
      },
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Slate 50
      appBar: AppBar(
        title: const Text('Syllabus & Lesson Plan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        backgroundColor: const Color(0xFF1E40AF), // Blue 800
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildHeader(),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final chapter = _courseData['chapters'][index];
                  return _buildChapterTimelineNode(chapter, index, index == _courseData['chapters'].length - 1);
                },
                childCount: _courseData['chapters'].length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF1E40AF), // Blue 800
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
      ),
      child: Column(
        children: [
          Text(_courseData['subject'], style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
            child: Text(_courseData['class'], style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: _courseData['progress'],
                      strokeWidth: 8,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF34D399)), // Emerald 400
                    ),
                    Center(
                      child: Text(
                        '${(_courseData['progress'] * 100).toInt()}%',
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatRow(Icons.check_circle_rounded, const Color(0xFF34D399), 'Completed', '1 Chapter'),
                  const SizedBox(height: 12),
                  _buildStatRow(Icons.sync_rounded, const Color(0xFFFBBF24), 'In Progress', '1 Chapter'),
                  const SizedBox(height: 12),
                  _buildStatRow(Icons.pending_rounded, Colors.white54, 'Pending', '2 Chapters'),
                ],
              )
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildStatRow(IconData icon, Color color, String label, String count) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
            Text(count, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        )
      ],
    );
  }

  Widget _buildChapterTimelineNode(Map<String, dynamic> chapter, int index, bool isLast) {
    Color statusColor;
    IconData statusIcon;
    switch (chapter['status']) {
      case 'COMPLETED':
        statusColor = Colors.green.shade600; // Emerald 500
        statusIcon = Icons.check_circle_rounded;
        break;
      case 'IN_PROGRESS':
        statusColor = Colors.orange.shade500; // Amber 500
        statusIcon = Icons.sync_rounded;
        break;
      default:
        statusColor = Colors.grey.shade500; // Slate 400
        statusIcon = Icons.radio_button_unchecked_rounded;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Container(
          margin: const EdgeInsets.only(top: 16),
          width: 40,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(statusIcon, color: statusColor, size: 24),
          ),
        ),
        const SizedBox(width: 12),
        // Content Card
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: _buildChapterCard(chapter, statusColor),
          ),
        ),
      ],
    );
  }

  Widget _buildChapterCard(Map<String, dynamic> chapter, Color statusColor) {
    List<String> topics = List<String>.from(chapter['topics']);
    int completedTopics = chapter['completedTopics'];
    double progress = topics.isNotEmpty ? completedTopics / topics.length : 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: statusColor,
          collapsedIconColor: Colors.grey.shade400,
          title: Text(chapter['title'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textPrimary)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: statusColor.withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('$completedTopics/${topics.length}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: statusColor)),
                ],
              ),
            ],
          ),
          children: [
            Container(
              color: Colors.grey.shade50,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: List.generate(topics.length, (index) {
                  bool isTopicCompleted = index < completedTopics;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Icon(
                          isTopicCompleted ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                          color: isTopicCompleted ? statusColor : Colors.grey.shade400,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            topics[index],
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isTopicCompleted ? FontWeight.bold : FontWeight.w500,
                              color: isTopicCompleted ? AppTheme.textPrimary : Colors.grey.shade600,
                              decoration: isTopicCompleted ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            if (chapter['status'] == 'IN_PROGRESS')
              Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E40AF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Update Progress'),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

