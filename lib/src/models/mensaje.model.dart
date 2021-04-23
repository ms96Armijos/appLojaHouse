// To parse this JSON data, do
//
//     final mensaje = mensajeFromJson(jsonString);

import 'dart:convert';

Mensaje mensajeFromJson(String str) => Mensaje.fromJson(json.decode(str));

String mensajeToJson(Mensaje data) => json.encode(data.toJson());

String mensajeElementToJson(MensajeElement data) => json.encode(data.toJson());

class Mensaje {
    Mensaje({
        this.ok,
        this.mensajes,
        this.total,
    });

    bool ok;
    List<MensajeElement> mensajes;
    int total;

    factory Mensaje.fromJson(Map<String, dynamic> json) => Mensaje(
        ok: json["ok"],
        mensajes: List<MensajeElement>.from(json["mensajes"].map((x) => MensajeElement.fromJson(x))),
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "mensajes": List<dynamic>.from(mensajes.map((x) => x.toJson())),
        "total": total,
    };
}

class MensajeElement {
    MensajeElement({
        this.estado,
        this.id,
        this.titulo,
        this.asunto,
        this.fecha,
        this.correo,
        this.createdAt,
        this.updatedAt,
    });

    String estado;
    String id;
    String titulo;
    String asunto;
    DateTime fecha;
    String correo;
    DateTime createdAt;
    DateTime updatedAt;

    factory MensajeElement.fromJson(Map<String, dynamic> json) => MensajeElement(
        estado: json["estado"],
        id: json["_id"],
        titulo: json["titulo"],
        asunto: json["asunto"],
        fecha: DateTime.parse(json["fecha"]),
        correo: json["correo"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "estado": estado,
        "_id": id,
        "titulo": titulo,
        "asunto": asunto,
        "fecha": fecha.toIso8601String(),
        "correo": correo,
        //"createdAt": createdAt.toIso8601String(),
        //"updatedAt": updatedAt.toIso8601String(),
    };
}
