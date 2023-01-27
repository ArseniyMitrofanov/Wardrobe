//
//  AddClothesViewController.swift
//  Wardrobe
//
//  Created by Арсений on 13.01.23.
//

import UIKit

class AddClothesViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    var nameText: String = ""
    var descriptionText: String = ""
    var eType = Clothes.eType.hat
    var temperatureLowerBound: Double = 99
    var temperatureUpperBound: Double = 99
    private lazy var imagePicker: ImagePicker = {
        let imagePicker = ImagePicker()
        imagePicker.delegate = self
        return imagePicker
    }()
    let imageView: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "tshirt"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .red
        return view
    }()
    let cameraButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Камера", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .red
        button.titleLabel?.font =  .systemFont(ofSize: 15)
        return button
    }()
    let photoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Выбрать из галереии", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .red
        button.titleLabel?.font =  .systemFont(ofSize: 15)
        return button
    }()
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = "Название"
        return textField
    }()
    let descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = "Описание"
        return textField
    }()
    let eTypePicker: UIPickerView = {
        let view = UIPickerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let eTypePickerData: [String] = ["hat", "outerwear", "sweater", "tshirt", "trousers", "shoes"]
    let temperatureStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 2
        view.alignment = .leading
        view.distribution = .fill
        return view
    }()
    let lowLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "от"
        label.font = .systemFont(ofSize: 25)
        return label
    }()
    let mediumLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "℃   до"
        label.font = .systemFont(ofSize: 25)
        return label
    }()
    let highLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "℃"
        label.font = .systemFont(ofSize: 25)
        return label
    }()
    let lowTemperatureTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numbersAndPunctuation
        return textField
    }()
    let highTemperatureTextFiel: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numbersAndPunctuation
        return textField
    }()
    let addClothesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Добавить одежду", for: .normal)
        button.layer.cornerRadius = 20
        button.backgroundColor = .red
        button.titleLabel?.font =  .systemFont(ofSize: 30)
        return button
    }()
//    let wardrobeService = WardrobeService()
    override func viewDidLoad() {
        super.viewDidLoad()
        makeConstraints()
        nameTextField.delegate = self
        descriptionTextField.delegate = self
        lowTemperatureTextField.delegate = self
        highTemperatureTextFiel.delegate = self
        eTypePicker.delegate = self
        eTypePicker.dataSource = self
        photoButton.addTarget(self, action: #selector(photoButtonTapped), for: .touchUpInside)
        cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        addClothesButton.addTarget(self, action: #selector(addClothesButtonTapped), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(AddClothesViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddClothesViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func makeConstraints(){
        
        self.view.addSubview(imageView)
        self.view.addSubview(cameraButton)
        self.view.addSubview(photoButton)
        self.view.addSubview(nameTextField)
        self.view.addSubview(descriptionTextField)
        self.view.addSubview(eTypePicker)
        self.view.addSubview(temperatureStackView)
        self.view.addSubview(addClothesButton)
        temperatureStackView.addArrangedSubview(lowLabel)
        temperatureStackView.addArrangedSubview(lowTemperatureTextField)
        temperatureStackView.addArrangedSubview(mediumLabel)
        temperatureStackView.addArrangedSubview(highTemperatureTextFiel)
        temperatureStackView.addArrangedSubview(highLabel)
      
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            photoButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            photoButton.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 22),
            photoButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            photoButton.heightAnchor.constraint(equalToConstant: 40),
            cameraButton.bottomAnchor.constraint(equalTo: photoButton.topAnchor, constant: -10),
            cameraButton.leadingAnchor.constraint(equalTo: photoButton.leadingAnchor),
            cameraButton.trailingAnchor.constraint(equalTo: photoButton.trailingAnchor),
            cameraButton.heightAnchor.constraint(equalToConstant:40),
            eTypePicker.topAnchor.constraint(equalTo: photoButton.bottomAnchor, constant: 5),
            eTypePicker.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            eTypePicker.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            eTypePicker.bottomAnchor.constraint(equalTo: nameTextField.topAnchor, constant: -5),
            nameTextField.bottomAnchor.constraint(equalTo: descriptionTextField.topAnchor, constant: -15),
            nameTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            nameTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            descriptionTextField.bottomAnchor.constraint(equalTo: temperatureStackView.topAnchor, constant: -15),
            descriptionTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            descriptionTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            temperatureStackView.bottomAnchor.constraint(equalTo: addClothesButton.topAnchor, constant: -15),
            temperatureStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            lowTemperatureTextField.widthAnchor.constraint(equalToConstant: 60),
            highTemperatureTextFiel.widthAnchor.constraint(equalToConstant: 60),
            addClothesButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addClothesButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 22),
            addClothesButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -22),
     ])
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameText = nameTextField.text ?? ""
        descriptionText = descriptionTextField.text ?? ""
        temperatureLowerBound = Double(lowTemperatureTextField.text!) ?? 99
        temperatureUpperBound = Double(highTemperatureTextFiel.text!) ?? 99
        self.view.endEditing(true)
        return true
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return eTypePickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return eTypePickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row{
        case 0: eType = .hat
        case 1: eType = .outerwear
        case 2: eType = .sweater
        case 3: eType = .tshirt
        case 4: eType = .trousers
        case 5: eType = .shoes
        default:
            break
        }
    }
    @objc func photoButtonTapped(_ sender: UIButton) { imagePicker.photoGalleryAsscessRequest() }
    @objc func cameraButtonTapped(_ sender: UIButton) { imagePicker.cameraAsscessRequest() }
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if self.view.frame.origin.y == 0{
            self.view.frame.origin.y -= keyboardFrame.height
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y += keyboardFrame.height
        }
    }
    @objc func addClothesButtonTapped(){
        textFieldShouldReturn(nameTextField)
        if  (imageView.image != UIImage(systemName: "tshirt")) &&
             (nameText != "") &&
             (descriptionText != "") &&
             (temperatureLowerBound != 99) &&
             (temperatureUpperBound != 99) &&
             (temperatureLowerBound <= temperatureUpperBound){
            let clothes = Clothes(image: imageView.image!, name: nameText, description: descriptionText, temperatureLowerBound: temperatureLowerBound, temperatureUpperBound: temperatureUpperBound, type: eType)
            WardrobeService.defaultWardrobeService.addClothes(clothes: clothes)
            navigationController?.popViewController(animated: true)
        }else{
            print("input error")
        }
    }
}

extension AddClothesViewController: ImagePickerDelegate {
    
    func imagePicker(_ imagePicker: ImagePicker, didSelect image: UIImage) {
        imageView.image = image
        imagePicker.dismiss()
    }
    
    func cancelButtonDidClick(on imageView: ImagePicker) { imagePicker.dismiss() }
    func imagePicker(_ imagePicker: ImagePicker, grantedAccess: Bool,
                     to sourceType: UIImagePickerController.SourceType) {
        guard grantedAccess else { return }
        imagePicker.present(parent: self, sourceType: sourceType)
    }
}
