import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../mod/prjmod.dart';

class GanttController extends GetxController {
  String CLASS = 'GanntController->';

  @override
  void onInit() {
    super.onInit();
    log('Iniciando $CLASS');
    // Inicializa o controlador de rolagem horizontal
    verticalScrollControllerGantt = ScrollController();
    horizontalScrollController = ScrollController();

    //calcula_par_lar_bloc_semana(); // Calcula o tamanho do bloco da semana COM BASE NA LARGURA DO CABEÇALHO DO DIA
    //fetch();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    // Libera os controladores ao fechar
    verticalScrollControllerGantt.dispose();
    horizontalScrollController.dispose();
  }

  // variaveis
  var projects = <Project2>[].obs;
  //var tamanhodayDetails = 0.0.obs;
  var weeks = <String>[].obs;
  var dayDetails = <Map<String, dynamic>>[].obs;
  //var tasks = <task>[].obs;
  var tasks_G = <task_>[].obs;
  var tasks_Padrao = <task_>[].obs;
  var tasks_filtro = <task_>[].obs;
  var tasks_edts = <Map>[].obs;
  var tasks_edts_filtro = <Map>[].obs;
  var par_menorStartDate = DateTime.now().obs; // Data inicial mais antiga
  var par_maiorEndDate = DateTime.now().obs; // Data final mais recente

  //controller scroll
  late ScrollController verticalScrollControllerGantt; // Para o Gantt
  late ScrollController horizontalScrollController;
  //controle filtro
  final search = TextEditingController();

  //PARAMETROS DE CONFIGURAÇÃO

  var par_nome_projeto = 'Projeto 1'.obs; //Nome do projeto
  var par_versao_projeto = 1.obs; //Versão do projeto
  var par_id_projeto = 1.obs; //ID do projeto

  //SEMANA INICIO
  var par_lar_bloc_semana = 210.0.obs; //largura da bloco da semana
  var par_size_text_bloc_semana = 15.0.obs; //Tamanho da bolca do dia
  var par_alt_bloc_semana = 50.0.obs; //altura do bloco da semana
  //SEMANA FIM

  //DIA INICIO
  var par_alt_head_dias = 35.0.obs; // Altura do cabeçalho dos dias default 30
  var par_lar_head_dia = 30.0.obs; // largua do bloco do dia deault 30
  var par_size_text_head_dia = 12.0.obs; // Tamanho do texto do cabeçalho do dia
  //DIA FIM

  //TAREFA INICIO
  var par_alt_tarefa = 35.0.obs; // Altura da tarefa
  var par_size_text_tarefa = 13.0.obs; // tamanho da fonte da tarefa
  var par_size_text_tarefa_progress = 12.0.obs; // tamanho da fonte da tarefa

