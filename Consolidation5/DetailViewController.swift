//
//  DetailViewController.swift
//  Consolidation5
//
//  Created by Yuki Shinohara on 2020/05/28.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var name: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = name
        let path = getDocumentsDirectory().appendingPathComponent(selectedImage ?? "")
        imageView.image = UIImage(contentsOfFile: path.path)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
