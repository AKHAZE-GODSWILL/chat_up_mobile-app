
import 'package:hive/hive.dart';

part 'storiesSenderModel.g.dart';

@HiveType(typeId: 3)
class StoriesSenderModel{

      @HiveField(0)
      String name;

      @HiveField(1)
      String profileImage;

      @HiveField(2)
      String id;


      

      StoriesSenderModel({required this.name,required this.profileImage , required this.id});

}