  //parametros de EDts Configurações
  var par_selected_edt = 'Todos'.obs; //EDT selecionado
  var par_selected_edt_id = 'Todos'.obs; //EDT selecionado
  var par_show_tarefas = true.obs; //Mostra tarefas

// Método para buscar EDTs e Tarefas do banco de dados
  Future<void> fetch() async {
    String METODO = '$CLASS fetch()->';
    try {
      print('[LOG]->************************************');
      print('[LOG]->$METODO Iniciando...');
      int VERSAO_PROJ = 1; // par_versao_projeto.value;
      int ID_PROJ = 1; //par_id_projeto.value;
      String NOME_PROJ = 'Projeto 1'; //par_nome_projeto.value;
      print('[LOG]->$METODO ID_PROJ: $ID_PROJ');
      print('[LOG]->$METODO VERSAO_PROJ: $VERSAO_PROJ');
      print('[LOG]->$METODO NOME_PROJ: $NOME_PROJ');
      print('[LOG]->************************************');
      projects.clear();
      projects.refresh();
      tasks_G.clear();
      tasks_G.refresh();
      tasks_edts.clear();
      tasks_edts.refresh();
      tasks_filtro.clear();
      tasks_filtro.refresh();
      //verifica os projetos
      projects.add(Project2(id: '$ID_PROJ', name: NOME_PROJ));

      final edtGeral1 =
          EDT2(id: '20250301_EDT01', name: 'EDT 01', order: 0, status: 'S');
      projects.first.edts.add(edtGeral1);
      print('[LOG]->$METODO EDT 01 adicionada com sucesso.');
      final edtGeral2 =
          EDT2(id: '20250301_EDT02', name: 'EDT 02', order: 1, status: 'S');
      projects.first.edts.add(edtGeral2);
      print('[LOG]->$METODO EDT 02 adicionada com sucesso.');
      final edtGeral3 =
          EDT2(id: '20250301_EDT03', name: 'EDT 03', order: 2, status: 'S');
      projects.first.edts.add(edtGeral3);
      print('[LOG]->$METODO EDT 03 adicionada com sucesso.');

      //ADD TAREFAZ 01
      var edt_ =
          projects.first.edts.firstWhere((e) => e.id == '20250301_EDT01');
      print('[LOG]->$METODO EDT 01 encontrada com sucesso. $edt_');
      edt_.tasks.add(TaskGantt(
          id: '20250301_TF01.1',
          name: 'TAREFA 01',
          status: 'S',
          order: 0,
          dependence: '',
          dataini: '2025-03-01',
          datafim: '2025-03-04',
          observacao: '',
          percentual: 10));
      print('[LOG]->$METODO EDT 01 add Task 01 com sucesso.');
      edt_.tasks.add(TaskGantt(
          id: '20250301_TF01.2',
          name: 'TAREFA 02',
          status: 'S',
          order: 1,
          dependence: '',
          dataini: '2025-03-01',
          datafim: '2025-03-04',
          observacao: '',
          percentual: 20));
      print('[LOG]->$METODO EDT 02 add Task 01 com sucesso.');
      projects.refresh();
      // ADD TASK 02
      var edt_2 =
          projects.first.edts.firstWhere((e) => e.id == '20250301_EDT02');
      print('[LOG]->$METODO EDT 02 encontrada com sucesso. $edt_2');
      edt_2.tasks.add(TaskGantt(
          id: '20250301_TF02.1',
          name: 'TAREFA 01',
          status: 'S',
          order: 0,
          dependence: '20250301_TF01.2',
          dataini: '2025-03-06',
          datafim: '2025-03-07',
          observacao: '',
          percentual: 10));
      print('[LOG]->$METODO EDT 02 add Task 01 com sucesso.');
      edt_2.tasks.add(TaskGantt(
          id: '20250301_TF02.2',
          name: 'TAREFA 02',
          status: 'S',
          order: 1,
          dependence: '',
          dataini: '2025-03-08',
          datafim: '2025-03-10',
          observacao: '',
          percentual: 20));
      print('[LOG]->$METODO EDT 02 add Task 02 com sucesso.');
      projects.refresh();
      // ADD TASK 03
      var edt_3 =
          projects.first.edts.firstWhere((e) => e.id == '20250301_EDT03');
      print('[LOG]->$METODO EDT 03 encontrada com sucesso. $edt_3');
      edt_3.tasks.add(TaskGantt(
          id: '20250301_TF03.1',
          name: 'TAREFA 01',
          status: 'S',
          order: 0,
          dependence: '',
          dataini: '2025-03-17',
          datafim: '2025-03-21',
          observacao: '',
          percentual: 10));
      print('[LOG]->$METODO EDT 03 add Task 01 com sucesso.');
      edt_3.tasks.add(TaskGantt(
          id: '20250301_TF03.2',
          name: 'TAREFA 02',
          status: 'S',
          order: 1,
          dependence: '',
          dataini: '2025-03-24',
          datafim: '2025-03-28',
          observacao: '',
          percentual: 20));
      print('[LOG]->$METODO EDT 03 add Task 02 com sucesso.');
      projects.refresh();
      print('[LOG]->$METODO Projetos carregados com sucesso.');
      printProjects();
    } catch (e) {
      log('[ERRO]->$e', name: METODO);
    }
  }

