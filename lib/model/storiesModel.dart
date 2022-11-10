

import 'package:hive/hive.dart';

part 'storiesModel.g.dart';

@HiveType(typeId: 2)
class StoriesModel{

      @HiveField(0)
      String url;

      @HiveField(1)
      String media;

      @HiveField(2)
      Map<String, dynamic> user;
      
      @HiveField(3)
      int duration;

      StoriesModel({required this.url,required this.media , required this.user, required this.duration});

}