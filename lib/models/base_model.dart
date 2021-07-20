import 'package:flutter/material.dart';

abstract class BaseModel {
  final String id;
  final String name;
  final String cover;

  BaseModel({required this.id, required this.name, required this.cover});

  Widget toTile([String? subtitle]);
  Widget toCard();
}
