import 'package:flutter/material.dart';

class QueryModel {
  var sort = {"bool": false, "type": "relevance", "desc": false};
  String artist;
  List<String> filterArray = [];
  bool sale = true;
  bool nextPage;
  RangeValues priceRange;
  QueryModel(
      {this.sale,
      this.sort,
      this.filterArray,
      this.priceRange,
      this.artist,
      this.nextPage});
}
