import 'dart:async';

import 'package:bloc/bloc.dart';

class OffsetPagingCubitStateItem<TItem, TParam> {
  final TItem item;
  final TParam param;

  OffsetPagingCubitStateItem({required this.item, required this.param});
}

typedef PageItem<TItem, TParam> = OffsetPagingCubitStateItem<TItem, TParam>;

class OffsetPagingCubitState<TItem, TParam> {
  final List<OffsetPagingCubitStateItem<TItem, TParam>> items;
  final bool isLoading;
  final bool isFetchingMore;
  final bool isError;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final TParam initialPageParam;
  bool started = false;

  OffsetPagingCubitState({
    this.items = const [],
    required this.isLoading,
    required this.isFetchingMore,
    required this.isError,
    required this.hasNextPage,
    required this.hasPreviousPage,
    required this.initialPageParam,
    this.started = false,
  });

  OffsetPagingCubitState<TItem, TParam> copyWith({
    List<OffsetPagingCubitStateItem<TItem, TParam>>? items,
    bool? isLoading,
    bool? isFetchingMore,
    bool? isError,
    bool? hasNextPage,
    bool? hasPreviousPage,
    TParam? initialPageParam,
    bool? started,
  }) {
    return OffsetPagingCubitState(
        items: items ?? this.items,
        isLoading: isLoading ?? this.isLoading,
        isFetchingMore: isFetchingMore ?? this.isFetchingMore,
        isError: isError ?? this.isError,
        hasNextPage: hasNextPage ?? this.hasNextPage,
        hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
        initialPageParam: initialPageParam ?? this.initialPageParam,
        started: started ?? this.started);
  }
}

abstract class OffsetPagingCubit<TPage, TParam>
    extends Cubit<OffsetPagingCubitState<TPage, TParam>> {
  OffsetPagingCubit(TParam initialPageParam)
      : super(OffsetPagingCubitState(
          isLoading: false,
          isFetchingMore: false,
          hasNextPage: false,
          hasPreviousPage: false,
          isError: false,
          initialPageParam: initialPageParam,
        ));

  Future<TPage> queryFn(TParam param);

  Future<void> fetchNextPage() async {
    TParam? param = _getNextPageParam();

    if (param == null) return;

    if (!state.started) {
      emit(state.copyWith(isLoading: true));
    } else {
      emit(state.copyWith(isFetchingMore: true));
    }

    try {
      TPage nextPage = await queryFn(param);
      emit(state.copyWith(
        items: [
          ...state.items,
          OffsetPagingCubitStateItem(item: nextPage, param: param)
        ],
        hasNextPage: getNextPageParam(param, nextPage) != null,
        hasPreviousPage: getPreviousPageParam(param, nextPage) != null,
        isLoading: false,
        isFetchingMore: false,
        started: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isFetchingMore: false,
        isLoading: false,
        isError: true,
      ));
    }
  }

  TParam? _getNextPageParam() {
    return !state.started
        ? state.initialPageParam
        : getNextPageParam(state.items.last.param, state.items.last.item);
  }

  TParam? getNextPageParam(TParam lastParam, TPage lastPage);

  TParam? getPreviousPageParam(TParam firstParam, TPage firstPage);

  void reset() {
    emit(
      OffsetPagingCubitState(
        items: [],
        isLoading: false,
        isFetchingMore: false,
        isError: false,
        hasNextPage: false,
        hasPreviousPage: false,
        initialPageParam: state.initialPageParam,
        started: false,
      ),
    );
  }
}
