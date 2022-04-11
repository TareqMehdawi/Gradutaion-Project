import 'package:flutter/material.dart';

class Message{
  final String name;
  final String service;
  final DateTime date;
  final TimeOfDay time;


  const Message({
    required this.name,
    required this.service,
    required this.date,
    required this.time,
});
}
