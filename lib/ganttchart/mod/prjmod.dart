import 'dart:developer';

import '../../utils/utils.dart';

class PRJMOD {
  final int proj_id;
  final String proj_nome;
  final String proj_datacad;
  final String proj_end;
  final String proj_municipio;
  final String proj_uf;
  final int proj_id_user;
  final String proj_responsavel;
  final String proj_localizacao;
  final String proj_obs;
  final String proj_datapreini;
  final String proj_dataprefin;
  final int proj_ativo;
  final String DATAATL;
  final String D_E_L_E_T_;
  final String log_inclusao;
  final String log_alteracao;
  final int proj_versao;
  final int proj_interno;
  bool isSelectd = false;

  PRJMOD({
    required this.proj_id,
    required this.proj_nome,
    required this.proj_datacad,
    required this.proj_end,
    required this.proj_municipio,
    required this.proj_uf,
    required this.proj_id_user,
    required this.proj_responsavel,
    required this.proj_localizacao,
    required this.proj_obs,
    required this.proj_datapreini,
    required this.proj_dataprefin,
    required this.proj_ativo,
    required this.DATAATL,
    required this.D_E_L_E_T_,
    required this.log_inclusao,
    required this.log_alteracao,
    this.isSelectd = false,
    this.proj_versao = 0,
    this.proj_interno = 0,
  });

// criar factory para converter json em objeto completo
  factory PRJMOD.fromJson(Map<String, dynamic> json) {
    try {
      print("Item: ${json['proj_id']}...");
      return PRJMOD(
        proj_id: json['proj_id'] == null ? 0 : json['proj_id'],
        proj_nome:
            json['proj_nome'] == null ? '' : getCP_NUL(json['proj_nome']),
        proj_datacad:
            json['proj_datacad'] == null ? '' : getCP_NUL(json['proj_datacad']),
        proj_end: json['proj_end'] == null ? '' : getCP_NUL(json['proj_end']),
        proj_municipio: json['proj_municipio'] == null
            ? ''
            : getCP_NUL(json['proj_municipio']),
        proj_uf: json['proj_uf'] == null ? '' : getCP_NUL(json['proj_uf']),
        proj_id_user: json['proj_id_user'] == null ? 0 : json['proj_id_user'],
        proj_responsavel: json['proj_responsavel'] == null
            ? ''
            : getCP_NUL(json['proj_responsavel']),
        proj_localizacao: json['proj_localizacao'] == null
            ? ''
            : getCP_NUL(json['proj_localizacao']),
        proj_obs: json['proj_obs'] == null ? '' : getCP_NUL(json['proj_obs']),
        proj_datapreini: json['proj_datapreini'] == null
            ? ''
            : getCP_NUL(json['proj_datapreini']),
        proj_dataprefin: json['proj_dataprefin'] == null
            ? ''
            : getCP_NUL(json['proj_dataprefin']),
        proj_ativo: json['proj_ativo'] == null ? 0 : json['proj_ativo'],
        DATAATL: json['DATAATL'] == null ? '' : getCP_NUL(json['DATAATL']),
        D_E_L_E_T_:
            json['D_E_L_E_T_'] == null ? '' : getCP_NUL(json['D_E_L_E_T_']),
        log_inclusao:
            json['log_inclusao'] == null ? '' : getCP_NUL(json['log_inclusao']),
        log_alteracao: json['log_alteracao'] == null
            ? ''
            : getCP_NUL(json['log_alteracao']),
        proj_versao: json['proj_versao'] == null ? 0 : json['proj_versao'],
        proj_interno: json['proj_interno'] == null ? 0 : json['proj_interno'],
      );
    } catch (e, s) {
      log('Erro = $e', name: 'PRJMOD.fromJson', error: e, stackTrace: s);
      return PRJMOD(
          proj_id: 0,
          proj_nome: '',
          proj_datacad: '',
          proj_end: '',
          proj_municipio: '',
          proj_uf: '',
          proj_id_user: 0,
          proj_responsavel: '',
          proj_localizacao: '',
          proj_obs: '',
          proj_datapreini: '',
          proj_dataprefin: '',
          proj_ativo: 0,
          DATAATL: '',
          D_E_L_E_T_: '',
          log_inclusao: '',
          log_alteracao: '',
          proj_versao: 0,
          proj_interno: 2);
    }
  }
}
