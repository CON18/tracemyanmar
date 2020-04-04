import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'employee.dart';

class DBHelper{
  static Database _db;
  static const String ID = 'id';
  static const String LOCATION = 'location';
  static const String TIME = 'time';
  static const String RID = 'rid';
  static const String COLOR = 'color';
  static const String TABLE = 'Employee';
  static const String DB_NAME = 'employee.db';

  Future<Database> get db async{
    if(_db != null){
      return _db;
    }
    _db = await initDb();
    return _db;
  }
  
  initDb() async{
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    print(path);
    return db;
  }
  
  _onCreate(Database db, int version) async{
    await db  
      .execute("CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $LOCATION TEXT,$TIME TEXT,$RID TEXT,$COLOR TEXT)");
  }

  Future<Employee> save (Employee employee) async{
    var dbClient = await db;
    employee.id = await dbClient.insert(TABLE, employee.toMap());
    return employee;

    // await dbClient.transaction((txn) async{
    //   var query = "INSERT INTO $TABLE ($NAME) VALUES ('"+employee.name+"')";
    //   return await txn.rawInsert(query);
    // });
  }

  Future<List<Employee>> getEmployees() async{
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [ID, LOCATION, TIME , RID ,COLOR]);
    List<Map> mapss = await dbClient.rawQuery("SELECT * FROM $TABLE");
    // print(mapss);
    List<Employee> employees = [];
    if(maps.length > 0){
      for(int i = 0; i < maps.length; i++){
        employees.add(Employee.fromMap(maps[i]));
      }
    }
    
<<<<<<< HEAD
    print("EML >>> " + employees[0].location);
=======
    print(employees[0].location);
>>>>>>> f996309ad1cf097a1f9de3b0ff2405b2edb708ba
    return employees; 
  }

  Future<int> delete(int id) async{
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> update(Employee employee) async{
    var dbClient = await db;
    return await dbClient.update(TABLE, employee.toMap(), 
      where:'$ID= ?', whereArgs: [employee.id]);
  }

  Future close() async{
    var dbClient = await db;
    dbClient.close();
  }
}