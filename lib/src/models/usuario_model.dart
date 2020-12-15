// To parse this JSON data, do
//
//     final usuarioModel = usuarioModelFromJson(jsonString);

import 'dart:convert';

UsuarioModel usuarioModelFromJson(String str) =>
    UsuarioModel.fromJson(json.decode(str));

String usuarioModelToJson(UsuarioModel data) => json.encode(data.toJson());

class UsuarioModel {
  UsuarioModel({
    this.id,
    this.nombre,
    this.apellido,
    this.correo,
    this.password,
    this.imagen,
    this.cedula,
    this.movil,
    this.convencional,
    this.estado='1',
    this.rol='ARRENDATARIO',
  });

  String id;
  String nombre;
  String apellido;
  String correo;
  String password;
  String imagen;
  String cedula;
  String movil;
  String convencional;
  String estado;
  String rol;

  factory UsuarioModel.fromJson(Map<String, dynamic> json) => UsuarioModel(
        id: json["_id"],
        nombre: json["nombre"],
        apellido: json["apellido"],
        correo: json["correo"],
        password: json["password"],
        imagen: json["imagen"],
        cedula: json["cedula"],
        movil: json["movil"],
        convencional: json["convencional"],
        estado: json["estado"],
        rol: json["rol"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "nombre": nombre,
        "apellido": apellido,
        "correo": correo,
        "password": password,
        "imagen": imagen,
        "cedula": cedula,
        "movil": movil,
        "convencional": convencional,
        "estado": estado,
        "rol": rol,
      };
}
