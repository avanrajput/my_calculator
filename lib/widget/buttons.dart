import 'package:flutter/material.dart';
import 'package:my_calculator/main.dart';

class MyButton extends StatelessWidget {
  const MyButton(
      {super.key,
      required this.buttonName,
      required this.onTapButton,
      required this.colorList});

  final String buttonName;
  final void Function(String) onTapButton;
  final List<Color> colorList;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTapButton(buttonName);
      },
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: MyApp.themeNotifier.value == ThemeMode.light
                  ? Colors.grey.shade400
                  : const Color.fromARGB(255, 63, 61, 61),
              blurRadius: 1,
              offset: const Offset(1, 1),
            ),
          ],
          gradient: LinearGradient(
            colors: colorList,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Text(
          buttonName,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(),
        ),
      ),
    );
  }
}
