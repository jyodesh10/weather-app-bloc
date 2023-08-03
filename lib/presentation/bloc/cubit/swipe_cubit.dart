import 'package:flutter_bloc/flutter_bloc.dart';

part 'swipe_state.dart';

class SwipeCubit extends Cubit<bool> {
  bool day = true;
  SwipeCubit() : super(true);

  void swipeUpEvent()=>emit(false);
  

  void swipeDownEvent()=>emit(true);
}
