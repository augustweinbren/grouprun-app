import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/meetup.dart';
import 'dart:async';

Future<void> clearDatabase() async {
  return deleteDatabase(join(await getDatabasesPath(),
      'meetup_database.db')); //needed to refresh the system
}

Future<Database> openMeetupDatabase() async {
  return openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'meetup_database.db'),
    // When the database is first created, create a table to store meetups.
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE meetups(id INTEGER PRIMARY KEY, group_name TEXT, ' +
              'day INTEGER, start_time INTEGER, end_time INTEGER,' +
              'url TEXT, latitude REAL, longitude REAL,' +
              'bag_drop INTEGER, dog_friendly INTEGER, post_run_social INTEGER,' +
              'competition_training INTEGER, beginner_friendly INTEGER,' +
              'running_setting_type INTEGER)');
    },
    version: 1,
  );
}

Future<void> insertMeetup(Meetup meetup) async {
  final db =
      await openMeetupDatabase(); // assuming you have a database connection
  // Insert the Meetup into the correct table. You might also specify the
  // `conflictAlgorithm` to use in case the same meetup is inserted twice.
  //
  // In this case, replace any previous data.
  await db.insert(
    'meetups',
    meetup.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> updateMeetup(Meetup meetup) async {
  //TODO: incorporate when the data has been uploaded
  // Get a reference to the database.
  final db = await openMeetupDatabase();

  // Update the given meetup.
  await db.update(
    'meetups',
    meetup.toMap(),
    // Ensure that the meetup has a matching id.
    where: 'id = ?',
    // Pass the Meetup's id as a whereArg to prevent SQL injection.
    whereArgs: [meetup.id],
  );
}

Future<List<Meetup>> meetups() async {
  final db =
      await openMeetupDatabase(); // assuming you have a database connection
  final List<Map<String, dynamic>> maps = await db.query('meetups');
  return List.generate(maps.length, (i) {
    return Meetup(
      id: maps[i]['id'],
      groupName: maps[i]['group_name'],
      lat: maps[i]['latitude'],
      lng: maps[i]['longitude'],
      day: maps[i]['day'],
      startTime: maps[i]['start_time'],
      endTime: maps[i]['end_time'],
      url: maps[i]['url'],
      bagDrop: maps[i]['bag_drop'],
      dogFriendly: maps[i]['dog_friendly'],
      postRunSocial: maps[i]['post_run_social'],
      competitionTraining: maps[i]['competition_training'],
      beginnerFriendly: maps[i]['beginner_friendly'],
      runningSettingType: maps[i]['running_setting_type'],
    );
  });
}

Future<void> addAllLondonParkrunMeetups() async {
  final hhParkrun = Meetup(
    id: 1,
    groupName: 'Hampstead Heath parkrun',
    lat: 51.560899634933506,
    lng: -0.17320792069946106,
    day: Day.Saturday.index,
    url: 'https://www.parkrun.org.uk/hampsteadheath/course/',
    startTime: 900,
    endTime: 1000,
    bagDrop: 1,
    dogFriendly: 1,
    postRunSocial: 1,
    competitionTraining: 1,
    beginnerFriendly: 1,
    runningSettingType: RunningSettingType.park.index,
  );
  await insertMeetup(hhParkrun);

  final hfParkrun = Meetup(
    id: 2,
    groupName: 'Highbury Fields parkrun',
    lat: 51.548815035984795,
    lng: -0.10401080493052133,
    day: Day.Saturday.index,
    url: 'https://www.parkrun.org.uk/highburyfields/course/',
    startTime: 900,
    endTime: 1000,
    bagDrop: 1,
    dogFriendly: 1,
    postRunSocial: 1,
    competitionTraining: 1,
    beginnerFriendly: 1,
    runningSettingType: RunningSettingType.park.index,
  );
  await insertMeetup(hfParkrun);

  final finsParkrun = Meetup(
    id: 3,
    groupName: 'Finsbury Park parkrun',
    lat: 51.56958442044193,
    lng: -0.10416797995832222,
    day: Day.Saturday.index,
    url: 'https://www.parkrun.org.uk/finsbury/course/',
    startTime: 900,
    endTime: 1000,
    bagDrop: 1,
    dogFriendly: 1,
    postRunSocial: 1,
    competitionTraining: 1,
    beginnerFriendly: 1,
    runningSettingType: RunningSettingType.park.index,
  );
  await insertMeetup(finsParkrun);

  final hackneyMarshesParkrun = Meetup(
    id: 4,
    groupName: 'Hackney Marshes parkrun',
    lat: 51.55541569283087,
    lng: -0.024496272786963126,
    day: Day.Saturday.index,
    url: 'https://www.parkrun.org.uk/hackneymarshes/course/',
    startTime: 900,
    endTime: 1000,
    bagDrop: 1,
    dogFriendly: 1,
    postRunSocial: 1,
    competitionTraining: 1,
    beginnerFriendly: 1,
    runningSettingType: RunningSettingType.park.index,
  );
  await insertMeetup(hackneyMarshesParkrun);

  final meParkrun = Meetup(
    id: 5,
    groupName: 'Mile End parkrun',
    lat: 51.51839021641621,
    lng: -0.03456499996390295,
    day: Day.Saturday.index,
    url: 'https://www.parkrun.org.uk/mileend/course/',
    startTime: 900,
    endTime: 1000,
    bagDrop: 1,
    dogFriendly: 1,
    postRunSocial: 1,
    competitionTraining: 1,
    beginnerFriendly: 1,
    runningSettingType: RunningSettingType.park.index,
  );
  await insertMeetup(meParkrun);

  final southwarkParkrun = Meetup(
    id: 6,
    groupName: 'Southwark parkrun',
    lat: 51.493768030807054,
    lng: -0.05113941090284307,
    day: Day.Saturday.index,
    url: 'https://www.parkrun.org.uk/southwark/course/',
    startTime: 900,
    endTime: 1000,
    bagDrop: 1,
    dogFriendly: 1,
    postRunSocial: 1,
    competitionTraining: 1,
    beginnerFriendly: 1,
    runningSettingType: RunningSettingType.park.index,
  );
  await insertMeetup(southwarkParkrun);

  final victoriadockParkrun = Meetup(
    id: 7,
    groupName: 'Victoria Dock parkrun',
    lat: 51.50642478714656,
    lng: 0.016823562169137937,
    day: Day.Saturday.index,
    url: 'https://www.parkrun.org.uk/victoriadock/course/',
    startTime: 900,
    endTime: 1000,
    bagDrop: 1,
    dogFriendly: 1,
    postRunSocial: 1,
    competitionTraining: 1,
    beginnerFriendly: 1,
    runningSettingType: RunningSettingType.park.index,
  );
  await insertMeetup(victoriadockParkrun);

  final burgessparkParkrun = Meetup(
    id: 8,
    groupName: 'Burgess Park parkrun',
    lat: 51.48175949385538,
    lng: -0.09317734572395736,
    day: Day.Saturday.index,
    url: 'https://www.parkrun.org.uk/burgess/course/',
    startTime: 900,
    endTime: 1000,
    bagDrop: 1,
    dogFriendly: 1,
    postRunSocial: 1,
    competitionTraining: 1,
    beginnerFriendly: 1,
    runningSettingType: RunningSettingType.park.index,
  );
  await insertMeetup(burgessparkParkrun);

  final peckhamryeParkrun = Meetup(
    id: 9,
    groupName: 'Peckham Rye parkrun',
    lat: 51.481742657835724,
    lng: -0.09310084283996853,
    day: Day.Saturday.index,
    url: 'https://www.parkrun.org.uk/burgess/course/',
    startTime: 900,
    endTime: 1000,
    bagDrop: 1,
    dogFriendly: 1,
    postRunSocial: 1,
    competitionTraining: 1,
    beginnerFriendly: 1,
    runningSettingType: RunningSettingType.park.index,
  );
  await insertMeetup(peckhamryeParkrun);

  final brockwellparkParkrun = Meetup(
    id: 10,
    groupName: 'Brockwell Park parkrun',
    lat: 51.453770162082336,
    lng: -0.1091219789431514,
    day: Day.Saturday.index,
    url: 'https://www.parkrun.org.uk/brockwell/course/',
    startTime: 900,
    endTime: 1000,
    bagDrop: 1,
    dogFriendly: 1,
    postRunSocial: 1,
    competitionTraining: 1,
    beginnerFriendly: 1,
    runningSettingType: RunningSettingType.park.index,
  );
  await insertMeetup(brockwellparkParkrun);

  final claphamcommonParkrun = Meetup(
    id: 11,
    groupName: 'Clapham Common parkrun',
    lat: 51.45615507245232,
    lng: -0.15376265751033583,
    day: Day.Saturday.index,
    url: 'https://www.parkrun.org.uk/claphamcommon/course/',
    startTime: 900,
    endTime: 1000,
    bagDrop: 1,
    dogFriendly: 1,
    postRunSocial: 1,
    competitionTraining: 1,
    beginnerFriendly: 1,
    runningSettingType: RunningSettingType.park.index,
  );
  await insertMeetup(claphamcommonParkrun);

  final hillyfieldsParkrun = Meetup(
    id: 12,
    groupName: 'Hilly Fields parkrun',
    lat: 51.460141384786155,
    lng: -0.025015229418334756,
    day: Day.Saturday.index,
    url: 'https://www.parkrun.org.uk/hillyfields/course/',
    startTime: 900,
    endTime: 1000,
    bagDrop: 1,
    dogFriendly: 1,
    postRunSocial: 1,
    competitionTraining: 1,
    beginnerFriendly: 1,
    runningSettingType: RunningSettingType.park.index,
  );
  await insertMeetup(hillyfieldsParkrun);

  final allypallyParkrun = Meetup(
    id: 13,
    groupName: 'Ally Pally parkrun',
    lat: 51.59501986788866,
    lng: -0.12343581019013808,
    day: Day.Saturday.index,
    url: 'https://www.parkrun.org.uk/allypally/course/',
    startTime: 900,
    endTime: 1000,
    bagDrop: 1,
    dogFriendly: 1,
    postRunSocial: 1,
    competitionTraining: 1,
    beginnerFriendly: 1,
    runningSettingType: RunningSettingType.park.index,
  );
  await insertMeetup(allypallyParkrun);

  final lordshiprecreationgroundParkrun = Meetup(
    id: 14,
    groupName: 'Lordship Recreation Ground parkrun',
    lat: 51.59436459647848,
    lng: -0.08703845340003445,
    day: Day.Saturday.index,
    url: 'https://www.parkrun.org.uk/lordshiprecreationground/course/',
    startTime: 900,
    endTime: 1000,
    bagDrop: 1,
    dogFriendly: 1,
    postRunSocial: 1,
    competitionTraining: 1,
    beginnerFriendly: 1,
    runningSettingType: RunningSettingType.park.index,
  );
  await insertMeetup(lordshiprecreationgroundParkrun);
}
