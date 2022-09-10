import 'package:flutter/material.dart';
import 'package:jhijri/jHijri.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            JHijriPicker(
              widgetType: WidgetType.CONTAINER,
              buttons: const SizedBox(),
              primaryColor: Colors.blue,
              calendarTextColor: Colors.white,
              backgroundColor: Colors.black,
              borderRadius: const Radius.circular(10),
              headerTitle: const Center(
                child: Text("التقويم الهجري"),
              ),
              startDate: JHijri(
                fYear: 1442,
                fMonth: 12,
                fDay: 10,
              ),
              selectedDate: JHijri.now(),
              endDate: JHijri(
                fDay: 25,
                fMonth: 1,
                fYear: 1460,
              ),
              pickerMode: DatePickerMode.day,
              themeD: Theme.of(context),
              textDirection: TextDirection.rtl,
              onChange: (val) {
                debugPrint(val.toString());
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "2",
            onPressed: () async {
              getDate();
            },
            tooltip: 'C',
            child: const Icon(Icons.cached),
          ),
          FloatingActionButton(
            heroTag: "4",
            onPressed: () async {
              final sl = JHijri.now();
              final en = JHijri(
                fDay: 25,
                fMonth: 1,
                fYear: 1460,
              );
              final st = JHijri(
                fYear: 1442,
                fMonth: 12,
                fDay: 10,
              );

              HijriDate? dateTime = await showJHijriPicker(
                context: context,
                startDate: st,
                selectedDate: sl,
                endDate: en,
                pickerMode: DatePickerMode.day,
                theme: Theme.of(context),
                textDirection: TextDirection.rtl,
                //locale: const Locale("ar", "SA"),
                okButton: "حفظ",
                cancelButton: "عودة",
                onChange: (val) {
                  debugPrint(val.toString());
                },
                onOk: (value) {
                  debugPrint(value.toMap().toString());
                  Navigator.pop(context);
                },
                onCancel: () {
                  Navigator.pop(context);
                },
                primaryColor: Colors.blue,
                calendarTextColor: Colors.white,
                backgroundColor: Colors.black,
                borderRadius: const Radius.circular(10),
                buttonTextColor: Colors.white,
                headerTitle: const Center(
                  child: Text("التقويم الهجري"),
                ),
              );
              if (dateTime != null) {
                debugPrint(dateTime.toMap().toString());
              }
            },
            tooltip: 'CC',
            child: const Icon(Icons.cabin),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  getDate() {
    final jh1 = JHijri.now();
    debugPrint(jh1.dateTime.toString());
    debugPrint(jh1.toString());
    final jh2 = JHijri(fMonth: 2, fYear: 1444, fDay: 11);
    debugPrint(jh2.dateTime.toString());
    debugPrint(jh2.hijri.toString());
    final jh3 = JHijri(fDate: DateTime.parse("1984-12-24"));
    debugPrint(jh3.hijri.dayName);
    debugPrint(jh3.fullDate);
  }
}
