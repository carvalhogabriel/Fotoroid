//
//  EffectsViewController.swift
//  Fotoroid
//
//  Created by Gabriel Carvalho Guerrero on 26/03/19.
//  Copyright © 2019 Gabriel Carvalho Guerrero. All rights reserved.
//

import UIKit

class EffectsViewController: UIViewController {

    // MARK: - @IBOutlet's
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewLoading: UIView!
    @IBOutlet weak var imageViewPhoto: UIImageView!
    
    var image: UIImage!
    lazy var filterManager: FilterManager = {
        let filterManager = FilterManager(image: image)
        return filterManager
    }()
    
    let filterImageNames = [
        "comic",
        "sepia",
        "halftone",
        "crystallize",
        "vignette",
        "noir"
    ]
    
    // MARK: - Method's
    func showLoading(_ show: Bool) {
        viewLoading.isHidden = !show
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageViewPhoto.image = image
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! FinalViewController
        vc.image = imageViewPhoto.image
    }
    
}

extension EffectsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterManager.filterNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EffectCollectionViewCell
        
        cell.imageViewEffect.image = UIImage(named: filterImageNames[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let type = FilterType(rawValue: indexPath.row) {
            showLoading(true)
            DispatchQueue.global(qos: .userInitiated).async {
                let filteredImage = self.filterManager.applyFilter(type: type)
                DispatchQueue.main.async {
                    self.imageViewPhoto.image = filteredImage
                    self.showLoading(false)
                }
            }
        }
    }
}
