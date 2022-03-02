
import 'package:hive/hive.dart';

class HiveBase{
  static String DB_NAME = "firebase_notes";
  static var box = Hive.box(DB_NAME);

  static void storeUser(String base) async{
    box.put("base", base);
  }

  static String? loadUser(){
    return box.get("base");
  }

  static Future<void> removeUser(){
    return box.delete("base");
  }


}