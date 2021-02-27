//
//  PhotoViewController.swift
//  Wine_manager
//
//  Created by Hiroya Kato on 2018/07/31.
//  Copyright © 2018年 Hiroya Kato. All rights reserved.
//

import UIKit
import AVFoundation

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
// セッション.
    var mySession : AVCaptureSession!
    // デバイス.
    var myDevice : AVCaptureDevice!
    // 画像のアウトプット.
    var myImageOutput : AVCaptureStillImageOutput!

    override func viewDidLoad() {
        super.viewDidLoad()
        // セッションの作成.
        mySession = AVCaptureSession()
        // デバイス一覧の取得.
        let devices = AVCaptureDevice.devices()
        // バックカメラをmyDeviceに格納.
        for device in devices{
            if(device.position == AVCaptureDevice.Position.back){
                myDevice = device as! AVCaptureDevice
            }
        }

        // バックカメラからVideoInputを取得.
        do {
            let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
            let videoInput = try AVCaptureDeviceInput(device: captureDevice!)
            mySession.addInput(videoInput)
            // 出力先を生成.
            myImageOutput = AVCaptureStillImageOutput()
            // セッションに追加.
            mySession.addOutput(myImageOutput)
            // 画像を表示するレイヤーを生成.
            let myVideoLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: mySession) as! AVCaptureVideoPreviewLayer
            myVideoLayer.frame = self.view.bounds
            myVideoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            // Viewに追加.
            self.view.layer.addSublayer(myVideoLayer)
            // セッション開始.
            mySession.startRunning()
            // UIボタンを作成.
            let myButton = UIButton(frame: CGRect(x:0,y:0,width:120,height:50))
            myButton.backgroundColor = UIColor.red;
            myButton.layer.masksToBounds = true
            myButton.setTitle("撮影", for: .normal)
            myButton.layer.cornerRadius = 20.0
            myButton.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height-50)
            myButton.addTarget(self, action: "onClickMyButton:", for: .touchUpInside)
            // UIボタンをViewに追加.
            self.view.addSubview(myButton);
        } catch {
            print ("error")
        }
    }
    // ボタンイベント.
    func onClickMyButton(sender: UIButton){
        // ビデオ出力に接続.
        let myVideoConnection = myImageOutput.connection(with: AVMediaType.video)
        // 接続から画像を取得.
        self.myImageOutput.captureStillImageAsynchronously(from: myVideoConnection!, completionHandler: { (imageDataBuffer, error) -> Void in
            // 取得したImageのDataBufferをJpegに変換.
            let myImageData : NSData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataBuffer!) as! NSData
            // JpegからUIIMageを作成.
            let myImage : UIImage = UIImage(data: myImageData as Data)!
            // アルバムに追加.
            UIImageWriteToSavedPhotosAlbum(myImage, self, nil, nil)
        })
        
    }
}
