import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:jhijri/jHijri.dart';

enum WidgetType {
  DIALOG,
  CONTAINER,
}

typedef SelectableDayPredicate = bool Function(HijriDate day);
Future<HijriDate?> showJHijriPicker({
  required BuildContext context,
  JHijri? selectedDate,
  JHijri? startDate,
  JHijri? endDate,
  DatePickerMode pickerMode = DatePickerMode.day,
  String? okButton,
  String? cancelButton,
  Widget? headerTitle,
  Widget? buttons,
  Function(HijriDate datetime)? onOk,
  Function(HijriDate datetime)? onChange,
  VoidCallback? onCancel,
  ThemeData? theme,
  Color? primaryColor,
  Color? backgroundColor,
  Color? calendarTextColor,
  Color? buttonTextColor,
  Radius? borderRadius,
  TextDirection? textDirection,
  Locale? locale,
}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return JHijriPicker(
        startDate: startDate,
        selectedDate: selectedDate,
        endDate: endDate,
        pickerMode: pickerMode,
        themeD: theme,
        textDirection: textDirection,
        locale: locale,
        okButtonT: okButton,
        cancelButtonT: cancelButton,
        onOk: onOk,
        onCancel: onCancel,
        primaryColor: primaryColor,
        calendarTextColor: calendarTextColor,
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
        buttonTextColor: buttonTextColor,
        headerTitle: headerTitle,
        buttons: buttons,
        widgetType: WidgetType.DIALOG,
        onChange: onChange,
      );
    },
  );
}

