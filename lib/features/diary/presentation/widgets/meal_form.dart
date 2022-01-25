import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_diary/features/diary/domain/value_objects/food.dart';
import 'package:food_diary/features/diary/presentation/bloc/meal_form_bloc.dart';
import 'package:food_diary/features/diary/presentation/bloc/misc/food_item.dart';
import 'package:food_diary/features/diary/presentation/bloc/misc/meal_item.dart';
import 'package:food_diary/injection_container.dart';
import 'package:intl/intl.dart';

enum FormType {
  addMeal,
  updateMeal,
}

class MealForm extends StatelessWidget {
  final FormType type;
  final MealItem? meal;

  const MealForm({Key? key, this.type = FormType.addMeal, this.meal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String buttonText = type == FormType.addMeal ? "Add" : "Update";
    return BlocProvider<MealFormBloc>(
      create: (context) => MealFormBloc(sl(), meal),
      child: BlocListener<MealFormBloc, MealFormState>(
        listener: (context, state) {
          if (state is MealFormSubmitFailed) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Builder(builder: (context) {
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 0,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: BlocBuilder<MealFormBloc, MealFormState>(
                    buildWhen: (previous, current) =>
                        true, //current is MealFormSubmitted,
                    builder: (context, state) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () async {
                                final DateTime? pickedDate =
                                    await showDatePicker(
                                        context: context,
                                        initialDate: state.dateTime,
                                        initialDatePickerMode:
                                            DatePickerMode.day,
                                        firstDate: DateTime(2015),
                                        lastDate: DateTime(2101));
                                final TimeOfDay? pickedTime =
                                    await showTimePicker(
                                  context: context,
                                  initialTime:
                                      TimeOfDay.fromDateTime(state.dateTime),
                                );
                                // if (pickedDate != null) {
                                //   DateTime dateTime = DateTime(
                                //       pickedDate.year,
                                //       pickedDate.month,
                                //       pickedDate.day,
                                //       pickedTime?.hour ?? 0,
                                //       pickedTime?.minute ?? 0);
                                //   BlocProvider.of<MealFormBloc>(context)
                                //       .add(MealFormDateTimeChanged(dateTime));
                                // }
                              },
                              child: Text(
                                DateFormat('EEE, dd.MM.yyy')
                                    .format(state.dateTime),
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0)),
                                  border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    width: 2.0,
                                  ),
                                ),
                                child: Column(
                                  children: state.foods
                                      .asMap()
                                      .entries
                                      .map((e) =>
                                          FoodEntry(id: e.key, food: e.value))
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
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
                    BlocListener<MealFormBloc, MealFormState>(
                      listener: (context, state) {
                        if (state is MealFormSubmitted) {
                          Navigator.pop(context);
                        } else if (state is MealFormSubmitFailed) {}
                      },
                      child: ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<MealFormBloc>(context)
                              .add(MealFormSubmit());
                        },
                        child: Text(buttonText),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class FoodEntry extends StatefulWidget {
  FoodEntry({Key? key, required this.food, required this.id}) : super(key: key);
  final FoodItem food;
  final int id;
  final TextEditingController controller = TextEditingController();

  @override
  State<FoodEntry> createState() => _FoodEntryState();
}

class _FoodEntryState extends State<FoodEntry> {
  @override
  Widget build(BuildContext context) {
    widget.controller.text = widget.food.name;
    widget.controller.selection = TextSelection(
        baseOffset: widget.food.name.length,
        extentOffset: widget.food.name.length);

    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: (text) {
              BlocProvider.of<MealFormBloc>(context)
                  .add(MealFormNameChanged(widget.id, text));
            },
            controller: widget.controller,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            maxLines: 1,
            minLines: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: DropdownButton<Amount>(
            value: widget.food.amount,
            onChanged: (Amount? amount) {
              BlocProvider.of<MealFormBloc>(context).add(
                  MealFormAmountChanged(widget.id, amount ?? Amount.small));
            },
            items: const [
              DropdownMenuItem<Amount>(
                child: Text("Small"),
                value: Amount.small,
              ),
              DropdownMenuItem<Amount>(
                child: Text("Medium"),
                value: Amount.medium,
              ),
              DropdownMenuItem<Amount>(
                child: Text("High"),
                value: Amount.high,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