  // Método para imprimir os projetos e suas tarefas
  void printProjects() {
    print('\n===== INÍCIO DA LISTAGEM DOS PROJETOS =====\n');
    for (var project in projects) {
      print(
          'Projeto ID: ${project.id}, Nome: ${project.name}, Status: ${project.status}');

      if (project.edts.isNotEmpty) {
        print('  [EDTs]:');
        for (var edt in project.edts) {
          print(
              '    - EDT ID: ${edt.id}, Nome: ${edt.name}, Status: ${edt.status}, Ordem: ${edt.order}');

          if (edt.tasks.isNotEmpty) {
            print('      [Tarefas]:');
            for (var task in edt.tasks) {
              print('        * Tarefa ID: ${task.id}, Nome: ${task.name}');
              print('          - Status: ${task.status}, Ordem: ${task.order}');
              print('          - Dependência: ${task.dependence}');
              print('          - Observação: ${task.observacao}');
              print(
                  '          - Data Início: ${task.dataini}, Data Fim: ${task.datafim}');
              print('          - Percentual: ${task.percentual}%');
              tasks_G.add(task_(
                  task.name,
                  task.dataini,
                  task.datafim,
                  task.order,
                  25,
                  task.dependence,
                  edt.id,
                  edt.name,
                  task.id,
                  edt.order));
            }
          } else {
            print('      Nenhuma tarefa encontrada para esta EDT.');
          }
        }
      } else {
        print('  Nenhuma EDT encontrada para este projeto.');
      }
    }
    tasks_filtro.value = List<task_>.from(tasks_G);
    agruparTarefasPorEDT();
    GET_CALENDARIO();
    print('\n===== FIM DA LISTAGEM DOS PROJETOS =====\n');
  }

  //ALTERA O TAMANHO DO BLOCO DA SEMANA CONFORME A LARGUA DA CELULA DO HEAD DIA
  // VERIFICAR QUE ESTA DANDO ERRO: Another exception was thrown: A RenderFlex overflowed by XXXX pixels on the right
  void calcula_par_lar_bloc_semana() {
    double CAL = 7 * par_lar_head_dia.value;
    par_lar_bloc_semana.value = CAL;
  }

  // Método para calcular as semanas e os detalhes dos dias data inicio e fim da tarefa
  Future<void> CALCULA_DATAS(String startdate, String enddate) async {
    String METD = 'CALCULA_DATAS';
    try {
      log('$METD INICIANDO');
      log('$METD $startdate'); // Exemplo: 2025-01-01
      log('$METD $enddate'); // Exemplo: 2025-01-17
      weeks.clear();
      dayDetails.clear();
      //LIMPA_LISTAS();
      //verifica se as data sao em branca ou null e define data atual + 30 dias

      DateTime start = DateTime.parse(startdate);
      DateTime end = DateTime.parse(enddate);

      // Ajusta o início para a segunda-feira anterior ou igual à data inicial
      while (start.weekday != DateTime.monday) {
        start = start.subtract(const Duration(days: 1));
      }

      //List<String> weeks = [];
      //List<Map<String, dynamic>> dayDetails = [];
      int weekNumber = 1;

      while (start.isBefore(end) || start.isAtSameMomentAs(end)) {
        // Adiciona apenas a segunda-feira de cada semana à lista de semanas
        if (start.weekday == DateTime.monday) {
          weeks.add('${_formatDate(start)} #$weekNumber');
        }

        // Adiciona os detalhes dos dias
        dayDetails.add({
          "nDia": start.day,
          "NomeDia": _getDayName(start.weekday),
          "Semana": "#$weekNumber",
          "Data": start,
        });

        // Incrementa o número da semana no domingo
        if (start.weekday == DateTime.sunday) {
          weekNumber++;
        }

        // Avança para o próximo dia
        start = start.add(const Duration(days: 1));
      }

      //log('$METD Lista de Semanas: $weeks');
      //log('$METD Detalhes dos Dias: $dayDetails');
    } catch (e) {
      log('$METD $e');
    }
  }

