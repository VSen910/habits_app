import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habits/auth/auth_functions.dart';
import 'package:habits/components/drawer_info_tile.dart';
import 'package:habits/screens/habit_create_screen.dart';
import 'package:habits/screens/habit_details_screen.dart';
import 'package:habits/screens/register_screen.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:star_menu/star_menu.dart';
import 'package:flutter/material.dart';
import 'package:weekly_date_picker/weekly_date_picker.dart';
import '../components/custom_appbar.dart';
import '../components/habit_status_icons.dart';
import '../constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.username, required this.prefs})
      : super(key: key);

  final String username;
  final SharedPreferences prefs;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final statusKey = GlobalKey();

  final String userEmail = FirebaseAuth.instance.currentUser!.email!;

  int statusFlag = 0;
  List<Widget> status = [
    SizedBox(
      width: 160,
      child: Row(
        children: [
          const SizedBox(
            width: 30,
          ),
          const Text(
            'Done',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(
            width: 12,
          ),
          DoneIcon(onPressed: () {}),
        ],
      ),
    ),
    SizedBox(
      width: 160,
      child: Row(
        children: const [
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
    SizedBox(
      width: 160,
      child: Row(
        children: const [
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

  String getTimeInfo() {
    DateTime currentTime = DateTime.now();
    String month = currentTime.month >= 10
        ? currentTime.month.toString()
        : "0${currentTime.month}";
    String day = currentTime.day < 10
        ? "0${currentTime.day}"
        : currentTime.day.toString();
    String formate1 = "${currentTime.year}-$month-$day 00:00:00";
    return formate1;
  }

  DateTime getSelectedDay() {
    DateTime selectedDay = DateTime.parse(getTimeInfo());
    return selectedDay;
  }

  // String? username;

  // Future getUsername() async {
  //   final userDoc = await FirebaseFirestore.instance
  //       .collection('users')
  //       .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email!)
  //       .get();
  //   setState(() {
  //     username = userDoc.docs.first.get('name');
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        print(isAllowed);
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidht = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        titleText: "${widget.username}'s\nhabits",
        hasLeading: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.05),
                const Padding(
                  padding: EdgeInsets.only(left: 8),
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
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text('Nothing to show'),
                      );
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      separatorBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(4),
                        );
                      },
                      itemBuilder: (context, cardIndex) {
                        final List doneDatesTstp =
                            snapshot.data!.docs[cardIndex]['doneDates'];
                        final List notDoneDatesTstp =
                            snapshot.data!.docs[cardIndex]['notDoneDates'];

                        List<DateTime> doneDates = [];
                        List<DateTime> notDoneDates = [];

                        for (var date in doneDatesTstp) {
                          date = date.toDate();
                          DateTime newDate =
                              DateTime(date.year, date.month, date.day);
                          doneDates.add(newDate);
                        }
                        for (var date in notDoneDatesTstp) {
                          date = date.toDate();
                          DateTime newDate =
                              DateTime(date.year, date.month, date.day);
                          notDoneDates.add(newDate);
                        }

                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black12),
                          ),
                          child: ExpansionTile(
                            textColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1, color: kPrimaryColour),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            leading: Container(
                              margin: const EdgeInsets.only(left: 8),
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
                            title: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child:
                                  Text(snapshot.data!.docs[cardIndex]['title']),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                  snapshot.data!.docs[cardIndex]['subtitle']),
                            ),
                            trailing: Builder(builder: (context) {
                              StarMenuController statusIconController =
                                  StarMenuController();

                              return StarMenu(
                                controller: statusIconController,
                                onStateChanged: (state) =>
                                    print('State changed: $state'),
                                onItemTapped:
                                    (index, statusIconController) async {
                                  var habitDoc = FirebaseFirestore.instance
                                      .collection('habits')
                                      .doc(snapshot.data!.docs[cardIndex].id);

                                  setState(() {
                                    //Done Icon
                                    if (index == 0) {
                                      habitDoc.update({'currentStatus': 0});
                                    }

                                    //Pending Icon
                                    else if (index == 1) {
                                      habitDoc.update({'currentStatus': 1});
                                    }

                                    //Taken off Icon
                                    else if (index == 2) {
                                      habitDoc.update({'currentStatus': 2});
                                    }
                                  });
                                  statusIconController.closeMenu!();
                                  statusIconController.dispose();
                                },
                                params: const StarMenuParameters(
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
                                child: (snapshot.data!.docs[cardIndex]
                                            ['currentStatus'] ==
                                        0)
                                    ? DoneIcon(onPressed: () {})
                                    : (snapshot.data!.docs[cardIndex]
                                                ['currentStatus'] ==
                                            1)
                                        ? const PendingIcon()
                                        : const NotDoneIcon(),
                              );
                            }),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: WeeklyDatePicker(
                                  key: UniqueKey(),
                                  doneDays: doneDates,
                                  notDoneDays: notDoneDates,
                                  selectedDay: getSelectedDay(),
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
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              HabitDetailsScreen(
                                            prefs: widget.prefs,
                                            username: widget.username,
                                            habitId: snapshot
                                                .data!.docs[cardIndex].id,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12.0),
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
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text('Nothing to show'),
                      );
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      separatorBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(4),
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

                        final List doneDatesTstp =
                            snapshot.data!.docs[cardIndex2]['doneDates'];
                        final List notDoneDatesTstp =
                            snapshot.data!.docs[cardIndex2]['notDoneDates'];

                        List<DateTime> doneDates = [];
                        List<DateTime> notDoneDates = [];

                        for (var date in doneDatesTstp) {
                          date = date.toDate();
                          DateTime newDate =
                              DateTime(date.year, date.month, date.day);
                          doneDates.add(newDate);
                        }
                        for (var date in notDoneDatesTstp) {
                          date = date.toDate();
                          DateTime newDate =
                              DateTime(date.year, date.month, date.day);
                          notDoneDates.add(newDate);
                        }

                        return Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black12),
                            ),
                            child: ExpansionTile(
                              textColor: Colors.black,
                              iconColor: kPrimaryColour,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  width: 1,
                                  color: kPrimaryColour,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              leading: Container(
                                margin: const EdgeInsets.only(left: 8),
                                height: double.infinity,
                                child: Icon(
                                  IconData(
                                    int.parse(
                                        snapshot.data!.docs[cardIndex2]
                                            ['icondata'],
                                        radix: 16),
                                    fontFamily: 'MaterialIcons',
                                  ),
                                  size: 28,
                                  color: Color(int.parse(snapshot
                                      .data!.docs[cardIndex2]['iconColor'])),
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
                                    doneDays: doneDates,
                                    notDoneDays: notDoneDates,
                                    selectedDay: getSelectedDay(),
                                    changeDay: (value) =>
                                        (value) => setState(() {}),
                                    // selectedBackgroundColor: Colors.green,
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
                                                HabitDetailsScreen(
                                              prefs: widget.prefs,
                                              username: widget.username,
                                              habitId: snapshot
                                                  .data!.docs[cardIndex2].id,
                                            ),
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HabitCreateScreen(
                prefs: widget.prefs,
              ),
            ),
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      drawer: Drawer(
        backgroundColor: kPrimaryColour,
        shape: const RoundedRectangleBorder(
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
                  children: const [
                    Text(
                      'habits',
                      style: TextStyle(
                        fontFamily: 'antre',
                        fontSize: 40,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Make habits stick',
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
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  DrawerInfoTile(
                    title: 'Username',
                    value: widget.prefs.getString('username')!,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DrawerInfoTile(
                    title: 'Email',
                    value: userEmail,
                  ),
                  SizedBox(
                    height: screenHeight * 0.4,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(width: 1, color: kPrimaryColour),
                          ),
                        ),
                        onPressed: () async {
                          await AuthServices.signOut();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterScreen(
                                prefs: widget.prefs,
                              ),
                            ),
                          );
                          // Navigator.pop(context);
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
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
                  ),
                  const SizedBox(
                    height: 200,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
