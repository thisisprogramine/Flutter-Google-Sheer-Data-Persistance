import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sheets_data/api/sheet/member_sheet_api.dart';
import 'package:google_sheets_data/model/member.dart';
import 'package:google_sheets_data/model/notification_model.dart';
import 'package:google_sheets_data/screens/registration_screen.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  static final CollectionReference _tokensDB = FirebaseFirestore.instance.collection('Tokens');

  static Future<bool> sendNotification({required String title, required String body, required List<String?> userToken}) async {
    final postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      "registration_ids" : userToken,
      "collapse_key" : "type_a",
      "notification" : {
        "title": title,
        "body" : body,
      }
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=AAAA3gPV2T8:APA91bHu-O8ocJz1edlT8FSwifPeR24vqmNwyv8Rooa3Ngs6mE_2s45St5U4YYxK1XIjq93OcsKG3XHiq1jKTQUgvIFtJbjlx8tcQm4OGkbZC3iL9DgwX3MaSth8BkvpFjCNrvFNZ2Ui' // 'key=YOUR_SERVER_KEY'
    };

    final response = await http.post(Uri.parse(postUrl),
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
      // on success do sth
      print('test ok push CFM');
      return true;
    } else {
      print(' CFM error');
      // on failure do sth
      return false;
    }
  }

  static Future<void> _updateToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    if(token != null) {
      DocumentReference docRef = await _tokensDB.doc(token);
      docRef.set({'token': token});
    }
  }

  static Future<List<String>> getTokens() async {
    List<String> tokenList = [];
    final token = await FirebaseMessaging.instance.getToken();
    await _tokensDB.get().then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        tokenList.add(element['token']);
        print('${element['token']}');
      });
    });
    tokenList.remove(token);
    return tokenList;
  }
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Members>> members;
  late final FirebaseMessaging _messaging;
  late int _totalNotificationCounter;
  late PushNotification _pushNotification;


  Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }

  @override
  void initState() {
    // TODO: implement initState
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
          title: message.notification!.title,
          body: message.notification!.body,
          dataTitle: message.data['title'],
          dataBody: message.data['body']
      );
      setState(() {
        _totalNotificationCounter++;
        _pushNotification = notification;
      });
    });
    registerNotification();
    checkForInitialMessage();
    _totalNotificationCounter = 0;
    HomePage._updateToken();
    super.initState();
    refreshMembers();
  }
  
  void registerNotification() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;
    //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Permission Granted');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        PushNotification notification = PushNotification(
          title: message.notification!.title,
          body: message.notification!.body,
          dataTitle: message.data['title'],
          dataBody: message.data['body']
        );
        setState(() {
          _totalNotificationCounter++;
          _pushNotification = notification;
        });

        if(notification != null) {
          showSimpleNotification(
            Text('${notification.title}'),
            leading: Icon(Icons.notifications_active),
            subtitle: Text('${_pushNotification.body}'),
            background: Colors.black45,
            duration: Duration(seconds: 5),
          );
        }
      });
    }else {
      print('Permission Denied');
    }
  }

  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if(initialMessage != null) {
      PushNotification notification = PushNotification(
          title: initialMessage.notification!.title,
          body: initialMessage.notification!.body,
          dataTitle: initialMessage.data['title'],
          dataBody: initialMessage.data['body']
      );
      setState(() {
        _totalNotificationCounter++;
        _pushNotification = notification;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agrogenix Members'),
        actions: [
          IconButton(
              onPressed: () async  {
                final tokens = await HomePage.getTokens();
                HomePage.sendNotification(title: "Agrogenix", body: "New Member added", userToken: tokens);
              },
              icon: Icon(Icons.notifications)
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(builder: (builder) => RegistrationScreen()));
          refreshMembers();
        },
      ),
      body: Center(
        child: FutureBuilder<List<Members>>(
          future: members,
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              return snapshot.data!.isNotEmpty ? ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index){
                    return ListTile(
                      onTap: () async {
                        await Navigator.of(context).push(MaterialPageRoute(builder: (builder) => RegistrationScreen(members: snapshot.data![index])));
                        refreshMembers();
                      },
                      leading: Text('${index+1}', style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),),
                      title: Text('${snapshot.data![index].full_name}', style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),),
                      subtitle: Text('${snapshot.data![index].address}', style: Theme.of(context).textTheme.subtitle1,),
                    );
                  }
              ) : Center(child: Text('No Members Found'),);
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Future<List<Members>> getMember() async{
    // final member = await MemberSheetApi.getById(2);

    return await MemberSheetApi.getAll();
  }
  refreshMembers() {
    setState(() {
      members = getMember();
    });
  }
}
