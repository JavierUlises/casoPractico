//
//  ProductosViewController.swift
//  casoPractico
//
//  Created by Javier Ulises Martinez Sanchez on 29/11/22.
//  Resource: https://www.kodeco.com/16906182-ios-14-tutorial-uicollectionview-list

import UIKit

class ProductosViewController: UIViewController {
    
    var productosManager = ProductosManager()
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Producto>!
    var snapshot: NSDiffableDataSourceSnapshot<Section, Producto>!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productosManager.delegate = self
        productosManager.getProductos()
        
        let layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: listLayout)
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        // Contraints para toma de la pantalla completa
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 0.0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0),
        ])
        
        dataSource = UICollectionViewDiffableDataSource<Section, Producto>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Producto) -> UICollectionViewCell? in
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: identifier)
            cell.accessories = [.disclosureIndicator()]
            
            return cell
        }
        
        // Snapshot del actual estado
        snapshot = NSDiffableDataSourceSnapshot<Section, Producto>()
        snapshot.appendSections([.main])
    }
    
    enum Section {
        case main
    }
    
    // Celda de item de la lista
    let cellRegistration = UICollectionView.CellRegistration { (cell: UICollectionViewListCell, indexPath: IndexPath, item: Producto) in
        var content = cell.defaultContentConfiguration()
        content.text = item.nombre
        cell.contentConfiguration = content
    }
}

extension ProductosViewController: ProductosManagerDelegate {
    func didUpdateProductos(_ productosManager: ProductosManager, productos: ProductosData) {
        snapshot.appendItems(productos.resultado.productos, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//collectionView.delegate = self

extension ProductosViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        guard let selectedItem = dataSource.itemIdentifier(for: indexPath) else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }
        let categoria = "Categoria \(selectedItem.codigoCategoria)"
        let precio = "Precio \(selectedItem.precioFinal)"
        let alert = UIAlertController(title: selectedItem.nombre,
        message: "\(categoria) \n \(precio)" , preferredStyle: .alert)
        let urlImage = URL(string: selectedItem.urlImagenes[0])
        var imageFromUrl: UIImageView
        //alert.view.addSubview(imageFromUrl.load(url: urlImage!))
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (_) in
            collectionView.deselectItem(at: indexPath, animated: true)
        })
        alert.addAction(okAction)
        present(alert, animated: true, completion:nil)
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }                
            }
        }
    }
}
