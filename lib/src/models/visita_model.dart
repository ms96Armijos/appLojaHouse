// To parse this JSON data, do
//
//     final visitaModel = visitaModelFromJson(jsonString);

import 'dart:convert';


VisitaModel visitaModelFromJson(String str) => VisitaModel.fromJson(json.decode(str));

String visitaModelToJson(VisitaModel data) => json.encode(data.toJson());

class VisitaModel {
    VisitaModel({
        this.estado,
        this.id,
        this.fecha,
        this.descripcion,
        this.inmueble,
        this.usuarioarrendatario,
        this.createdAt,
        this.updatedAt,
    });

    String estado;
    String id;
    DateTime fecha;
    String descripcion;
    String inmueble;
    String usuarioarrendatario;
    DateTime createdAt;
    DateTime updatedAt;

    factory VisitaModel.fromJson(Map<String, dynamic> json) => VisitaModel(
        estado: json["estado"],
        id: json["_id"],
        fecha: DateTime.parse(json["fecha"]),
        descripcion: json["descripcion"],
        inmueble: json["inmueble"],
        usuarioarrendatario: json["usuarioarrendatario"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "estado": estado,
        "_id": id,
        "fecha": fecha.toIso8601String(),
        "descripcion": descripcion,
        "inmueble": inmueble,
        "usuarioarrendatario": usuarioarrendatario,
        //"createdAt": createdAt.toIso8601String(),
        //"updatedAt": updatedAt.toIso8601String(),
    };
}