  // Monta calendário com base nas tasks
  Future<void> GET_CALENDARIO() async {
    String METD = 'GET_CALENDARIO';
    try {
      log('$METD INICIANDO');
      if (tasks_filtro.isNotEmpty) {
        log('$METD Tasks já estão definidas.');

        // Inicializa as variáveis para menor startDate e maior endDate
        DateTime? menorStartDate;
        DateTime? maiorEndDate;

        // Percorre as tarefas para encontrar os limites
        for (var task in tasks_filtro) {
          DateTime startDate = DateTime.parse(task.startDate);
          DateTime endDate = DateTime.parse(task.endDate);

          // Atualiza a menor startDate
          if (menorStartDate == null || startDate.isBefore(menorStartDate)) {
            menorStartDate = startDate;
          }

          // Atualiza a maior endDate
          if (maiorEndDate == null || endDate.isAfter(maiorEndDate)) {
            maiorEndDate = endDate;
            //add mais um dia para pegar o ultimo dia
            //maiorEndDate = maiorEndDate.add(const Duration(days: 1));
          }
        }

        // Formata as datas no formato "YYYY-MM-DD"
        String startDateStr =
            "${menorStartDate!.year}-${menorStartDate.month.toString().padLeft(2, '0')}-${menorStartDate.day.toString().padLeft(2, '0')}";
        String endDateStr =
            "${maiorEndDate!.year}-${maiorEndDate.month.toString().padLeft(2, '0')}-${maiorEndDate.day.toString().padLeft(2, '0')}";

        // Atualiza as variáveis observáveis
        par_menorStartDate.value = menorStartDate!;
        par_maiorEndDate.value = maiorEndDate!;

        log('$METD Menor startDate: $startDateStr');
        log('$METD Maior endDate: $endDateStr');

        // Chama CALCULA_DATAS com as datas calculadas
        await CALCULA_DATAS(startDateStr, endDateStr);
      } else {
        // Data atual
        DateTime now = DateTime.now();

        // Primeiro dia do mês atual
        DateTime startOfMonth = DateTime(now.year, now.month, 1);

        // Último dia do mês atual
        DateTime endOfMonth = DateTime(now.year, now.month + 1, 0);

        // Formata as datas no formato desejado (exemplo: "YYYY-MM-DD")
        String startDate =
            "${startOfMonth.year}-${startOfMonth.month.toString().padLeft(2, '0')}-${startOfMonth.day.toString().padLeft(2, '0')}";
        String endDate =
            "${endOfMonth.year}-${endOfMonth.month.toString().padLeft(2, '0')}-${endOfMonth.day.toString().padLeft(2, '0')}";

        // Atualiza as variáveis observáveis
        par_menorStartDate.value = startOfMonth;
        par_maiorEndDate.value = endOfMonth;

        log('$METD Data inicial do mês: $startDate');
        log('$METD Data final do mês: $endDate');

        // Adiciona as datas ao cálculo das semanas e dias
        await CALCULA_DATAS(startDate, endDate);
      }
    } catch (e) {
      log('$METD $e', error: e);
    }
  }

//Filtramos todas as tarefas da EDT (task_filtro).
// Pegamos a duração de cada tarefa em dias (diasTarefa).
// Multiplicamos o progresso da tarefa (t.progess) pelo tempo dela.
// Somamos os valores ponderados (progressoPonderadoTotal).
// Dividimos pelo tempo total (duracaoTotalEDT) para calcular o progresso médio.
  void agruparTarefasPorEDT() {
    String METD = 'agruparTarefasPorEDT';
    try {
      //criar uma lista de edts sem duplicidade
      List<Map> uniqueTasks = [];
      for (var t in tasks_G) {
        Map data = {
          "ID": t.edt_id,
          "NOME": t.edt_nome,
          "DATA_START": '',
          'DATA_END': '',
          "PROGRESS": 0,
          "ORDER": 0
        };
        if (uniqueTasks.isNotEmpty) {
          //verifica se ja existe o edt na lista
          List<Map> uniqueTasks_filtro = [];
          uniqueTasks_filtro = uniqueTasks
              .where((element) => element["ID"] == t.edt_id)
              .toList();
          if (uniqueTasks_filtro.isNotEmpty) {
            print('EDT ja existe na lista');
          } else {
            print('edts add');
            uniqueTasks.add(data);
          }
        } else {
          //primeiro elemento
          print('primeiro elemento add');
          uniqueTasks.add({
            "ID": 'Todos',
            "NOME": "Todos",
            "DATA_START": '',
            'DATA_END': '',
            "PROGRESS": 0,
            "ORDER": 0
          });
          uniqueTasks.add(data);
        }
      }

      tasks_edts.value = uniqueTasks;
      //imprime a lista de edts
      for (var i in uniqueTasks) {
        print('[log]->uniqueTasks: $i');
      }

      //atualiza a lista de edts tasks_edts
      for (var edts in tasks_edts) {
        if (edts['ID'] == "Todos") {
          print('Edts todos nao faz nada ');
        } else {
          String id = edts['ID'];
          List<task_> task_filtro =
              tasks_G.where((task) => task.edt_id == id).toList();
          if (task_filtro.isNotEmpty) {
            DateTime? menorStartDate;
            DateTime? maiorEndDate;
            double progressoPonderadoTotal = 0.0;
            int duracaoTotalEDT = 0;

            for (var t in task_filtro) {
              print('[LOG]->Edt $id tem tarefas');
              DateTime startDate = DateTime.parse(t.startDate);
              DateTime endDate = DateTime.parse(t.endDate);

              // Atualiza a menor startDate
              if (menorStartDate == null ||
                  startDate.isBefore(menorStartDate)) {
                menorStartDate = startDate;
              }

              // Atualiza a maior endDate
              if (maiorEndDate == null || endDate.isAfter(maiorEndDate)) {
                maiorEndDate = endDate;
                //add mais um dia para pegar o ultimo dia
                //maiorEndDate = maiorEndDate.add(const Duration(days: 1));
              }

              // Calcula a duração da tarefa em dias
              int diasTarefa = endDate.difference(startDate).inDays;
              duracaoTotalEDT += diasTarefa;

              // Calcula o progresso ponderado (progresso * duração da tarefa)
              progressoPonderadoTotal += (t.progess / 100) * diasTarefa;
            }
            // Formata as datas no formato "YYYY-MM-DD"
            String startDateStr =
                "${menorStartDate!.year}-${menorStartDate.month.toString().padLeft(2, '0')}-${menorStartDate.day.toString().padLeft(2, '0')}";
            String endDateStr =
                "${maiorEndDate!.year}-${maiorEndDate.month.toString().padLeft(2, '0')}-${maiorEndDate.day.toString().padLeft(2, '0')}";

            edts['DATA_START'] = startDateStr;
            edts['DATA_END'] = endDateStr;

            // Calcula o progresso final da EDT
            // Calcula o progresso final da EDT e arredonda para inteiro
            int progressoFinal = duracaoTotalEDT > 0
                ? ((progressoPonderadoTotal / duracaoTotalEDT) * 100)
                    .round() // Aqui garantimos número inteiro
                : 0;

            edts['PROGRESS'] =
                progressoFinal; // Salva como string sem casas decimais
          } else {
            print('[LOG]->Edt $id não tem tarefas');
            edts['PROGRESS'] = "0"; // Se não houver tarefas, progresso é 0
          }
        }
      }

      // remove o edt todos
      //tasks_edts.removeWhere((element) => element['ID'] == 'Todos');
      ajustarEdtTodos();
      for (var i in tasks_edts) {
        print('[log]-> EDTs Ajustado: $i');
      }
    } catch (e) {
      log('$METD $e');
    }
  }

//Busca a menor DATA_START e maior DATA_END das EDTs.
// Soma +5 dias à maior DATA_END para melhorar a visualização.
// Calcula o progresso médio ponderado, considerando a duração de cada EDT.
// Atualiza o item "Todos" em tasks_edts com os novos valores.
  void ajustarEdtTodos() {
    if (tasks_edts.isEmpty) return; // Se a lista estiver vazia, sai da função

    DateTime? menorData;
    double progressoPonderadoTotal = 0.0;
    int duracaoTotal = 0;

    // Percorre todas as EDTs para encontrar a menor DATA_START
    for (var edt in tasks_edts) {
      if (edt["ID"] == "Todos") continue; // Ignora o ID "Todos"

      if (edt["DATA_START"] != '' && edt["DATA_START"] != null) {
        DateTime startDate = DateTime.parse(edt["DATA_START"]);
        if (menorData == null || startDate.isBefore(menorData)) {
          menorData = startDate;
        }
      }

      // Calcula a duração da EDT
      if (edt["DATA_START"] != '' &&
          edt["DATA_START"] != null &&
          edt["DATA_END"] != '' &&
          edt["DATA_END"] != null) {
        DateTime startDate = DateTime.parse(edt["DATA_START"]);
        DateTime endDate = DateTime.parse(edt["DATA_END"]);
        int duracaoEDT = endDate.difference(startDate).inDays;
        duracaoTotal += duracaoEDT;

        // Calcula o progresso ponderado (progresso * duração da EDT)
        progressoPonderadoTotal += (edt["PROGRESS"] / 100) * duracaoEDT;
      }
    }

    // Ajusta a DATA_END como a menor DATA_START + 5 dias
    DateTime? novaDataFinal =
        menorData != null ? menorData.add(Duration(days: 5)) : null;

    // Calcula o progresso geral das EDTs
    int progressoFinal = duracaoTotal > 0
        ? ((progressoPonderadoTotal / duracaoTotal) * 100).round()
        : 0;

    // Formata as datas no formato "YYYY-MM-DD"
    String startDateStr = menorData != null
        ? "${menorData.year}-${menorData.month.toString().padLeft(2, '0')}-${menorData.day.toString().padLeft(2, '0')}"
        : '';

    String endDateStr = novaDataFinal != null
        ? "${novaDataFinal.year}-${novaDataFinal.month.toString().padLeft(2, '0')}-${novaDataFinal.day.toString().padLeft(2, '0')}"
        : '';

    // Atualiza o registro "Todos"
    for (var edt in tasks_edts) {
      if (edt["ID"] == "Todos") {
        edt["DATA_START"] = startDateStr;
        edt["DATA_END"] = endDateStr;
        edt["PROGRESS"] = progressoFinal;
        break;
      }
    }

    // Exibe os valores ajustados no log
    print(
        "[LOG] EDT 'Todos' Atualizado -> Início: $startDateStr, Fim: $endDateStr, Progresso: $progressoFinal%");
  }

