import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_diary/features/diary/domain/value_objects/food.dart';

part 'meal_form_state.dart';

class MealFormCubit extends Cubit<MealFormState> {
  MealFormCubit()
      : super(
          MealFormInitial(
            DateTime.now(),
            const [Food(name: "", amount: Amount.small)],
          ),
        );

  void nameChanged(int id, String name) {
    emit(MealFormChanged(state.dateTime, state.food));
  }

  void amountChanged(int id, Amount amount) {
    emit(MealFormChanged(state.dateTime, state.food));
  }

  void submit() {
    emit(MealFormSubmitted(state.dateTime, state.food));
  }
}
