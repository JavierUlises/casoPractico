//
//  ProductosManager.swift
//  casoPractico
//
//  Created by Javier Ulises Martinez Sanchez on 27/11/22.
//

import Foundation

protocol ProductosManagerDelegate {
    func didUpdateProductos(_ productosManager: ProductosManager, productos: ProductosData)
    func didFailWithError(error: Error)
}

struct ProductosManager {
    
    var delegate: ProductosManagerDelegate?
    
    func getProductos() {
        let url = "http://alb-dev-ekt-875108740.us-east-1.elb.amazonaws.com/sapp/productos/plp/1/ad2fdd4bbaec4d15aa610a884f02c91a"
        fetchService(urlString: url)
    }
    
    func fetchService(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {
                (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                //let stringData = String(data: data!, encoding: .utf8)
                //print(stringData!)
                if let safeData = data {
                    if let productos = self.parseJSON(safeData) {
                        self.delegate?.didUpdateProductos(self, productos: productos)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ productosData: Data) -> ProductosData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ProductosData.self, from: productosData)            
            return ProductosData(resultado: decodedData.resultado)
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
