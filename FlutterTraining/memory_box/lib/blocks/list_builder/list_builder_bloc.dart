import 'package:bloc/bloc.dart';
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
          allTales: allTales,
          isInit: true,
        ),
      );
    });
    on<DeleteTale>((event, emit) async {
      DatabaseService.instance.setTaleDeleteStatus(event.taleID);

      state.allTales?.removeWhere((item) => item.ID == event.taleID);

      emit(state);
    });
    on<DeleteFewTales>((event, emit) {});
    on<UndoRenameTale>((event, emit) {
      emit(state);
    });
    on<RenameTale>((event, emit) {
      DatabaseService.instance.updateTaleData(
        taleID: event.taleID,
        title: event.newTitle,
      );

      int renamedIndex = state.allTales!.indexWhere(
        (element) => element.ID == event.taleID,
      );

      state.allTales?[renamedIndex].title = event.newTitle;

      emit(state);
    });

    on<ShareTale>((event, emit) {
      Share.share(event.taleUrl);
    });

    on<PlayTale>((event, emit) {
      emit(
        state.copyWith(currentPlayTaleIndex: event.taleIndex),
      );
    });
    on<StopTale>((event, emit) {
      emit(
        state.copyWith(
          currentPlayTaleIndex: null,
        ),
      );
    });
  }
}
