import 'package:flutter_riverpod/flutter_riverpod.dart';

enum MadrasahType { qawmi, alia, both }

class MadrasahTypeNotifier extends Notifier<MadrasahType> {
  @override
  MadrasahType build() {
    return MadrasahType.both;
  }

  void setType(MadrasahType type) {
    state = type;
  }
}

final madrasahTypeProvider = NotifierProvider<MadrasahTypeNotifier, MadrasahType>(() {
  return MadrasahTypeNotifier();
});

