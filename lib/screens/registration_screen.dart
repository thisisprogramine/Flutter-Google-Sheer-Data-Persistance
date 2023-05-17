import 'package:flutter/material.dart';
import 'package:google_sheets_data/model/member.dart';
import 'package:google_sheets_data/screens/homepage.dart';
import 'package:intl/intl.dart';

import '../api/sheet/member_sheet_api.dart';
class RegistrationScreen extends StatefulWidget {
  final Members? members;

  RegistrationScreen({
    this.members,
  });

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool isEnable = true;
  late TextEditingController controller_1;
  late TextEditingController controller_2;
  late TextEditingController controller_3;
  late TextEditingController controller_4;
  late TextEditingController controller_5;
  late TextEditingController controller_6;
  late TextEditingController controller_7;
  late TextEditingController controller_8;
  late TextEditingController controller_9;
  late TextEditingController controller_10;
  late TextEditingController controller_11;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller_1 = TextEditingController();
    controller_2 = TextEditingController();
    controller_3 = TextEditingController();
    controller_3.text = '--select--';
    controller_4 = TextEditingController();
    controller_5 = TextEditingController();
    controller_6 = TextEditingController();
    controller_6.text = '--select--';
    controller_7 = TextEditingController();
    controller_8 = TextEditingController();
    controller_9 = TextEditingController();
    controller_10 = TextEditingController();
    controller_11 = TextEditingController();

