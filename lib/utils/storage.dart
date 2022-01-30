import 'dart:async';

import 'package:uuid/uuid.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

var uuid = Uuid();

class DB {
  Future<Database> database() async {
    // Open the database and store the reference.
    return openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'database.db'),
      // When the database is first created, create a table to store cards.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE cards(id VARCHAR(40) PRIMARY KEY, number TEXT, cvv TEXT, holder TEXT, expiration TEXT)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  // Define a function that inserts cards into the database
  Future<void> insertCard(CardModel card) async {
    // Get a reference to the database.
    final db = await database();

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same card is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'cards',
      card.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the cards from the cards table.
  Future<List<CardModel>> cards() async {
    // Get a reference to the database.
    final db = await database();

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('cards');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return CardModel(
        maps[i]['number'],
        maps[i]['holder'],
        maps[i]['cvv'],
        maps[i]['expiration'],
        id: maps[i]['id'],
      );
    });
  }

  Future<void> updateCard(CardModel card) async {
    // Get a reference to the database.
    final db = await database();

    // Update the given Dog.
    await db.update(
      'cards',
      card.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [card.id],
    );
  }

  Future<void> deleteCard(String id) async {
    // Get a reference to the database.
    final db = await database();

    // Remove the Dog from the database.
    await db.delete(
      'cards',
      // Use a `where` clause to delete a specific item.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
}

class CardModel {
  String id;
  final String number;
  final String holder;
  final String cvv;
  final String expiration;

  CardModel(
    this.number,
    this.holder,
    this.cvv,
    this.expiration, {
    this.id,
  }) {
    if (id == null) {
      this.id = uuid.v4();
    }
  }

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'holder': holder,
      'cvv': cvv,
      'number': number,
      'expiration': expiration,
    };
  }

  // Implement toString to make it easier to see information about
  // each card when using the print statement.
  @override
  String toString() {
    final String last4 = number.substring(number.length - 4);
    return 'Card $holder XX$last4';
  }
}
