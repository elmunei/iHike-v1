//
//  IHPhotoHelper.swift
//  iHike
//
//  Created by Elvis Tapfumanei on 15/11/2017.
//  Copyright © 2017 Elmunei. All rights reserved.
//

import UIKit
import YPImagePicker

class IHPhotoHelper: NSObject {

    var imageSelected: UIImage?
    
    // MARK: - Properties
    
    var completionHandler: ((UIImage) -> Void)?
    
    // MARK: - Helper Methods
    
    func photoPicker (viewController: UIViewController) {
        
        
        var config = YPImagePickerConfiguration()
        config.libraryTargetImageSize = .original
        config.usesFrontCamera = false
        config.onlySquareImages = true
        config.showsFilters = true
        config.shouldSaveNewPicturesToAlbum = true
        config.albumName = "iHike"
        
        let picker = YPImagePicker(configuration: config)
        
        picker.didSelectImage = { [unowned picker] img in
            // image picked
            print(img.size)
            self.imageSelected = img

            
            
            picker.dismiss(animated: true, completion: nil)
        }
        viewController.present(picker, animated: true, completion: nil)
    }
    

    
}
