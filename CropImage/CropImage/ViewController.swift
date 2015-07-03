//
//  ViewController.swift
//  CropImage
//
//  Created by NakashimaHiroki on 2015/07/03.
//  Copyright (c) 2015年 com.marsbar. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var cropRegion: UIView!
    @IBOutlet weak var croppedImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Sample Button
    @IBAction func addButton(sender: AnyObject) {
        
        if let image = mainImageView.image {
            mainImageView.image = nil
        }
        
        if let image = croppedImageView.image {
            croppedImageView.image = nil
        }
        
        //self.pickImageFromCamera()
        self.pickImageFromLibrary()
    }
    
    // Crop View Button
    @IBAction func tappedCropBtn(sender: AnyObject) {
        //println( __FUNCTION__ )
        croppedImageView.image = self.cropImage(mainImageView.image!,rect:cropRegion.frame)
    }
    
    func cropImage(origin:UIImage,rect:CGRect)-> UIImage {
        //println( __FUNCTION__ )
        var scale:CGFloat
        let mvf = mainImageView.frame
        let clipRect:CGRect
        
        if isLandscape(origin) {
            // 横長
            scale = origin.size.width / mainImageView.frame.size.width
            
            clipRect = CGRectMake( (rect.origin.x - mvf.origin.x) * scale,
                (rect.origin.y - mvf.origin.y ) * scale,
                rect.size.width * scale,
                rect.size.height * scale )
        }else{
            // 縦長
            scale = origin.size.height / mainImageView.frame.size.height
            // displaying size width
            let rscale:CGFloat = mainImageView.frame.size.height / origin.size.height
            let displaySizeWidth:CGFloat = origin.size.width * rscale
            let displayPointX:CGFloat = (mvf.size.width - displaySizeWidth)/2
            
            var newRect:CGRect
            
            newRect = CGRectMake(displayPointX + mvf.origin.x,
                rect.origin.y,
                displaySizeWidth,
                rect.size.height)
            // --- Debuug ----
            /*
            var DynamicView=UIView(frame:newRect)
            DynamicView.backgroundColor=UIColor.redColor()
            DynamicView.alpha = 0.4
            self.view.addSubview(DynamicView)
            */
            // --- END -----
            
            clipRect = CGRectMake( 0,
                (origin.size.height - newRect.size.height*scale)/2,
                newRect.size.width * scale,
                newRect.size.height * scale)
            //println("cliprect= \(clipRect)")
            
        }
        
        // ソース画像からCGImageRefを取り出す
        let srcImage:CGImageRef = origin.CGImage
        
        // 指定された範囲を切り抜いたCGImageRefを生成しUIImageとする
        let imageRef:CGImageRef = CGImageCreateWithImageInRect(srcImage, clipRect)
        let resultImage:UIImage = UIImage(CGImage: imageRef)!
        
        return resultImage
    }
    
    func isLandscape(image:UIImage)->Bool {
        
        return image.size.width >= image.size.height
    }
    
    // MARK: - UIImagePickerController Delegate
    // カメラ画面のキャンセル
    func imagePickerControllerDidCancel(picker:UIImagePickerController) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // ライブラリから写真を選択する
    func pickImageFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    // 写真を選択した時に呼ばれる
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
            
            // Access the uncropped image from info dictionary
            var imageToSave: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            if picker.sourceType == UIImagePickerControllerSourceType.Camera {
                
                // カメラロールに保存
                UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
                
            }else if picker.sourceType == UIImagePickerControllerSourceType.PhotoLibrary {
                
                self.mainImageView.image = imageToSave
            }
            
            // Photo関連のModalは終了
            self.dismissViewControllerAnimated(true, completion: nil)
            
    }
    
    
}


