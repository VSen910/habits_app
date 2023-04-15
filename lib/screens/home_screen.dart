import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:habits/auth/authFunctions.dart';
import 'package:habits/components/drawer_info_tile.dart';
import 'package:habits/dataHandling/dataHandler.dart';
import 'package:habits/screens/habit_details_screen.dart';
import 'package:habits/screens/register_screen.dart';
import 'package:intl/intl.dart';
import 'package:star_menu/star_menu.dart';
import 'package:flutter/material.dart';
import 'package:weekly_date_picker/weekly_date_picker.dart';
import '../components/custom_appbar.dart';
import '../components/habit_class.dart';
import '../components/habit_status_icons.dart';
import '../constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final statusKey = GlobalKey();

  final String userEmail = FirebaseAuth.instance.currentUser!.email!;

  late List<List<HabitDetails>> habits_list = [
    [
      HabitDetails(
          'Go for a walk',
          'Go to park at 8:00 AM',
          1,
          Icons.directions_walk,
          [DateTime(2023, 4, 10), DateTime(2023, 4, 12)],
          [DateTime(2023, 4, 11), DateTime(2023, 4, 9)])
    ],
    [
      HabitDetails(
          'Go for a walk',
          'Go to park at 8:00 AM',
          1,
          Icons.directions_walk,
          [DateTime(2023, 4, 10), DateTime(2023, 4, 11)],
          [DateTime(2023, 4, 12), DateTime(2023, 4, 9)])
    ],
    [
      HabitDetails(
          'Go for a walk',
          'Go to park at 8:00 AM',
          1,
          Icons.directions_walk,
          [DateTime(2023, 4, 11), DateTime(2023, 4, 9)],
          [DateTime(2023, 4, 10), DateTime(2023, 4, 12)])
    ]
  ];
  int statusFlag = 0;
  List<Widget> status = [
    Container(
      width: 160,
      child: Row(
        children: [
          SizedBox(
            width: 30,
          ),
          Text(
            'Done',
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(
            width: 12,
          ),
          DoneIcon(onPressed: () {}),
        ],
      ),
    ),
    Container(
      width: 160,
      child: Row(
        children: [
          SizedBox(
            width: 13,
          ),
          Text(
            'Pending',
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(
            width: 10,
          ),
          PendingIcon(),
        ],
      ),
    ),
    Container(
      width: 160,
      child: Row(
        children: [
          SizedBox(
            width: 5,
          ),
          Text(
            'Taken off',
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(
            width: 10,
          ),
          NotDoneIcon(),
        ],
      ),
    ),
  ];

  //
  List<DateTime> completedDays = [DateTime(2023, 4, 14), DateTime(2023, 4, 13)];
  List<DateTime> notDoneDays = [DateTime(2023, 4, 15), DateTime(2023, 4, 16)];

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   statusIconController.dispose();
  //   super.dispose();
  // }

  String getTimeInfo() {
    DateTime currentTime = DateTime.now();
    String month = currentTime.month >= 10
        ? currentTime.month.toString()
        : "0" + currentTime.month.toString();
    String day = currentTime.day < 10
        ? "0" + currentTime.day.toString()
        : currentTime.day.toString();
    String formate1 = "${currentTime.year}-${month}-${day} 00:00:00";
    return formate1;
  }

  DateTime get_SelectedDay() {
    DateTime _selectedDay = DateTime.parse(getTimeInfo());
    return _selectedDay;
  }

  String? username;

  Future getUsername() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email!)
        .get();
    setState(() {
      username = userDoc.docs.first.get('name');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsername();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidht = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        titleText: "$username's\nhabits",
        hasLeading: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.05),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    'Today',
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('habits')
                      .where('email',
                          isEqualTo: FirebaseAuth.instance.currentUser!.email!)
                      .where('weekdays',
                          arrayContains: DateFormat('EEEE')
                              .format(DateTime.now())
                              .toLowerCase())
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text('Nothing to show'),
                      );
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      separatorBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.all(4),
                        );
                      },
                      itemBuilder: (context, cardIndex) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(8, 0, 8, 10),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black12),
                            ),
                            child: ExpansionTile(
                              textColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                side:
                                    BorderSide(width: 2, color: Colors.black12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              leading: Container(
                                margin: EdgeInsets.only(left: 8),
                                height: double.infinity,
                                child: Icon(
                                  IconData(
                                    int.parse(
                                        snapshot.data!.docs[cardIndex]
                                            ['icondata'],
                                        radix: 16),
                                    fontFamily: 'MaterialIcons',
                                  ),
                                  size: 28,
                                  color: Color(int.parse(snapshot
                                      .data!.docs[cardIndex]['iconColor'])),
                                ),
                              ),
                              title:
                                  Text(snapshot.data!.docs[cardIndex]['title']),
                              subtitle: Text(
                                  snapshot.data!.docs[cardIndex]['subtitle']),
                              trailing: Builder(builder: (context) {
                                StarMenuController statusIconController =
                                    StarMenuController();

                                return StarMenu(
                                  controller: statusIconController,
                                  onStateChanged: (state) =>
                                      print('State changed: $state'),
                                  onItemTapped: (index, statusIconController) {
                                    setState(() {
                                      //Done Icon
                                      if (index == 0) {
                                        habits_list[cardIndex][0].status_icon =
                                            0;
                                        if (statusFlag == 0) {
                                          habits_list[cardIndex][0]
                                              .completedDays
                                              .add(DateTime.parse(
                                                  getTimeInfo()));
                                          statusFlag = 1;
                                        } else if (statusFlag == 1) {
                                          if (habits_list[cardIndex][0]
                                              .notDoneDays
                                              .contains(DateTime.parse(
                                                  getTimeInfo()))) {
                                            habits_list[cardIndex][0]
                                                .notDoneDays
                                                .remove(DateTime.parse(
                                                    getTimeInfo()));
                                          }
                                          habits_list[cardIndex][0]
                                              .completedDays
                                              .add(DateTime.parse(
                                                  getTimeInfo()));
                                        }
                                      }

                                      //Pending Icon
                                      else if (index == 1) {
                                        habits_list[cardIndex][0].status_icon =
                                            1;
                                        if (statusFlag == 0) {
                                          statusFlag = 1;
                                        } else if (statusFlag == 1) {
                                          if (habits_list[cardIndex][0]
                                              .completedDays
                                              .contains(DateTime.parse(
                                                  getTimeInfo()))) {
                                            habits_list[cardIndex][0]
                                                .completedDays
                                                .remove(DateTime.parse(
                                                    getTimeInfo()));
                                          } else if (habits_list[cardIndex][0]
                                              .notDoneDays
                                              .contains(DateTime.parse(
                                                  getTimeInfo()))) {
                                            habits_list[cardIndex][0]
                                                .notDoneDays
                                                .remove(DateTime.parse(
                                                    getTimeInfo()));
                                          }
                                        }
                                      }

                                      //Taken off Icon
                                      else if (index == 2) {
                                        habits_list[cardIndex][0].status_icon =
                                            3;
                                        if (statusFlag == 0) {
                                          habits_list[cardIndex][0]
                                              .notDoneDays
                                              .add(DateTime.parse(
                                                  getTimeInfo()));
                                          statusFlag = 1;
                                        } else if (statusFlag == 1) {
                                          if (habits_list[cardIndex][0]
                                              .completedDays
                                              .contains(DateTime.parse(
                                                  getTimeInfo()))) {
                                            habits_list[cardIndex][0]
                                                .completedDays
                                                .remove(DateTime.parse(
                                                    getTimeInfo()));
                                          }
                                          habits_list[cardIndex][0]
                                              .notDoneDays
                                              .add(DateTime.parse(
                                                  getTimeInfo()));
                                        }
                                      }
                                    });
                                    statusIconController.closeMenu!();
                                    statusIconController.dispose();
                                  },
                                  params: StarMenuParameters(
                                    backgroundParams: BackgroundParams(
                                        sigmaX: 3,
                                        sigmaY: 3,
                                        backgroundColor: Colors.black54),
                                    shape: MenuShape.linear,
                                    linearShapeParams: LinearShapeParams(
                                        angle: 90,
                                        alignment: LinearAlignment.left,
                                        space: 15),
                                    centerOffset: Offset(10, -70),
                                    openDurationMs: 150,
                                  ),
                                  items: status,
                                  parentContext: statusKey.currentContext,
                                  child:
                                      (habits_list[cardIndex][0].status_icon ==
                                              0)
                                          ? DoneIcon(onPressed: () {})
                                          : (habits_list[cardIndex][0]
                                                      .status_icon ==
                                                  1)
                                              ? PendingIcon()
                                              : NotDoneIcon(),
                                );
                              }),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: WeeklyDatePicker(
                                    key: UniqueKey(),
                                    doneDays:
                                        habits_list[cardIndex][0].completedDays,
                                    notDoneDays:
                                        habits_list[cardIndex][0].notDoneDays,
                                    selectedDay: get_SelectedDay(),
                                    changeDay: (value) =>
                                        (value) => setState(() {}),
                                    enableWeeknumberText: false,
                                    digitsColor: Colors.black,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: kPrimaryColour,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                HabitDetailsScreen(),
                                          ),
                                        );
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12.0),
                                        child: Text(
                                          'View more details',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                SizedBox(
                  height: screenHeight * 0.04,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text(
                    'Others',
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('habits')
                      .where('email',
                          isEqualTo: FirebaseAuth.instance.currentUser!.email!)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text('Nothing to show'),
                      );
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return Container(
                          padding: EdgeInsets.all(4),
                        );
                      },
                      itemBuilder: (context, cardIndex2) {
                        bool hasToday = snapshot
                            .data!.docs[cardIndex2]['weekdays']
                            .contains(DateFormat('EEEE')
                                .format(DateTime.now())
                                .toLowerCase());
                        if (hasToday) {
                          return Container();
                        }

                        return Padding(
                          padding: EdgeInsets.fromLTRB(8, 0, 8, 10),
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black12)),
                            child: ExpansionTile(
                              textColor: Colors.black,
                              iconColor: Color(int.parse(snapshot
                                  .data!.docs[cardIndex2]['iconColor'])),
                              collapsedIconColor: Color(int.parse(snapshot
                                  .data!.docs[cardIndex2]['iconColor'])),
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 2,
                                    color: Colors.black12,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              leading: Container(
                                margin: EdgeInsets.only(left: 8),
                                height: double.infinity,
                                child: Icon(
                                  IconData(
                                    int.parse(
                                      snapshot.data!.docs[cardIndex2]
                                          ['icondata'],
                                      radix: 16,
                                    ),
                                    fontFamily: 'MaterialIcons',
                                  ),
                                  size: 28,
                                ),
                              ),
                              title: Text(
                                  snapshot.data!.docs[cardIndex2]['title']),
                              subtitle: Text(
                                  snapshot.data!.docs[cardIndex2]['subtitle']),
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: WeeklyDatePicker(
                                    doneDays: completedDays,
                                    notDoneDays: notDoneDays,
                                    selectedDay: get_SelectedDay(),
                                    changeDay: (value) =>
                                        (value) => setState(() {}),
                                    selectedBackgroundColor: Colors.green,
                                    enableWeeknumberText: false,
                                    digitsColor: Colors.black,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: kPrimaryColour,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                HabitDetailsScreen(),
                                          ),
                                        );
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12.0),
                                        child: Text(
                                          'View more details',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColour,
        onPressed: () {},
        child: Icon(
          Icons.add,
        ),
      ),
      drawer: Drawer(
        backgroundColor: kPrimaryColour,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: ListView(
          children: [
            DrawerHeader(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    Text(
                      'habits',
                      style: TextStyle(
                        fontFamily: 'antre',
                        fontSize: 40,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Build better habits',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff3f3f3f),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  DrawerInfoTile(
                    title: 'Username',
                    value: 'Palash',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DrawerInfoTile(
                    title: 'Email',
                    value: 'palash@bhasme.com',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DrawerInfoTile(
                    title: 'Habits being tracked',
                    value: '3',
                  ),
                  SizedBox(
                    height: screenHeight * 0.3,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(width: 1, color: kPrimaryColour),
                        ),
                      ),
                      onPressed: () async {
                        await AuthServices.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ),
                        );
                        // Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 24.0,
                        ),
                        child: Text(
                          'Sign out',
                          style: TextStyle(
                            fontSize: 16,
                            color: kPrimaryColour,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 200,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
