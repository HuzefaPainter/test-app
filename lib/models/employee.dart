import 'package:objectbox/objectbox.dart';

@Entity()
class Employee {
  @Id()
  int id = 0;
  String? name;
  String? role;
  @Property(type: PropertyType.date)
  DateTime? startDate;
  @Property(type: PropertyType.date)
  DateTime? endDate;
}
