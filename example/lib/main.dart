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
      title: 'JHijri Picker Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _jHijriDate = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hijri Date Converter"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(_jHijriDate),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          getDate();
        },
        child: const Icon(Icons.cached),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  getDate() {
    final jh1 = JHijri.now();
    final jh2 = JHijri(fMonth: 2, fYear: 1444, fDay: 11);
    final jh3 = JHijri(fDate: DateTime.parse("1984-12-24"));
    setState(() {
      _jHijriDate = '''
      ${jh1.dateTime.toString()}
      ${jh1.hijri.westernDate.toString()}
      ${jh2.hijri.toString()}
      ${jh3.hijri.toMap().toString()}
      ''';
    });
  }
}
