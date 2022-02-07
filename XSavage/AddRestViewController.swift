//
//  AddRestViewController.swift
//  XSavage
//
//  Created by  Даниил on 08.01.2022.
//

import UIKit


class AddRestViewController: UITableViewController {
    
    var currentPlace: Place?
    var imagedIsChanged = false
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeLocation: UITextField!
    @IBOutlet weak var placeCheck: UITextField!
    @IBOutlet weak var placeType: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        saveButton.isEnabled = false
        placeName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        setupEditScreen()
        
        

    }
//MARK: TABLE
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let cameraicon = #imageLiteral(resourceName: "camera")
            let photoicon = #imageLiteral(resourceName: "photo")
            let actionsheet = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseimagepicker(source: .camera)
                
                
            }
            camera.setValue(cameraicon, forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            let photo = UIAlertAction(title: "Photo", style: .default) { _ in
                self.chooseimagepicker(source: .photoLibrary)
                
            }
            photo.setValue(photoicon, forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionsheet.addAction(photo)
            actionsheet.addAction(camera)
            actionsheet.addAction(cancel)
            present(actionsheet, animated: true)
        } else {
            view.endEditing(true)
        }
        
    }
    func savePlace(){
        
        var image: UIImage?
        if imagedIsChanged {
            image = placeImage.image
            
            
        } else {
            image = #imageLiteral(resourceName: "imagePlaceholder")
        }
        
        let imageData = image?.pngData()
        
        let NewPlace = Place(name: placeName.text!,
                             location: placeLocation.text,
                             type: placeType.text,
                             avCheck: placeCheck.text,
                             imageData: imageData)
        if currentPlace != nil {
            try! realm.write {
                currentPlace?.name = NewPlace.name
                currentPlace?.location = NewPlace.location
                currentPlace?.avCheck = NewPlace.avCheck
                currentPlace?.imageData = NewPlace.imageData
                currentPlace?.type = NewPlace.type
            }
            
        } else {
            StorageManager.saveObject(NewPlace)
        }
        
        

    }
    private func setupEditScreen() {
        imagedIsChanged = true
        setupNavigationBar()
        if currentPlace != nil {
            guard let data = currentPlace?.imageData, let image = UIImage(data: data) else { return }
            placeImage.image = image
            placeImage.contentMode = .scaleAspectFit
            placeName.text = currentPlace?.name
            placeType.text = currentPlace?.type
            placeLocation.text = currentPlace?.location
            placeCheck.text = currentPlace?.avCheck
        }
        
        
    }
    private func setupNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        navigationItem.backButtonTitle = nil
        navigationItem.title = currentPlace?.name
        saveButton.isEnabled = true
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
//MARK: TextFieldDelegate
extension AddRestViewController: UITextFieldDelegate {
    //Скрываем клавиатуру по нажатию "Done"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @objc private func textFieldChanged() {
        if placeName.text?.isEmpty == false {
            saveButton.isEnabled = true
        }
        else {
            saveButton.isEnabled = false
        }
        
        
        
    }
}


//MARK: Work with image
extension AddRestViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func chooseimagepicker(source: UIImagePickerController.SourceType){
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagepicker = UIImagePickerController()
            imagepicker.allowsEditing = true
            imagepicker.sourceType = source
            imagepicker.delegate = self
            present(imagepicker, animated: true)
        }
        
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImage.image = (info[.editedImage] as! UIImage)
        placeImage.contentMode = .scaleAspectFit
        placeImage.clipsToBounds = true
        dismiss(animated: true)
        imagedIsChanged = true
        
    }
}
