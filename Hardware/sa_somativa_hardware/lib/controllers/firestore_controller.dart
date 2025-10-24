import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sa_somativa_hardware/models/clock_record.dart';
import 'package:sa_somativa_hardware/models/workplace.dart';
import 'package:intl/intl.dart';

class FirestoreController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<void> saveClockRecord(ClockRecord record) async {
    if (currentUser == null) return;
    await _db.collection('clock_records').add(record.toMap());
  }

  Future<ClockRecord?> getLastClockRecordToday() async {
    if (currentUser == null) return null;

    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    QuerySnapshot snapshot = await _db
        .collection('clock_records')
        .where('userId', isEqualTo: currentUser!.uid)
        .where('date', isEqualTo: today)
        .orderBy('time', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return ClockRecord.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
    }
    return null;
  }

  Stream<List<ClockRecord>> getClockRecords() {
    if (currentUser == null) return Stream.value([]);

    return _db
        .collection('clock_records')
        .where('userId', isEqualTo: currentUser!.uid)
        .orderBy('date', descending: true)
        .orderBy('time', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ClockRecord.fromMap(doc.data())).toList());
  }

  Future<void> saveWorkplace(Workplace workplace) async {
    if (currentUser == null) return;
    await _db.collection('workplaces').doc(currentUser!.uid).set(workplace.toMap());
  }

  Future<Workplace?> getWorkplace() async {
    if (currentUser == null) return null;

    DocumentSnapshot snapshot = await _db.collection('workplaces').doc(currentUser!.uid).get();

    if (snapshot.exists) {
      return Workplace.fromMap(snapshot.data() as Map<String, dynamic>);
    }
    return null;
  }
}
