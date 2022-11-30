//
//  ProductosController.swift
//  casoPractico
//
//  Created by Javier Ulises Martinez Sanchez on 28/11/22.
//

import UIKit
import Foundation

class ViewController: UIViewController {
            
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    @IBAction func onPressedButton(_ sender: UIButton) {
        let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "productosViewController") as! ProductosViewController
        self.navigationController?.pushViewController(storyboard, animated: true)
    }
}

