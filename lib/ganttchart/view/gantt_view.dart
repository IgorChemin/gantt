import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/utils.dart';
import '../controller/gantt_controller.dart';
import '../mod/prjmod.dart';

class GanttView extends StatefulWidget {
  //final int id_projeto; // Parâmetro para o ID do projeto
  //final int versao_projeto; // Parâmetro para a versão
  //final String nome_projeto; // Parâmetro para o nome do projeto
  //final List<PRJMOD> list_base;

  const GanttView({
    Key? key,
    //required this.id_projeto,
    //required this.versao_projeto,
    //required this.nome_projeto,
    //required this.list_base,
  }) : super(key: key);

  @override
  State<GanttView> createState() => _GanttViewState();
}

class _GanttViewState extends State<GanttView> {
  double larguraColuna30 = 0.0;

  @override
  Widget build(BuildContext context) {
    larguraColuna30 = MediaQuery.of(context).size.width * 0.3;
    final GanttController controller = Get.put(GanttController());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gantt Chart',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            color: Colors.white,
            tooltip: 'Carregar dados',
            onPressed: () async {
              await controller.fetch();
              await controller.GET_CALENDARIO();
            },
          ),
        ],
      ),
      body: GANTTCHART(controller),
    );
  }

  //Cria o cabeçalho da coluna 30%
  Widget HEAD_COLUNA_30(GanttController controller) {
    return Container(
      width: larguraColuna30,
      color: Colors.grey[350],
      child: Column(
        children: [
          Container(
            height: controller.par_alt_bloc_semana
                .value, // 50, // altura do cabeçalho da semana
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //icone button para adicionar tarefa
                IconButton(
                  icon: const Icon(Icons.settings),
                  color: Colors.grey,
                  tooltip: 'Configuração de parâmetros',
                  onPressed: () {
                    print('Configuração de parâmetros');
                    showGerenciarModal(context, controller);
                  },
                ),
                // Campo de texto para o filtro
                Container(
                  width: larguraColuna30 - 60, // Ajusta o espaço restante
                  height: 45,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TextField(
                      controller: controller.search,
                      onChanged: (value) {
                        print('[LOG] Buscar: $value');
                        controller.FILTRA_TAREFAS();
                      },
                      decoration: InputDecoration(
                        hintText: 'Buscar',
                        //prefixIcon: const Icon(Icons.search),
                        suffixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: controller
                .par_alt_head_dias.value, // 35, // altura do cabeçalho dos dias
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text('${controller.par_nome_projeto.value}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //agrupa head da semana e head dos dias
  Widget HEAD_COLUNA_70(GanttController controller) {
    return Expanded(
      child: Container(
        //color: Colors.grey[350],
        child: Column(
          children: [
            SEMANA(controller),

            // Detalhes fixos dos dias
            DIAS_SEMANA(controller),
          ],
        ),
      ),
    );
  }

  // Cria o widget do GanttChart
  Widget GANTTCHART(GanttController controller) {
    //double larguraColuna30 = MediaQuery.of(context).size.width * 0.3;
    return Obx(
      () => Scrollbar(
        thumbVisibility:
            true, // Mostra a barra de rolagem sempre que necessário
        controller:
            controller.horizontalScrollController, // Controlador para o scroll
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: controller.horizontalScrollController,
          child: Scrollbar(
            thumbVisibility: true,
            controller: controller
                .verticalScrollControllerGantt, // Sincroniza o scroll vertical
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              controller: controller
                  .verticalScrollControllerGantt, // Controlador vertical
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: larguraColuna30 +
                      (controller.dayDetails.length *
                          30.0), // Largura mínima para o conteúdo horizontal
                  // minHeight: controller.tasks.length * controller.par_alt_tarefa.value, // Altura mínima para o conteúdo vertical
                  // Garante que o mínimo seja a altura total da tela
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Container(
                  color: Colors.grey[300],
                  width:
                      larguraColuna30 + (controller.dayDetails.length * 30.0),

                  /*height: controller.tasks.length *
                      controller.par_alt_tarefa.value,*/
                  height: controller.tasks_G.isNotEmpty
                      ? controller.tasks_G.length *
                          controller.par_alt_tarefa.value
                      : MediaQuery.of(context)
                          .size
                          .height, // Altura total mínima
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          HEAD_COLUNA_30(controller),
                          HEAD_COLUNA_70(controller),
                        ],
                      ),
                      // Linhas de tarefas
                      TAREFAS(controller),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //apesenta HEAD Das semanas
  Widget SEMANA(GanttController controller) {
    return SizedBox(
      height: controller.par_alt_bloc_semana.value, // deault 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.weeks.length,
        itemBuilder: (context, index) {
          return Container(
            width: controller.par_lar_bloc_semana.value,
            color: Colors.blue,
            child: Center(
              child: Text(
                controller.weeks[index],
                style: TextStyle(
                    fontSize: controller.par_size_text_bloc_semana.value,
                    color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }

  //apresenta HEAD dos diaspe
  Widget DIAS_SEMANA(GanttController controller) {
    return SizedBox(
      height: controller.par_alt_head_dias.value, // default 35,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.dayDetails.length,
        itemBuilder: (context, index) {
          final day = controller.dayDetails[index];
          return Container(
            width: controller.par_lar_head_dia.value, //default 30
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                day["NomeDia"] == "Sab" || day["NomeDia"] == "Dom"
                    ? Container(
                        width: controller.par_lar_head_dia.value, //30,
                        color: Colors.black,
                        child: Center(
                          child: Text(
                            '${day["NomeDia"]}',
                            style: TextStyle(
                                fontSize:
                                    controller.par_size_text_head_dia.value,
                                color: Colors.white),
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.white,
                        child: Text(
                          '${day["NomeDia"]}',
                          style: TextStyle(
                              fontSize: controller.par_size_text_head_dia.value,
                              color: Colors.black),
                        ),
                      ),
                day["NomeDia"] == "Sab" || day["NomeDia"] == "Dom"
                    ? Container(
                        width: controller.par_lar_head_dia.value, //30,
                        color: Colors.grey[350],
                        child: Center(
                          child: Text(
                            '${day["nDia"]}',
                            style: TextStyle(
                                fontSize:
                                    controller.par_size_text_head_dia.value,
                                color: Colors.white),
                          ),
                        ),
                      )
                    : Text(
                        '${day["nDia"]}',
                        style: TextStyle(
                            fontSize: controller.par_size_text_head_dia.value,
                            color: Colors.black),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget TAREFAS(GanttController controller) {
    return Expanded(
      child: Obx(() => ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: controller.tasks_filtro.length, // Número de tarefas
            itemBuilder: (context, taskIndex) {
              final task = controller.tasks_filtro[taskIndex];
              final taskStartDate = DateTime.parse(task.startDate);
              final taskEndDate = DateTime.parse(task.endDate);

              int diferencaDias = taskEndDate.difference(taskStartDate).inDays;

              // Calcula a posição inicial da tarefa
              int ndiasstar = 0;
              for (var dayd in controller.dayDetails) {
                if (dayd["nDia"] == taskStartDate.day &&
                    dayd["Data"] == taskStartDate) {
                  break;
                }

                ndiasstar++;
              }

              // Calcula a largura da tarefa com base nos dias
              int ndiasend = 0;
              for (var dayd in controller.dayDetails) {
                if (dayd["nDia"] == taskEndDate.day &&
                    dayd["Data"] == taskEndDate) {
                  break;
                }
                ndiasend++;
              }
              print('NDIASSTAR: $ndiasstar | NDIASEND: $ndiasend');
              // Certifique-se de que o cálculo do duration seja válido
              int duration = 1;
              if (ndiasstar > ndiasend) {
                int numeroDeDias =
                    taskEndDate.difference(taskStartDate).inDays + 1;
                print('numeroDeDias: $numeroDeDias');
                //if (duration == 0) {
                duration = numeroDeDias;
                //}
              } else {
                duration = ((ndiasend - ndiasstar) + 1)
                    .clamp(0, controller.dayDetails.length);
                //AJUST EM ANDAMENTO
                if (duration == 0) {
                  duration = 1;
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 1),
                child: Row(
                  children: [
                    // Nome da Tarefa (30%)
                    Container(
                      width:
                          larguraColuna30, // Largura fixa para a coluna de nomes
                      height: controller.par_alt_tarefa.value,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      color: Colors.grey[200],
                      child: Row(
                        children: [
                          Icon(
                            Icons.task,
                            //.subdirectory_arrow_right, // Ícone de "Enter"
                            color: Colors.green,
                            size: 20,
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: TEXTO(
                                task.name,
                                controller.par_size_text_tarefa.value,
                                Colors.black,
                                2,
                                TextAlign.start),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          // Preenche os espaços antes da tarefa com contêineres brancos
                          for (int i = 0; i < ndiasstar; i++)
                            if (task.dependencia.isNotEmpty &&
                                i == ndiasstar - 1)
                              Container(
                                width: controller.par_lar_head_dia
                                    .value, // Largura de cada dia
                                height: controller.par_alt_tarefa.value,
                                color: controller.dayDetails[i]["NomeDia"] ==
                                            "Sab" ||
                                        controller.dayDetails[i]["NomeDia"] ==
                                            "Dom"
                                    ? Colors.grey[
                                        300] // Cinza para sábados e domingos
                                    : Colors.white,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.task,
                                    color: controller.dayDetails[i]
                                                    ["NomeDia"] ==
                                                "Sab" ||
                                            controller.dayDetails[i]
                                                    ["NomeDia"] ==
                                                "Dom"
                                        ? Colors
                                            .green // Cinza para sábados e domingos
                                        : Colors.black,
                                    size: 20,
                                  ),
                                  tooltip:
                                      'Dependência ${controller.getNomeTask(task.dependencia)}',
                                  onPressed: () {
                                    controller.search.text = task.dependencia;
                                    controller.FILTRA_DEPENDENCIA();
                                    //gera mensagem que esta em desenvolvimento para usuario
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            const Text('Em desenvolvimento...'),
                                      ),
                                    );
                                  },
                                ),
                              )
                            else
                              Container(
                                width: controller.par_lar_head_dia
                                    .value, // Largura de cada dia
                                height: controller.par_alt_tarefa.value,
                                color: controller.dayDetails[i]["NomeDia"] ==
                                            "Sab" ||
                                        controller.dayDetails[i]["NomeDia"] ==
                                            "Dom"
                                    ? Colors.grey[
                                        300] // Cinza para sábados e domingos
                                    : Colors
                                        .white, // Branco para os demais dias
                              ),
                          // Adiciona o contêiner da tarefa
                          GestureDetector(
                            onLongPress: () {
                              print('[LOG] Tarefa: ${task.name}');
                              String dependencia_ =
                                  controller.getNomeTask(task.dependencia);
                              Map DADOS = {
                                "ID": task.id,
                                "NOME": task.name,
                                "DATA_INICIO": task.startDate,
                                "DATA_FIM": task.endDate,
                                "PROGRESSO": task.progess,
                                "DEPENDENCIA": dependencia_,
                                "DURACAO": diferencaDias
                              };
                              showOpcoes(context, controller, DADOS);
                            },
                            child: Container(
                              //duration
                              width: (duration *
                                  controller.par_lar_head_dia.value),

                              // Largura com base no duration
                              height: controller
                                  .par_alt_tarefa.value, // Altura da tarefa
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 1),
                                color: Colors.green[100],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Stack(
                                children: [
                                  // Barra de progresso (preenchimento com base no progresso)
                                  FractionallySizedBox(
                                    widthFactor: task.progess /
                                        100, // Percentual concluído
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ),
                                  // Nome da tarefa no centro
                                  Center(
                                    child: Text(
                                      '${task.progess}%',
                                      style: TextStyle(
                                          fontSize: controller
                                              .par_size_text_tarefa_progress
                                              .value,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Preenche os espaços restantes após a tarefa com contêineres brancos
                          if (ndiasstar <= ndiasend)
                            for (int i =
                                    ndiasend == 1 ? ndiasend : ndiasend + 1;
                                i < controller.dayDetails.length;
                                i++)
                              Container(
                                width: controller.par_lar_head_dia.value,
                                height: controller.par_alt_tarefa.value,
                                color: controller.dayDetails[i]["NomeDia"] ==
                                            "Sab" ||
                                        controller.dayDetails[i]["NomeDia"] ==
                                            "Dom"
                                    ? Colors.grey[300]
                                    : Colors.white,
                              ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          )),
    );
  }

  void showGerenciarModal(BuildContext context, GanttController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: screenWidth * 0.50,
            height: screenHeight * 0.50,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Configurações',
                      style: TextStyle(
                        fontSize: controller.par_size_text_tarefa.value,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 100, // Tamanho fixo para o rótulo "EDTs"
                      child: Text(
                        'EDTs',
                        style: TextStyle(
                          fontSize: controller.par_size_text_tarefa.value,
                        ),
                      ),
                    ),
                    SizedBox(width: 1), // Espaço entre o rótulo e o ComboBox
                    Flexible(
                      // Permite que o DropdownButton ocupe o espaço restante
                      child: Obx(() {
                        return Visibility(
                          visible: controller.par_show_tarefas.value,
                          child: Container(
                            width: double
                                .infinity, // Garante que respeite o espaço do Row
                            child: DropdownButton<String>(
                              isExpanded:
                                  true, // Faz com que o Dropdown use toda a largura do Container
                              hint: Text("Selecione uma tarefa"),
                              value: controller
                                          .par_selected_edt.value.isNotEmpty &&
                                      controller.tasks_edts.any((task) =>
                                          task["ID"] ==
                                          controller.par_selected_edt.value)
                                  ? controller.par_selected_edt.value
                                  : null, // Evita erro de valor inválido
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  String id = controller.tasks_edts.firstWhere(
                                      (task) => task["ID"] == newValue,
                                      orElse: () => {"ID": ""})["ID"];
                                  controller.par_selected_edt.value = newValue;
                                  controller.par_selected_edt_id.value = id;
                                  controller.FILTRA_EDT_TAREFAS();
                                }
                              },
                              items: controller.tasks_edts.map((task_) {
                                return DropdownMenuItem<String>(
                                  value:
                                      task_['ID'], // ID como valor selecionado
                                  child: Text(
                                    task_['NOME'], // Nome exibido no Dropdown
                                    overflow: TextOverflow
                                        .ellipsis, // Evita textos longos
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
                SizedBox(height: 15), // Espaço entre os elementos
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Show Tarefas',
                      style: TextStyle(
                        fontSize: controller.par_size_text_tarefa.value,
                      ),
                    ),
                    Obx(() {
                      return Switch(
                        value: controller.par_show_tarefas.value,
                        onChanged: (bool value) {
                          print('[log] Show Tarefas: $value');

                          controller.par_show_tarefas.value = value;

                          controller.par_selected_edt.value =
                              'Todos'; //EDT selecionado
                          controller.par_selected_edt_id.value = 'Todos';

                          controller.CARREGA_EDTS_COMO_TAREFAS();
                        },
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showOpcoes(BuildContext context, GanttController controller, Map Dados) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: screenWidth * 0.35,
            height: screenHeight * 0.25,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Detalhes da Tarefa',
                      style: TextStyle(
                        fontSize: controller.par_size_text_tarefa.value,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                              child: Text('Id :',
                                  style: TextStyle(
                                    fontSize:
                                        controller.par_size_text_tarefa.value,
                                  ))),
                          SizedBox(
                              width: 4), // Espaço entre o rótulo e o ComboBox
                          Container(
                              child: Text('${Dados["ID"]}',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize:
                                        controller.par_size_text_tarefa.value,
                                  ))),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Row(
                    children: [
                      Container(
                          child: Text('Nome :',
                              style: TextStyle(
                                fontSize: controller.par_size_text_tarefa.value,
                              ))),
                      SizedBox(width: 3), // Espaço entre o rótulo e o ComboBox
                      Container(
                          child: Text('${Dados["NOME"]}',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: controller.par_size_text_tarefa.value,
                              ))),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                              child: Text('Data Inici. :',
                                  style: TextStyle(
                                    fontSize:
                                        controller.par_size_text_tarefa.value,
                                  ))),
                          SizedBox(
                              width: 4), // Espaço entre o rótulo e o ComboBox
                          Container(
                              child: Text('${Dados["DATA_INICIO"]}',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize:
                                        controller.par_size_text_tarefa.value,
                                  ))),
                        ],
                      ),
                    ),
                    //LINHA DATA INICIO E FIM
                    Container(
                      child: Row(
                        children: [
                          Container(
                              child: Text('Data Fim :',
                                  style: TextStyle(
                                    fontSize:
                                        controller.par_size_text_tarefa.value,
                                  ))),
                          SizedBox(
                              width: 4), // Espaço entre o rótulo e o ComboBox
                          Container(
                              child: Text('${Dados["DATA_FIM"]}',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize:
                                        controller.par_size_text_tarefa.value,
                                  ))),
                        ],
                      ),
                    ),
                    //LINHA QUE APRESENTA DURACAO
                    Container(
                      child: Row(
                        children: [
                          Container(
                              child: Text('Duração :',
                                  style: TextStyle(
                                    fontSize:
                                        controller.par_size_text_tarefa.value,
                                  ))),
                          SizedBox(
                              width: 4), // Espaço entre o rótulo e o ComboBox
                          Container(
                              child: Text('${Dados["DURACAO"]}',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize:
                                        controller.par_size_text_tarefa.value,
                                  ))),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                          child: Text('Dependencia :',
                              style: TextStyle(
                                fontSize: controller.par_size_text_tarefa.value,
                              ))),
                      SizedBox(width: 4), // Espaço entre o rótulo e o ComboBox
                      Container(
                          child: Text('${Dados["DEPENDENCIA"]}',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: controller.par_size_text_tarefa.value,
                              ))),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  //END CLASS
}
