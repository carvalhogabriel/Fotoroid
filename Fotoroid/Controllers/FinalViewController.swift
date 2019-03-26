//
//  FinalViewController.swift
//  Fotoroid
//
//  Created by Gabriel Carvalho Guerrero on 26/03/19.
//  Copyright © 2019 Gabriel Carvalho Guerrero. All rights reserved.
//

import UIKit
import Photos

class FinalViewController: UIViewController {

    // MARK: - @IBOutlet's
    @IBOutlet weak var imageViewPhoto: UIImageView!
    
    // MARK: - Var's
    var image: UIImage!
    
    // MARK: - @IBAction's
    @IBAction func save(_ sender: UIButton) {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                self.saveToAlbum()
            default:
                let alert = UIAlertController(title: "Erro", message: "Você precisa autorizar o acesso ao álbum para poder salvar sua foto.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func restart(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func saveToAlbum() {
        PHPhotoLibrary.shared().performChanges({
            
            let creationRequest = PHAssetChangeRequest.creationRequestForAsset(from: self.image)
            let addAssetRequest = PHAssetCollectionChangeRequest()
            addAssetRequest.addAssets([creationRequest.placeholderForCreatedAsset] as NSFastEnumeration)
            
        }) { (success, error) in
            if !success {
                print(error?.localizedDescription)
            } else {
                let alert = UIAlertController(title: "Imagem salva!", message: "Sua imagem foi salva no álbum de fotos", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageViewPhoto.image = image
        imageViewPhoto.layer.borderWidth = 10
        imageViewPhoto.layer.borderColor = UIColor.white.cgColor
    }

}
