// To parse this JSON data, do
//
//     final contratoModel = contratoModelFromJson(jsonString);

import 'dart:convert';

ContratoModel contratoModelFromJson(String str) => ContratoModel.fromJson(json.decode(str));

String contratoModelToJson(ContratoModel data) => json.encode(data.toJson());

class ContratoModel {
    ContratoModel({
        this.ok,
        this.contratos,
        this.total,
    });

    bool ok;
    List<Contrato> contratos;
    int total;

    factory ContratoModel.fromJson(Map<String, dynamic> json) => ContratoModel(
        ok: json["ok"],
        contratos: List<Contrato>.from(json["contratos"].map((x) => Contrato.fromJson(x))),
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "contratos": List<dynamic>.from(contratos.map((x) => x.toJson())),
        "total": total,
    };
}

class Contrato {
    Contrato({
        this.acuerdo,
        this.id,
        this.nombrecontrato,
        this.fechainicio,
        this.fechafin,
        this.tiempocontrato,
        this.monto,
        this.usuarioarrendador,
        this.usuarioarrendatario,
        this.inmueble,
    });

    String acuerdo;
    String id;
    String nombrecontrato;
    DateTime fechainicio;
    DateTime fechafin;
    int tiempocontrato;
    int monto;
    Usuarioarrenda usuarioarrendador;
    Usuarioarrenda usuarioarrendatario;
    InmuebleContrato inmueble;

    factory Contrato.fromJson(Map<String, dynamic> json) => Contrato(
        acuerdo: json["acuerdo"],
        id: json["_id"],
        nombrecontrato: json["nombrecontrato"],
        fechainicio: DateTime.parse(json["fechainicio"]),
        fechafin: DateTime.parse(json["fechafin"]),
        tiempocontrato: json["tiempocontrato"],
        monto: json["monto"],
        usuarioarrendador: Usuarioarrenda.fromJson(json["usuarioarrendador"]),
        usuarioarrendatario: Usuarioarrenda.fromJson(json["usuarioarrendatario"]),
        inmueble: InmuebleContrato.fromJson(json["inmueble"]),
    );

    Map<String, dynamic> toJson() => {
        "acuerdo": acuerdo,
        "_id": id,
        "nombrecontrato": nombrecontrato,
        "fechainicio": fechainicio.toIso8601String(),
        "fechafin": fechafin.toIso8601String(),
        "tiempocontrato": tiempocontrato,
        "monto": monto,
        "usuarioarrendador": usuarioarrendador.toJson(),
        "usuarioarrendatario": usuarioarrendatario.toJson(),
        "inmueble": inmueble.toJson(),
    };
}

class InmuebleContrato {
    InmuebleContrato({
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
    String usuario;
    String barrio;
    String ciudad;
    String provincia;
    DateTime createdAt;
    DateTime updatedAt;

    factory InmuebleContrato.fromJson(Map<String, dynamic> json) => InmuebleContrato(
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
        barrio: json["codigo"],
        ciudad: json["codigo"],
        provincia: json["codigo"],
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
        "barrio": barrio,
        "ciudad": ciudad,
        "provincia": provincia,
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

class Usuarioarrenda {
    Usuarioarrenda({
        this.id,
        this.nombre,
        this.apellido,
        this.correo,
    });

    String id;
    String nombre;
    String apellido;
    String correo;

    factory Usuarioarrenda.fromJson(Map<String, dynamic> json) => Usuarioarrenda(
        id: json["_id"],
        nombre: json["nombre"],
        apellido: json["apellido"],
        correo: json["correo"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "nombre": nombre,
        "apellido": apellido,
        "correo": correo,
    };
}
