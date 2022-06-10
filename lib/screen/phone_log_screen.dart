import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';
import 'package:google_fonts/google_fonts.dart';
import './callLogs.dart';
import 'dart:developer';

class PhonelogsScreen extends StatefulWidget {
  @override
  _PhonelogsScreenState createState() => _PhonelogsScreenState();
}

class _PhonelogsScreenState extends State<PhonelogsScreen>
    with WidgetsBindingObserver {
  //Iterable<CallLogEntry> entries;
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
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '전화 기록',
          style: GoogleFonts.gaegu(
              textStyle: TextStyle(color: Colors.white, fontSize: 25)),
        ),
        toolbarHeight: 60,
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        //print(cl.getDate(new DateTime.fromMillisecondsSinceEpoch(entries!.elementAt(index).timestamp!)));
                        final aa = cl.getDate(new DateTime.fromMillisecondsSinceEpoch(entries!.elementAt(index).timestamp!));

                        if(index==0){
                          return Column(
                            children: [
                              Text(aa.toString(),style: TextStyle(color: Colors.white,fontSize: 25), ),
                              GestureDetector(
                                child: Card(
                                  color: Colors.grey.shade800 ,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.white,width: 3
                                    ),
                                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                                  ),
                                  child: ListTile(
                                    leading: cl.getAvator(
                                        entries.elementAt(index).callType!),
                                    title: cl.getTitle(entries.elementAt(index)),
                                    subtitle: Text(cl.formatDate(
                                        new DateTime.fromMillisecondsSinceEpoch(
                                            entries
                                                .elementAt(index)
                                                .timestamp!)) +
                                        "\n" +
                                        cl.getTime(
                                            entries.elementAt(index).duration!),style: TextStyle(color: Colors.white),),
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
                              ),
                            ],
                          );
                        }
                        else if(aa == cl.getDate(new DateTime.fromMillisecondsSinceEpoch(entries.elementAt(index-1).timestamp!))){
                          return GestureDetector(
                            child: Card(
                              color: Colors.grey.shade800 ,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.white,width: 3
                                ),
                                borderRadius: const BorderRadius.all(Radius.circular(12)),
                              ),
                              child: ListTile(
                                leading: cl.getAvator(
                                    entries.elementAt(index).callType!),
                                title: cl.getTitle(entries.elementAt(index)),
                                subtitle: Text(cl.formatDate(
                                    new DateTime.fromMillisecondsSinceEpoch(
                                        entries
                                            .elementAt(index)
                                            .timestamp!)) +
                                    "\n" +
                                    cl.getTime(
                                        entries.elementAt(index).duration!),style: TextStyle(color: Colors.white),),
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
                        }
                        else{
                          return Column(
                            children: [
                              Text(aa.toString(),style: TextStyle(color: Colors.white,fontSize: 25), ),
                              GestureDetector(
                                child: Card(
                                  color: Colors.grey.shade800 ,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.white,width: 3
                                    ),
                                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                                  ),
                                  child: ListTile(
                                    leading: cl.getAvator(
                                        entries.elementAt(index).callType!),
                                    title: cl.getTitle(entries.elementAt(index)),
                                    subtitle: Text(cl.formatDate(
                                        new DateTime.fromMillisecondsSinceEpoch(
                                            entries
                                                .elementAt(index)
                                                .timestamp!)) +
                                        "\n" +
                                        cl.getTime(
                                            entries.elementAt(index).duration!),style: TextStyle(color: Colors.white),),
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
                              ),
                            ],
                          );
                        }
                        return GestureDetector(
                          child: Card(
                            color: Colors.grey.shade800 ,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.white,width: 3
                              ),
                              borderRadius: const BorderRadius.all(Radius.circular(12)),
                            ),
                            child: ListTile(
                              leading: cl.getAvator(
                                  entries.elementAt(index).callType!),
                              title: cl.getTitle(entries.elementAt(index)),
                              subtitle: Text(cl.formatDate(
                                      new DateTime.fromMillisecondsSinceEpoch(
                                          entries
                                              .elementAt(index)
                                              .timestamp!)) +
                                  "\n" +
                                  cl.getTime(
                                      entries.elementAt(index).duration!),style: TextStyle(color: Colors.white),),
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
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              })
        ],
      ),
    );
  }


}
