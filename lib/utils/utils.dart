import 'package:flutter/material.dart';

Widget TEXTO(
    String TEXTO, double SIZE, Color COR, int MAXLINE, TextAlign ALINHAMENTO) {
  return Text(
    TEXTO,
    maxLines: MAXLINE,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontStyle: FontStyle.normal,
      fontFamily: 'OpenSans',
      fontWeight: FontWeight.w700,
      fontSize: SIZE,
      color: COR,
    ),
    textAlign: ALINHAMENTO,
  );
}

String getCP_NUL(String dados) {
  String R = "";
  try {
    if (dados == "") {
    } else if (dados == null) {}
    if (dados == "(NULL)" && dados == "NULL" && dados == "null") {
    } else {
      R = dados.toString().trim();
    }
    return R;
  } catch (e) {
    print('getCP_NUL()-> ERRO = $e');
    return R;
  }
}
