import 'dart:collection';
import 'package:share_plus/share_plus.dart';
import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'callLogs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final TextStyle whiteText = TextStyle(color: Colors.white);
  CallLogs cl = CallLogs();
  late Future<Iterable<CallLogEntry>> logs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    logs = cl.getToday();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

    if (AppLifecycleState.resumed == state) {
      setState(() {
        logs = cl.getToday();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Today'history",
          style: GoogleFonts.gaegu(
              textStyle: TextStyle(color: Colors.white, fontSize: 25)),
        ),
        toolbarHeight: 60,
        actions: [
          IconButton(
              onPressed: () async {
                await Share.share("공유하기 테스트");
              },
              icon: Icon(Icons.share))
        ],
      ),
      body: Column(
        children: [
          FutureBuilder<Iterable<CallLogEntry>>(
              future: logs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Iterable<CallLogEntry>? entries = snapshot.data;

                  return Ranking(entries!);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ],
      ),
    );
  }

  Ranking(Iterable<CallLogEntry> entry) {
    Map my_map = {};
    var rs = entry.fold(0, (previousValue, element) {
      if (my_map.containsKey(element.number)) {
        my_map[element.number][0] += element.duration;
        my_map[element.number][3] += 1;
      } else {
        my_map[element.number] = [
          element.duration,
          element.name,
          element.formattedNumber,
          1
        ];
      }
      return element.duration! + (previousValue as num);
    });
    print(my_map);
    final sortedValuesDesc = SplayTreeMap<String, dynamic>.from(my_map,
        (keys1, keys2) => my_map[keys2][0]!.compareTo(my_map[keys1][0]!));
    print(sortedValuesDesc);

    final sortedValuesDesc2 = SplayTreeMap<String, dynamic>.from(my_map,
        (keys1, keys2) => my_map[keys2][3]!.compareTo(my_map[keys1][3]!));

    var todayBest;
    var todayBest2;
    if (entry.length > 0) {
      todayBest = sortedValuesDesc.values.toList()[0][1];
      if (todayBest == null) {
        todayBest = sortedValuesDesc.values.toList()[0][2];
      }
    } else {
      todayBest = "";
    }
    var toHour;
    var toMin;
    var toSec;
    bool toIsHour = false;
    bool toIsMin = false;
    var bestTime = sortedValuesDesc.values.toList()[0][0];
    print(bestTime);
    if (bestTime >= 3600) {
      toIsHour = true;
      toHour = (bestTime / 3600).toInt();
      bestTime = bestTime - toHour * 3600;
      toMin = (bestTime / 60).toInt();
      bestTime = bestTime - toMin * 60;
      toSec = bestTime;
    } else if (bestTime < 3600 && bestTime >= 60) {
      toIsMin = true;
      toMin = (bestTime / 60).toInt();
      bestTime = bestTime - toMin * 60;
      toSec = bestTime;
    } else {
      toSec = bestTime;
    }
    print(toHour);
    print(toMin);
    print(toSec);

    var hour;
    var min;
    var sec;
    bool isHour = false;
    bool isMin = false;

    if (rs >= 3600) {
      isHour = true;
      hour = (rs / 3600).toInt();
      rs = rs - hour * 3600;
      min = (rs / 60).toInt();
      rs = rs - min * 60;
      sec = rs;
    } else if (rs < 3600 && rs >= 60) {
      isMin = true;
      min = (rs / 60).toInt();
      rs = rs - min * 60;
      sec = rs;
    } else {
      sec = rs;
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: <Widget>[
                    Nemo(
                        entry,
                        "오늘의 통화시간",
                        isHour
                            ? Text(
                                "${hour.toString()}시간 ${min.toString()}분 ${sec}초",
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                ))
                            : isMin
                                ? Text("${min.toString()}분 ${sec}초",
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                    ))
                                : Text("${sec}초",
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                    )),
                        Colors.deepOrangeAccent),
                    const SizedBox(height: 10.0),
                    Nemo(
                        entry,
                        "오늘의 통화건수",
                        Text("${entry.length.toString()} 건",
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            )),
                        Colors.green),
                    const SizedBox(height: 10.0),
                    Nemo(
                        entry,
                        "누구랑 가장 오래 통화했어?",
                        toIsHour
                            ? Text(
                                "${toHour.toString()}시간 ${toMin.toString()}분 ${toSec}초 with ${todayBest}",
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                ))
                            : toIsMin
                                ? Text(
                                    "${toMin.toString()}분 ${toSec}초 with ${todayBest}",
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                    ))
                                : Text("${toSec}초 with ${todayBest}",
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                    )),
                        Colors.blue),
                    const SizedBox(height: 10.0),
                    Nemo(
                        entry,
                        '누구랑 가장 여러번 통화했어?',
                        Text(
                            "${sortedValuesDesc2.values.toList()[0][3]}통 with ${sortedValuesDesc2.values.toList()[0][1]}",
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            )),
                        Colors.orange),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Nemo(Iterable<CallLogEntry> entry, titleName, result, color) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text(
              titleName,
              style: GoogleFonts.gaegu(
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      decoration: TextDecoration.underline)),
            ),
            trailing: Icon(
              Icons.how_to_vote,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            // child: Text("${entry.length.toString()} 건",
            child: result,
          )
        ],
      ),
    );
  }
}
