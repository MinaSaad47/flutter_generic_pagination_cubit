class OffsetPage<T> {
  final List<T> items;
  OffsetPagingInfo pagingInfo;

  OffsetPage({required this.items, required this.pagingInfo});
}

class OffsetPagingInfo {
  final int page;
  final int pageSize;
  final int total;
  final bool hasNextPage;
  final bool hasPreviousPage;

  OffsetPagingInfo({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });
}
