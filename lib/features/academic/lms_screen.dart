import '../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class LmsScreen extends StatefulWidget {
  final String role;
  const LmsScreen({super.key, required this.role});

  @override
  State<LmsScreen> createState() => _LmsScreenState();
}

class _LmsScreenState extends State<LmsScreen> {
  String _selectedClass = 'Class 8';
  String _selectedType = 'All'; // All, PDF, Video, Link
  final List<String> _classes = ['Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10'];
  final List<String> _types = ['All', 'PDF', 'Video', 'Link'];

  void _showUploadSheet() {
    String title = '';
    String subject = '';
    String type = 'PDF';
    String link = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 24, right: 24, top: 24,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)))),
                    const SizedBox(height: 24),
                    Text('Upload Study Material', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryBrand)),
                    const SizedBox(height: 16),
                    
                    TextField(
                      decoration: const InputDecoration(labelText: 'Material Title', hintText: 'e.g. Nahw Syntax Notes', border: OutlineInputBorder()),
                      onChanged: (val) => title = val,
                    ),
                    const SizedBox(height: 12),
                    
                    TextField(
                      decoration: const InputDecoration(labelText: 'Subject', hintText: 'e.g. Arabic Grammar', border: OutlineInputBorder()),
                      onChanged: (val) => subject = val,
                    ),
                    const SizedBox(height: 12),
                    
                    DropdownButtonFormField<String>(
                      initialValue: type,
                      decoration: const InputDecoration(labelText: 'Material Type', border: OutlineInputBorder()),
                      items: ['PDF', 'Video', 'Link'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (val) => setSheetState(() => type = val!),
                    ),
                    const SizedBox(height: 12),
                    
                    TextField(
                      decoration: InputDecoration(
                        labelText: type == 'PDF' ? 'PDF URL (Drive/Storage)' : (type == 'Video' ? 'Video URL (YouTube)' : 'Website URL'),
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (val) => link = val,
                    ),
                    
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4338CA), // Indigo theme
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {
                          if (title.isEmpty || subject.isEmpty || link.isEmpty) return;

                          await FirebaseFirestore.instance.collection('study_materials').add({
                            'sClass': _selectedClass,
                            'title': title,
                            'subject': subject,
                            'type': type,
                            'link': link,
                            'uploadedBy': widget.role,
                            'createdAt': FieldValue.serverTimestamp(),
                          });
                          
                          if (context.mounted) Navigator.pop(context);
                        },
                        child: const Text('Upload Material', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open link')));
      }
    }
  }

  void _deleteMaterial(String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Material'),
        content: const Text('Are you sure you want to delete this study material?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              FirebaseFirestore.instance.collection('study_materials').doc(docId).delete();
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAdminOrTeacher = widget.role == 'Admin' || widget.role == 'Teacher';

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Digital Classroom', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF4338CA), // Indigo theme for learning
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Filter Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF4338CA),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedClass,
                      isExpanded: true,
                      dropdownColor: const Color(0xFF312E81),
                      icon: const Icon(Icons.arrow_drop_down_rounded, color: Colors.white),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      items: _classes.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (val) => setState(() => _selectedClass = val!),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Type Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _types.map((type) {
                      final isSelected = _selectedType == type;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(type, style: TextStyle(color: isSelected ? const Color(0xFF4338CA) : Colors.white, fontWeight: FontWeight.bold)),
                          selected: isSelected,
                          selectedColor: Colors.white,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          side: BorderSide.none,
                          onSelected: (val) {
                            if (val) setState(() => _selectedType = type);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('study_materials').orderBy('createdAt', descending: true).limit(30).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF4338CA)));
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                
                final allDocs = snapshot.data?.docs ?? [];
                
                // Client-side filtering to avoid Composite Index errors
                final filteredDocs = allDocs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final matchClass = data['sClass'] == _selectedClass;
                  final matchType = _selectedType == 'All' || data['type'] == _selectedType;
                  return matchClass && matchType;
                }).toList();

                if (filteredDocs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.folder_off_rounded, size: 80, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text('No materials found for $_selectedClass', style: const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    final data = filteredDocs[index].data() as Map<String, dynamic>;
                    return _buildMaterialCard(filteredDocs[index].id, data, isAdminOrTeacher);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: isAdminOrTeacher
          ? FloatingActionButton.extended(
              onPressed: _showUploadSheet,
              backgroundColor: const Color(0xFF4338CA),
              icon: const Icon(Icons.cloud_upload_rounded, color: Colors.white),
              label: const Text('Upload', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          : null,
    );
  }

  Widget _buildMaterialCard(String docId, Map<String, dynamic> data, bool isAdminOrTeacher) {
    final title = data['title'] ?? 'Untitled';
    final subject = data['subject'] ?? 'General';
    final type = data['type'] ?? 'Link';
    final link = data['link'] ?? '';

    IconData typeIcon;
    Color iconColor;
    String actionText;

    switch (type) {
      case 'PDF':
        typeIcon = Icons.picture_as_pdf_rounded;
        iconColor = Colors.red.shade600; // Red
        actionText = 'View PDF';
        break;
      case 'Video':
        typeIcon = Icons.play_circle_fill_rounded;
        iconColor = Colors.blue.shade700; // Blue
        actionText = 'Watch Video';
        break;
      case 'Link':
      default:
        typeIcon = Icons.link_rounded;
        iconColor = AppTheme.primaryBrand; // Teal
        actionText = 'Open Link';
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(typeIcon, color: iconColor, size: 28),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryBrand)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(subject, style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500)),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: iconColor.withValues(alpha: 0.1),
                foregroundColor: iconColor,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => _launchUrl(link),
              child: Text(actionText, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
            if (isAdminOrTeacher)
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                onPressed: () => _deleteMaterial(docId),
                tooltip: 'Delete',
              ),
          ],
        ),
      ),
    );
  }
}

