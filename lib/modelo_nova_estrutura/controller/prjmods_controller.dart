import 'dart:convert';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class PrjmodsController extends GetxController {
  final count = 0.obs;
  final projects = <Project>[].obs; // Lista observável de projetos
  final uuid = Uuid();

  void increment(int value) {
    count.value = value;
  }

  void addProject(Project project) {
    projects.add(project);
  }

  // METODO PARA ADICIONAR UMA EDT
  void addEdt(String edtId, String nome, int nivel) {
    print('[LOG] addEdt-> EDT ID: $edtId NOME: $nome NIVEL: $nivel');
    if (edtId == "") {
      print('[LOG] addEdt-> IF');
      final edtGeral = EDT(id: getUUID(), name: nome, order: 0, nivel: 1);
      projects[0].items.add(edtGeral);
      projects.refresh();
    } else {
      print('[LOG] addEdt-> ELSE');
      for (var project in projects) {
        for (var item in project.items) {
          if (item is EDT && item.id == edtId) {
            int order_ = item.order + 1;
            final edtGeral =
                EDT(id: getUUID(), name: nome, order: order_, nivel: nivel + 1);
            item.items.add(edtGeral);
            projects.refresh(); // Notifica a mudança na lista projects
            return;
          }
        }
      }
    }
  }

// METODO PARA ADICIONAR UMA TAREFA
  void addTask(String edtId, String nome, int nivel) {
    print('[LOG] addTask-> EDT ID: $edtId NOME: $nome NIVEL: $nivel');
    if (edtId == "") {
      print('[LOG] addTask-> edtId == ""');
      final task_ = Task(id: getUUID(), name: nome, order: 0, nivel: 1);
      projects[0].items.add(task_);
      projects.refresh();
    } else {
      print('[LOG] addTask-> else');
      for (var project in projects) {
        print('[LOG] addTask-> Projetos ID: ${project.id}');
        for (var item in project.items) {
          print('[LOG] addTask-> item: ${item.id} == $edtId ');
          if (item is EDT && item.id == edtId) {
            int order_ = item.order + 1;
            int nivel_ = item.nivel + 1;
            print('[LOG]-> ORDER: $order_ NIVEL: $nivel_');
            print('[LOG]-> ITM: $item');
            final task_ =
                Task(id: getUUID(), name: nome, order: order_, nivel: nivel_);
            item.items.add(task_);
            projects.refresh(); // Notifica a mudança na lista projects
            return;
          } else {
            for (var item2 in item.items) {
              print('[LOG] addTask-> item2: ${item2.id} == $edtId ');
              if (item2 is EDT && item2.id == edtId) {
                int order_ = item2.order + 1;
                int nivel_ = item2.nivel == 1 ? 0 : item2.nivel + 1;
                print('[LOG]-> ORDER: $order_ NIVEL: $nivel_');
                print('[LOG]-> ITM: $item2');
                final task_ = Task(
                    id: getUUID(), name: nome, order: order_, nivel: nivel_);
                item2.items.add(task_);
                projects.refresh(); // Notifica a mudança na lista projects
                return;
              }
            }
          }
        }
      }
    }
  }

//metodo para adicionar uma atividade
  void addActivity(String taskId, String nome, int nivel) {
    print('[LOG] addActivity-> Task ID: $taskId NOME: $nome NIVEL: $nivel');
    for (var projeto in projects) {
      print('[LOG] Projeto: ${projeto.name}');
      for (var item in projeto.items) {
        print('[LOG] Item: ${item.id} - ${item.name}');
        if (item is Task && item.id == taskId) {
          print('[LOG] Encontro Item: ${item.id} - ${taskId}');
          final activity = Activity(
              id: getUUID(),
              name: nome,
              order: item.items?.length ?? 0,
              nivel: nivel);
          item.items?.add(activity);
          projects.refresh();
          return;
        }
        for (var item2 in item.items) {
          print('  [LOG] Item2: ${item2.id} - ${item2.name}');
          if (item2 is Task && item2.id == taskId) {
            print('[LOG] Encontro Item2: ${item2.id} - ${taskId}');
            final activity = Activity(
                id: getUUID(),
                name: nome,
                order: item2.items?.length ?? 0,
                nivel: nivel);
            item2.items?.add(activity);
            projects.refresh();
            return;
          }
          for (var item3 in item2.items) {
            print('    [LOG] Item3: ${item3.id} - ${item3.name}');
            if (item3 is Task && item3.id == taskId) {
              print('[LOG] Encontro Item3: ${item3.id} - ${taskId}');
              final activity = Activity(
                  id: getUUID(),
                  name: nome,
                  order: item3.items?.length ?? 0,
                  nivel: nivel);
              item3.items?.add(activity);
              projects.refresh();
              return;
            }
          }
        }
      }
    }
  }

  //metodologia de teste
  void adicionarEstrutura() async {
    // 1. Criar o Projeto "Projeto 01"
    final projeto01 = Project(id: getUUID(), name: 'Projeto 01');
    projects.add(projeto01);
    //cria um delay de 1 segundo
    await Future.delayed(Duration(seconds: 1));

    // 2. Criar a EDT "Geral" dentro do Projeto 01
    final edtGeral = EDT(id: getUUID(), name: 'Geral', order: 0, nivel: 1);
    projeto01.items.add(edtGeral);

    await Future.delayed(Duration(seconds: 1));

    // 3. Criar a EDT "EDT 01" dentro da EDT "Geral"
    final edt01 = EDT(id: getUUID(), name: 'EDT 01', order: 0, nivel: 2);
    edtGeral.items.add(edt01);

    await Future.delayed(Duration(seconds: 1));

    // 4. Criar a Tarefa dentro da EDT "EDT 01"
    final tarefa01 = Task(id: getUUID(), name: 'Tarefa 01', order: 0, nivel: 3);
    edt01.items.add(tarefa01);

    await Future.delayed(Duration(seconds: 1));

    // 4. Criar a Tarefa dentro da EDT "EDT 01"
    final tarefa012 =
        Task(id: getUUID(), name: 'Tarefa 02', order: 0, nivel: 3);
    edt01.items.add(tarefa012);
    await Future.delayed(Duration(seconds: 1));
    // 4. Criar a Tarefa dentro da EDT "EDT 01"
    final tarefa013 =
        Task(id: getUUID(), name: 'Tarefa 03', order: 0, nivel: 3);
    edt01.items.add(tarefa013);

    await Future.delayed(Duration(seconds: 1));

    // 5. Criar outra Tarefa diretamente dentro da EDT "Geral"
    /*final tarefa02 = Task(id: getUUID(), name: 'Tarefa 02', order: 0, nivel: 1);
    edtGeral.items.add(tarefa02);

    await Future.delayed(Duration(seconds: 1));*/

    // 3. Criar a EDT "EDT 01" dentro da EDT "Geral"
    final edtGeral2 = EDT(id: getUUID(), name: 'Geral 02', order: 0, nivel: 1);
    projeto01.items.add(edtGeral2);

    await Future.delayed(Duration(seconds: 1));

    final tarefa04 = Task(id: getUUID(), name: 'Tarefa 04', order: 0, nivel: 2);
    edtGeral2.items.add(tarefa04);

    projects.refresh(); // Importante: Notifica as mudanças para a UI
    _printEstrutura(); // Chama a função para imprimir a estrutura no console
  }

  void _printEstrutura() {
    for (var projeto in projects) {
      print('Projeto: ${projeto.name}');
      for (var item in projeto.items) {
        if (item is EDT) {
          print('  EDT:${item.id} - ${item.name}');
          for (var subItem in item.items) {
            if (subItem is EDT) {
              print('    EDT: ${subItem.id} - ${subItem.name}');
              for (var tarefa in subItem.items) {
                print('      Tarefa:${tarefa.id} - ${tarefa.name}');
              }
            } else if (subItem is Task) {
              print('    Tarefa:${subItem.id} - ${subItem.name}');
            }
          }
        } else if (item is Task) {
          print('  Tarefa: ${item.id} - ${item.name}');
        }
      }
    }
  }

  void PRINT_ESTRUTURA() {
    for (var projeto in projects) {
      print('[LOG] Projeto: ${projeto.name}');
      for (var item in projeto.items) {
        print('[LOG] Item: ${item.id} - ${item.name}');
        for (var item2 in item.items) {
          print('  [LOG] Item2: ${item2.id} - ${item2.name}');
          for (var item3 in item2.items) {
            print('    [LOG] Item3: ${item3.id} - ${item3.name}');
            if (item3 is Activity) {
              //print('      [LOG] Item3: ${item3.id} - ${item3.name}');
            } else {
              for (var item4 in item3.items) {
                print('      [LOG] Item4: ${item4.id} - ${item4.name}');
              }
            }
          }
        }
      }
    }
  }

  String getUUID() {
    // Pega a data e hora atual
    var now = DateTime.now();
    // Converte para
    var timestamp = now
        .toString()
        .replaceAll('-', '')
        .replaceAll(' ', '')
        .replaceAll(':', '')
        .replaceAll('.', '');
    return timestamp.toString();
  }

  // END CLASSE
}

// models/project.dart
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

// models/edt.dart
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
