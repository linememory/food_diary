import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_diary/features/diary/domain/value_objects/bowel_movement.dart';

part 'bowel_movement_form_state.dart';

class BowelMovementFormCubit extends Cubit<BowelMovementFormState> {
  BowelMovementFormCubit()
      : super(
          BowelMovementFormInitial(
            DateTime.now(),
            const [BowelMovement(stoolType: StoolType.type1, note: "")],
          ),
        );

  void typeChanged(int id, StoolType type) {
    emit(BowelMovementFormChanged(state.dateTime, state.bowelMovement));
  }

  void noteChanged(int id, String note) {
    emit(BowelMovementFormChanged(state.dateTime, state.bowelMovement));
  }

  void submit() {
    emit(BowelMovementFormSubmitted(state.dateTime, state.bowelMovement));
  }
}
