//
//  DetailViewController.swift
//  CoreDataPersonFetchResult
//
//  Created by Hiếu Nguyễn on 9/28/18.
//  Copyright © 2018 Hiếu Nguyễn. All rights reserved.
//

import UIKit
import os.log

class DetailViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textAge: UITextField!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    
    var person: Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textName.delegate = self
        
        if let dataObject = person {
            textName.text = dataObject.name
            textAge.text = String(dataObject.age)
            photoView.image = dataObject.photo as? UIImage
        }
    
        updateSaveButtonState()
    }
    
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Loại bỏ bộ chọn nếu người dùng đã huỷ
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        // Set photoImageView to display the selected image.
        
        
        photoView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        // Hide the keyboard
        textName.resignFirstResponder()
        //        textAge.resignFirstResponder()
        // UIImagePickerController là một view controller cho phép một người dùng chọn phương tiện từ thư viện ảnh của họ.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func saveData(_ sender: UIBarButtonItem) {
        guard let name = textName.text  else {
            return
        }
        guard let age = textAge.text else {
            return
        }
        guard let photo = photoView.image else {return}
        if person == nil {
            person = Person(context: (DataService.sharedInstance.fetchedResultsController.managedObjectContext))
        }
        
        person?.name = name
        person?.age = Int16(Int(age) ?? 0 )
        person?.photo = photo
        
        DataService.sharedInstance.saveData()
        
        navigationController?.popViewController(animated: true)
    }
    
    
    func updateSaveButtonState()  {
        // Disable the Save button if the text field is empty.
        let text = textName.text ?? ""
        saveButton.isEnabled = !text.isEmpty
        
    }
    
    
    
    
    
}

