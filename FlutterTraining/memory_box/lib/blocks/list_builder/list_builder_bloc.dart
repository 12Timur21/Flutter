import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:memory_box/blocks/audioplayer/audioplayer_bloc.dart';
import 'package:memory_box/models/tale_model.dart';
import 'package:memory_box/repositories/database_service.dart';
import 'package:share_plus/share_plus.dart';
part 'list_builder_event.dart';
part 'list_builder_state.dart';

class ListBuilderBloc extends Bloc<ListBuilderEvent, ListBuilderState> {
  ListBuilderBloc() : super(ListBuilderState()) {
    on<InitializeListBuilder>((event, emit) async {
      List<TaleModel> allTales = await event.initializationTales;
      emit(
        state.copyWith(
          isInit: true,
          allTales: allTales,
        ),
      );
    });
    on<DeleteTale>((event, emit) async {
      String? taleID = state.allTales?[event.index].ID;
      if (taleID != null) {
        await DatabaseService.instance.setTaleDeleteStatus(taleID);
      }

      List<TaleModel>? updatedTaled = state.allTales;
      updatedTaled?.removeAt(event.index);
      emit(
        state.copyWith(allTales: updatedTaled),
      );
    });
    on<DeleteFewTales>((event, emit) {});
    on<UndoRenameTale>((event, emit) {
      emit(state.copyWith());
    });
    on<RenameTale>((event, emit) {
      DatabaseService.instance.updateTaleData(
        taleID: event.taleID,
        title: event.newTitle,
      );

      List<TaleModel>? updatedTaleList = state.allTales;

      int? renamedIndex = state.allTales?.indexWhere(
        (element) => element.ID == event.taleID,
      );

      if (renamedIndex != null) {
        updatedTaleList?[renamedIndex] =
            state.allTales![renamedIndex].copyWith(title: event.newTitle);
      }

      emit(
        state.copyWith(allTales: updatedTaleList),
      );
    });

    on<PlayTale>(
      (event, emit) {
        print('play');
        emit(
          PlayTaleState(
            isInit: state.isInit,
            isPlay: true,
            isPlayAllTalesMode: state.isPlayAllTalesMode,
            allTales: state.allTales,
            selectedTales: state.selectedTales,
            currentPlayTaleIndex: event.taleIndex,
          ),
        );
      },
    );
    on<StopTale>((event, emit) {
      print('stop');
      emit(
        StopTaleState(
          isInit: state.isInit,
          isPlay: false,
          isPlayAllTalesMode: state.isPlayAllTalesMode,
          allTales: state.allTales,
          selectedTales: state.selectedTales,
          currentPlayTaleIndex: state.currentPlayTaleIndex,
        ),
      );
    });

    on<TaleEndPlay>((event, emit) {
      print('end play');
      emit(
        state.copyWith(
          isPlay: false,
        ),
      );
      if (state.isPlayAllTalesMode) {
        add(
          NextTale(),
        );
      }
    });

    on<PlayAllTales>((event, emit) {
      print(event.isPlayAllTales);
      emit(
        state.copyWith(
          isPlayAllTalesMode: event.isPlayAllTales,
        ),
      );
      // PlayTaleState(
      //   isInit: state.isInit,
      //   isPlay: true,
      //   isPlayAllTalesMode: event.isPlayAllTales,
      //   allTales: state.allTales,
      //   selectedTales: state.selectedTales,
      //   currentPlayTaleIndex: state.currentPlayTaleIndex,
      // );
    });

    on<NextTale>((event, emit) {
      if (state.currentPlayTaleIndex == null) return;

      int nextTaleIndex = state.currentPlayTaleIndex! + 1;

      if (nextTaleIndex >= state.allTales!.length) {
        nextTaleIndex = 0;
      }

      add(
        PlayTale(nextTaleIndex),
      );
    });
  }
}
