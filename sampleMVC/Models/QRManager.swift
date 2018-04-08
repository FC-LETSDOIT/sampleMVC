//
//  QRManager.swift
//  sampleMVC
//
//  Created by 滋野靖之 on 2018/03/30.
//  Copyright © 2018年 Alternated. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class QRManager:NSObject,AVCaptureMetadataOutputObjectsDelegate{
    private let session = AVCaptureSession()
    let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera],
                                                                mediaType: .video,
                                                                position: .back)
 
    private(set) var qrview:UIView?
    private(set) var QRlabel:UILabel?
    
    func getQR(qrview:UIView, qrlabel:UILabel){
        self.QRlabel=qrlabel
        let devices = discoverySession.devices
        self.qrview=qrview
        if let backCamera = devices.first {
            do {
                // QRコードの読み取りに背面カメラの映像を利用するための設定
                let deviceInput = try AVCaptureDeviceInput(device: backCamera)

                if self.session.canAddInput(deviceInput) {
                    self.session.addInput(deviceInput)

                    // 背面カメラの映像からQRコードを検出するための設定
                    let metadataOutput = AVCaptureMetadataOutput()

                    if self.session.canAddOutput(metadataOutput) {
                        self.session.addOutput(metadataOutput)

                        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                        metadataOutput.metadataObjectTypes = [.qr]

                        // 背面カメラの映像を画面に表示するためのレイヤーを生成
                        let previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
                        previewLayer.frame = (self.qrview?.bounds)!
                        previewLayer.videoGravity = .resizeAspectFill
                        self.qrview?.layer.addSublayer(previewLayer)

                        // 読み取り開始
                        self.session.startRunning()
                        print("session_startrunninng_ok")
                    }
                }
            } catch {
                print("Error occured while creating video device input: \(error)")
            }
        }

    }
    // ワイドアングルカメラ・ビデオ・背e面カメラに該当するデバイスを取得


    //　該当するデバイスのうち最初に取得したものを利用する

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        print("metadataOutput_ok")
        for metadata in metadataObjects as! [AVMetadataMachineReadableCodeObject] {
            // QRコードのデータかどうかの確認
            if metadata.type != .qr { continue }

            // QRコードの内容が空かどうかの確認
            if metadata.stringValue == nil { continue }

            /*
             このあたりで取得したQRコードを使ってゴニョゴニョする
             読み取りの終了・再開のタイミングは用途によって制御が異なるので注意
             以下はQRコードに紐づくWebサイトをSafariで開く例
             */
            self.QRlabel?.text=metadata.stringValue
           
            // 読み取り終了
            self.session.stopRunning()
            self.qrview?.layer.sublayers?.removeLast()
            break
            }
            
        }
    }




