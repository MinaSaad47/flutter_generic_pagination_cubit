import 'package:flutter_pagination/offset_paging_cubit.dart';
import 'package:flutter_pagination/pagination_models.dart';

class OfferModel {
  final String title;
  final String description;

  const OfferModel({
    required this.title,
    required this.description,
  });
}

class OfferParams {
  final int page;
  final int pageSize;

  const OfferParams({
    this.page = 1,
    this.pageSize = 5,
  });
}

class OfferService {
  final List<OfferModel> _offers = [
    const OfferModel(title: 'Offer 1', description: 'Description 1'),
    const OfferModel(title: 'Offer 2', description: 'Description 2'),
    const OfferModel(title: 'Offer 3', description: 'Description 3'),
    const OfferModel(title: 'Offer 4', description: 'Description 4'),
    const OfferModel(title: 'Offer 5', description: 'Description 5'),
    const OfferModel(title: 'Offer 6', description: 'Description 6'),
    const OfferModel(title: 'Offer 7', description: 'Description 7'),
    const OfferModel(title: 'Offer 8', description: 'Description 8'),
    const OfferModel(title: 'Offer 9', description: 'Description 9'),
    const OfferModel(title: 'Offer 10', description: 'Description 10'),
    const OfferModel(title: 'Offer 11', description: 'Description 11'),
    const OfferModel(title: 'Offer 12', description: 'Description 12'),
    const OfferModel(title: 'Offer 13', description: 'Description 13'),
    const OfferModel(title: 'Offer 14', description: 'Description 14'),
    const OfferModel(title: 'Offer 15', description: 'Description 15'),
    const OfferModel(title: 'Offer 16', description: 'Description 16'),
  ];

  OffsetPage<OfferModel> getPaginatedOffers(OfferParams params) {
    final startIndex = (params.page - 1) * params.pageSize;
    final endIndex = startIndex + params.pageSize;

    return OffsetPage<OfferModel>(
      items: _offers.sublist(startIndex, endIndex),
      pagingInfo: OffsetPagingInfo(
        total: _offers.length,
        page: params.page,
        hasNextPage: endIndex < _offers.length,
        hasPreviousPage: params.page > 1,
        pageSize: params.pageSize,
      ),
    );
  }
}

class OfferCubit
    extends OffsetPagingCubit<OffsetPage<OfferModel>, OfferParams> {
  OfferCubit(super.initialPageParam);

  @override
  Future<OffsetPage<OfferModel>> queryFn(OfferParams param) {
    return Future.value(OfferService().getPaginatedOffers(param));
  }

  @override
  OfferParams? getNextPageParam(
      OfferParams lastParam, OffsetPage<OfferModel> lastPage) {
    return lastPage.pagingInfo.hasNextPage
        ? OfferParams(page: lastParam.page + 1)
        : null;
  }

  @override
  OfferParams? getPreviousPageParam(
      OfferParams firstParam, OffsetPage<OfferModel> firstPage) {
    return null;
  }
}
