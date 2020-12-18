import 'package:cv_builder/models/education.dart';
import 'package:cv_builder/models/person.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'person.db'),
      onCreate: (db, version) async {
        await db.execute(
            "CREATE TABLE persons(id INTEGER PRIMARY KEY, title TEXT, firstName TEXT, surname TEXT,"
            "jobTitle TEXT, aboutMe TEXT, gender TEXT, dob TEXT, nationality TEXT,"
            "country TEXT, city TEXT, creationDateTime TEXT, phone TEXT, email TEXT,"
            "address TEXT, linkedin TEXT, facebook TEXT, github TEXT)");

        // await db.execute(
        //     "CREATE TABLE education(id INTEGER PRIMARY KEY, years TEXT, school TEXT, faculty TEXT,"
        //         "department TEXT, grade TEXT, notes TEXT)");

        // await db.execute(
        //     "CREATE TABLE experience(id INTEGER PRIMARY KEY, years TEXT, school TEXT, faculty TEXT,"
        //         "department TEXT, grade TEXT, notes TEXT)");
        return db;
      },
      version: 1,
    );
  }

  Future<void> insertPerson(Person person) async {
    Database db = await database();
    await db.insert('persons', person.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> insertEducation(Education education) async {
    int educationId = 0;
    Database db = await database();
    await db
        .insert('education', education.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      educationId = value;
    });
    return educationId;
  }

  Future<List<Person>> getPersons() async {
    // Get a reference to the database.
    final Database db = await database();

    final List<Map<String, dynamic>> personMap = await db.query('persons');

    return List.generate(personMap.length, (i) {
      return Person(
        id: personMap[i]['id'],
        title: personMap[i]['title'],
        firstName: personMap[i]['firstName'],
        surname: personMap[i]['surname'],
        jobTitle: personMap[i]['jobTitle'],
        aboutMe: personMap[i]['aboutMe'],
        gender: personMap[i]['gender'],
        dob: personMap[i]['dob'],
        nationality: personMap[i]['nationality'],
        country: personMap[i]['country'],
        city: personMap[i]['city'],
        creationDateTime: personMap[i]['creationDateTime'],
        phone: personMap[i]['phone'],
        email: personMap[i]['email'],
        address: personMap[i]['address'],
        linkedin: personMap[i]['linkedin'],
        facebook: personMap[i]['facebook'],
        github: personMap[i]['github'],
      );
    });
  }

  Future<void> updateTitle(int id, String title) async {
    Database db = await database();
    await db.rawUpdate("update persons set title = '$title' where id = '$id'");
  }

  Future<void> updatePersonalInformation(
      int id,
      String firstName,
      String surname,
      String jobTitle,
      String aboutMe,
      String gender,
      String dob,
      String nationality,
      String country,
      String city) async {
    Database db = await database();
    await db.rawUpdate(
        "update persons set firstName = '$firstName', surname = '$surname', jobTitle = '$jobTitle',"
        "aboutMe = '$aboutMe', gender = '$gender', dob = '$dob', nationality = '$nationality',"
        "country = '$country', city = '$city' where id = '$id'");
    print("Updated");

    // print(firstName +
    //     surname +
    //     jobTitle +
    //     aboutMe +
    //     gender +
    //     dob +
    //     nationality +
    //     country +
    //     city);
  }

  Future<void> updateContactInformation(
    int id,
    String phone,
    String email,
    String address,
    String linkedin,
    String facebook,
    String github,
  ) async {
    Database db = await database();
    await db.rawUpdate(
        "update persons set phone = '$phone', email = '$email', address = '$address',"
        "linkedin = '$linkedin', facebook = '$facebook', github = '$github' where id = '$id'");
    print("Updated");
  }

  Future<void> updateEducationInformation(
    int id,
    String phone,
    String email,
    String address,
    String linkedin,
    String facebook,
    String github,
  ) async {
    Database db = await database();
    await db.rawUpdate(
        "update persons set phone = '$phone', email = '$email', address = '$address',"
        "linkedin = '$linkedin', facebook = '$facebook', github = '$github' where id = '$id'");
    print("Updated");
  }

  Future<void> deletePerson(int id) async {
    Database db = await database();
    await db.rawDelete("delete from persons where id = '$id'");
    print("Deleted");
  }

//  Future<List<Person>> getPersonData(int id) async {
//    // Get a reference to the database.
//    final Database db = await database();
//
//    final List<Map<String, dynamic>> personMap = await db.rawQuery('select * from persons where id = $id');
//
//    return List.generate(personMap.length, (i) {
//      return Person(
//        id: personMap[i]['id'],
//        title: personMap[i]['title'],
//        firstName: personMap[i]['firstName'],
//        surname: personMap[i]['surname'],
//        jobTitle: personMap[i]['jobTitle'],
//        aboutMe: personMap[i]['aboutMe'],
//        gender: personMap[i]['gender'],
//        dob: personMap[i]['dob'],
//        nationality: personMap[i]['nationality'],
//        country: personMap[i]['country'],
//        city: personMap[i]['city'],
//        creationDateTime: personMap[i]['creationDateTime'],
//        phone: personMap[i]['phone'],
//        email: personMap[i]['email'],
//        address: personMap[i]['address'],
//        linkedin: personMap[i]['linkedin'],
//        facebook: personMap[i]['facebook'],
//        github: personMap[i]['github'],
//      );
//    });
//  }
}
