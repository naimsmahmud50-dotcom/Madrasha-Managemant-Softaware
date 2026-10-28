import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SyncStatus { idle, syncing, success, conflict, error }

class SyncState {
  final int pendingCount;
  final SyncStatus status;
  final String? lastError;
  final DateTime? lastSyncedAt;

  const SyncState({
    this.pendingCount = 0,
    this.status = SyncStatus.idle,
    this.lastError,
    this.lastSyncedAt,
  });

  SyncState copyWith({
    int? pendingCount,
    SyncStatus? status,
    String? lastError,
    DateTime? lastSyncedAt,
  }) {
    return SyncState(
      pendingCount: pendingCount ?? this.pendingCount,
      status: status ?? this.status,
      lastError: lastError,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    );
  }
}

class SyncNotifier extends Notifier<SyncState> {
  @override
  SyncState build() {
    return const SyncState();
  }

  void setPendingCount(int count) {
    state = state.copyWith(pendingCount: count);
  }

  void addPending() {
    state = state.copyWith(pendingCount: state.pendingCount + 1);
  }

  Future<void> syncNow() async {
    if (state.status == SyncStatus.syncing) return;

    state = state.copyWith(status: SyncStatus.syncing);
    debugPrint('[SyncEngine] Triggered manual outbox synchronization...');

    try {
      // Simulate network sync roundtrip to NestJS API
      await Future.delayed(const Duration(milliseconds: 600));

      state = state.copyWith(
        pendingCount: 0,
        status: SyncStatus.success,
        lastSyncedAt: DateTime.now(),
      );
      debugPrint('[SyncEngine] Outbox synced successfully.');
    } catch (e) {
      state = state.copyWith(
        status: SyncStatus.error,
        lastError: e.toString(),
      );
      debugPrint('[SyncEngine] Sync failed: $e');
    }
  }
}

final syncStateProvider = NotifierProvider<SyncNotifier, SyncState>(() {
  return SyncNotifier();
});

class SyncService {
  Future<void> markAttendanceOffline(String studentId, String status) async {
    debugPrint('Inserting offline attendance for $studentId -> LOCAL_ONLY');
  }

  Future<void> runSyncJob() async {
    debugPrint('Fetching pending records from Drift DB...');
  }
}

final syncServiceProvider = Provider((ref) => SyncService());
