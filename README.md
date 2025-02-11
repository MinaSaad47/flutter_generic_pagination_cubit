# Generic cubit pagination example

An example of generic implementation of offset-based pagination using Cubit (Bloc)

## usage

```dart
class MyPagingCubit extends OffsetPagingCubit<List<String>, int> {
  MyPagingCubit() : super(0); // Start page index

  @override
  Future<List<String>> queryFn(int param) async {
    await Future.delayed(const Duration(seconds: 1));
    return List.generate(10, (index) => "Item ${param * 10 + index}");
  }

  @override
  int? getNextPageParam(int lastParam, List<String> lastPage) {
    return lastPage.isEmpty ? null : lastParam + 1;
  }

  @override
  int? getPreviousPageParam(int firstParam, List<String> firstPage) {
    return firstParam > 0 ? firstParam - 1 : null;
  }
}
```