  void CARREGA_EDTS_COMO_TAREFAS() {
    String METD = 'CARREGA_EDTS_COMO_TAREFAS';
    try {
      log('$METD INICIANDO');
      print('[LOG]-> STATUS $par_show_tarefas');
      if (tasks_G.isNotEmpty) {
        print('[LOG]-> NUMERO DE TASKS = [${tasks_G.length}]');
        tasks_Padrao.value = List<task_>.from(tasks_G);
      }
      if (par_show_tarefas.value == false) {
        tasks_filtro.clear();
        //tasks_edts.removeWhere((element) => element['ID'] == 'Todos');
        List<task_> tasks_edts_ajustada = [];
        for (var edt in tasks_edts) {
          tasks_edts_ajustada.add(task_(
              edt['NOME'],
              edt['DATA_START'],
              edt['DATA_END'],
              1,
              edt['PROGRESS'],
              '',
              edt['ID'],
              edt['NOME'],
              edt['ID'],
              edt['ORDER']));
        }
        print('[LOG]-> Atualizando tasks_filtro com EDTs');
        tasks_filtro.value = tasks_edts_ajustada;
        tasks_filtro.refresh();
      } else {
        print('[LOG]-> Recarrergando as tarefas');
        if (tasks_Padrao.isNotEmpty) {
          print('[LOG]-> NUMERO DE tasks_Padrao = [${tasks_Padrao.length}]');
        }
        //tasks_edts.insert(0, {"ID": 'Todos', "NOME": "Todos"});
        tasks_filtro.value =
            List<task_>.from(tasks_Padrao); // Garante que é uma cópia
        tasks_filtro.refresh();
      }

      //GET_CALENDARIO();
    } catch (e) {
      log('$METD $e');
    }
  }

