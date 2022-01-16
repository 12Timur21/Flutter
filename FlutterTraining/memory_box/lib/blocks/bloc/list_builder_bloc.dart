import 'package:bloc/bloc.dart';
import 'package:memory_box/models/tale_model.dart';
import 'package:memory_box/repositories/database_service.dart';
import 'package:share_plus/share_plus.dart';
part 'list_builder_event.dart';
part 'list_builder_state.dart';

class ListBuilderBloc extends Bloc<ListBuilderEvent, ListBuilderState> {
  ListBuilderBloc() : super(NotInitializedListBuilderState()) {
    on<InitializeListBuilder>((event, emit) async {
      List<TaleModel> allTales = await event.initializationTales;
      emit(
        InitializedListBuilderState(allTales: allTales),
      );
    });
    on<DeleteTale>((event, emit) async {
      if (state is InitializedListBuilderState) {
        DatabaseService.instance.setTaleDeleteStatus(event.taleID);

        InitializedListBuilderState newState =
            state as InitializedListBuilderState;

        newState.allTales?.removeWhere((item) => item.ID == event.taleID);

        emit(
          InitializedListBuilderState(allTales: newState.allTales),
        );
      }
    });
    on<DeleteFewTales>((event, emit) {});
    on<UndoRenameTale>((event, emit) {
      InitializedListBuilderState newState =
          state as InitializedListBuilderState;
      emit(
        InitializedListBuilderState(allTales: newState.allTales),
      );
    });
    on<RenameTale>((event, emit) {
      DatabaseService.instance.updateTaleData(
        taleID: event.taleID,
        title: event.newTitle,
      );

      InitializedListBuilderState newState =
          state as InitializedListBuilderState;

      newState
          .allTales?[newState.allTales!.indexWhere(
        (element) => element.ID == event.taleID,
      )]
          .title = event.newTitle;

      emit(
        InitializedListBuilderState(allTales: newState.allTales),
      );
    });
    on<ShareTale>((event, emit) {
      Share.share(event.taleUrl);
    });
  }
}
