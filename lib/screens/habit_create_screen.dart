import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:habits/components/custom_appbar.dart';
import 'package:habits/components/habit_class.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_iconpicker/Models/IconPack.dart';
import 'package:habits/constants.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'package:intl/intl.dart';

import '../components/reminder_chips.dart';

class HabitCreateScreen extends StatefulWidget {
  const HabitCreateScreen({Key? key}) : super(key: key);

  @override
  State<HabitCreateScreen> createState() => _HabitCreateScreenState();
}

class _HabitCreateScreenState extends State<HabitCreateScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  TabController? tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  final Map<String, IconData> myIconCollection = {
    'favorite': Icons.favorite,
    'home': Icons.home,
    'album': Icons.album,
    'ac_unit': Icons.ac_unit,
    //  'six__ft_apart': Icons.six_ft_apart,
  };

  // final PageController _controller = PageController();
  //
  // void _showIconPickerDialog(BuildContext context) async {
  //   IconData? selectedIcon = await FlutterIconPicker.showIconPicker(
  //     context,
  //     iconPickerShape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     //iconPackModes: IconPack.material,
  //     iconPackModes: [IconPack.material, IconPack.material, IconPack.cupertino],
  //   );
  //
  //   // Do something with the selected icon, such as updating your state or saving it to a database
  // }

  late List<List<HabitDetails>> habits_list = [
    [
      HabitDetails('Sleep early', 'Choose the time to go to bed', 1,
          Icons.bedtime, [], [])
    ],
    [
      HabitDetails('Go for a walk', 'Choose the time to g to walk', 1,
          Icons.directions_walk, [], [])
    ],
    [
      HabitDetails('Meditation', 'Choose the time for meditation', 1,
          Icons.directions_walk, [], [])
    ]
  ];
  List<bool?> weekdaysBool = List.filled(7, false);

  printIntAsDay(int day) {
    print(
        'Received integer: $day. Corresponds to day: ${intDayToEnglish(day)}');
  }

  String intDayToEnglish(int day) {
    if (day % 7 == DateTime.monday % 7) return 'Monday';
    if (day % 7 == DateTime.tuesday % 7) return 'Tuesday';
    if (day % 7 == DateTime.wednesday % 7) return 'Wednesday';
    if (day % 7 == DateTime.thursday % 7) return 'Thursday';
    if (day % 7 == DateTime.friday % 7) return 'Friday';
    if (day % 7 == DateTime.saturday % 7) return 'Saturday';
    if (day % 7 == DateTime.sunday % 7) return 'Sunday';
    throw '🐞 This should never have happened: $day';
  }

  //timepicker
  final TextEditingController _timeController = TextEditingController();

  // Future<void> _selectTime(BuildContext context) async {
  //   final TimeOfDay? picked = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   );
  //   if (picked != null) {
  //     setState(() {
  //       _timeController.text = DateFormat.Hm().format(
  //         DateTime(
  //           2023, // any year
  //           1, // any month
  //           1, // any day
  //           picked.hour,
  //           picked.minute,
  //         ),
  //       );
  //     });
  //   }
  // }
  final titleController = TextEditingController();
  final subtitleController = TextEditingController();

  String? title;
  String? subtitle;

  bool hasReminders = true;
  List<TimeOfDay> reminders = [TimeOfDay(hour: 7, minute: 0)];

  IconData iconData = Icons.brightness_1;
  Color iconColor = Colors.grey;

  _getWeekdays(List<bool?> weekdaysBool) {
    List days = [
      'sunday',
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday'
    ];
    List<String> res = [];

    for (int i = 0; i < weekdaysBool.length; i++) {
      if (weekdaysBool[i]!) {
        res.add(days[i]);
      }
    }

    return res;
  }

  _pickIcon() async {
    IconData? icon = await FlutterIconPicker.showIconPicker(context,
        iconPackModes: [IconPack.material]);

    if (icon != null) {
      setState(() {
        iconData = icon;
      });
    }
  }

  buildColorPicker() => ColorPicker(
        pickerColor: iconColor,
        onColorChanged: (value) {
          setState(() {
            iconColor = value;
          });
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'Create\nHabit',
        hasLeading: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
              child: Center(
                heightFactor: 3,
                child: Container(
                  width: 295,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: TabBar(
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.grey[200],
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    controller: tabController,
                    isScrollable: false,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 25),
                    tabs: const [
                      Tab(
                        child: Text(
                          'Choose',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Create',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('habitTemplates')
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
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data!.size,
                        separatorBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.all(10),
                          );
                        },
                        itemBuilder: (context, cardIndex2) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black12),
                              ),
                              child: ListTile(
                                onTap: () async {
                                  var pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );
                                  if (pickedTime != null) {
                                    setState(() {
                                      weekdaysBool = List.filled(7, true);
                                      iconData = IconData(
                                        int.parse(
                                            snapshot.data!.docs[cardIndex2]
                                            ['icondata'],
                                            radix: 16),
                                        fontFamily: 'MaterialIcons',
                                      );
                                      iconColor = Color(int.parse(snapshot
                                          .data!.docs[cardIndex2]['iconColor']));
                                    });
                                    reminders[0] = pickedTime;
                                    titleController.text = snapshot
                                        .data!.docs[cardIndex2]['title'];
                                    subtitleController.text = '${
                                      snapshot.data!.docs[cardIndex2]
                                          ['description']
                                    } ${pickedTime.format(context)}';
                                    tabController!.animateTo(1);
                                  }
                                },
                                textColor: Colors.black,
                                iconColor: Color(int.parse(snapshot
                                    .data!.docs[cardIndex2]['iconColor'])),
                                leading: Container(
                                  margin: EdgeInsets.only(left: 8),
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
                                  ),
                                ),
                                title: Text(
                                    snapshot.data!.docs[cardIndex2]['title']),
                                subtitle: Text(snapshot.data!.docs[cardIndex2]
                                    ['subtitle']),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              'Whats your habit called',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            child: TextFormField(
                              controller: titleController,
                              keyboardType: TextInputType.text,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                hintText: 'Ex: jogging',
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Please enter a title for the habit';
                                } else if (val.length > 30) {
                                  return 'Title should be less than 30 characters';
                                }
                                return null;
                              },
                              onSaved: (val) {
                                setState(() {
                                  title = val;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              'Provide a short Description',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            child: TextFormField(
                              controller: subtitleController,
                              keyboardType: TextInputType.text,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                hintText: 'Ex: Goo for jogging at 6:00am',
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Please enter a description';
                                } else if (val.length > 60) {
                                  return 'Description should be less than 60 characters';
                                }
                                return null;
                              },
                              onSaved: (val) {
                                setState(() {
                                  subtitle = val;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Text(
                              'Pick days for your habit',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: WeekdaySelector(
                              onChanged: (v) {
                                // printIntAsDay(v);
                                setState(() {
                                  weekdaysBool[v % 7] = !weekdaysBool[v % 7]!;
                                });
                              },
                              values: weekdaysBool,
                              selectedFillColor: kPrimaryColour,
                              elevation: 0,
                              selectedElevation: 0,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Enable reminders',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Switch(
                                  value: hasReminders,
                                  onChanged: (val) {
                                    setState(() {
                                      hasReminders = val;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          if (hasReminders)
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ReminderChips(
                                reminders: reminders,
                              ),
                            ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    TextButton(
                                      onPressed: _pickIcon,
                                      child: Text(
                                        'Pick an icon',
                                        style: TextStyle(
                                          color: kPrimaryColour,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text('Pick a color'),
                                            content: buildColorPicker(),
                                            actions: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      kPrimaryColour,
                                                  elevation: 0,
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Select'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Pick a color',
                                        style: TextStyle(
                                          color: kPrimaryColour,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    iconData,
                                    color: iconColor,
                                    size: 70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryColour,
                                elevation: 0,
                                minimumSize: Size(double.infinity, 60),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();

                                  for(int i=0; i<weekdaysBool.length; i++) {
                                    if(weekdaysBool[i]!) break;
                                    if(i == weekdaysBool.length - 1) {
                                      Fluttertoast.showToast(msg: 'Select weekdays to track your habit');
                                      return;
                                    }
                                  }

                                  Map<String, dynamic> habit = {
                                    'email': FirebaseAuth
                                        .instance.currentUser!.email,
                                    'title': title,
                                    'subtitle': subtitle,
                                    'iconColor':
                                        '0x${iconColor.value.toRadixString(16).padLeft(8, '0')}',
                                    'icondata':
                                        iconData.codePoint.toRadixString(16),
                                    'weekdays': _getWeekdays(weekdaysBool),
                                    'rewards': [0],
                                    'doneDates': [],
                                    'notDoneDates': [],
                                    'activeStreak': 0,
                                    'longestStreak': 0,
                                    'totalActiveDays': 0,
                                    'currentStatus': 1,
                                  };
                                  if (hasReminders) {
                                    habit['reminders'] = reminders.map(
                                      (time) => DateTime(
                                        DateTime.now().year,
                                        DateTime.now().month,
                                        DateTime.now().day,
                                        time.hour,
                                        time.minute,
                                      ),
                                    );
                                  } else {
                                    habit['reminders'] = [];
                                  }

                                  await FirebaseFirestore.instance
                                      .collection('habits')
                                      .add(habit);
                                  Navigator.pop(context);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  'Create habit',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
