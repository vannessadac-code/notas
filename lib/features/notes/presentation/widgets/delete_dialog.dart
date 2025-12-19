import 'package:flutter/material.dart';

void handleDelete(BuildContext context, Function() onPressed) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      insetPadding: EdgeInsets.all(16),
      content: Text("¿Seguro desea eliminar la nota?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: () => {onPressed.call(), Navigator.pop(context)},
          child: Text("Confirmar"),
        ),
      ],
    ),
  );
}
