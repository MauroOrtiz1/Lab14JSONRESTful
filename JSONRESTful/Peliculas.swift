//
//  Peliculas.swift
//  JSONRESTful
//
//  Created by Bernie Mauro Ortiz Ortega on 6/11/24.
//

import Foundation
struct Peliculas:Decodable{
    let usuarioId:Int
    let id:Int
    let nombre:String
    let genero:String
    let duracion:String
}
