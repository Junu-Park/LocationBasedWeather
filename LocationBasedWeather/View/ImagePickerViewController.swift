//
//  ImagePickerViewController.swift
//  LocationBasedWeather
//
//  Created by 박준우 on 2/4/25.
//

import UIKit

import SnapKit

final class ImagePickerViewController: UIViewController {
    
    private lazy var imagePickerButton: UIButton = {
        let btn: UIButton = UIButton()
        var configure = UIButton.Configuration.filled()
        configure.title = "ImagePickerController"
        configure.baseBackgroundColor = UIColor.black
        configure.baseForegroundColor = UIColor.orange
        configure.cornerStyle = .capsule
        btn.configuration = configure
        btn.addTarget(self, action: #selector(self.imagePickerTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var phPickerButton: UIButton = {
        let btn: UIButton = UIButton()
        var configure = UIButton.Configuration.filled()
        configure.title = "PHPickerViewController"
        configure.baseBackgroundColor = UIColor.gray
        configure.baseForegroundColor = UIColor.black
        configure.cornerStyle = .capsule
        btn.configuration = configure
        btn.addTarget(self, action: #selector(self.phPickerTapped), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.configureHierarchy()
        self.configureLayout()
    }
    
    private func configureHierarchy() {
        self.view.addSubview(self.imagePickerButton)
        self.view.addSubview(self.phPickerButton)
    }
    
    private func configureLayout() {
        self.imagePickerButton.snp.makeConstraints { make in
            make.width.equalTo(250)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
        }
        
        self.phPickerButton.snp.makeConstraints { make in
            make.width.equalTo(250)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(50)
        }
    }
    
    @objc private func imagePickerTapped() {
        print(#function)
    }
    
    @objc private func phPickerTapped() {
        print(#function)
    }
}
