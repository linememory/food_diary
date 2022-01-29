import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_diary/features/diary/domain/entities/bowel_movement_entry.dart';
import 'package:food_diary/features/diary/domain/entities/diary_entry.dart';
import 'package:food_diary/features/diary/domain/entities/meal_entry.dart';
import 'package:food_diary/features/diary/domain/entities/symptom_entry.dart';
import 'package:food_diary/features/diary/domain/value_objects/bowel_movement.dart';
import 'package:food_diary/features/diary/domain/value_objects/food.dart';
import 'package:food_diary/features/diary/domain/value_objects/symptom.dart';
import 'package:food_diary/features/diary/presentation/cubit/bowel_movement_form_cubit.dart';
import 'package:food_diary/features/diary/presentation/cubit/entry_form_cubit.dart';
import 'package:food_diary/features/diary/presentation/cubit/meal_form_cubit.dart';
import 'package:food_diary/features/diary/presentation/cubit/symptom_form_cubit.dart';
import 'package:food_diary/injection_container.dart';
import 'package:intl/intl.dart';

class EntryForm extends StatelessWidget {
  final DiaryEntry entry;

  const EntryForm({Key? key, required this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String buttonText = entry.id == null ? "Add" : "Update";
    return BlocProvider<EntryFormCubit>(
      create: (context) => EntryFormCubit(sl()),
      child: BlocListener<EntryFormCubit, EntryFormState>(
        listener: (context, state) {
          if (state is EntryFormSubmitFailed) {
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
                InputFields(entry: entry),
                FormButtons(buttonText: buttonText),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class InputFields extends StatelessWidget {
  const InputFields({
    Key? key,
    required this.entry,
  }) : super(key: key);

  final DiaryEntry entry;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: _inputFields(context),
      //
    );
  }

  Widget _inputFields(BuildContext context) {
    Widget formColumn(
      BuildContext context,
      DateTimePicker dateTimePicker,
      Widget fields,
    ) =>
        Column(
          children: [
            dateTimePicker,
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 2.0,
                    ),
                  ),
                  child: fields,
                ),
              ),
            ),
          ],
        );
    if (entry is MealEntry) {
      return BlocProvider<MealFormCubit>(
        create: (context) => MealFormCubit(
            entry as MealEntry, BlocProvider.of<EntryFormCubit>(context)),
        child: BlocBuilder<MealFormCubit, MealFormState>(
            builder: (context, state) {
          return formColumn(
              context,
              DateTimePicker(
                  dateTime: state.mealEntry.dateTime,
                  onNewDate: (newDateTime) =>
                      BlocProvider.of<MealFormCubit>(context)
                          .dateTimeChanged(newDateTime)),
              Column(
                children: state.mealEntry.foods
                    .asMap()
                    .entries
                    .map((e) => FoodField(id: e.key, food: e.value))
                    .toList(),
              ));
        }),
      );
    } else if (entry is SymptomEntry) {
      return BlocProvider<SymptomFormCubit>(
        create: (context) => SymptomFormCubit(
            entry as SymptomEntry, BlocProvider.of<EntryFormCubit>(context)),
        child: BlocBuilder<SymptomFormCubit, SymptomFormState>(
            builder: (context, state) {
          return formColumn(
            context,
            DateTimePicker(
                dateTime: state.symptomEntry.dateTime,
                onNewDate: (newDateTime) =>
                    BlocProvider.of<SymptomFormCubit>(context)
                        .dateTimeChanged(newDateTime)),
            Column(
              children: state.symptomEntry.symptoms
                  .asMap()
                  .entries
                  .map((e) => SymptomField(
                        id: e.key,
                        symptom: e.value,
                      ))
                  .toList(),
            ),
          );
        }),
      );
    } else if (entry is BowelMovementEntry) {
      return BlocProvider<BowelMovementFormCubit>(
          create: (context) => BowelMovementFormCubit(
              entry as BowelMovementEntry,
              BlocProvider.of<EntryFormCubit>(context)),
          child: BlocBuilder<BowelMovementFormCubit, BowelMovementFormState>(
              builder: (context, state) {
            return formColumn(
                context,
                DateTimePicker(
                    dateTime: state.bowelMovementEntry.dateTime,
                    onNewDate: (newDateTime) =>
                        BlocProvider.of<BowelMovementFormCubit>(context)
                            .dateTimeChanged(newDateTime)),
                BowelMovementField(
                  bowelMovement: state.bowelMovementEntry.bowelMovement,
                ));
          }));
    } else {
      throw (Exception("Not a valid type"));
    }
  }
}

