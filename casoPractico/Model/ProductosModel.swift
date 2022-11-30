//
//  Resultado.swift
//  casoPractico
//
//  Created by Javier Ulises Martinez Sanchez on 28/11/22.
//

import Foundation
// MARK: - Modelo
struct ProductosData: Codable {
    //let codigo: String
    let resultado: Resultado
}

// MARK: - Resultado
struct Resultado: Codable {
    let categoria: String
    let productos: [Producto]
}

// MARK: - Producto
struct Producto: Codable, Hashable {
    let id: String
    let idLinea: Int
    let codigoCategoria: String
    let idModalidad, relevancia: Int
    let lineaCredito: String
    let pagoSemanalPrincipal, plazoPrincipal: Int
    let disponibleCredito: Bool
    let sku, nombre: String
    let urlImagenes: [String]
    let precioRegular, precioFinal: Double
    let porcentajeDescuento: Double
    let descuento: Bool
    let precioCredito, montoDescuento: Double
}
