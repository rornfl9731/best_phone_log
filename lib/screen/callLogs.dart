import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CallLogs {
  void call(String text) async {
    bool? res = await FlutterPhoneDirectCaller.callNumber(text);
  }

  getAvator(CallType callType) {
    switch (callType) {
      case CallType.outgoing:
        return CircleAvatar(
          maxRadius: 30,
          foregroundColor: Colors.green,
          backgroundColor: Colors.greenAccent,
          child: Icon(Icons.call_made),
        );
      case CallType.missed:
        return CircleAvatar(
          maxRadius: 30,
          foregroundColor: Colors.red[400],
          backgroundColor: Colors.red[400],
          child: Icon(Icons.call_missed),

        );
      case CallType.incoming:
        return CircleAvatar(
          maxRadius: 30,
          foregroundColor: Colors.red[400],
          backgroundColor: Colors.red[400],
          child: Icon(Icons.call_received,color: Colors.blue,),

        );
      default:
        return CircleAvatar(
          maxRadius: 30,
          foregroundColor: Colors.indigo[700],
          backgroundColor: Colors.indigo[700],
          child: Icon(Icons.call_missed,color: Colors.red,),

        );
    }
  }

  Future<Iterable<CallLogEntry>> getCallLogs() {
    return CallLog.get();
  }

  Future<Iterable<CallLogEntry>> getJW() {
    return CallLog.query(
      number: "01099829397"
    );
  }

  Future<Iterable<CallLogEntry>> getToday() {
    return CallLog.query(
        // dateFrom: DateTime.now().subtract(Duration(hours: 10)).millisecondsSinceEpoch,
      dateFrom: DateTime(DateTime.now().year,DateTime.now().month,07,00).millisecondsSinceEpoch,
        dateTo: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,24).millisecondsSinceEpoch
    );
  }

  String formatDate(DateTime dt) {

    return DateFormat('y년 MM월 dd일 HH시mm분').format(dt);
  }

  getTitle(CallLogEntry entry) {
    if (entry.name == null) return Text(entry.number!,style: TextStyle(color: Colors.white));
    if (entry.name!.isEmpty)
      return Text(entry.number!,style: TextStyle(color: Colors.white));
    else
      return Text(entry.name!,style: TextStyle(color: Colors.white));
  }

  String getTime(int duration) {
    Duration d1 = Duration(seconds: duration);
    String formatedDuration = "";
    if (d1.inHours > 0) {
      formatedDuration += d1.inHours.toString() + "시간 ";
    }
    if (d1.inMinutes - (d1.inHours * 60) > 0) {
      formatedDuration += (d1.inMinutes - (d1.inHours * 60)).toString() + "분 ";
    }
    if (d1.inSeconds - (d1.inMinutes * 60) > 0) {
      formatedDuration += (d1.inSeconds - (d1.inMinutes * 60)).toString() + "초";
    }
    if (formatedDuration.isEmpty) return "0초";
    return formatedDuration;
  }
}