    if(widget.members != null)
      initField(members: widget.members);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller_1.dispose();
    controller_2.dispose();
    controller_3.dispose();
    controller_4.dispose();
    controller_5.dispose();
    controller_6.dispose();
    controller_7.dispose();
    controller_8.dispose();
    controller_9.dispose();
    controller_10.dispose();
    controller_11.dispose();
  }

  List<Widget> getSaveList() {
    return [IconButton(
        onPressed: () async {
          if(controller_1.text.isNotEmpty && controller_2.text.isNotEmpty && controller_3.text.isNotEmpty && controller_3.text != '--select--' && controller_4.text.isNotEmpty && controller_5.text.isNotEmpty && controller_6.text.isNotEmpty && controller_6.text != '--select--' && controller_7.text.isNotEmpty && controller_8.text.isNotEmpty && controller_9.text.isNotEmpty && controller_10.text.isNotEmpty && controller_11.text.isNotEmpty) {
            if(widget.members == null) {
              final id = await MemberSheetApi.getRowCount()+1;
              final member = getModel().copy(sr: id);
              await MemberSheetApi.insert([member.toJson()]);
            }else {
              final id = widget.members!.sr;
              final member = getModel().copy(sr: id);
              await MemberSheetApi.update(id!, member.toJson());
            }
            final tokens = await HomePage.getTokens();
            HomePage.sendNotification(title: 'Agrogenix', body: 'New Member Added\n ${controller_4.text}', userToken: tokens);
            Navigator.of(context).pop();
          }else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('All Fields are required'),));
          }
        },
        icon: Icon(Icons.check)
    )];
  }
  List<Widget> getDeleteList() {
    return [
      IconButton(
          onPressed: () {
            setState(() {
              isEnable = true;
            });
          },
          icon: Icon(Icons.edit)
      ),
      IconButton(
          onPressed: () async {
            await MemberSheetApi.deleteById(widget.members!.sr ?? -1);
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.delete)
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
        automaticallyImplyLeading: false,
        actions: isEnable ? getSaveList() : getDeleteList(),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            fieldMember(title: 'Member number', controller: controller_1, isNumber: true),
            fieldMember(title: 'Share number', controller: controller_2, isNumber: true),
            fieldMember(title: 'Reg Date', controller: controller_3, isNumber: false, isDateField: true),
            fieldMember(title: 'Full name', controller: controller_4, isNumber: false),
            fieldMember(title: 'Adhar number', controller: controller_5, isNumber: true),
            fieldMember(title: 'Gender', controller: controller_6, isNumber: false, isGenderField: true),
            fieldMember(title: 'Address', controller: controller_7, isNumber: false),
            fieldMember(title: 'Account number', controller: controller_8, isNumber: true),
            fieldMember(title: 'Group number', controller: controller_9, isNumber: true),
            fieldMember(title: 'Number of shares', controller: controller_10, isNumber: true),
            fieldMember(title: 'Mobile Number', controller: controller_11, isNumber: true),
          ],
        ),
      )
    );
  }

  Widget fieldMember({title, controller, isNumber, isDateField = false, isGenderField = false}) {
    DateTime currentDate = DateTime.now();
    String? _dropDownValue;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Container(
            width: MediaQuery.of(context).size.width *0.50,
            child: isDateField ? GestureDetector(
              onTap: isEnable ? () {
                showDate(context);
              } : null,
              child: TextField(
                keyboardType: TextInputType.text,
                enabled: false,
                controller: controller,
                cursorColor: Colors.black,
                cursorWidth: 1.0,
              ),
            ) : isGenderField ? GestureDetector(
              onTap: isEnable ? () {
                showDialogBox();
              } : null,
              child: TextField(
                keyboardType: TextInputType.text,
                enabled: false,
                controller: controller,
                cursorColor: Colors.black,
                cursorWidth: 1.0,
              ),
            ) : TextField(
              keyboardType: isNumber ? TextInputType.number : TextInputType.text,
              enabled: isEnable,

              controller: controller,
              cursorColor: Colors.black,
              cursorWidth: 1.0,
            ),
          )
        ],
      ),
    );
  }

  void showDialogBox() {
    int groupValue = 0;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Select Gender'),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RadioListTile(
                        title: Text('Male'),
                        activeColor: Theme.of(context).colorScheme.secondary,
                        value: 0,
                        selected: groupValue == 0 ? true : false,
                        groupValue: groupValue,
                        onChanged: (value) {
                          setState(() {
                            groupValue = value as int;
                          });
                        }
                    ),
                    RadioListTile(
                        title: Text('Female'),
                        activeColor: Theme.of(context).colorScheme.secondary,
                        value: 1,
                        selected: groupValue == 1 ? true : false,
                        groupValue: groupValue,
                        onChanged: (value) {
                          setState(() {
                            groupValue = value as int;
                          });
                        }
                    ),
                  ],
                );
              },
            ),
            actions: [
              ElevatedButton(
                // textColor: Colors.black,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('CANCEL'),
              ),
              ElevatedButton(
                // textColor: Colors.black,
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    if(groupValue == 0){
                      controller_6.text = 'Male';
                    }else if(groupValue == 1){
                      controller_6.text = 'Female';
                    }
                  });
                },
                child: Text('DONE'),
              )
            ],
          );
        }
    );
  }

  Future<void> showDate(BuildContext context) async{
    DateTime currentDate = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        controller_3.text = DateFormat('dd/MM/yyyy').format(pickedDate).toString();
      });
  }

  Members getModel() {
    return Members(
        sr: 0,
        member_number: controller_1.text,
        share_number: controller_2.text,
        registration_date: controller_3.text,
        full_name: controller_4.text,
        adhar_number: controller_5.text,
        gender: controller_6.text,
        address: controller_7.text,
        account_number: controller_8.text,
        group_number: controller_9.text,
        numbers_of_shares: controller_10.text,
        mobile_number: controller_11.text);
  }

  void initField({Members? members}) {
    controller_1.text = members?.member_number ?? '';
    controller_2.text = members?.share_number ?? '';
    controller_3.text = members?.registration_date ?? '';
    controller_4.text = members?.full_name ?? '';
    controller_5.text = members?.adhar_number ?? '';
    controller_6.text = members?.gender ?? '';
    controller_7.text = members?.address ?? '';
    controller_8.text = members?.account_number ?? '';
    controller_9.text = members?.group_number ?? '';
    controller_10.text = members?.numbers_of_shares ?? '';
    controller_11.text = members?.mobile_number ?? '';
    isEnable = false;
  }
}

