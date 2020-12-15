import 'package:applojahouse/src/models/contrato_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';

class VisualizarContratoPDFPage extends StatelessWidget {

  final String path;
  
  VisualizarContratoPDFPage({this.path});

  @override
  Widget build(BuildContext context) {
    
    return PDFViewerScaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Leer contrato'),
      ),
      path: path,
    );
  }
}