import 'package:flutter/material.dart';

enum GoRounds {
  m(8), l(12), circle(99);

  final double value;

  const GoRounds(this.value);

  BorderRadius get borderRadius => BorderRadius.circular(value);

  Radius get radius => Radius.circular(value);


}