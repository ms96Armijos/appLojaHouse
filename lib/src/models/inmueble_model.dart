// To parse this JSON data, do
//
//     final inmuebleModel = inmuebleModelFromJson(jsonString);

import 'dart:convert';

InmuebleModel inmuebleModelFromJson(String str) => InmuebleModel.fromJson(json.decode(str));

String inmuebleModelToJson(InmuebleModel data) => json.encode(data.toJson());

class InmuebleModel {
    InmuebleModel({
        this.inmuebles,
    });

    List<Inmueble> inmuebles;

    factory InmuebleModel.fromJson(Map<String, dynamic> json) => InmuebleModel(
        inmuebles: List<Inmueble>.from(json["inmuebles"].map((x) => Inmueble.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "inmuebles": List<dynamic>.from(inmuebles.map((x) => x.toJson())),
    };
}

class Inmueble {
    Inmueble({
        this.servicio,
        this.imagen,
        this.estado,
        this.publicado,
        this.id,
        this.nombre,
        this.descripcion,
        this.direccion,
        this.codigo,
        this.tipo,
        this.precioalquiler,
        this.garantia,
        this.usuario,
        this.createdAt,
        this.updatedAt,
    });

    List<String> servicio;
    List<String> imagen;
    String estado;
    String publicado;
    String id;
    String nombre;
    String descripcion;
    String direccion;
    String codigo;
    String tipo;
    int precioalquiler;
    int garantia;
    UsuarioInmueble usuario;
    DateTime createdAt;
    DateTime updatedAt;

    factory Inmueble.fromJson(Map<String, dynamic> json) => Inmueble(
        servicio: List<String>.from(json["servicio"].map((x) => x)),
        imagen: List<String>.from(json["imagen"].map((x) => x)),
        estado: json["estado"],
        publicado: json["publicado"],
        id: json["_id"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        direccion: json["direccion"],
        codigo: json["codigo"],
        tipo: json["tipo"],
        precioalquiler: json["precioalquiler"],
        garantia: json["garantia"],
        usuario: UsuarioInmueble.fromJson(json["usuario"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "servicio": List<dynamic>.from(servicio.map((x) => x)),
        "imagen": List<dynamic>.from(imagen.map((x) => x)),
        "estado": estado,
        "publicado": publicado,
        "_id": id,
        "nombre": nombre,
        "descripcion": descripcion,
        "direccion": direccion,
        "codigo": codigo,
        "tipo": tipo,
        "precioalquiler": precioalquiler,
        "garantia": garantia,
        "usuario": usuario.toJson(),
        //"createdAt": createdAt.toIso8601String(),
        //"updatedAt": updatedAt.toIso8601String(),
    };
}





class UsuarioInmueble {
    UsuarioInmueble({
        this.id,
        this.nombre,
        this.correo,
    });

    String id;
    String nombre;
    String correo;

    factory UsuarioInmueble.fromJson(Map<String, dynamic> json) => UsuarioInmueble(
        id: json["_id"],
        nombre: json["nombre"],
        correo: json["correo"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "nombre": nombre,
        "correo": correo,
    };
}