class JHijriPicker extends StatelessWidget {
  final JHijri? selectedDate;
  final JHijri? startDate;
  final JHijri? endDate;
  final DatePickerMode? pickerMode;
  final String? okButtonT;
  final String? cancelButtonT;
  final Widget? headerTitle;
  final Function(HijriDate datetime)? onOk;
  final Function(HijriDate datetime)? onChange;
  final VoidCallback? onCancel;
  final ThemeData? themeD;
  final Color? primaryColor;
  final Color? backgroundColor;
  final Color? calendarTextColor;
  final Color? buttonTextColor;
  final Radius? borderRadius;
  final Widget? buttons;
  final WidgetType widgetType;
  final TextDirection? textDirection;
  final Locale? locale;
  JHijriPicker(
      {Key? key,
      this.selectedDate,
      this.startDate,
      this.endDate,
      this.pickerMode,
      this.okButtonT,
      this.cancelButtonT,
      this.headerTitle,
      this.onOk,
      this.onChange,
      this.onCancel,
      this.themeD,
      this.primaryColor,
      this.backgroundColor,
      this.calendarTextColor,
      this.buttonTextColor,
      this.borderRadius,
      this.buttons,
      this.widgetType = WidgetType.DIALOG,
      this.textDirection,
      this.locale})
      : super(key: key) {
    sel = selectedDate != null ? selectedDate!.hijri : HijriDate.now();
  }
  late final HijriDate sel;
  @override
  Widget build(BuildContext context) {
    final theme = themeD ?? Theme.of(context);
    final media = MediaQuery.of(context);
    return _JHijriPicker(
        locale: locale,
        textDirection: textDirection,
        child: _WidgetType(
            widgetType: widgetType,
            child: Theme(
              data: ThemeData(
                colorScheme: theme.colorScheme.copyWith(
                  primary: primaryColor ?? Colors.blue,
                  surface: backgroundColor ?? Colors.white,
                  onSurface: calendarTextColor ?? Colors.black,
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (headerTitle != null) headerTitle!,
                    Container(
                      constraints:
                          BoxConstraints(maxHeight: media.size.height - 120),
                      decoration: BoxDecoration(
                        color: backgroundColor ?? Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: borderRadius ?? const Radius.circular(16),
                            topRight:
                                borderRadius ?? const Radius.circular(16)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          JCalendarDatePicker(
                            initialDate: selectedDate ?? JHijri.now(),
                            firstDate: startDate ?? JHijri(fYear: 2018),
                            lastDate: endDate ?? JHijri(fYear: 2060),
                            onDateChanged: onChange != null
                                ? (dateTime) => onChange!(dateTime)
                                : (dateTime) {
                                    sel = dateTime;
                                  },
                          ),
                        ],
                      ),
                    ),
                    if (buttons != null) buttons!,
                    if (buttons == null)
                      Container(
                        decoration: BoxDecoration(
                          color: backgroundColor ?? Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft:
                                borderRadius ?? const Radius.circular(16),
                            bottomRight:
                                borderRadius ?? const Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      backgroundColor),
                                ),
                                onPressed: onCancel ??
                                    () {
                                      Navigator.pop(context);
                                    },
                                child: Text(
                                  cancelButtonT ?? "Cancel",
                                  style: TextStyle(
                                      color: buttonTextColor ?? Colors.black),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                              child: VerticalDivider(
                                color: Colors.grey,
                              ),
                            ),
                            Expanded(
                              child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      backgroundColor),
                                ),
                                onPressed: onOk != null
                                    ? onOk!(sel)
                                    : () {
                                        Navigator.pop(context, startDate);
                                      },
                                child: Text(
                                  okButtonT ?? "Ok",
                                  style: TextStyle(
                                      color: buttonTextColor ?? Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            )));
  }
}

class _JHijriPicker extends StatelessWidget {
  final TextDirection? textDirection;
  final Locale? locale;
  final Widget child;
  const _JHijriPicker(
      {Key? key, this.textDirection, this.locale, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Localizations.override(
      context: context,
      locale: locale,
      child: textDirection != null
          ? Directionality(
              textDirection: textDirection!,
              child: child,
            )
          : child,
    );
  }
}

class _WidgetType extends StatelessWidget {
  final Widget child;
  final WidgetType widgetType;
  const _WidgetType({Key? key, required this.widgetType, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (widgetType) {
      case WidgetType.DIALOG:
        return Dialog(
          backgroundColor: Colors.transparent,
          alignment: Alignment.center,
          child: child,
        );
      case WidgetType.CONTAINER:
        return Container(
          color: Colors.transparent,
          alignment: Alignment.center,
          child: child,
        );
    }
  }
}

const Duration _monthScrollDuration = Duration(milliseconds: 200);

const double _dayPickerRowHeight = 42.0;
const int _maxDayPickerRowCount = 6; // A 31 day month that starts on Saturday.
// One extra row for the day-of-week header.
const double _maxDayPickerHeight =
    _dayPickerRowHeight * (_maxDayPickerRowCount + 1);
const double _monthPickerHorizontalPadding = 8.0;

const int _yearPickerColumnCount = 3;
const double _yearPickerPadding = 16.0;
const double _yearPickerRowHeight = 52.0;
const double _yearPickerRowSpacing = 8.0;

const double _subHeaderHeight = 52.0;
const double _monthNavButtonsWidth = 108.0;

/// Displays a grid of days for a given month and allows the user to select a
/// date.
///
/// Days are arranged in a rectangular grid with one column for each day of the
/// week. Controls are provided to change the year and month that the grid is
/// showing.
///
/// The calendar picker widget is rarely used directly. Instead, consider using
/// [showDatePicker], which will create a dialog that uses this as well as
/// provides a text entry option.
///
/// See also:
///
///  * [showDatePicker], which creates a Dialog that contains a
///    [JCalendarDatePicker] and provides an optional compact view where the
///    user can enter a date as a line of text.
///  * [showTimePicker], which shows a dialog that contains a Material Design
///    time picker.
///
class JCalendarDatePicker extends StatefulWidget {
  /// Creates a calendar date picker.
  ///
  /// It will display a grid of days for the [initialDate]'s month. The day
  /// indicated by [initialDate] will be selected.
  ///
  /// The optional [onDisplayedMonthChanged] callback can be used to track
  /// the currently displayed month.
  ///
  /// The user interface provides a way to change the year of the month being
  /// displayed. By default it will show the day grid, but this can be changed
  /// to start in the year selection interface with [initialCalendarMode] set
  /// to [DatePickerMode.year].
  ///
  /// The [initialDate], [firstDate], [lastDate], [onDateChanged], and
  /// [initialCalendarMode] must be non-null.
  ///
  /// [lastDate] must be after or equal to [firstDate].
  ///
  /// [initialDate] must be between [firstDate] and [lastDate] or equal to
  /// one of them.
  ///
  /// [currentDate] represents the current day (i.e. today). This
  /// date will be highlighted in the day grid. If null, the date of
  /// `DateTime.now()` will be used.
  ///
  /// If [selectableDayPredicate] is non-null, it must return `true` for the
  /// [initialDate].
  JCalendarDatePicker({
    super.key,
    required JHijri initialDate,
    required JHijri firstDate,
    required JHijri lastDate,
    JHijri? currentDate,
    required this.onDateChanged,
    this.onDisplayedMonthChanged,
    this.initialCalendarMode = DatePickerMode.day,
    this.selectableDayPredicate,
  })  : initialDate = initialDate.hijri,
        firstDate = firstDate.hijri,
        lastDate = lastDate.hijri,
        currentDate = currentDate?.hijri ?? HijriDate.now() {
    assert(
      !this.lastDate.dateTime.isBefore(this.firstDate.dateTime),
      'lastDate ${this.lastDate} must be on or after firstDate ${this.firstDate}.',
    );
    assert(
      !this.initialDate.dateTime.isBefore(this.firstDate.dateTime),
      'initialDate ${this.initialDate} must be on or after firstDate ${this.firstDate}.',
    );
    assert(
      !this.initialDate.dateTime.isAfter(this.lastDate.dateTime),
      'initialDate ${this.initialDate} must be on or before lastDate ${this.lastDate}.',
    );
    assert(
      selectableDayPredicate == null ||
          selectableDayPredicate!(this.initialDate),
      'Provided initialDate ${this.initialDate} must satisfy provided selectableDayPredicate.',
    );
  }

  /// The initially selected [HijriDate] that the picker should display.
  final HijriDate initialDate;

  /// The earliest allowable [HijriDate] that the user can select.
  final HijriDate firstDate;

  /// The latest allowable [HijriDate] that the user can select.
  final HijriDate lastDate;

  /// The [DateTime] representing today. It will be highlighted in the day grid.
  final HijriDate currentDate;

  /// Called when the user selects a date in the picker.
  final ValueChanged<HijriDate> onDateChanged;

  /// Called when the user navigates to a new month/year in the picker.
  final ValueChanged<HijriDate>? onDisplayedMonthChanged;

  /// The initial display of the calendar picker.
  final DatePickerMode initialCalendarMode;

  /// Function to provide full control over which dates in the calendar can be selected.
  final SelectableDayPredicate? selectableDayPredicate;

  @override
  State<JCalendarDatePicker> createState() => _JCalendarDatePickerState();
}

class _JCalendarDatePickerState extends State<JCalendarDatePicker> {
  bool _announcedInitialDate = false;
  late DatePickerMode _mode;
  late HijriDate _currentDisplayedMonthDate;
  late HijriDate _selectedDate;
  final GlobalKey _monthPickerKey = GlobalKey();
  final GlobalKey _yearPickerKey = GlobalKey();
  //late MaterialLocalizations _localizations;
  late TextDirection _textDirection;

  @override
  void initState() {
    super.initState();
    _mode = widget.initialCalendarMode;
    _currentDisplayedMonthDate = JHijri(
            fYear: widget.initialDate.year,
            fMonth: widget.initialDate.month,
            fDay: widget.initialDate.day)
        .hijri;
    _selectedDate = widget.initialDate;
  }

  @override
  void didUpdateWidget(JCalendarDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCalendarMode != oldWidget.initialCalendarMode) {
      _mode = widget.initialCalendarMode;
    }

    if (!widget.initialDate.dateTime
        .isAtSameMomentAs(oldWidget.initialDate.dateTime)) {
      _currentDisplayedMonthDate = JHijri(
              fYear: widget.initialDate.year,
              fMonth: widget.initialDate.month,
              fDay: widget.initialDate.day)
          .hijri;
      _selectedDate = widget.initialDate;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    assert(debugCheckHasDirectionality(context));
    // _localizations = MaterialLocalizations.of(context);
    _textDirection = Directionality.of(context);
    if (!_announcedInitialDate) {
      _announcedInitialDate = true;
      SemanticsService.announce(
        _selectedDate.toString(),
        _textDirection,
      );
    }
  }

  void _vibrate() {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        HapticFeedback.vibrate();
        break;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        break;
    }
  }

  void _handleModeChanged(DatePickerMode mode) {
    _vibrate();
    setState(() {
      _mode = mode;
      if (_mode == DatePickerMode.day) {
        SemanticsService.announce(
          _selectedDate.monthName,
          _textDirection,
        );
      } else {
        SemanticsService.announce(
          _selectedDate.year.toString(),
          _textDirection,
        );
      }
    });
  }

  void _handleMonthChanged(HijriDate date) {
    setState(() {
      if (_currentDisplayedMonthDate.year != date.year ||
          _currentDisplayedMonthDate.month != date.month) {
        _currentDisplayedMonthDate =
            JHijri(fYear: date.year, fMonth: date.month, fDay: date.day).hijri;
        widget.onDisplayedMonthChanged?.call(_currentDisplayedMonthDate);
      }
    });
  }

  void _handleYearChanged(HijriDate value) {
    _vibrate();

    if (value.dateTime.isBefore(widget.firstDate.dateTime)) {
      value = widget.firstDate;
    } else if (value.dateTime.isAfter(widget.lastDate.dateTime)) {
      value = widget.lastDate;
    }

    setState(() {
      _mode = DatePickerMode.day;
      _handleMonthChanged(value);
    });
  }

  void _handleDayChanged(HijriDate value) {
    _vibrate();
    setState(() {
      _selectedDate = value;
      widget.onDateChanged(_selectedDate);
    });
  }

  Widget _buildPicker() {
    switch (_mode) {
      case DatePickerMode.day:
        return _JMonthPicker(
          key: _monthPickerKey,
          initialMonth: _currentDisplayedMonthDate,
          currentDate: widget.currentDate,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          selectedDate: _selectedDate,
          onChanged: _handleDayChanged,
          onDisplayedMonthChanged: _handleMonthChanged,
          selectableDayPredicate: widget.selectableDayPredicate,
        );
      case DatePickerMode.year:
        return Padding(
          padding: const EdgeInsets.only(top: _subHeaderHeight),
          child: JYearPicker(
            key: _yearPickerKey,
            currentDate: widget.currentDate,
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
            initialDate: _currentDisplayedMonthDate,
            selectedDate: _selectedDate,
            onChanged: _handleYearChanged,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    assert(debugCheckHasDirectionality(context));
    return Stack(
      children: <Widget>[
        SizedBox(
          height: _subHeaderHeight + _maxDayPickerHeight,
          child: _buildPicker(),
        ),

        // Put the mode toggle button on top so that it won't be covered up by the _MonthPicker
        _JDatePickerModeToggleButton(
          mode: _mode,
          year: _currentDisplayedMonthDate.year.toString(),
          onTitlePressed: () {
            // Toggle the day/year mode.
            _handleModeChanged(_mode == DatePickerMode.day
                ? DatePickerMode.year
                : DatePickerMode.day);
          },
        ),
      ],
    );
  }
}

/// A button that used to toggle the [DatePickerMode] for a date picker.
///
/// This appears above the calendar grid and allows the user to toggle the
/// [DatePickerMode] to display either the calendar view or the year list.
class _JDatePickerModeToggleButton extends StatefulWidget {
  const _JDatePickerModeToggleButton({
    required this.mode,
    required this.onTitlePressed,
    required this.year,
  });

  /// The current display of the calendar picker.
  final DatePickerMode mode;

  /// The text that displays the current month/year being viewed.
  final String year;

  /// The callback when the title is pressed.
  final VoidCallback onTitlePressed;

  @override
  _JDatePickerModeToggleButtonState createState() =>
      _JDatePickerModeToggleButtonState();
}

class _JDatePickerModeToggleButtonState
    extends State<_JDatePickerModeToggleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: widget.mode == DatePickerMode.year ? 0.5 : 0,
      upperBound: 0.5,
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(_JDatePickerModeToggleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mode == widget.mode) {
      return;
    }

    if (widget.mode == DatePickerMode.year) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color controlColor = colorScheme.onSurface.withOpacity(0.60);

    return Container(
      padding: const EdgeInsetsDirectional.only(start: 16, end: 4),
      height: _subHeaderHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Flexible(
            child: Semantics(
              label: "Hello",
              excludeSemantics: true,
              button: true,
              child: SizedBox(
                height: _subHeaderHeight,
                child: InkWell(
                  onTap: widget.onTitlePressed,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            widget.year,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.subtitle2?.copyWith(
                              color: controlColor,
                            ),
                          ),
                        ),
                        RotationTransition(
                          turns: _controller,
                          child: Icon(
                            Icons.arrow_drop_down,
                            color: controlColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (widget.mode == DatePickerMode.day)
            // Give space for the prev/next month buttons that are underneath this row
            const SizedBox(width: _monthNavButtonsWidth),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _JMonthPicker extends StatefulWidget {
  /// Creates a month picker.
  _JMonthPicker({
    super.key,
    required this.initialMonth,
    required this.currentDate,
    required this.firstDate,
    required this.lastDate,
    required this.selectedDate,
    required this.onChanged,
    required this.onDisplayedMonthChanged,
    this.selectableDayPredicate,
  })  : assert(!firstDate.dateTime.isAfter(lastDate.dateTime)),
        assert(!selectedDate.dateTime.isBefore(firstDate.dateTime)),
        assert(!selectedDate.dateTime.isAfter(lastDate.dateTime));

  /// The initial month to display.
  final HijriDate initialMonth;

  /// The current date.
  ///
  /// This date is subtly highlighted in the picker.
  final HijriDate currentDate;

  /// The earliest date the user is permitted to pick.
  ///
  /// This date must be on or before the [lastDate].
  final HijriDate firstDate;

  /// The latest date the user is permitted to pick.
  ///
  /// This date must be on or after the [firstDate].
  final HijriDate lastDate;

  /// The currently selected date.
  ///
  /// This date is highlighted in the picker.
  final HijriDate selectedDate;

  /// Called when the user picks a day.
  final ValueChanged<HijriDate> onChanged;

  /// Called when the user navigates to a new month.
  final ValueChanged<HijriDate> onDisplayedMonthChanged;

  /// Optional user supplied predicate function to customize selectable days.
  final SelectableDayPredicate? selectableDayPredicate;

  @override
  _JMonthPickerState createState() => _JMonthPickerState();
}

class _JMonthPickerState extends State<_JMonthPicker> {
  final GlobalKey _pageViewKey = GlobalKey();
  late HijriDate _currentMonth;
  late PageController _pageController;
  late MaterialLocalizations _localizations;
  late TextDirection _textDirection;
  Map<ShortcutActivator, Intent>? _shortcutMap;
  Map<Type, Action<Intent>>? _actionMap;
  late FocusNode _dayGridFocus;
  HijriDate? _focusedDay;

  @override
  void initState() {
    super.initState();
    _currentMonth = widget.initialMonth;
    _pageController = PageController(
        initialPage: _monthDelta(widget.firstDate, _currentMonth));
    _shortcutMap = const <ShortcutActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.arrowLeft):
          DirectionalFocusIntent(TraversalDirection.left),
      SingleActivator(LogicalKeyboardKey.arrowRight):
          DirectionalFocusIntent(TraversalDirection.right),
      SingleActivator(LogicalKeyboardKey.arrowDown):
          DirectionalFocusIntent(TraversalDirection.down),
      SingleActivator(LogicalKeyboardKey.arrowUp):
          DirectionalFocusIntent(TraversalDirection.up),
    };
    _actionMap = <Type, Action<Intent>>{
      NextFocusIntent:
          CallbackAction<NextFocusIntent>(onInvoke: _handleGridNextFocus),
      PreviousFocusIntent: CallbackAction<PreviousFocusIntent>(
          onInvoke: _handleGridPreviousFocus),
      DirectionalFocusIntent: CallbackAction<DirectionalFocusIntent>(
          onInvoke: _handleDirectionFocus),
    };
    _dayGridFocus = FocusNode(debugLabel: 'Day Grid');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localizations = MaterialLocalizations.of(context);
    _textDirection = Directionality.of(context);
  }

  @override
  void didUpdateWidget(_JMonthPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialMonth != oldWidget.initialMonth &&
        widget.initialMonth != _currentMonth) {
      // We can't interrupt this widget build with a scroll, so do it next frame
      WidgetsBinding.instance.addPostFrameCallback(
        (Duration timeStamp) => _showMonth(widget.initialMonth, jump: true),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _dayGridFocus.dispose();
    super.dispose();
  }

  void _handleDateSelected(HijriDate selectedDate) {
    _focusedDay = selectedDate;
    widget.onChanged(selectedDate);
  }

  /// The value for `delta` would be `7`.
  static int _monthDelta(HijriDate startDate, HijriDate endDate) {
    return (endDate.year - startDate.year) * 12 +
        endDate.month -
        startDate.month;
  }

  /// Add months to a month truncated date.
  HijriDate _addMonthsToMonthDate(HijriDate monthDate, int monthsToAdd) {
    var xx = monthDate.year + (monthDate.month + monthsToAdd) ~/ 12;
    var xz = monthDate.month + monthsToAdd % 12;
    int fY = xz % 12 == 0 ? xx - 1 : xx;
    int fM = xz % 12 == 0 ? 12 : xz % 12;
    var x = JHijri(fMonth: fM, fDay: 1, fYear: fY).hijri;
    /* var x = HijriCalendar.addMonth(
        monthDate.hYear + (monthDate.hMonth + monthsToAdd) ~/ 12,
        monthDate.hMonth + monthsToAdd % 12);*/
    return x;
  }

  static bool _isSameMonth(HijriDate? dateA, HijriDate? dateB) {
    return dateA?.year == dateB?.year && dateA?.month == dateB?.month;
  }

  void _handleMonthPageChanged(int monthPage) {
    setState(() {
      final HijriDate monthDate =
          _addMonthsToMonthDate(widget.firstDate, monthPage);
      if (!_isSameMonth(_currentMonth, monthDate)) {
        _currentMonth =
            JHijri(fYear: monthDate.year, fMonth: monthDate.month).hijri;
        widget.onDisplayedMonthChanged(_currentMonth);
        if (_focusedDay != null && !_isSameMonth(_focusedDay, _currentMonth)) {
          // We have navigated to a new month with the grid focused, but the
          // focused day is not in this month. Choose a new one trying to keep
          // the same day of the month.
          _focusedDay = _focusableDayForMonth(_currentMonth, _focusedDay!.day);
        }
        SemanticsService.announce(
          _currentMonth.month.toString(),
          _textDirection,
        );
      }
    });
  }

  /// Returns a focusable date for the given month.
  ///
  /// If the preferredDay is available in the month it will be returned,
  /// otherwise the first selectable day in the month will be returned. If
  /// no dates are selectable in the month, then it will return null.
  HijriDate? _focusableDayForMonth(HijriDate month, int preferredDay) {
    final int daysInMonth = getDaysInAMonth(month.year, month.month);

    // Can we use the preferred day in this month?
    if (preferredDay <= daysInMonth) {
      final HijriDate newFocus =
          JHijri(fYear: month.year, fMonth: month.month, fDay: preferredDay)
              .hijri;
      if (_isSelectable(newFocus)) {
        return newFocus;
      }
    }

    // Start at the 1st and take the first selectable date.
    for (int day = 1; day <= daysInMonth; day++) {
      final HijriDate newFocus =
          JHijri(fYear: month.year, fMonth: month.month, fDay: day).hijri;
      if (_isSelectable(newFocus)) {
        return newFocus;
      }
    }
    return null;
  }

  /// Navigate to the next month.
  void _handleNextMonth() {
    if (!_isDisplayingLastMonth) {
      _pageController.nextPage(
        duration: _monthScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  /// Navigate to the previous month.
  void _handlePreviousMonth() {
    if (!_isDisplayingFirstMonth) {
      _pageController.previousPage(
        duration: _monthScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  /// Navigate to the given month.
  void _showMonth(HijriDate month, {bool jump = false}) {
    final int monthPage = _monthDelta(widget.firstDate, month);
    if (jump) {
      _pageController.jumpToPage(monthPage);
    } else {
      _pageController.animateToPage(
        monthPage,
        duration: _monthScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  /// True if the earliest allowable month is displayed.
  bool get _isDisplayingFirstMonth {
    return !_currentMonth.dateTime.isAfter(
      JHijri(fYear: widget.firstDate.year, fMonth: widget.firstDate.month)
          .dateTime,
    );
  }

  /// True if the latest allowable month is displayed.
  bool get _isDisplayingLastMonth {
    return !_currentMonth.dateTime.isBefore(
      JHijri(fYear: widget.lastDate.year, fMonth: widget.lastDate.month)
          .dateTime,
    );
  }

  /// Handler for when the overall day grid obtains or loses focus.
  void _handleGridFocusChange(bool focused) {
    setState(() {
      if (focused && _focusedDay == null) {
        if (_isSameMonth(widget.selectedDate, _currentMonth)) {
          _focusedDay = widget.selectedDate;
        } else if (_isSameMonth(widget.currentDate, _currentMonth)) {
          _focusedDay =
              _focusableDayForMonth(_currentMonth, widget.currentDate.day);
        } else {
          _focusedDay = _focusableDayForMonth(_currentMonth, 1);
        }
      }
    });
  }

  /// Move focus to the next element after the day grid.
  void _handleGridNextFocus(NextFocusIntent intent) {
    _dayGridFocus.requestFocus();
    _dayGridFocus.nextFocus();
  }

  /// Move focus to the previous element before the day grid.
  void _handleGridPreviousFocus(PreviousFocusIntent intent) {
    _dayGridFocus.requestFocus();
    _dayGridFocus.previousFocus();
  }

  /// Move the internal focus date in the direction of the given intent.
  ///
  /// This will attempt to move the focused day to the next selectable day in
  /// the given direction. If the new date is not in the current month, then
  /// the page view will be scrolled to show the new date's month.
  ///
  /// For horizontal directions, it will move forward or backward a day (depending
  /// on the current [TextDirection]). For vertical directions it will move up and
  /// down a week at a time.
  void _handleDirectionFocus(DirectionalFocusIntent intent) {
    assert(_focusedDay != null);
    setState(() {
      final HijriDate? nextDate =
          _nextDateInDirection(_focusedDay!, intent.direction);
      if (nextDate != null) {
        _focusedDay = nextDate;
        if (!_isSameMonth(_focusedDay, _currentMonth)) {
          _showMonth(_focusedDay!);
        }
      }
    });
  }

  static const Map<TraversalDirection, int> _directionOffset =
      <TraversalDirection, int>{
    TraversalDirection.up: -DateTime.daysPerWeek,
    TraversalDirection.right: 1,
    TraversalDirection.down: DateTime.daysPerWeek,
    TraversalDirection.left: -1,
  };

  int _dayDirectionOffset(
      TraversalDirection traversalDirection, TextDirection textDirection) {
    // Swap left and right if the text direction if RTL
    if (textDirection == TextDirection.rtl) {
      if (traversalDirection == TraversalDirection.left) {
        traversalDirection = TraversalDirection.right;
      } else if (traversalDirection == TraversalDirection.right) {
        traversalDirection = TraversalDirection.left;
      }
    }
    return _directionOffset[traversalDirection]!;
  }

  HijriDate? _nextDateInDirection(
      HijriDate date, TraversalDirection direction) {
    final TextDirection textDirection = Directionality.of(context);

    HijriDate nextDate = JHijri(
            fYear: date.year,
            fMonth: date.month,
            fDay: _dayDirectionOffset(direction, textDirection))
        .hijri;
    while (!nextDate.dateTime.isBefore(widget.firstDate.dateTime) &&
        !nextDate.dateTime.isAfter(widget.lastDate.dateTime)) {
      if (_isSelectable(nextDate)) {
        return nextDate;
      }

      nextDate = JHijri(
              fYear: nextDate.year,
              fMonth: nextDate.month,
              fDay: _dayDirectionOffset(direction, textDirection))
          .hijri;
    }
    return null;
  }

  bool _isSelectable(HijriDate date) {
    return widget.selectableDayPredicate == null ||
        widget.selectableDayPredicate!.call(date);
  }

  Widget _buildItems(BuildContext context, int index) {
    final month = _addMonthsToMonthDate(widget.firstDate, index);
    //final DateTime month = DateUtils.addMonthsToMonthDate(widget.firstDate, index);
    return _JDayPicker(
      key: ValueKey<HijriDate>(month),
      selectedDate: widget.selectedDate,
      currentDate: widget.currentDate,
      onChanged: _handleDateSelected,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      displayedMonth: month,
      selectableDayPredicate: widget.selectableDayPredicate,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color controlColor =
        Theme.of(context).colorScheme.onSurface.withOpacity(0.60);
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Semantics(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsetsDirectional.only(start: 16, end: 4),
            height: _subHeaderHeight,
            child: Row(
              children: <Widget>[
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  color: controlColor,
                  tooltip: _isDisplayingFirstMonth
                      ? null
                      : _localizations.previousMonthTooltip,
                  onPressed:
                      _isDisplayingFirstMonth ? null : _handlePreviousMonth,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  color: controlColor,
                  tooltip: _isDisplayingLastMonth
                      ? null
                      : _localizations.nextMonthTooltip,
                  onPressed: _isDisplayingLastMonth ? null : _handleNextMonth,
                ),
              ],
            ),
          ),
          Text(
            "${widget.selectedDate.dayName.toString()} / ${widget.selectedDate.day} / ${widget.selectedDate.monthName}",
            overflow: TextOverflow.ellipsis,
            style: textTheme.subtitle2?.copyWith(
              color: controlColor,
            ),
          ),
          Expanded(
            child: FocusableActionDetector(
              shortcuts: _shortcutMap,
              actions: _actionMap,
              focusNode: _dayGridFocus,
              onFocusChange: _handleGridFocusChange,
              child: _JFocusedDate(
                date: _dayGridFocus.hasFocus ? _focusedDay : null,
                child: PageView.builder(
                  key: _pageViewKey,
                  controller: _pageController,
                  itemBuilder: _buildItems,
                  itemCount: _monthDelta(widget.firstDate, widget.lastDate) + 1,
                  onPageChanged: _handleMonthPageChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// InheritedWidget indicating what the current focused date is for its children.
///
/// This is used by the [_JMonthPicker] to let its children [_JDayPicker]s know
/// what the currently focused date (if any) should be.
class _JFocusedDate extends InheritedWidget {
  const _JFocusedDate({
    required super.child,
    this.date,
  });

  final HijriDate? date;

  @override
  bool updateShouldNotify(_JFocusedDate oldWidget) {
    return !_isSameDay(date, oldWidget.date);
  }

  static bool _isSameDay(HijriDate? dateA, HijriDate? dateB) {
    return dateA?.year == dateB?.year &&
        dateA?.month == dateB?.month &&
        dateA?.day == dateB?.day;
  }

  static HijriDate? of(BuildContext context) {
    final _JFocusedDate? focusedDate =
        context.dependOnInheritedWidgetOfExactType<_JFocusedDate>();
    return focusedDate?.date;
  }
}

/// Displays the days of a given month and allows choosing a day.
///
/// The days are arranged in a rectangular grid with one column for each day of
/// the week.
class _JDayPicker extends StatefulWidget {
  /// Creates a day picker.
  _JDayPicker({
    super.key,
    required this.currentDate,
    required this.displayedMonth,
    required this.firstDate,
    required this.lastDate,
    required this.selectedDate,
    required this.onChanged,
    this.selectableDayPredicate,
  })  : assert(!firstDate.dateTime.isAfter(lastDate.dateTime)),
        assert(!selectedDate.dateTime.isBefore(firstDate.dateTime)),
        assert(!selectedDate.dateTime.isAfter(lastDate.dateTime));

  /// The currently selected date.
  ///
  /// This date is highlighted in the picker.
  final HijriDate selectedDate;

  /// The current date at the time the picker is displayed.
  final HijriDate currentDate;

  /// Called when the user picks a day.
  final ValueChanged<HijriDate> onChanged;

  /// The earliest date the user is permitted to pick.
  ///
  /// This date must be on or before the [lastDate].
  final HijriDate firstDate;

  /// The latest date the user is permitted to pick.
  ///
  /// This date must be on or after the [firstDate].
  final HijriDate lastDate;

  /// The month whose days are displayed by this picker.
  final HijriDate displayedMonth;

  /// Optional user supplied predicate function to customize selectable days.
  final SelectableDayPredicate? selectableDayPredicate;

  @override
  _JDayPickerState createState() => _JDayPickerState();
}

class _JDayPickerState extends State<_JDayPicker> {
  /// List of [FocusNode]s, one for each day of the month.
  late List<FocusNode> _dayFocusNodes;

  @override
  void initState() {
    super.initState();
    final int daysInMonth = getDaysInAMonth(
        widget.displayedMonth.year, widget.displayedMonth.month);
    _dayFocusNodes = List<FocusNode>.generate(
      daysInMonth,
      (int index) =>
          FocusNode(skipTraversal: true, debugLabel: 'Day ${index + 1}'),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check to see if the focused date is in this month, if so focus it.
    final HijriDate? focusedDate = _JFocusedDate.of(context);
    if (focusedDate != null &&
        _isSameMonth(widget.displayedMonth, focusedDate)) {
      _dayFocusNodes[focusedDate.day - 1].requestFocus();
    }
  }

  static bool _isSameMonth(HijriDate? dateA, HijriDate? dateB) {
    return dateA?.year == dateB?.year && dateA?.month == dateB?.month;
  }

  @override
  void dispose() {
    for (final FocusNode node in _dayFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  /// Builds widgets showing abbreviated days of week. The first widget in the
  /// returned list corresponds to the first day of week for the current locale.
  ///
  /// Examples:
  ///
  /// ```
  /// ┌ Sunday is the first day of week in the US (en_US)
  /// |
  /// S M T W T F S  <-- the returned list contains these widgets
  /// _ _ _ _ _ 1 2
  /// 3 4 5 6 7 8 9
  ///
  /// ┌ But it's Monday in the UK (en_GB)
  /// |
  /// M T W T F S S  <-- the returned list contains these widgets
  /// _ _ _ _ 1 2 3
  /// 4 5 6 7 8 9 10
  /// ```
  List<Widget> _dayHeaders(
      TextStyle? headerStyle, MaterialLocalizations localizations) {
    final List<Widget> result = <Widget>[];

    /// { 0 } pick first day of week as sunday
    for (int i = 0; true; i = (i + 1) % 7) {
      final String weekday = localizations.narrowWeekdays[i];

      result.add(ExcludeSemantics(
        child: Center(child: Text(weekday, style: headerStyle)),
      ));

      /// { 0 } pick first day of week as sunday
      if (i == (0 - 1) % 7) break;
    }
    return result;
  }
  /*List<Widget> _dayHeaders(
      TextStyle? headerStyle, MaterialLocalizations localizations) {
    final List<Widget> result = <Widget>[];
    for (int i = localizations.firstDayOfWeekIndex; true; i = (i + 1) % 7) {
      final String weekday = localizations.narrowWeekdays[i];
      result.add(ExcludeSemantics(
        child: Center(child: Text(weekday, style: headerStyle)),
      ));
      if (i == (localizations.firstDayOfWeekIndex - 1) % 7) {
        break;
      }
    }
    return result;
  }*/

  static bool _isSameDay(HijriDate? dateA, HijriDate? dateB) {
    return dateA?.year == dateB?.year &&
        dateA?.month == dateB?.month &&
        dateA?.day == dateB?.day;
  }

  int _computeFirstDayOffset(int year, int month) {
    var convertDate = JHijri(fYear: year, fMonth: month, fDay: 1).hijri;
    DateTime wkDay = convertDate.dateTime;
    // 0-based day of week, with 0 representing Monday.
    final int weekdayFromMonday = wkDay.weekday - 1;
    // 0-based day of week, with 0 representing Sunday.
    const int firstDayOfWeekFromSunday = 0;
    // firstDayOfWeekFromSunday recomputed to be Monday-based
    const int firstDayOfWeekFromMonday = (firstDayOfWeekFromSunday - 1) % 7;
    // Number of days between the first day of week appearing on the calendar,
    // and the day corresponding to the 1-st of the month.
    return (weekdayFromMonday - firstDayOfWeekFromMonday) % 7;
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final TextStyle? headerStyle = textTheme.caption?.apply(
      color: colorScheme.onSurface.withOpacity(0.60),
    );
    final TextStyle dayStyle = textTheme.caption!;
    final Color enabledDayColor = colorScheme.onSurface.withOpacity(0.87);
    final Color disabledDayColor = colorScheme.onSurface.withOpacity(0.38);
    final Color selectedDayColor = colorScheme.onPrimary;
    final Color selectedDayBackground = colorScheme.primary;
    final Color todayColor = colorScheme.primary;

    final int year = widget.displayedMonth.year;
    final int month = widget.displayedMonth.month;

    final int daysInMonth = getDaysInAMonth(year, month);
    final int dayOffset = _computeFirstDayOffset(year, month);

    final List<Widget> dayItems = _dayHeaders(headerStyle, localizations);
    // 1-based day of month, e.g. 1-31 for January, and 1-29 for February on
    // a leap year.
    int day = -dayOffset;
    while (day < daysInMonth) {
      day++;
      if (day < 1) {
        dayItems.add(Container());
      } else {
        final HijriDate dayToBuild =
            JHijri(fYear: year, fMonth: month, fDay: day).hijri;
        final bool isDisabled =
            dayToBuild.dateTime.isAfter(widget.lastDate.dateTime) ||
                dayToBuild.dateTime.isBefore(widget.firstDate.dateTime) ||
                (widget.selectableDayPredicate != null &&
                    !widget.selectableDayPredicate!(dayToBuild));
        final bool isSelectedDay = _isSameDay(widget.selectedDate, dayToBuild);
        final bool isToday = _isSameDay(widget.currentDate, dayToBuild);

        BoxDecoration? decoration;
        Color dayColor = enabledDayColor;
        if (isSelectedDay) {
          // The selected day gets a circle background highlight, and a
          // contrasting text color.
          dayColor = selectedDayColor;
          decoration = BoxDecoration(
            color: selectedDayBackground,
            shape: BoxShape.circle,
          );
        } else if (isDisabled) {
          dayColor = disabledDayColor;
        } else if (isToday) {
          // The current day gets a different text color and a circle stroke
          // border.
          dayColor = todayColor;
          decoration = BoxDecoration(
            border: Border.all(color: todayColor),
            shape: BoxShape.circle,
          );
        }

        Widget dayWidget = Container(
          decoration: decoration,
          child: Center(
            child: Text(localizations.formatDecimal(day),
                style: dayStyle.apply(color: dayColor)),
          ),
        );

        if (isDisabled) {
          dayWidget = ExcludeSemantics(
            child: dayWidget,
          );
        } else {
          dayWidget = InkResponse(
            focusNode: _dayFocusNodes[day - 1],
            onTap: () => widget.onChanged(dayToBuild),
            radius: _dayPickerRowHeight / 2 + 4,
            splashColor: selectedDayBackground.withOpacity(0.38),
            child: Semantics(
              // We want the day of month to be spoken first irrespective of the
              // locale-specific preferences or TextDirection. This is because
              // an accessibility user is more likely to be interested in the
              // day of month before the rest of the date, as they are looking
              // for the day of month. To do that we prepend day of month to the
              // formatted full date.
              label: '$day, ${dayToBuild.year}',
              selected: isSelectedDay,
              excludeSemantics: true,
              child: dayWidget,
            ),
          );
        }

        dayItems.add(dayWidget);
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _monthPickerHorizontalPadding,
      ),
      child: GridView.custom(
        physics: const ClampingScrollPhysics(),
        gridDelegate: _dayPickerGridDelegate,
        childrenDelegate: SliverChildListDelegate(
          dayItems,
          addRepaintBoundaries: false,
        ),
      ),
    );
  }
}

class _JDayPickerGridDelegate extends SliverGridDelegate {
  const _JDayPickerGridDelegate();

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    const int columnCount = 7;
    final double tileWidth = constraints.crossAxisExtent / columnCount;
    final double tileHeight = math.min(
      _dayPickerRowHeight,
      constraints.viewportMainAxisExtent / (_maxDayPickerRowCount + 1),
    );
    return SliverGridRegularTileLayout(
      childCrossAxisExtent: tileWidth,
      childMainAxisExtent: tileHeight,
      crossAxisCount: columnCount,
      crossAxisStride: tileWidth,
      mainAxisStride: tileHeight,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(_JDayPickerGridDelegate oldDelegate) => false;
}

const _JDayPickerGridDelegate _dayPickerGridDelegate =
    _JDayPickerGridDelegate();

/// A scrollable grid of years to allow picking a year.
///
/// The year picker widget is rarely used directly. Instead, consider using
/// [JCalendarDatePicker], or [showJHijriPicker] which create full date pickers.
///
/// See also:
///
///  * [JCalendarDatePicker], which provides a Material Design date picker
///    interface.
///
///  * [showJHijriPicker], which shows a dialog containing a Material Design
///    date picker.
///
class JYearPicker extends StatefulWidget {
  /// Creates a year picker.
  ///
  /// The [firstDate], [lastDate], [selectedDate], and [onChanged]
  /// arguments must be non-null. The [lastDate] must be after the [firstDate].
  JYearPicker({
    super.key,
    HijriDate? currentDate,
    required this.firstDate,
    required this.lastDate,
    HijriDate? initialDate,
    required this.selectedDate,
    required this.onChanged,
    this.dragStartBehavior = DragStartBehavior.start,
  })  : assert(!firstDate.dateTime.isAfter(lastDate.dateTime)),
        currentDate = currentDate ?? HijriDate.now(),
        initialDate = initialDate ?? selectedDate;

  /// The current date.
  ///
  /// This date is subtly highlighted in the picker.
  final HijriDate currentDate;

  /// The earliest date the user is permitted to pick.
  final HijriDate firstDate;

  /// The latest date the user is permitted to pick.
  final HijriDate lastDate;

  /// The initial date to center the year display around.
  final HijriDate initialDate;

  /// The currently selected date.
  ///
  /// This date is highlighted in the picker.
  final HijriDate selectedDate;

  /// Called when the user picks a year.
  final ValueChanged<HijriDate> onChanged;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  @override
  State<JYearPicker> createState() => _JYearPickerState();
}

class _JYearPickerState extends State<JYearPicker> {
  late ScrollController _scrollController;

  // The approximate number of years necessary to fill the available space.
  static const int minYears = 18;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(
        initialScrollOffset: _scrollOffsetForYear(widget.selectedDate));
  }

  @override
  void didUpdateWidget(JYearPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      _scrollController.jumpTo(_scrollOffsetForYear(widget.selectedDate));
    }
  }

  double _scrollOffsetForYear(HijriDate date) {
    final int initialYearIndex = date.year - widget.firstDate.year;
    final int initialYearRow = initialYearIndex ~/ _yearPickerColumnCount;
    // Move the offset down by 2 rows to approximately center it.
    final int centeredYearRow = initialYearRow - 2;
    return _itemCount < minYears ? 0 : centeredYearRow * _yearPickerRowHeight;
  }

  Widget _buildYearItem(BuildContext context, int index) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    // Backfill the _YearPicker with disabled years if necessary.
    final int offset = _itemCount < minYears ? (minYears - _itemCount) ~/ 2 : 0;
    final int year = widget.firstDate.year + index - offset;
    final bool isSelected = year == widget.selectedDate.year;
    final bool isCurrentYear = year == widget.currentDate.year;
    final bool isDisabled =
        year < widget.firstDate.year || year > widget.lastDate.year;
    const double decorationHeight = 36.0;
    const double decorationWidth = 72.0;

    final Color textColor;
    if (isSelected) {
      textColor = colorScheme.onPrimary;
    } else if (isDisabled) {
      textColor = colorScheme.onSurface.withOpacity(0.38);
    } else if (isCurrentYear) {
      textColor = colorScheme.primary;
    } else {
      textColor = colorScheme.onSurface.withOpacity(0.87);
    }
    final TextStyle? itemStyle = textTheme.bodyText1?.apply(color: textColor);

    BoxDecoration? decoration;
    if (isSelected) {
      decoration = BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(decorationHeight / 2),
      );
    } else if (isCurrentYear && !isDisabled) {
      decoration = BoxDecoration(
        border: Border.all(
          color: colorScheme.primary,
        ),
        borderRadius: BorderRadius.circular(decorationHeight / 2),
      );
    }

    Widget yearItem = Center(
      child: Container(
        decoration: decoration,
        height: decorationHeight,
        width: decorationWidth,
        child: Center(
          child: Semantics(
            selected: isSelected,
            button: true,
            child: Text(year.toString(), style: itemStyle),
          ),
        ),
      ),
    );

    if (isDisabled) {
      yearItem = ExcludeSemantics(
        child: yearItem,
      );
    } else {
      yearItem = InkWell(
        key: ValueKey<int>(year),
        onTap: () => widget.onChanged(JHijri(
                fYear: year,
                fMonth: widget.initialDate.month,
                fDay: widget.initialDate.day)
            .hijri),
        child: yearItem,
      );
    }

    return yearItem;
  }

  int get _itemCount {
    return widget.lastDate.year - widget.firstDate.year + 1;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    return Column(
      children: <Widget>[
        const Divider(),
        Expanded(
          child: GridView.builder(
            controller: _scrollController,
            dragStartBehavior: widget.dragStartBehavior,
            gridDelegate: _yearPickerGridDelegate,
            itemBuilder: _buildYearItem,
            itemCount: math.max(_itemCount, minYears),
            padding: const EdgeInsets.symmetric(horizontal: _yearPickerPadding),
          ),
        ),
        const Divider(),
      ],
    );
  }
}

class _JYearPickerGridDelegate extends SliverGridDelegate {
  const _JYearPickerGridDelegate();

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final double tileWidth = (constraints.crossAxisExtent -
            (_yearPickerColumnCount - 1) * _yearPickerRowSpacing) /
        _yearPickerColumnCount;
    return SliverGridRegularTileLayout(
      childCrossAxisExtent: tileWidth,
      childMainAxisExtent: _yearPickerRowHeight,
      crossAxisCount: _yearPickerColumnCount,
      crossAxisStride: tileWidth + _yearPickerRowSpacing,
      mainAxisStride: _yearPickerRowHeight,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(_JYearPickerGridDelegate oldDelegate) => false;
}

const _JYearPickerGridDelegate _yearPickerGridDelegate =
    _JYearPickerGridDelegate();
