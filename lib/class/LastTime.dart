import 'package:hive/hive.dart';
part 'LastTime.g.dart';

@HiveType(typeId: 0)
class LastTime {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String categories;

  @HiveField(2)
  final DateTime date;

  LastTime(this.title, this.categories, this.date);
}
