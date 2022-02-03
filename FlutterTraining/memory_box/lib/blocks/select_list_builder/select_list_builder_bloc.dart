import 'dart:developer';
import 'dart:ffi';

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
    on<UpdateSelectListTaleModels>((event, emit) async {
      emit(state.copyWith(
        allTales: event.newTaleModels,
      ));
    });
    on<DeleteFewTales>((event, emit) async {
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

    on<PlaySelectTale>(
      (event, emit) {
        emit(
          PlaySelectTaleState(
            isInit: state.isInit,
            isPlay: true,
            allTales: state.allTales,
            selectedTales: state.selectedTales,
            currentPlayTaleModel: event.taleModel,
          ),
        );
      },
    );
    on<StopSelectTale>((event, emit) {
      emit(
        StopSelectTaleState(
          isInit: state.isInit,
          isPlay: false,
          allTales: state.allTales,
          selectedTales: state.selectedTales,
          currentPlayTaleModel: state.currentPlayTaleModel,
        ),
      );
    });
    on<SelectTale>((event, emit) {
      // final List<TaleModel> updatedSelectList = state.selectedTales;
      // updatedSelectList.add(event.taleModel);

      emit(
        state.copyWith(
          selectedTales: [...state.selectedTales, event.taleModel],
        ),
      );
    });
    on<UnselectTale>((event, emit) {
      List<TaleModel> updatedSelectedList = state.selectedTales;
      updatedSelectedList.remove(event.taleModel);

      emit(
        state.copyWith(
          selectedTales: [...state.selectedTales, event.taleModel],
        ),
      );
    });

    //!rename
    on<TaleSelectEndPlay>((event, emit) {
      emit(
        state.copyWith(
          isPlay: false,
        ),
      );
    });
  }
}
