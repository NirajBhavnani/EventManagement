import 'package:cloud_firestore/cloud_firestore.dart';


//final CollectionReference myCollection = Firestore.instance.collection('eventlist');

class FirestoreService {
  String etitle;
  String edes;
  String eroom;
  String edate;
  String etf;
  String ett;
  DocumentReference reference;

  FirestoreService({this.etitle, this.edes, this.eroom, this.edate, this.etf, this.ett});

  FirestoreService.fromMap(Map<String, dynamic> map, {this.reference}) {
    etitle = map["etitle"];
    edes = map["edes"];
    eroom = map["eroom"];
    edate = map["edate"];
    etf = map["etf"];
    ett = map["ett"];
  }

  FirestoreService.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  toJson() {
    return {'etitle': etitle, 'edes': edes, 'eroom': eroom, 'edate': edate, 'etf': etf, 'ett': ett};
  }

}
//  Future<Task> createTODOTask(String title, String description,String time) async {
//    final TransactionHandler createTransaction = (Transaction tx) async {
//      final DocumentSnapshot ds = await tx.get(myCollection.document());
//
//      final Task task = new Task(title, description,time);
//      final Map<String, dynamic> data = task.toMap();
//      await tx.set(ds.reference, data);
//      return data;
//    };
//
//    return Firestore.instance.runTransaction(createTransaction).then((mapData) {
//      return Task.fromMap(mapData);
//    }).catchError((error) {
//      print('error: $error');
//      return null;
//    });
//  }
//
//  Stream<QuerySnapshot> getTaskList({int offset, int limit}) {
//    Stream<QuerySnapshot> snapshots = myCollection.snapshots();
//
//    if (offset != null) {
//      snapshots = snapshots.skip(offset);
//    }
//    if (limit != null) {
//      snapshots = snapshots.take(limit);
//    }
//    return snapshots;
//  }