import 'dart:collection';

import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';

import 'callLogs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  CallLogs cl = CallLogs();
  late Future<Iterable<CallLogEntry>> logs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    logs = cl.getCallLogs();
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
        logs = cl.getCallLogs();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('전화 기록'),
          toolbarHeight: 60,
          backgroundColor: Colors.black26,
        ),
        body: Column(
          children: [
            //TextField(controller: t1, decoration: InputDecoration(labelText: "Phone number", contentPadding: EdgeInsets.all(10), suffixIcon: IconButton(icon: Icon(Icons.phone), onPressed: (){print("pressed");})),keyboardType: TextInputType.phone, textInputAction: TextInputAction.done, onSubmitted: (value) => call(value),),
            FutureBuilder<Iterable<CallLogEntry>>(
                future: logs,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Iterable<CallLogEntry>? entries = snapshot.data;
                    return Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Text(
                                    " 총 통화 : ${snapshot.data!.length.toString()}"),
                                Ranking(entries!),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 20,
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  child: Card(
                                    child: ListTile(
                                      leading: cl.getAvator(
                                          entries.elementAt(index).callType!),
                                      title:
                                          cl.getTitle(entries.elementAt(index)),
                                      subtitle: Text(cl.formatDate(new DateTime
                                                  .fromMillisecondsSinceEpoch(
                                              entries
                                                  .elementAt(index)
                                                  .timestamp!)) +
                                          "\n" +
                                          cl.getTime(entries
                                              .elementAt(index)
                                              .duration!)),
                                      isThreeLine: true,
                                      trailing: IconButton(
                                          icon: Icon(Icons.phone),
                                          color: Colors.green,
                                          onPressed: () {
                                            //cl.call(entries.elementAt(index).number!);
                                          }),
                                    ),
                                  ),
                                  onLongPress: () => {print('call')},
                                );
                              },
                              itemCount: entries.length,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                })
          ],
        ),
      ),
    );
  }

  Ranking(Iterable<CallLogEntry> entry){
    Map my_map = {};
    var rs = entry.fold(0, (previousValue, element) {
      if(my_map.containsKey(element.number)){
        my_map[element.number] += element.duration;
      }
      else{
        my_map[element.number] = element.duration;
      }
      return element.duration! + (previousValue as num);
    });

    final sortedValuesDesc = SplayTreeMap<String, dynamic>.from(
        my_map, (keys1, keys2) => my_map[keys2]!.compareTo(my_map[keys1]!));
    print(sortedValuesDesc);

    var first = sortedValuesDesc.keys.toList()[0];
    var first_ = sortedValuesDesc.values.toList()[0];
    var second = sortedValuesDesc.keys.toList()[1];
    


    var hour;
    var min;
    var sec;

    if(rs >= 3600){
      hour = (rs / 3600).toInt();
      rs = rs - hour*3600;
      min = (rs/60).toInt();
      rs = rs - min*60;
      sec = rs;

      return Column(
        children: [
          Text(" 총 시간 : ${hour.toString()}시간 ${min.toString()}분 ${sec}초"),
          Text(" 총 시간 : ${first} -> ${first_}"),

        ],
      );
    }
    else if(rs<3600 && rs>=60){
      min = (rs/60).toInt();
      rs = rs - min*60;
      sec = rs;
      return Text(" 총 시간 : ${min.toString()}분 ${sec}초");
    }else{
      return Text(" 총 시간 : ${sec}초");
    }




  }

}
