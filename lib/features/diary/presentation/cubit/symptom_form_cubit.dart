import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_diary/features/diary/domain/entities/symptom_entry.dart';
import 'package:food_diary/features/diary/domain/value_objects/symptom.dart';
import 'package:food_diary/features/diary/presentation/cubit/entry_form_cubit.dart';

part 'symptom_form_state.dart';

class SymptomFormCubit extends Cubit<SymptomFormState> {
  final EntryFormCubit _entryFormCubit;
  SymptomFormCubit(SymptomEntry? symptomEntry, this._entryFormCubit)
      : super(
          SymptomFormInitial(
            Data.fromEntity(
              symptomEntry ??
                  SymptomEntry(
                    dateTime: DateTime.now(),
                    symptoms: const [],
                  ),
            )..addEmpty(),
          ),
        );

  void dateTimeChanged(DateTime newDateTime) {
    emit(SymptomFormChanged(state.data.copyWith(dateTime: newDateTime)));
    notifyEntryFormCubit(state.data);
  }

  void nameChanged(int id, String name) {
    Data newData = Data.from(state.data);
    if (id == newData.fields.length - 1) {
      newData.addEmpty();
    }
    emit(SymptomFormChanged(newData));
    notifyEntryFormCubit(newData);
  }

  void intensityChanged(int id, Intensity intensity) {
    Data newData = Data.from(state.data);
    newData.fields[id].intensity = intensity;

    emit(SymptomFormChanged(newData));
    notifyEntryFormCubit(newData);
  }

  void submit() {
    emit(SymptomFormSubmitted(state.data));
  }

  void notifyEntryFormCubit(Data newData) {
    SymptomEntry entry = newData.toEntity();
    _entryFormCubit.formValid(entry);
  }

  @override
  void onChange(Change<SymptomFormState> change) {
    log(change.toString(), name: runtimeType.toString());
    super.onChange(change);
  }
}

class Data {
  final int? id;
  final DateTime dateTime;
  final List<Field> fields;
  Data({
    this.id,
    required this.dateTime,
    required this.fields,
  });

  Data.from(Data data)
      : id = data.id,
        dateTime = data.dateTime,
        fields = data.fields.map((e) => Field.from(e)).toList();

  Data.fromEntity(SymptomEntry symptomEntity)
      : id = symptomEntity.id,
        dateTime = symptomEntity.dateTime,
        fields = symptomEntity.symptoms
            .map((e) => Field(
                controller: TextEditingController(text: e.name),
                intensity: e.intensity))
            .toList();

  Data copyWith({
    final int? id,
    final DateTime? dateTime,
    final List<Field>? fields,
  }) {
    return Data(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      fields: fields ?? this.fields.map((e) => Field.from(e)).toList(),
    );
  }

  SymptomEntry toEntity() {
    List<Symptom> symptoms = [];
    for (var field in fields) {
      if (field.controller.text.isNotEmpty) {
        symptoms.add(
            Symptom(name: field.controller.text, intensity: field.intensity));
      }
    }

    return SymptomEntry(id: id, dateTime: dateTime, symptoms: symptoms);
  }

  void addEmpty() {
    fields.add(
        Field(controller: TextEditingController(), intensity: Intensity.low));
  }

  removeEmptyFields() {
    fields.removeWhere((element) => element.controller.text.isEmpty);
    addEmpty();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Data &&
        other.id == id &&
        other.dateTime == dateTime &&
        listEquals(other.fields, fields);
  }

  @override
  int get hashCode => id.hashCode ^ dateTime.hashCode ^ fields.hashCode;

  @override
  String toString() => 'Data(id: $id, dateTime: $dateTime, fields: $fields)';
}

class Field {
  TextEditingController controller;
  Intensity intensity;
  Field({
    required this.controller,
    required this.intensity,
  });

  Field.from(Field field)
      : controller = field.controller,
        intensity = field.intensity;

  Field copyWith({
    TextEditingController? controller,
    Intensity? intensity,
  }) {
    return Field(
      controller: controller ?? this.controller,
      intensity: intensity ?? this.intensity,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => controller.text.hashCode ^ intensity.index.hashCode;

  @override
  String toString() =>
      'Field(controller: ${controller.text}, amount: $intensity)';
}
