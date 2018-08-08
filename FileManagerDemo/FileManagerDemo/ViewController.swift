//
//  ViewController.swift
//  FileManagerDemo
//
//  Created by Ada 2018 on 08/08/18.
//  Copyright © 2018 Ada 2018. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var loadedPhoto: UIImageView!
    
    var imagePicker: UIImagePickerController!
    var documentoDiretorio : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tirarFoto(_ sender: Any) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func savePhoto(_ sender: Any) {
        criarDiretorio()
        salvarFoto(photoView.image!)
    }
   
    @IBAction func loadPhoto(_ sender: Any) {
       
        let alertController = UIAlertController(title: "Nome da Foto", message: "Digite o nome da Foto", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: nil)
        
        let saveAction = UIAlertAction(title: "Carregar", style: .default, handler: { alert -> Void in
            let nomeFoto = alertController.textFields![0] as UITextField
            //carrega a foto na ImageView
            self.loadedPhoto.image = self.getFotoSalva(named: "\(nomeFoto.text ?? "foto").jpeg")
        })
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func criarDiretorio() {
        //diretorio da pasta documents
        if let caminho = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            //append um novo path com a pasta a ser criada
            documentoDiretorio = caminho.appendingPathComponent("Fotos")
            
            //verifico se a pasta existe, se não existir, ela é criada
            let saida = FileManager.default.fileExists(atPath: documentoDiretorio!.path)
            if !saida {
                do {
                    try FileManager.default.createDirectory(atPath: documentoDiretorio!.path, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func salvarFoto(_ image: UIImage) {
        //cria o alert para dar um nome a foto e salva-la
        let alertController = UIAlertController(title: "Nome da Foto", message: "Dê um nome a Foto", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: nil)
        
        let saveAction = UIAlertAction(title: "Salvar", style: .default, handler: { alert -> Void in
            let nomeFoto = alertController.textFields![0] as UITextField
            
                if let data = UIImageJPEGRepresentation(image, 1) ?? UIImagePNGRepresentation(image),
                    //diretorio da pasta documents
                    let diretorio = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL{
                    
                    do {
                        //salva a foto na pasta Fotos dentro de documents
                        try data.write(to: diretorio.appendingPathComponent("/Fotos/\(nomeFoto.text ?? "foto").jpeg")!)
                        print("Foto Salva!")
                    } catch {
                        print(error.localizedDescription)
                    }
                }
        })
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: {
            (action : UIAlertAction!) -> Void in })

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)

    }
    
    func getFotoSalva(named: String) -> UIImage? {
        //localiza o diretorio da pasta documents
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            //pega a url da imagem que está na pasta Fotos e a retorna
            let fileURL = URL(fileURLWithPath: dir.absoluteString).appendingPathComponent("/Fotos").appendingPathComponent(named).path
            print(fileURL)
            return UIImage(contentsOfFile:fileURL)
        }
        return nil
    }
}

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        photoView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
}
