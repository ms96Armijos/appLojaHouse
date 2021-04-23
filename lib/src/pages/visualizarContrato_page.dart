import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';

class VisualizarContratoPDFPage extends StatelessWidget {

  final String path;
  
  VisualizarContratoPDFPage({this.path});
  

  @override
  Widget build(BuildContext context) {
    //print(path.toString());
    return PDFViewerScaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Leer contrato'),
      ),
      path: path,
    );
  }
}