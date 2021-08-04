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
        this.barrio,
        this.ciudad,
        this.provincia,
        this.createdAt,
        this.updatedAt,
    });

    List<String> servicio;
    List<Imagen> imagen;
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
    String barrio;
    String ciudad;
    String provincia;
    DateTime createdAt;
    DateTime updatedAt;

    factory Inmueble.fromJson(Map<String, dynamic> json) => Inmueble(
        servicio: List<String>.from(json["servicio"].map((x) => x)),
        imagen: List<Imagen>.from(json["imagen"].map((x) => Imagen.fromJson(x))),
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
        barrio: json["barrio"],
        ciudad: json["ciudad"],
        provincia: json["provincia"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "servicio": List<dynamic>.from(servicio.map((x) => x)),
        "imagen": List<dynamic>.from(imagen.map((x) => x.toJson())),
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
        "barrio": barrio,
        "ciudad": ciudad,
        "provincia": provincia,
        //"createdAt": createdAt.toIso8601String(),
        //"updatedAt": updatedAt.toIso8601String(),
    };
}


class Imagen {
    Imagen({
        this.id,
        this.url,
        this.inmueble,
        this.publicId,
    });

    String id;
    String url;
    String inmueble;
    String publicId;

    factory Imagen.fromJson(Map<String, dynamic> json) => Imagen(
        id: json["_id"],
        url: json["url"],
        inmueble: json["inmueble"],
        publicId: json["public_id"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "url": url,
        "inmueble": inmueble,
        "public_id": publicId,
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
