import 'package:get/get.dart';

class Project {
  String id;
  String name;
  String status;
  RxList<dynamic> items;

  Project(
      {required this.id,
      required this.name,
      List<dynamic>? items,
      this.status = 'N'})
      : items = (items ?? []).obs;
}

class EDT {
  String id;
  String name;
  RxList<dynamic> items;
  String status;
  int order;
  int nivel;

  EDT(
      {required this.id,
      required this.name,
      List<dynamic>? items,
      this.status = 'N',
      this.order = 0,
      this.nivel = 0})
      : items = (items ?? []).obs;
}

// models/task.dart
class Task {
  String id;
  String name;
  String status;
  int order;
  int nivel;
  String dataini;
  String datafim;
  String dependencia;
  int interno;
  String obs;
  RxList<dynamic>? items;

  Task(
      {required this.id,
      required this.name,
      List<dynamic>? items,
      this.dataini = '',
      this.datafim = '',
      this.dependencia = '',
      this.interno = 0,
      this.obs = '',
      this.status = 'N',
      this.order = 0,
      this.nivel = 0})
      : items = (items ?? []).obs;
}

class Activity {
  String id;
  String name;
  String status;
  int order;
  int nivel;
  String dataini;
  String datafim;
  String dependencia;
  int interno;
  String obs;

  Activity(
      {required this.id,
      required this.name,
      this.dataini = '',
      this.datafim = '',
      this.dependencia = '',
      this.interno = 0,
      this.obs = '',
      this.status = 'N',
      this.order = 0,
      this.nivel = 0});
}
