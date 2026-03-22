import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_filter.freezed.dart';
part 'search_filter.g.dart';

@freezed
abstract class SearchFilter with _$SearchFilter {
  const factory SearchFilter({
    // Text search
    String? query,
    // Dimension ranges (mm)
    double? widthMin,
    double? widthMax,
    double? heightMin,
    double? heightMax,
    double? depthMin,
    double? depthMax,
    double? pipeDiameterMin,
    double? pipeDiameterMax,
    // Voltage filter
    int? voltage, // null = all, 100, 200
    // Price range
    int? priceMin,
    int? priceMax,
    // Manufacturer filter (multiple select)
    @Default([]) List<String> manufacturerIds,
    // Category filter
    String? categoryId,
    // Include discontinued
    @Default(false) bool includeDiscontinued,
    // Sorting
    @Default('updated_at') String sortBy,
    @Default(false) bool sortAscending,
    // Pagination
    @Default(0) int offset,
    @Default(20) int limit,
  }) = _SearchFilter;

  factory SearchFilter.fromJson(Map<String, dynamic> json) =>
      _$SearchFilterFromJson(json);
}

extension SearchFilterX on SearchFilter {
  int get activeFilterCount {
    int count = 0;
    if (voltage != null) count++;
    if (widthMin != null || widthMax != null) count++;
    if (heightMin != null || heightMax != null) count++;
    if (depthMin != null || depthMax != null) count++;
    if (pipeDiameterMin != null || pipeDiameterMax != null) count++;
    if (priceMin != null || priceMax != null) count++;
    if (manufacturerIds.isNotEmpty) count++;
    if (categoryId != null) count++;
    if (includeDiscontinued) count++;
    return count;
  }
}