  // Método para filtrar as tarefas por EDT
  void FILTRA_EDT_TAREFAS() {
    String METD = 'FILTRA_EDT_TAREFAS';
    try {
      log('$METD INICIANDO');
      log('$METD Filtro: ${par_selected_edt_id.value}');
      if (par_selected_edt_id.value == 'Todos') {
        tasks_filtro.value = List<task_>.from(tasks_G);
      } else {
        tasks_filtro.value = tasks_G
            .where((task) => task.edt_id == par_selected_edt_id.value)
            .toList();
      }
      GET_CALENDARIO();
    } catch (e) {
      log('$METD $e');
    }
  }

  void FILTRA_TAREFAS() {
    String METD = 'FILTRA_TAREFAS';
    try {
      log('$METD INICIANDO');
      log('$METD Filtro: ${search.text}');
      if (search.text == '') {
        if (par_selected_edt_id.value == 'Todos') {
          tasks_filtro.value = List<task_>.from(tasks_G);
        } else {
          tasks_filtro.value = tasks_G
              .where((task) => task.edt_id == par_selected_edt_id.value)
              .toList();
        }
      } else {
        log('$METD where  ${search.text.toLowerCase()} and ${par_selected_edt_id.value}');

        if (par_selected_edt_id.value == 'Todos') {
          tasks_filtro.value = tasks_G
              .where((task) =>
                  task.name.toLowerCase().contains(search.text.toLowerCase()))
              .toList();
        } else {
          tasks_filtro.value = tasks_G
              .where((task) =>
                  task.name.toLowerCase().contains(search.text.toLowerCase()) &&
                  task.edt_id == par_selected_edt_id.value)
              .toList();
        }
      }
      GET_CALENDARIO();
    } catch (e) {
      log('$METD $e');
    }
  }

