import 'package:hive/hive.dart';
part 'Data.g.dart';

@HiveType(typeId: 0)
class Data {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int number;

  Data(this.name, this.number);
}
