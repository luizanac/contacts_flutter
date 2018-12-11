import 'package:contatos/models/contact.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String contactTable = "contact";
final String idColumn = "id";
final String nameColumn = "name";
final String emailColumn = "email";
final String phoneColumn = "phone";
final String imgColumn = "img";

class ContactHelper {
  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;

  ContactHelper.internal();

  Database _db;

  Future<Database> get db async {
    if(_db !=null) return _db;
    _db = await initDb();
    return _db;
  }

  Future<Contact> saveContact(Contact contact) async {
    Database dbContact = await db;
    contact.id = await dbContact.insert(contactTable, contact.toMap());
    return contact;
  }

  Future<Contact> getContact(int id) async {
    Database dbContact = await db;
    List<Map> maps = await dbContact.query(contactTable,
        columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);

    if(maps.length > 0)
      return Contact.fromMap(maps.first);

    return null;
  }

  Future<bool> deleteContact(int id) async {
    Database dbContact = await db;
    var result = await dbContact.delete(contactTable, where: "$idColumn = ?", whereArgs: [id]);
    return result == 1;
  }

  Future<bool> updateContact(Contact contact) async {
    Database dbContact = await db;
    var result = await dbContact
        .update(
        contactTable, contact.toMap(),
        where: "$idColumn = ?",
        whereArgs: [contact.id]);

    return result == 1;
  }

  Future<List<Contact>> getAllContacts() async {
    Database dbContact = await db;
    List listMap = await dbContact.rawQuery("SELECT * FROM $contactTable");
    List<Contact> listContact = List();
    for(Map m in listMap){
      listContact.add(Contact.fromMap(m));
    }
    return listContact;
  }

  Future<int> getNumber() async {
    Database dbContact = await db;
    return Sqflite.firstIntValue(await dbContact.rawQuery("SELECT COUNT(*) FROM $contactTable"));
  }

  Future close() async {
    Database dbContact = await db;
    dbContact.close();
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "contacts.db");

    return openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT,"
              "$phoneColumn TEXT, $imgColumn TEXT)"
      );
    });
  }

}