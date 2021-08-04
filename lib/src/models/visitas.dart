// To parse this JSON data, do
//
//     final getvisitaModel = getvisitaModelFromJson(jsonString);

import 'dart:convert';

GetvisitaModel getvisitaModelFromJson(String str) => GetvisitaModel.fromJson(json.decode(str));

String getvisitaModelToJson(GetvisitaModel data) => json.encode(data.toJson());

class GetvisitaModel {
    GetvisitaModel({
        this.ok,
        this.visitas,
        this.total,
    });

    bool ok;
    List<Visita> visitas;
    int total;

    factory GetvisitaModel.fromJson(Map<String, dynamic> json) => GetvisitaModel(
        ok: json["ok"],
        visitas: List<Visita>.from(json["visitas"].map((x) => Visita.fromJson(x))),
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "visitas": List<dynamic>.from(visitas.map((x) => x.toJson())),
        "total": total,
    };
}

class Visita {
    Visita({
        this.estado,
        this.id,
        this.fecha,
        this.descripcion,
        this.inmueble,
        this.usuarioarrendatario,

    });

    String estado;
    String id;
    DateTime fecha;
    String descripcion;
    Inmueble inmueble;
    Usuarioarrendatario usuarioarrendatario;


    factory Visita.fromJson(Map<String, dynamic> json) => Visita(
        estado: json["estado"],
        id: json["_id"],
        fecha: DateTime.parse(json["fecha"]),
        descripcion: json["descripcion"],
        inmueble: Inmueble.fromJson(json["inmueble"]),
        usuarioarrendatario: Usuarioarrendatario.fromJson(json["usuarioarrendatario"]),

    );

    Map<String, dynamic> toJson() => {
        "estado": estado,
        "_id": id,
        "fecha": fecha.toIso8601String(),
        "descripcion": descripcion,
        "inmueble": inmueble.toJson(),
        "usuarioarrendatario": usuarioarrendatario.toJson(),

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
    String usuario;
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
        usuario: json["usuario"],
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
        "usuario": usuario,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
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

class Usuarioarrendatario {
    Usuarioarrendatario({
        this.id,
        this.nombre,
        this.apellido,
        this.correo,
        this.movil,
        this.imagen,
        this.cedula,
    });

    String id;
    String nombre;
    String apellido;
    String correo;
    String movil;
    List<dynamic> imagen;
    String cedula;

    factory Usuarioarrendatario.fromJson(Map<String, dynamic> json) => Usuarioarrendatario(
        id: json["_id"],
        nombre: json["nombre"],
        apellido: json["apellido"],
        correo: json["correo"],
        movil: json["movil"],
        imagen: List<dynamic>.from(json["imagen"].map((x) => x)),
        cedula: json["cedula"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "nombre": nombre,
        "apellido": apellido,
        "correo": correo,
        "movil": movil,
        "imagen": imagen,
        "cedula": cedula,
    };
    
}