class FormButtons extends StatelessWidget {
  const FormButtons({
    Key? key,
    required this.buttonText,
  }) : super(key: key);

  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        BlocConsumer<EntryFormCubit, EntryFormState>(
          listener: (context, state) {
            if (state is EntryFormSubmitted) {
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            return ElevatedButton(
              onPressed: state is EntryFormValid
                  ? () {
                      BlocProvider.of<EntryFormCubit>(context)
                          .submit(state.entry);
                    }
                  : null,
              child: Text(buttonText),
            );
          },
        ),
      ],
    );
  }
}

class DateTimePicker extends StatelessWidget {
  const DateTimePicker({
    Key? key,
    required this.dateTime,
    required this.onNewDate,
  }) : super(key: key);

  final DateTime dateTime;

  final void Function(DateTime dateTime) onNewDate;

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
              onNewDate(newDateTime);
              // BlocProvider.of<MealFormBloc>(context)
              //     .add(MealFormDateTimeChanged(newDateTime));
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
              BlocProvider.of<MealFormCubit>(context).nameChanged(id, text);
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
              BlocProvider.of<MealFormCubit>(context)
                  .amountChanged(id, amount ?? Amount.small);
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
              BlocProvider.of<SymptomFormCubit>(context).nameChanged(id, text);
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
              BlocProvider.of<SymptomFormCubit>(context)
                  .intensityChanged(id, intensity ?? Intensity.low);
            },
            items: const [
              DropdownMenuItem<Intensity>(
                child: Text("Low"),
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

class BowelMovementField extends StatelessWidget {
  BowelMovementField({Key? key, required this.bowelMovement}) : super(key: key);

  final BowelMovement bowelMovement;
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller.text = bowelMovement.note;
    controller.selection = TextSelection(
        baseOffset: bowelMovement.note.length,
        extentOffset: bowelMovement.note.length);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: DropdownButton<StoolType>(
            value: bowelMovement.stoolType,
            onChanged: (StoolType? type) {
              BlocProvider.of<BowelMovementFormCubit>(context)
                  .typeChanged(type ?? StoolType.type1);
            },
            items: const [
              DropdownMenuItem<StoolType>(
                child: Text("Type 1"),
                value: StoolType.type1,
              ),
              DropdownMenuItem<StoolType>(
                child: Text("Type 2"),
                value: StoolType.type2,
              ),
              DropdownMenuItem<StoolType>(
                child: Text("Type 3"),
                value: StoolType.type3,
              ),
              DropdownMenuItem<StoolType>(
                child: Text("Type 4"),
                value: StoolType.type4,
              ),
              DropdownMenuItem<StoolType>(
                child: Text("Type 5"),
                value: StoolType.type5,
              ),
              DropdownMenuItem<StoolType>(
                child: Text("Type 6"),
                value: StoolType.type6,
              ),
              DropdownMenuItem<StoolType>(
                child: Text("Type 7"),
                value: StoolType.type7,
              ),
            ],
          ),
        ),
        TextField(
          onChanged: (text) {
            BlocProvider.of<BowelMovementFormCubit>(context).noteChanged(text);
          },
          controller: controller,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          maxLines: 25,
          minLines: 5,
        ),
      ],
    );
  }
}
