//
//  SettingsViewController.swift
//  Wardrobe
//
//  Created by Арсений on 7.12.22.
//

import UIKit

class SettingsViewController: UIViewController {
    let imageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "dev"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let conectionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Связь с разработчиком"
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 30)
        return label
    }()
    let openGitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("github.com", for: .normal)
        button.setTitleColor(UIColor.link, for: .normal)
        button.titleLabel?.font =  .systemFont(ofSize: 20)
        return button
    }()
    let devLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Так же в разработке: \nтемная тема, смена языка"
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        openGitButton.addTarget(self, action: #selector(openGit), for: .touchUpInside)
        makeConstraints()
        
    }
    
    func makeConstraints(){
        self.view.addSubview(conectionLabel)
        self.view.addSubview(openGitButton)
        self.view.addSubview(imageView)
        self.view.addSubview(devLabel)
        NSLayoutConstraint.activate([
            conectionLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50),
            conectionLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 22),
            openGitButton.topAnchor.constraint(equalTo: conectionLabel.bottomAnchor, constant: 15),
            openGitButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 22),
            imageView.topAnchor.constraint(equalTo: openGitButton.bottomAnchor, constant: 15),
            imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 535/600),
            devLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            devLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
        ])
    }
    
    @objc func openGit(){
        let url = URL(string: "https://github.com/ArseniyMitrofanov")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
}
