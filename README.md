JHijri Package
-
Converts Date From Gregorian to Hijri and Vice Versa It Also Comes With a Great Date Picker Widget That Easy To Use.

## Features
* Convert DateTime To Hijri
* Convert Hijri To DateTime
* Convert From DateTime or Input
* Hijri Date Picker is Included
* Easy To Use , Customise and Implement

## Usage
To Use `jHijri`

From Input:
-
```dart
final jHijri = JHijri(fMonth: 1, fYear: 1444, fDay: 1);
final jHijri2 = JHijri(fMonth: 1, fYear: 2020, fDay: 1);
```
From DateTime:
-
```dart
final jHijri = JHijri(fDate: DateTime.now());
```
Or:
-
```dart
final jHijri = JHijri.now();
```
To Use `JHijriPicker`

As Dialog:
-

```dart
final val = openDialog(context);
Future<HijriDate?> openDialog(BuildContext context)async{
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
  return dateTiem;
}
```
As Widget:
-
```dart
  class Ex extends StatelessWidget {
  const Ex({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return JHijriPicker(
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
    );
  }
}
```

## Additional information

Provided By [Just Codes Developers](https://jucodes.com/)
