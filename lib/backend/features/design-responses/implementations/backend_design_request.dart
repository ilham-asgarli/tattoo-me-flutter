import 'package:cloud_firestore/cloud_firestore.dart';

import '../interfaces/backend_design_request_interface.dart';

class BackendDesignResponse extends BackendDesignResponseInterface {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference designResponses =
      FirebaseFirestore.instance.collection("design-responses");
}