  void FILTRA_DEPENDENCIA() {
    String METD = 'FILTRA_DEPENDENCIA';
    try {
      log('$METD INICIANDO');
      log('$METD Filtro: ${search.text}');
      if (search.text == '') {
        if (par_selected_edt_id.value == 'Todos') {
          tasks_filtro.value = List<task_>.from(tasks_G);
        } else {
          tasks_filtro.value = tasks_G
              .where((task) => task.id == par_selected_edt_id.value)
              .toList();
        }
      } else {
        log('$METD where  ${search.text.toLowerCase()} and ${par_selected_edt_id.value}');

        if (par_selected_edt_id.value == 'Todos') {
          tasks_filtro.value = tasks_G
              .where(
                  (task) => task.id.toUpperCase() == search.text.toUpperCase())
              .toList();
        } else {
          tasks_filtro.value = tasks_G
              .where((task) =>
                  task.id.toUpperCase() == search.text.toUpperCase() &&
                  task.edt_id == par_selected_edt_id.value)
              .toList();
        }
      }
      GET_CALENDARIO();
    } catch (e) {
      log('$METD $e');
    }
  }

  String getNomeTask(String id) {
    String METD = 'getNomeTask';
    String nome = '';
    try {
      log('$METD INICIANDO');
      log('$METD ID: $id');
      List<task_> task_filtro = tasks_G.where((task) => task.id == id).toList();
      if (task_filtro.isNotEmpty) {
        nome = task_filtro[0].name +
            " \n Prog.${task_filtro[0].progess}%" +
            ' |  Inicio: ${_formatDate(DateTime.parse(task_filtro[0].startDate))}  | Fim: ${_formatDate(DateTime.parse(task_filtro[0].endDate))}';
      }
    } catch (e) {
      log('$METD $e');
    }
    return nome;
  }

  // Método para formatar a data no formato dd/MM/yyyy
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  //metodo para formatar a data no formato yyyy-MM-dd
  String formatDate2(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

// Método auxiliar para retornar o nome abreviado do dia
  String _getDayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return "Seg";
      case DateTime.tuesday:
        return "Ter";
      case DateTime.wednesday:
        return "Qua";
      case DateTime.thursday:
        return "Qui";
      case DateTime.friday:
        return "Sex";
      case DateTime.saturday:
        return "Sab";
      case DateTime.sunday:
        return "Dom";
      default:
        return "";
    }
  }

//END CLASS
}

//Classe mod para projetos
class Project2 {
  String id; // Identificador único
  String name; // Nome do projeto
  List<EDT2> edts; // Lista de EDTs dentro do projeto
  String status; // Status da tarefa (N: Novo, A: Alterado, S: Sincronizado)

  Project2(
      {required this.id,
      required this.name,
      List<EDT2>? edts,
      this.status = 'N'})
      : edts = edts ?? [];
}

//MOD EDTs
class EDT2 {
  String id;
  String name;
  List<TaskGantt> tasks;
  String status; // Status da tarefa (N: Novo, A: Alterado, S: Sincronizado)
  int order;

  EDT2(
      {required this.id,
      required this.name,
      List<TaskGantt>? tasks,
      this.status = 'N',
      this.order = 0})
      : tasks = tasks ?? []; // Inicialize como uma lista vazia mutável
}

class TaskGantt {
  //String edt_id;
  //String edt_name;
  String id;
  String name;
  String status; // Status da tarefa (N: Novo, A: Alterado, S: Sincronizado)
  int order; // Posição na lista
  String dependence;
  String observacao;
  String dataini;
  String datafim;
  int percentual;

  TaskGantt({
    //required this.edt_id,
    //required this.edt_name,
    required this.id,
    required this.name,
    this.status = 'N',
    this.order = 0,
    this.dependence = '',
    this.observacao = '',
    this.dataini = '',
    this.datafim = '',
    this.percentual = 0,
  });
}

class task_ {
  String name;
  String startDate;
  String endDate;
  int ordem;
  int progess;
  String dependencia;
  String edt_id;
  String edt_nome;
  String id;
  int order;

  task_(this.name, this.startDate, this.endDate, this.ordem, this.progess,
      this.dependencia, this.edt_id, this.edt_nome, this.id, this.order);
}
