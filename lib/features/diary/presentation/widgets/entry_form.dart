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
import 'package:food_diary/generated/l10n.dart';
import 'package:food_diary/injection_container.dart';
import 'package:intl/intl.dart';

class EntryForm extends StatelessWidget {
  final DiaryEntry entry;

  const EntryForm({Key? key, required this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String buttonText = entry.id == null
        ? S.of(context).diaryFormAdd
        : S.of(context).diaryFormUpdate;
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
                  dateTime: state.data.dateTime,
                  onNewDate: (newDateTime) =>
                      BlocProvider.of<MealFormCubit>(context)
                          .dateTimeChanged(newDateTime)),
              Column(
                children: state.data.fields
                    .asMap()
                    .entries
                    .map((e) => FoodField(
                          id: e.key,
                          controller: e.value.controller,
                          amount: e.value.amount,
                        ))
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
                dateTime: state.data.dateTime,
                onNewDate: (newDateTime) =>
                    BlocProvider.of<SymptomFormCubit>(context)
                        .dateTimeChanged(newDateTime)),
            Column(
              children: state.data.fields
                  .asMap()
                  .entries
                  .map((e) => SymptomField(
                      id: e.key,
                      controller: e.value.controller,
                      intensity: e.value.intensity))
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
                    dateTime: state.data.dateTime,
                    onNewDate: (newDateTime) =>
                        BlocProvider.of<BowelMovementFormCubit>(context)
                            .dateTimeChanged(newDateTime)),
                BowelMovementField(
                    stoolType: state.data.field.stoolType,
                    controller: state.data.field.controller));
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
          child: Text(S.of(context).diaryFormCancel),
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
            DateFormat.yMMMMEEEEd(Localizations.localeOf(context).toString())
                .add_Hm()
                .format(dateTime),
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
      ),
    );
  }
}

class FoodField extends StatefulWidget {
  const FoodField(
      {Key? key,
      required this.id,
      required this.amount,
      required this.controller})
      : super(key: key);

  final int id;
  final TextEditingController controller;
  final Amount amount;

  @override
  State<FoodField> createState() => _FoodFieldState();
}

class _FoodFieldState extends State<FoodField> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: (text) {
              BlocProvider.of<MealFormCubit>(context)
                  .nameChanged(widget.id, text);
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
            value: widget.amount,
            onChanged: (Amount? amount) {
              BlocProvider.of<MealFormCubit>(context)
                  .amountChanged(widget.id, amount ?? Amount.small);
            },
            items: [
              DropdownMenuItem<Amount>(
                child: Text(S.of(context).foodAmountSmall),
                value: Amount.small,
              ),
              DropdownMenuItem<Amount>(
                child: Text(S.of(context).foodAmountMedium),
                value: Amount.medium,
              ),
              DropdownMenuItem<Amount>(
                child: Text(S.of(context).foodAmountHigh),
                value: Amount.high,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }
}

class SymptomField extends StatelessWidget {
  const SymptomField(
      {Key? key,
      required this.intensity,
      required this.id,
      required this.controller})
      : super(key: key);

  final int id;
  final Intensity intensity;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
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
            value: intensity,
            onChanged: (Intensity? intensity) {
              BlocProvider.of<SymptomFormCubit>(context)
                  .intensityChanged(id, intensity ?? Intensity.low);
            },
            items: [
              DropdownMenuItem<Intensity>(
                child: Text(S.of(context).symptomIntensityLow),
                value: Intensity.low,
              ),
              DropdownMenuItem<Intensity>(
                child: Text(S.of(context).symptomIntensityMedium),
                value: Intensity.medium,
              ),
              DropdownMenuItem<Intensity>(
                child: Text(S.of(context).symptomIntensityHigh),
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
  const BowelMovementField(
      {Key? key, required this.stoolType, required this.controller})
      : super(key: key);

  final StoolType stoolType;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: DropdownButton<StoolType>(
            value: stoolType,
            onChanged: (StoolType? type) {
              BlocProvider.of<BowelMovementFormCubit>(context)
                  .typeChanged(type ?? StoolType.type1);
            },
            items: [
              DropdownMenuItem<StoolType>(
                child: Text(S.of(context).stoolType1),
                value: StoolType.type1,
              ),
              DropdownMenuItem<StoolType>(
                child: Text(S.of(context).stoolType2),
                value: StoolType.type2,
              ),
              DropdownMenuItem<StoolType>(
                child: Text(S.of(context).stoolType3),
                value: StoolType.type3,
              ),
              DropdownMenuItem<StoolType>(
                child: Text(S.of(context).stoolType4),
                value: StoolType.type4,
              ),
              DropdownMenuItem<StoolType>(
                child: Text(S.of(context).stoolType5),
                value: StoolType.type5,
              ),
              DropdownMenuItem<StoolType>(
                child: Text(S.of(context).stoolType6),
                value: StoolType.type6,
              ),
              DropdownMenuItem<StoolType>(
                child: Text(S.of(context).stoolType7),
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
