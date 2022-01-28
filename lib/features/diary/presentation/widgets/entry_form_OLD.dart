import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_diary/features/diary/domain/entities/bowel_movement_entry.dart';
import 'package:food_diary/features/diary/domain/entities/diary_entry.dart';
import 'package:food_diary/features/diary/domain/entities/meal_entry.dart';
import 'package:food_diary/features/diary/domain/entities/symptom_entry.dart';
import 'package:food_diary/features/diary/domain/value_objects/food.dart';
import 'package:food_diary/features/diary/domain/value_objects/symptom.dart';
import 'package:food_diary/features/diary/presentation/bloc/meal_form_bloc.dart';
import 'package:food_diary/features/diary/presentation/cubit/symptom_form_cubit.dart';
import 'package:food_diary/injection_container.dart';
import 'package:intl/intl.dart';

enum FormType {
  addMeal,
  updateMeal,
}

class MealForm extends StatelessWidget {
  final FormType type;
  final MealEntry? meal;

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
                          DateTimePicker(
                            dateTime: state.dateTime,
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
                                          FoodField(id: e.key, food: e.value))
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

class EntryForm extends StatelessWidget {
  const EntryForm({Key? key, required this.entry}) : super(key: key);

  final DiaryEntry entry;

  @override
  Widget build(BuildContext context) {
    String buttonText = entry.id == null ? "Add" : "Update";

    if (entry is MealEntry) {
      BlocBuilder bb = BlocBuilder<MealFormBloc, MealFormState>(
        builder: (context, state) {
          return Column(
            children: [
              DateTimePicker(
                dateTime: state.dateTime,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 2.0,
                      ),
                    ),
                    child: Column(
                      children: state.foods
                          .asMap()
                          .entries
                          .map((e) => FoodField(id: e.key, food: e.value))
                          .toList(),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );

      return BlocProvider<SymptomFormCubit>(
        create: (context) => SymptomFormCubit(),
        child: BlocListener<MealFormBloc, MealFormState>(
          listener: (context, state) {
            if (state is MealFormSubmitFailed) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: Builder(builder: (context) {
            return _scaffold(context, buttonText, bb);
          }),
        ),
      );
    } else if (entry is SymptomEntry) {
      BlocBuilder bb = BlocBuilder<MealFormBloc, MealFormState>(
        builder: (context, state) {
          return Column(
            children: [
              DateTimePicker(
                dateTime: state.dateTime,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 2.0,
                      ),
                    ),
                    child: Column(
                      children: state.foods
                          .asMap()
                          .entries
                          .map((e) => FoodField(id: e.key, food: e.value))
                          .toList(),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );

      return BlocProvider<SymptomFormCubit>(
        create: (context) => SymptomFormCubit(),
        child: BlocListener<MealFormBloc, MealFormState>(
          listener: (context, state) {
            if (state is MealFormSubmitFailed) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: Builder(builder: (context) {
            return _scaffold(context, buttonText, bb);
          }),
        ),
      );
    } else if (entry is BowelMovementEntry) {
      return Container();
    } else {
      return Container();
    }
  }

  Scaffold _scaffold(
      BuildContext context, String buttonText, BlocBuilder builder) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: builder,
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
  }
}

class DateTimePicker extends StatelessWidget {
  const DateTimePicker({
    Key? key,
    required this.dateTime,
  }) : super(key: key);

  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: GestureDetector(
          onTap: () async {
            final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: dateTime,
                initialDatePickerMode: DatePickerMode.day,
                firstDate: DateTime(2015),
                lastDate: DateTime(2101));
            final TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(dateTime),
            );
            if (pickedDate != null) {
              DateTime newDateTime = DateTime(
                pickedDate.year,
                pickedDate.month,
                pickedDate.day,
                pickedTime?.hour ?? 0,
                pickedTime?.minute ?? 0,
              );
              BlocProvider.of<MealFormBloc>(context)
                  .add(MealFormDateTimeChanged(newDateTime));
            }
          },
          child: Text(
            DateFormat('EEE, dd.MM.yyy  hh:mm').format(dateTime),
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
      ),
    );
  }
}

class FoodField extends StatelessWidget {
  FoodField({Key? key, required this.food, required this.id}) : super(key: key);

  final Food food;
  final int id;
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller.text = food.name;
    controller.selection = TextSelection(
        baseOffset: food.name.length, extentOffset: food.name.length);
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: (text) {
              BlocProvider.of<MealFormBloc>(context)
                  .add(MealFormNameChanged(id, text));
            },
            controller: controller,
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
            value: food.amount,
            onChanged: (Amount? amount) {
              BlocProvider.of<MealFormBloc>(context)
                  .add(MealFormAmountChanged(id, amount ?? Amount.small));
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

class SymptomField extends StatelessWidget {
  SymptomField({Key? key, required this.symptom, required this.id})
      : super(key: key);

  final Symptom symptom;
  final int id;
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller.text = symptom.name;
    controller.selection = TextSelection(
        baseOffset: symptom.name.length, extentOffset: symptom.name.length);
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: (text) {
              //TODO cubit
              // BlocProvider.of<MealFormBloc>(context)
              //     .add(MealFormNameChanged(id, text));
            },
            controller: controller,
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
          child: DropdownButton<Intensity>(
            value: symptom.intensity,
            onChanged: (Intensity? intensity) {
              //TODO cubit
              // BlocProvider.of<MealFormBloc>(context)
              //     .add(MealFormAmountChanged(id, intensity ?? Intensity.low));
            },
            items: const [
              DropdownMenuItem<Intensity>(
                child: Text("Small"),
                value: Intensity.low,
              ),
              DropdownMenuItem<Intensity>(
                child: Text("Medium"),
                value: Intensity.medium,
              ),
              DropdownMenuItem<Intensity>(
                child: Text("High"),
                value: Intensity.high,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
