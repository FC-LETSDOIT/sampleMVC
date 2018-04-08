//
//  ViewController.swift
//  sampleMVC
//
//  Created by 滋野靖之 on 2018/03/27.
//  Copyright © 2018年 Alternated. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController1: UIViewController{
    //delegateのインスタンスviewdidloadやボタンアクションのイベント処理で宣言してはだめ。
//    ↑イベントを抜けると死ぬから。
    var QRM:QRManager?
    @IBOutlet weak var QRLabel: UILabel!
    @IBAction func button1(_ sender: Any) {
        self.QRM=QRManager()
        self.QRM?.getQR(qrview: self.view,qrlabel: self.QRLabel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
    }
}

