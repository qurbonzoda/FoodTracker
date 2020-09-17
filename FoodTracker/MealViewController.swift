//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Abduqodiri Qurbonzoda on 04/08/2020.
//  Copyright © 2020 Abduqodiri Qurbonzoda. All rights reserved.
//

import UIKit
import os.log

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var mealNameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControll!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var meal: Meal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let nonNilMeal = meal {
            navigationItem.title = nonNilMeal.name
            mealNameTextField.text = nonNilMeal.name
            photoImageView.image = nonNilMeal.photo
            ratingControl.rating = nonNilMeal.rating
        }
        
        mealNameTextField.delegate = self
        updateSaveButtonState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = mealNameTextField.text ?? "" // (a != nil ? a : "") -> (a ?? "")
        let photo = photoImageView.image
        let rating = ratingControl.rating
        
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        meal = Meal(name: name, photo: photo, rating: rating)
    }
    
    @IBAction func didTapCancelButton(_ sender: UIBarButtonItem) {
        if presentingViewController != nil {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController!.popViewController(animated: true)
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }

    
    func updateSaveButtonState() {
        let text = mealNameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        print("Image was tapped")
        mealNameTextField.resignFirstResponder()
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        guard let pickedImage = info[.originalImage] as? UIImage else {
            fatalError("Something went wrong, there is no original photo!")
        }
        
        photoImageView.image = pickedImage
        dismiss(animated: true, completion: nil)
    }
}

