import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModalAdicionar extends StatefulWidget {
  final Function(String) onProjectAdded;
  final Function(String)? onEdtAdded;
  final Function(String)? onTaskAdded;
  final bool isEdt;

  const ModalAdicionar({
    Key? key,
    required this.onProjectAdded,
    this.onEdtAdded,
    this.onTaskAdded,
    this.isEdt = false,
  }) : super(key: key);

  @override
  State<ModalAdicionar> createState() => _ModalAdicionarState();
}

class _ModalAdicionarState extends State<ModalAdicionar> {
  final _nameController = TextEditingController();
  bool _isAddingEdt = false;
  bool _isAddingTask = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEdt ? 'Adicionar EDT/Tarefa' : 'Adicionar Projeto'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Nome'),
          ),
          if (widget.isEdt) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isAddingEdt = true;
                      _isAddingTask = false;
                    });
                  },
                  child: const Text('Adicionar EDT'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isAddingTask = true;
                      _isAddingEdt = false;
                    });
                  },
                  child: const Text('Adicionar Tarefa'),
                ),
              ],
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            final name = _nameController.text;
            if (name.isNotEmpty) {
              if (widget.isEdt) {
                if (_isAddingEdt && widget.onEdtAdded != null) {
                  widget.onEdtAdded!(name);
                } else if (_isAddingTask && widget.onTaskAdded != null) {
                  widget.onTaskAdded!(name);
                }
              } else {
                widget.onProjectAdded(name);
              }
              Get.back();
            }
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
