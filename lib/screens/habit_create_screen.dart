import 'package:flutter/material.dart';
import 'package:habits/components/custom_appbar.dart';
import 'package:habits/components/habit_class.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_iconpicker/Models/IconPack.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'package:intl/intl.dart';

class CreateScreen extends StatefulWidget{
  const CreateScreen({Key? key}) : super(key: key);


  @override
  State<CreateScreen> createState() => _CreateScreenState();
}
class _CreateScreenState extends State<CreateScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final HabitName = TextEditingController();
  final Description = TextEditingController();
  final Routine = TextEditingController();
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
    'ac_unit':Icons.ac_unit,
  //  'six__ft_apart': Icons.six_ft_apart,
  };
  final PageController _controller = PageController();
  void _showIconPickerDialog(BuildContext context) async {
    IconData? selectedIcon = await FlutterIconPicker.showIconPicker(context,
      iconPickerShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      //iconPackModes: IconPack.material,
      iconPackModes: [IconPack.material,IconPack.material, IconPack.cupertino],

    );

    // Do something with the selected icon, such as updating your state or saving it to a database
  }

  late List<List<HabitDetails>> habits_list = [
    [
      HabitDetails(
          'Sleep early', 'Choose the time to go to bed', 1, Icons.bedtime, [], [])
    ],
    [
      HabitDetails(
          'Go for a walk', 'Choose the time to g to walk', 1, Icons.directions_walk, [], [])
    ],
    [
      HabitDetails(
          'Meditation', 'Choose the time for meditation', 1, Icons.directions_walk, [], [])
    ]
  ];
  final values = List.filled(7, false);
  printIntAsDay(int day) {
    print('Received integer: $day. Corresponds to day: ${intDayToEnglish(day)}');
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
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _timeController.text = DateFormat.Hm().format(
          DateTime(
            2023, // any year
            1, // any month
            1, // any day
            picked.hour,
            picked.minute,
          ),
        );
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;



    return Scaffold(
      appBar: CustomAppBar(titleText: 'Create Habit', hasLeading: true,),
      body: SafeArea(
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation:0,
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
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[200],
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            controller: tabController,
                            isScrollable: false,
                            labelPadding: const EdgeInsets.symmetric(horizontal: 25),
                            tabs:  const [
                              Tab(
                                child: Text('Standard',
                                    style: TextStyle(color: Colors
                                    .black),
                                ),
                              ),
                              Tab(
                                child: Text('Custom',
                                    style: TextStyle(color: Colors
                                    .black),
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
                    ListView.separated(

                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: habits_list.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return Container(
                          padding: EdgeInsets.all(4),
                        );
                      },
                      itemBuilder: (BuildContext context, int cardIndex2) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(8, 0, 8, 10),
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black12)),
                            child: ListTile(
                              textColor: Colors.black,
                              iconColor: habits_list[cardIndex2][0].get_color(),


                              // shape: RoundedRectangleBorder(
                              //     side: BorderSide(width: 2, color: Colors.black12),
                              //     borderRadius: BorderRadius.circular(10)),

                              leading: Container(
                                margin: EdgeInsets.only(left: 8),
                                height: double.infinity,
                                child: Icon(
                                  habits_list[cardIndex2][0].habit_icon,
                                  size: 28,
                                ),
                              ),
                              title: Text(habits_list[cardIndex2][0].habit_name),
                              subtitle: Text(
                                  habits_list[cardIndex2][0].habit_description),
                              //trailing: (habits_list[cardIndex2][0].status_icon ==
                                  //1)
                                 // ? DoneIcon(onPressed: () {})
                                 // : (habits_list[cardIndex2][0].status_icon == 2)
                                 // ? PendingIcon()
                                 // : NotDoneIcon(),

                            ),
                          ),
                        );
                      },
                    ),
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(16,0,25,0),
                            child: Text(
                              'Whats your habit called',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          const SizedBox(height: 1),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 25, 0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              controller: HabitName,
                              decoration: InputDecoration(
                                // border:InputBorder.none,
                                // enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade401),),
                                // contentPadding: EdgeInsets.only(
                                //     left: 26.0,
                                //     top: 11,
                                //     right: 1.0,
                                //     bottom: 1.0,
                                // ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                hintText: 'Ex: jogging',
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height:31),
                          const Padding(padding: EdgeInsets.fromLTRB(16, 0, 25, 0),
                            child: Text('Provide a short Description',
                              style: TextStyle(color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 25, 0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              controller: Description,
                              decoration: InputDecoration(
                                //border:InputBorder.none,
                                //enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade401),),
                                //contentPadding: EdgeInsets.only(
                                //  left: 26.0,
                                //top: 11,
                                //right: 1.0,
                                //bottom: 1.0,
                                //),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                hintText: 'Ex: Goo for jogging at 6:00am',
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height:30),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(16,0,25,0),
                            child: Text(
                              'Select a time for your habit routine',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 25, 0),
                            child: TextFormField(
                              controller: _timeController,
                              readOnly: true,
                              onTap: (){
                                _selectTime(context);
                              },
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                // border:InputBorder.none,
                                // enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade401),),
                                // contentPadding: EdgeInsets.only(
                                //     left: 26.0,
                                //     top: 11,
                                //     right: 1.0,
                                //     bottom: 1.0,
                                // ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                hintText: 'Ex: 8:30',
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                ),
                                // suffixIcon: IconButton(
                                //   onPressed: (){
                                //     _selectTime(context);
                                //   },
                                //   icon: Icon(Icon.access_time),
                                // ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text('Pick days for your routine'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: WeekdaySelector(
                                  displayedDays: {
                                    DateTime.monday,
                                    DateTime.tuesday,
                                    DateTime.wednesday,
                                    DateTime.thursday,
                                    DateTime.friday,
                                    DateTime.saturday,
                                    DateTime.sunday,
                                  },
                                  onChanged: (v){
                                    printIntAsDay(v);
                                    setState(() {
                                      values[v % 7] = !values[v % 7];
                                    });
                                  },
                                  values: values
                              ),
                            ),

                          const SizedBox(height: 41),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 25, 0),
                            child: GestureDetector(
                              onTap: ()  {
                                print('You tap the screen');
                                _showIconPickerDialog(context);

                              },
                              child: Container(
                                child: Center(
                                  child: Text(
                                    'Pick icon for your habit',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                                width: 341,
                                height: 48,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(11),
                                  border: Border.all(
                                    color: Colors.grey.shade500,
                                    width: 3.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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




