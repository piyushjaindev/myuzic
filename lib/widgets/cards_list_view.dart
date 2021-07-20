import 'package:flutter/material.dart';

import '../models/base_model.dart';

class CardsListView extends StatelessWidget {
  final List<BaseModel> models;
  CardsListView(this.models);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(left: 12, top: 10, bottom: 20),
      itemBuilder: (context, index) => models[index].toCard(),
      separatorBuilder: (context, index) => SizedBox(width: 15),
      itemCount: models.length,
      scrollDirection: Axis.horizontal,
    );
  }
}
