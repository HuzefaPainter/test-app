import 'package:employee_app/objectbox.g.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ObjectBox {
  static ObjectBox? _instance;
  late final Store store;

  ObjectBox._create(this.store);

  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    if (_instance == null) {
      final store =
          await openStore(directory: p.join(docsDir.path, "employee-db"));
      _instance = ObjectBox._create(store);
    }
    return _instance!;
  }

  static ObjectBox get instance {
    if (_instance == null) {
      throw Exception(
          "ObjectBox has not been initialized. Call ObjectBox.create() first.");
    }
    return _instance!;
  }
}
