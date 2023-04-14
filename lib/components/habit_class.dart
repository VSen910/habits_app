import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habits/constants.dart';
class HabitDetails{
   String habit_name;
   String habit_description;
   int status_icon;
   IconData habit_icon;
  List<DateTime> completedDays;
  List<DateTime> notDoneDays;



   HabitDetails( this.habit_name, this.habit_description, this.status_icon,
      this.habit_icon, this.completedDays, this.notDoneDays);

   Color? get_color(){
     if(habit_icon == Icons.directions_walk)
       return kDirectionWalkingYellow;


   }


}