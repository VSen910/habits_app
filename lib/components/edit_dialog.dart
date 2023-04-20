import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:habits/constants.dart';

class EditDialog extends StatefulWidget {
  const EditDialog(
      {Key? key,
      required this.habitName,
      required this.habitDesc,
      required this.iconData,
      required this.iconColor,
      required this.habitId})
      : super(key: key);

  final String habitName;
  final String habitDesc;
  final IconData iconData;
  final Color iconColor;
  final String habitId;

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  TextEditingController? _textEditingController1;
  TextEditingController? _textEditingController2;

  IconData? iconData;
  Color? iconColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textEditingController1 = TextEditingController(text: widget.habitName);
    _textEditingController2 = TextEditingController(text: widget.habitDesc);
    iconData = widget.iconData;
    iconColor = widget.iconColor;
  }

  _pickIcon() async {
    IconData? icon = await FlutterIconPicker.showIconPicker(context,
        iconPackModes: [IconPack.material]);

    setState(() {
      iconData = icon;
    });
  }

  buildColorPicker() => ColorPicker(
        pickerColor: iconColor!,
        onColorChanged: (value) {
          setState(() {
            iconColor = value;
          });
        },
      );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text('Edit your habit'),
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              controller: _textEditingController1,
              decoration: InputDecoration(
                labelText: 'Habit name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              controller: _textEditingController2,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    TextButton(
                      onPressed: _pickIcon,
                      child: Text(
                        'Pick an icon',
                        style: TextStyle(color: kPrimaryColour),
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
                                  backgroundColor: kPrimaryColour,
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
                        style: TextStyle(color: kPrimaryColour),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    iconData,
                    color: iconColor,
                    size: 50,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: TextStyle(color: kPrimaryColour),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColour,
            elevation: 0,
          ),
          onPressed: () async {
            final documentReference = FirebaseFirestore.instance
                .collection('habits')
                .doc(widget.habitId);
            await documentReference.update({
              'title': _textEditingController1!.text,
              'subtitle': _textEditingController2!.text,
              'icondata': iconData!.codePoint.toRadixString(16),
              'iconColor': '0x${iconColor!.value.toRadixString(16).padLeft(8, '0')}',
            });
            Navigator.of(context).pop();
          },
          child: Text('Update'),
        ),
      ],
    );
  }
}
