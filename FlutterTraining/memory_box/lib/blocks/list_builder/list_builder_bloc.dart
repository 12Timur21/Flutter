import 'package:bloc/bloc.dart';
import 'package:memory_box/models/tale_model.dart';
import 'package:memory_box/repositories/database_service.dart';
part 'list_builder_event.dart';
part 'list_builder_state.dart';

class ListBuilderBloc extends Bloc<ListBuilderEvent, ListBuilderState> {
  ListBuilderBloc() : super(ListBuilderState()) {
    on<InitializeListBuilderWithFutureRequest>((event, emit) async {
      List<TaleModel> allTales = await event.initializationTales;
      emit(
        state.copyWith(
          isInit: true,
          allTales: allTales,
        ),
      );
    });

    on<InitializeListBuilderWithTaleModels>((event, emit) async {
      List<TaleModel>? allTales = event.initializationTales;
      emit(
        state.copyWith(
          isInit: true,
          allTales: allTales,
        ),
      );
    });
    on<DeleteTale>((event, emit) async {
      String? taleID = state.allTales[event.index].ID;
      if (taleID != null) {
        await DatabaseService.instance.setTaleDeleteStatus(taleID);
      }

      List<TaleModel>? updatedTaled = state.allTales;
      updatedTaled.removeAt(event.index);
      emit(
        state.copyWith(allTales: updatedTaled),
      );
    });

    on<UndoRenameTale>((event, emit) {
      emit(state.copyWith());
    });
    on<RenameTale>((event, emit) {
      DatabaseService.instance.updateTaleData(
        taleID: event.taleID,
        title: event.newTitle,
      );

      List<TaleModel>? updatedTaleList = state.allTales;

      int? renamedIndex = state.allTales.indexWhere(
        (element) => element.ID == event.taleID,
      );

      updatedTaleList[renamedIndex] =
          state.allTales[renamedIndex].copyWith(title: event.newTitle);

      emit(
        state.copyWith(allTales: updatedTaleList),
      );
    });

    on<TooglePlayMode>((event, emit) {
      if (state.isPlay && state.currentPlayTaleModel == event.taleModel ||
          event.taleModel == null) {
        emit(
          StopTaleState(
            isInit: state.isInit,
            isPlay: false,
            allTales: state.allTales,
            currentPlayTaleModel: state.currentPlayTaleModel,
            isPlayAllTalesMode: state.isPlayAllTalesMode,
          ),
        );
      } else {
        emit(
          PlayTaleState(
            isInit: state.isInit,
            isPlay: true,
            allTales: state.allTales,
            currentPlayTaleModel: event.taleModel,
            isPlayAllTalesMode: state.isPlayAllTalesMode,
          ),
        );
      }
    });

    on<TooglePlayAllMode>((event, emit) {
      emit(
        state.copyWith(
          isPlayAllTalesMode: !state.isPlayAllTalesMode,
        ),
      );
    });

    on<NextTale>((event, emit) {
      if (state.currentPlayTaleModel == null) return;
      int nextIndex = state.allTales
              .indexWhere((element) => element == state.currentPlayTaleModel) +
          1;

      if (nextIndex >= state.allTales.length) {
        nextIndex = 0;
      }

      add(
        TooglePlayMode(
          taleModel: state.allTales[nextIndex],
        ),
      );
    });
  }
}
