import 'package:flutter/material.dart';
import 'package:my_calculator/main.dart';
import 'package:my_calculator/widget/buttons.dart';
import 'package:math_expressions/math_expressions.dart';

import 'data/buttonlist.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool lastDigit = false;
  String screen = '';
  bool lastDecimal = false;
  bool operaPerform = false;
  bool lastOpera = false;
  // bool isDarkMode = MyApp.themeNotifier.value == ThemeMode.dark;

  String remZero(String result) {
    var value = result;
    if (result.contains(".0")) {
      value = result.substring(0, result.length - 2);
    }
    return value;
  }

  bool isOperatorAdded(String value) {
    return value.contains("/") ||
        value.contains("+") ||
        value.contains("%") ||
        value.contains("x") ||
        value.contains("-");
  }

  void onDigitClick(String button) {
    if (operaPerform) {
      screen = "";
      operaPerform = false;
    }

    screen += button;
    lastDigit = true;
  }

  void onClearClick() {
    screen = "";
    lastDigit = false;
    lastDecimal = false;
  }

  void onOperandClick(String button) {
    if (lastDigit && screen.isNotEmpty) {
      screen += button;
      lastDigit = false;
      lastDecimal = false;
      operaPerform = false;
    }
  }

  void onEqualClick() {
    operaPerform = true;
    var result = '';
    if (lastDigit) {
      result = screen;
    } else {
      result = screen.substring(0, screen.length - 1);
      lastDigit = true;
    }
    try {
      result = result.replaceAll("x", "*");

      if (result.contains('%')) {
        final splitValue = result.split("%");
        var one = splitValue[0];
        final two = splitValue[1];

        screen =
            remZero((double.parse(one) * (double.parse(two) / 100)).toString());
      } else {
        final parser = Parser();
        final expression = parser.parse(result);
        final evalResult =
            expression.evaluate(EvaluationType.REAL, ContextModel());

        screen = remZero(evalResult.toString());
      }
    } catch (e) {
      screen = e.toString();
    }
  }

  void onDecimalClick() {
    if (!lastDecimal) {
      screen += ".";
      lastDecimal = true;
    }
  }

  void showSelectedOp(String op) {
    setState(() {
      if (op == 'C') {
        onClearClick();
      } else if (op == '=') {
        onEqualClick();
      } else if (op == 'D') {
        screen = screen.substring(0, screen.length - 1);
      } else if (isOperatorAdded(op)) {
        onOperandClick(op);
      } else if (op == '.') {
        onDecimalClick();
      } else {
        onDigitClick(op);
      }
    });
  }

  List<Color> btnColorDark(String val) {
    if (isOperatorAdded(val) || val == '-') {
      return [Colors.deepPurple, Colors.purple, Colors.pink];
    } else if (val == '=') {
      return [
        const Color.fromARGB(255, 255, 17, 0),
        const Color.fromARGB(255, 252, 17, 0)
      ];
    } else if (val == 'C' || val == 'D') {
      return [Colors.deepPurple, Colors.deepPurple];
    }
    return [Colors.pink, Colors.red, Colors.orange];
  }

  List<Color> btnColor(String val) {
    if (isOperatorAdded(val) || val == '-') {
      return [Colors.purple, Colors.deepPurple];
    } else if (val == '=') {
      return [Colors.red, Colors.deepOrange];
    } else if (val == 'C' || val == 'D') {
      return [Colors.lightGreen, Colors.green];
    }
    if (MyApp.themeNotifier.value == ThemeMode.dark) {
      return [Colors.black, Colors.black];
    } else {
      return [Colors.grey.shade200, Colors.grey.shade300];
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget calcButtons = GridView(
      padding: const EdgeInsets.all(10),
      reverse: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      children: [
        for (final button in calcButtonsList)
          MyButton(
            buttonName: button,
            onTapButton: showSelectedOp,
            colorList: btnColor(button),
          )
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calculator',
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              icon: Icon(MyApp.themeNotifier.value == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode),
              onPressed: () {
                MyApp.themeNotifier.value =
                    MyApp.themeNotifier.value == ThemeMode.light
                        ? ThemeMode.dark
                        : ThemeMode.light;
              })
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            flex: 1,
            child: Container(
                padding: const EdgeInsets.all(12),
                alignment: Alignment.bottomRight,
                child: Text(
                  screen,
                  style: const TextStyle(fontSize: 35),
                  //overflow: TextOverflow.elipsis
                )),
          ),
          Flexible(flex: 2, child: calcButtons),
        ],
      ),
    );
  }
}
