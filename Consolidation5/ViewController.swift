//
//  ViewController.swift
//  Consolidation5
//
//  Created by Yuki Shinohara on 2020/05/28.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var pictures = [Picture]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPicture))
        
        let defaults = UserDefaults.standard

        if let savedPicture = defaults.object(forKey: "pictures") as? Data {
            let jsonDecoder = JSONDecoder()

            do {
                pictures = try jsonDecoder.decode([Picture].self, from: savedPicture)
            } catch {
                print("Failed to load picture")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Row", for: indexPath)
         let picture = pictures[indexPath.row]
        cell.textLabel?.text = picture.name
        
        let path = getDocumentsDirectory().appendingPathComponent(picture.image)
        cell.imageView?.image = UIImage(contentsOfFile: path.path)
         cell.textLabel?.font = UIFont(name: "Arial", size: 19) //cellのフォントとサイズ
         return cell
    }
    
    @objc func addPicture(){
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
            present(picker, animated: true)
      
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          guard let image = info[.editedImage] as? UIImage else { return }
          
          let imageName = UUID().uuidString
          let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
          
          if let jpegData = image.jpegData(compressionQuality: 0.8) {
              try? jpegData.write(to: imagePath)
          }
          
          let picture = Picture(name: "Unknown", image: imageName)
          pictures.append(picture)
          save()
          tableView.reloadData()
          
          dismiss(animated: true)
      }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "pictures")
        } else {
            print("Failed to save pictures.")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let picture = pictures[indexPath.row]
        let ac = UIAlertController(title: "選択してください", message: nil, preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "ページ遷移", style: .default) {[weak self] (UIAlertAction) -> Void in
            
            if let vc = self?.storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
                
                
                vc.selectedImage = picture.image ///
                vc.name = picture.name
                
                self?.navigationController?.pushViewController(vc, animated: true)
            }})
        
        ac.addAction(UIAlertAction(title: "名前変更", style: .default, handler: { [weak self] _ in
            let ac2 = UIAlertController(title: "入力してください", message: nil, preferredStyle: .alert)
            ac2.addTextField()
            
            ac2.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            ac2.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac2] _ in
                guard let newName = ac2?.textFields?[0].text else { return }
                picture.name = newName
                self?.save()
                self?.tableView.reloadData()
            })
            
            self?.present(ac2, animated: true)
            
        }))
        
         ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        //
        present(ac, animated: true)

    }

}

