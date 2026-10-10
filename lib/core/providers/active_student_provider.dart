import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActiveStudentNotifier extends Notifier<Map<String, dynamic>?> {
  @override
  Map<String, dynamic>? build() {
    return null;
  }

  void setStudent(Map<String, dynamic> student) {
    state = student;
  }
}

final activeStudentProvider = NotifierProvider<ActiveStudentNotifier, Map<String, dynamic>?>(() {
  return ActiveStudentNotifier();
});

