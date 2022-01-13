import 'package:flutter/material.dart';
import 'package:food_diary/features/diary/domain/entities/meal.dart';
import 'package:intl/intl.dart';

enum FormType {
  addMeal,
  updateMeal,
}

class MealForm extends StatefulWidget {
  final FormType type;
  final Meal? meal;

  const MealForm({Key? key, this.type = FormType.addMeal, this.meal})
      : super(key: key);

  @override
  State<MealForm> createState() => _MealFormState();
}

class _MealFormState extends State<MealForm> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _controller.text = widget.meal?.foods.join('\n') ?? "";
    String buttonText = widget.type == FormType.addMeal ? "Add" : "Update";
    DateTime dateTime = widget.meal?.dateTime ?? DateTime.now();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  DateFormat('EEE, dd.MM.yyy').format(dateTime),
                  style: Theme.of(context).textTheme.headline5,
                ),
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)))),
                  maxLines: 10,
                  minLines: 4,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    List<String> foods = _controller.text.split(
                      RegExp(r"[\n,;]+"),
                    );
                    widget.type == FormType.addMeal;
                    Navigator.pop(
                        context, Meal(dateTime: dateTime, foods: foods));
                  },
                  child: Text(buttonText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
