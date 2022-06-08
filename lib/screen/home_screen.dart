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
    logs = cl.getJW();
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
                            flex: 1,
                            child: Row(
                              children: [
                                Text(
                                    " 총 통화 : ${snapshot.data!.length.toString()}"),
                                Text(
                                  "총 통화 시간 : ${snapshot.data.reduce((value, element) => null)}"
                                )
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
                                          entries!.elementAt(index).callType!),
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
                              itemCount: entries!.length,
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
}
