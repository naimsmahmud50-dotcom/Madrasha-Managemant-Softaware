import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// PHASE 1 REQUIREMENT: Sync State Flow (Outbox Pattern)
// 1. Teacher marks attendance offline -> Status: LOCAL_ONLY
// 2. Network detected -> Move to Outbox Queue -> Status: PENDING -> SYNCING
// 3. API Request to POST /api/v1/attendance/sync with syncId
// 4. Server performs Idempotency Check:
//    - If already processed -> Returns 200 OK -> Local Status: SYNCED
//    - If conflict exists -> Returns 409 Conflict -> Local Status: CONFLICT
//    - On success -> Local Status: SYNCED

class SyncService {
  // Dependency injected database and network client would go here
  
  Future<void> markAttendanceOffline(String studentId, String status) async {
    // 1. Insert into Drift DB with status = LOCAL_ONLY
    debugPrint('Inserting offline attendance for $studentId -> LOCAL_ONLY');
  }

  Future<void> runSyncJob() async {
    // 2. Fetch all LOCAL_ONLY and PENDING records
    debugPrint('Fetching pending records from Drift DB...');
    
    // 3. Mark them as SYNCING in DB
    debugPrint('Updating DB status to SYNCING...');

    try {
      // 4. API Request to backend
      debugPrint('POST /api/v1/attendance/sync');
      
      // 5. On success, mark as SYNCED
      debugPrint('Response 200 OK: Marking as SYNCED in DB');
    } catch (e) {
      // 6. Handle Conflict (409) or other errors
      debugPrint('Response 409 Conflict: Marking as CONFLICT in DB');
    }
  }
}

// Provide the sync service across the app
final syncServiceProvider = Provider((ref) => SyncService());


