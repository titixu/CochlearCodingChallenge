//
//  LocationDetailViewController.swift
//  CochlearCodingChallenge
//
//  Created by An Xu on 2/8/19.
//  Copyright © 2019 An Xu. All rights reserved.
//

import UIKit

class LocationDetailViewController: UIViewController {
    private let padding: CGFloat = 8.0
    
    var viewModel: LocationDetailViewModel
    
    let locationView = LocationDetailView(frame: .zero)
    
    init(viewModel: LocationDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(locationView)
        locationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            locationView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            locationView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            locationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            locationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding)
            ])
        locationView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        updateLocationView()
    }
    
    private func updateLocationView() {
        locationView.nameTextField.text = viewModel.name
        locationView.noteTextArea.text = viewModel.note
    }
    
    @objc func saveButtonTapped() {
        viewModel.updateName(locationView.nameTextField.text)
        viewModel.updateNote(locationView.noteTextArea.text)
        viewModel.save()
        navigationController?.popViewController(animated: true)
    }
}

class LocationDetailView: UIView {
    let nameLabel = UILabel()
    let nameTextField = UITextField()
    let noteLable = UILabel()
    let noteTextArea = UITextView()
    let saveButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        addGestureRecognizer(tapGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapped() {
        nameTextField.resignFirstResponder()
        noteTextArea.resignFirstResponder()
    }
    
    private func setupViews() {
        
        nameLabel.text = "Name:"
        nameTextField.borderStyle = .bezel
        
        noteLable.text = "Note:"
        noteTextArea.translatesAutoresizingMaskIntoConstraints = false
        noteTextArea.heightAnchor.constraint(equalToConstant: 150.0).isActive = true
        noteTextArea.layer.borderColor = UIColor.gray.cgColor
        noteTextArea.layer.borderWidth = 2.0
        
        saveButton.setTitle("Save", for: .normal)
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, nameTextField, noteLable, noteTextArea, saveButton])
        stackView.axis = .vertical
        stackView.spacing = 5.0
        stackView.distribution = .fill
        
        stackView.setCustomSpacing(10.0, after: nameTextField)
        stackView.setCustomSpacing(10.0, after: noteTextArea)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor)
            ])
    }
}
