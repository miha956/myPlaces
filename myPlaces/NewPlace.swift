//
//  NewPlace.swift
//  myPlaces
//
//  Created by Миша Вашкевич on 06.10.2021.
//
import Cosmos
import UIKit
import RealmSwift

class NewPlace: UITableViewController {
    
    var currentPlace: Place!
    var imageIsChanged = false
    var currentRating = 0.0
    
    
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeLocation: UITextField!
    @IBOutlet weak var placeType: UITextField!
    @IBOutlet weak var ratingControl: RatingContlor!
    @IBOutlet weak var cosmosView: CosmosView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        saveButton.isEnabled = false
        placeName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        setupEditScreen()
        
        cosmosView.settings.fillMode = .half
        cosmosView.didTouchCosmos = {rating in
            self.currentRating = rating
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewPlace.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewPlace.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK : Table View Deligate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            let cameraIcon = #imageLiteral(resourceName: "camera")
            let photoIcon = #imageLiteral(resourceName: "photo")
            
            let actionSheet = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "Сделать фото", style: UIAlertAction.Style.default) { _ in
                self.chooseImagePicker(sourse: .camera)
            }
            camera.setValue(cameraIcon, forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            
            let photo = UIAlertAction(title: "Добавить из библиотеки", style: .default) { _ in
                self.chooseImagePicker(sourse: .photoLibrary)
            }
            photo.setValue(photoIcon, forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            
            present(actionSheet, animated: true)
            
            
        } else {
            view.endEditing(true)
        }
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
        if self.tableView.frame.origin.y == 0 {
            self.tableView.frame.origin.y -= keyboardSize.height - keyboardSize.height + 30
        }
    } }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
        if self.tableView.frame.origin.y != 0 {
            self.tableView.frame.origin.y = keyboardSize.height - keyboardSize.height
        }
    } }
    
    func savePlace() {
        
        
        var image: UIImage?
        
        if imageIsChanged {
            image = placeImage.image
        }else {
            image = #imageLiteral(resourceName: "imagePlaceholder")
        }
        
        let imageData = image?.pngData()
    
        let newPlace = Place(name: placeName.text!,
                             location: placeLocation.text,
                             type: placeType.text,
                             imageData: imageData,
                             rating: currentRating)
        
        if currentPlace != nil {
            try! realm.write {
                currentPlace?.name = newPlace.name
                currentPlace?.location = newPlace.location
                currentPlace?.type = newPlace.type
                currentPlace?.imageData = newPlace.imageData
                currentPlace?.rating = newPlace.rating
            }
        } else {
            StorageManager.saveObject(newPlace)
        }
    }
   
    private func  setupEditScreen() {
        if currentPlace != nil {
            
            setupNavigationBar()
            imageIsChanged = true
            guard let data = currentPlace?.imageData, let image = UIImage(data: data) else {return}
            
            placeImage.image = image
            placeImage.contentMode = .scaleAspectFill
            placeName.text = currentPlace?.name
            placeLocation.text = currentPlace?.location
            placeType.text = currentPlace?.type
            cosmosView.rating = currentPlace.rating
            
        }
    }
    
    private func setupNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            
        }
        
        navigationItem.leftBarButtonItem = nil
        title = currentPlace?.name
        saveButton.isEnabled = true
         
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}


// MARK : TextFieldDeligate

extension NewPlace: UITextFieldDelegate {
    
    //  крываем клавиутуру по нажатию done
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    @objc private func textFieldChanged() {
        
        if placeName.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
}

// MARK : Work with image

extension NewPlace: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(sourse: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(sourse) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = sourse
            present(imagePicker, animated: true)
            
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         
        placeImage.image = info[.editedImage] as? UIImage
        placeImage.contentMode = .scaleAspectFill
        placeImage.clipsToBounds = true
        
        imageIsChanged = true
        
        dismiss(animated: true)
       
    }
    
}
