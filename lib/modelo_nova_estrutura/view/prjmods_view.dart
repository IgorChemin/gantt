import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../components/modal_adicionar.dart';
import '../controller/prjmods_controller.dart';

class PrjmodsView extends GetView<PrjmodsController> {
  PrjmodsController _controller = Get.put(PrjmodsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projeto Mods View'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                _controller.PRINT_ESTRUTURA();
              },
              icon: Icon(Icons.bug_report)),
          IconButton(
              onPressed: () {
                _controller.projects.refresh();
              },
              icon: Icon(Icons.refresh)),
        ],
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: _controller.projects.length,
          itemBuilder: (context, index) {
            final project = _controller.projects[index];
            return _buildProjectItem(project, _controller, context);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.adicionarEstrutura();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Primeiro LINHA SERA PROJETO
  Widget _buildProjectItem(
      Project project, PrjmodsController controller, BuildContext context) {
    return ExpansionTile(
      title: Text(project.name),
      children: project.items
          .map((item) => _buildItem(item, project.id, controller, context))
          .toList(),
      trailing: IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          // Lógica para adicionar EDT ou tarefa
          String projectId = project.id;
          print('[LOG] _buildProjectItem -> ID: $projectId');
          showAddDialog("", 1, controller, context, true, false, false);
        },
      ),
    );
  }

  Widget _buildItem(dynamic item, String projectId,
      PrjmodsController controller, BuildContext context) {
    //verifica se o item e uma EDT
    if (item is EDT) {
      return ExpansionTile(
        title: LINHA_ITENS(item.name, item.nivel, "EDT"),
        children: item.items
            .map((subItem) => _buildItem(subItem, item.id, controller, context))
            .toList(),
        trailing: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () async {
            String selecID_EDT = item.id;
            int selectNivel_EDT = item.nivel;
            String selectName = item.name;
            print(
                '[LOG] ID: $selecID_EDT Nivel: $selectNivel_EDT Nome: $selectName');
            if (selectNivel_EDT == 1) {
              showAddDialog(selecID_EDT, selectNivel_EDT, controller, context,
                  true, false, true);
            } else {
              //_TASK
              showAddDialog(selecID_EDT, selectNivel_EDT, controller, context,
                  false, false, true);
            }

            print('[LOG]-> Nova Edt add');
          },
        ),
      );
      // caso o item seja uma tarefa
    } else if (item is Task) {
      return ExpansionTile(
        // Transforma a Task em ExpansionTile
        title: LINHA_ITENS(item.name, item.nivel, "Tarefa"),
        children: item.items
                ?.map((activity) =>
                    _buildActivity(activity, item.id, controller, context))
                .toList() ??
            [], // Renderiza as Activities
        trailing: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            print('[log]-> Nova Tarefa activity');
            showAddDialog(item.id, item.nivel, controller, context, false, true,
                true); // Passa isActivity: true
          },
        ),
      );
    } else if (item is Activity) {
      return _buildActivity(item, projectId, controller, context);
    }
    return Container(); // Ou um widget padrão para outros tipos
  }

  Widget _buildActivity(Activity activity, String taskId,
      PrjmodsController controller, BuildContext context) {
    return LINHA_ITENS(activity.name, activity.nivel, "Activity");
  }

  // LINHA ITENS E O RESPONSAVEL POR FAZER ESPACAMENTOS DOS CAMPOS DANDO UMA APARENCIA DE ARVORE DE ARQUIVOS
  Widget LINHA_ITENS(String nome, int nivel, String Tipo) {
    print('[LOG] Nivel: $nivel  Tipo: $Tipo Nome: $nome');
    if (Tipo == "EDT") {
      if (nivel == 1) {
        return Row(
          children: [
            Icon(Icons.folder, color: Colors.yellow[600]),
            SizedBox(width: 5),
            Text(nome),
          ],
        );
      } else {
        return Row(
          children: [
            SizedBox(width: 25),
            Icon(Icons.folder, color: Colors.yellow[600]),
            SizedBox(width: 5),
            Text(nome),
          ],
        );
      }
    } else if (Tipo == "Tarefa") {
      if (nivel == 1) {
        return ListTile(
          title: Row(
            children: [
              Icon(Icons.task, color: Colors.green),
              SizedBox(width: 5),
              Text(nome),
            ],
          ),
        );
      } else if (nivel == 2) {
        return ListTile(
          title: Row(
            children: [
              Container(width: 10, color: Colors.amber),
              Icon(Icons.task, color: Colors.green),
              SizedBox(width: 5),
              Text(nome),
            ],
          ),
        );
      } else if (nivel == 3) {
        return ListTile(
          title: Row(
            children: [
              Container(width: 50, color: Colors.amber),
              Icon(Icons.task, color: Colors.green),
              SizedBox(width: 5),
              Text(nome),
            ],
          ),
        );
      } else {
        return ListTile(
          title: Row(
            children: [
              Container(width: 75, color: Colors.amber),
              Icon(Icons.task, color: Colors.green),
              SizedBox(width: 5),
              Text(nome),
            ],
          ),
        );
      }
    } else {
      if (nivel == 1) {
        return ListTile(
          title: Row(
            children: [
              Icon(Icons.extension_outlined, color: Colors.red),
              SizedBox(width: 5),
              Text(nome),
            ],
          ),
        );
      } else if (nivel == 2) {
        return ListTile(
          title: Row(
            children: [
              Container(width: 25, color: Colors.amber),
              Icon(Icons.extension_outlined, color: Colors.red),
              SizedBox(width: 5),
              Text(nome),
            ],
          ),
        );
      } else if (nivel == 3) {
        return ListTile(
          title: Row(
            children: [
              Container(width: 50, color: Colors.amber),
              Icon(Icons.extension_outlined, color: Colors.red),
              SizedBox(width: 5),
              Text(nome),
            ],
          ),
        );
      } else {
        return ListTile(
          title: Row(
            children: [
              Container(width: 75, color: Colors.amber),
              Icon(Icons.extension_outlined, color: Colors.red),
              SizedBox(width: 5),
              Text(nome),
            ],
          ),
        );
      }
    }
  }

  void showAddDialog(
    String selecID_EDT,
    int selectNivel_EDT,
    PrjmodsController controller,
    BuildContext context,
    bool isEdt,
    bool isActivity,
    bool isTask,
  ) {
    final _nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Informe o nome"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Nome'),
                  ),
                  SizedBox(height: 10),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Cancelar'),
                ),
                isTask == true
                    ? TextButton(
                        onPressed: () {
                          final name = _nameController.text
                              .toString()
                              .toUpperCase()
                              .trim();
                          if (name.isNotEmpty) {
                            if (isActivity) {
                              controller.addActivity(selecID_EDT, name,
                                  selectNivel_EDT + 1); // Nível incrementado
                            } else {
                              controller.addTask(
                                  selecID_EDT, name, selectNivel_EDT);
                            }
                            Get.back();
                          }
                        },
                        child: isActivity == true
                            ? Text("Salvar Atividade")
                            : Text('Salvar Tarefa'),
                      )
                    : Text(''),
                isEdt == true
                    ? TextButton(
                        onPressed: () {
                          final name = _nameController.text
                              .toString()
                              .toUpperCase()
                              .trim();
                          if (name.isNotEmpty) {
                            controller.addEdt(
                                selecID_EDT, name, selectNivel_EDT);
                            Get.back();
                          }
                        },
                        child: const Text('Salvar Edt'),
                      )
                    : Text(''),
              ],
            );
          },
        );
      },
    );
  }

  //end classe
}
