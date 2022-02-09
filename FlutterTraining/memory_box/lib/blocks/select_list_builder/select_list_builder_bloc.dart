import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:memory_box/models/tale_model.dart';

part 'select_list_builder_event.dart';
part 'select_list_builder_state.dart';

class SelectListBuilderBloc
    extends Bloc<SelectListBuilderEvent, SelectListBuilderState> {
  SelectListBuilderBloc() : super(const SelectListBuilderState()) {
    on<InitializeSelectListBuilderWithFutureRequest>((event, emit) async {
      List<TaleModel> allTales = await event.initializationTales;

      emit(
        state.copyWith(
          isInit: true,
          allTales: allTales,
          selectedTales: event.selectedTaleModels,
        ),
      );
    });
    on<InitializeSelectListBuilderWithTaleModels>((event, emit) async {
      emit(
        state.copyWith(
          isInit: true,
          allTales: event.initializationTales,
        ),
      );
    });

    on<DeleteFewTales>((event, emit) async {
      print('popopopo');
      // String? taleID = state.allTales?[event.index].ID;
      // if (taleID != null) {
      //   await DatabaseService.instance.setTaleDeleteStatus(taleID);
      // }

      // List<TaleModel>? updatedTaled = state.allTales;
      // updatedTaled?.removeAt(event.index);
      // emit(
      //   state.copyWith(allTales: updatedTaled),
      // );
    });

    on<TooglePlayMode>((event, emit) {
      if (state.isPlay && state.currentPlayTaleModel == event.taleModel ||
          event.taleModel == null) {
        emit(
          StopTaleState(
            isInit: state.isInit,
            isPlay: false,
            allTales: state.allTales,
            selectedTales: state.selectedTales,
            currentPlayTaleModel: state.currentPlayTaleModel,
          ),
        );
      } else {
        emit(
          PlayTaleState(
            isInit: state.isInit,
            isPlay: true,
            allTales: state.allTales,
            selectedTales: state.selectedTales,
            currentPlayTaleModel: event.taleModel,
          ),
        );
      }
    });

    on<ToggleSelectMode>((event, emit) {
      final List<TaleModel> updatedSelectList = [...state.selectedTales];

      final bool isHasAlreadySelected =
          updatedSelectList.contains(event.taleModel);

      if (isHasAlreadySelected) {
        updatedSelectList.remove(event.taleModel);

        emit(
          state.copyWith(
            selectedTales: updatedSelectList,
          ),
        );
      } else {
        emit(
          state.copyWith(
            selectedTales: [...updatedSelectList, event.taleModel],
          ),
        );
      }
    });

    on<TaleEndPlay>((event, emit) {
      emit(
        state.copyWith(
          isPlay: false,
        ),
      );
    });
  }
}
