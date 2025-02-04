//
//  ImagePickerViewController.swift
//  LocationBasedWeather
//
//  Created by 박준우 on 2/4/25.
//

import PhotosUI
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
    
    private let imageCollectionView: ImageCollectionView = ImageCollectionView(layout: UICollectionViewFlowLayout())
    
    
    private var uiimageList: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.imageCollectionView.backgroundColor = UIColor.yellow
        
        self.imageCollectionView.delegate = self
        self.imageCollectionView.dataSource = self
        
        self.configureHierarchy()
        self.configureLayout()
    }
    
    private func configureHierarchy() {
        self.view.addSubview(self.imagePickerButton)
        self.view.addSubview(self.phPickerButton)
        self.view.addSubview(self.imageCollectionView)
    }
    
    private func configureLayout() {
        
        self.imageCollectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view.snp.centerY)
        }
        
        self.imagePickerButton.snp.makeConstraints { make in
            make.width.equalTo(250)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(50)
        }
        
        self.phPickerButton.snp.makeConstraints { make in
            make.width.equalTo(250)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(100)
        }
    }
    
    @objc private func imagePickerTapped() {
        
        let ipC: UIImagePickerController = UIImagePickerController()
        ipC.delegate = self
        ipC.sourceType = .photoLibrary
        ipC.allowsEditing = true
        self.present(ipC, animated: true)
    }
    
    @objc private func phPickerTapped() {
        
        var configure: PHPickerConfiguration = PHPickerConfiguration()
        configure.selectionLimit = 0
        let phpVC: PHPickerViewController = PHPickerViewController(configuration: configure)
        phpVC.delegate = self
        self.present(phpVC, animated: true)
    }
}

extension ImagePickerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3 - (8 * 2), height: collectionView.frame.width / 3 - (8 * 2))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return uiimageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.id, for: indexPath) as? ImageCollectionViewCell {
            cell.imageView.image = self.uiimageList[indexPath.item]
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

extension ImagePickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.uiimageList.append(image)
            self.imageCollectionView.reloadData()
        } else {
            print("사진 가져오기 실패")
        }
        self.dismiss(animated: true)
    }
}

extension ImagePickerViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        if !results.isEmpty {
            
            let group: DispatchGroup = DispatchGroup()
            
            results.forEach { result in
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    group.enter()
                    result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                        if let uiimage = image as? UIImage {
                            self.uiimageList.append(uiimage)
                            group.leave()
                        }
                    }
                } else {
                    return
                }
            }
            group.notify(queue: .main) {
                self.imageCollectionView.reloadData()
                self.dismiss(animated: true)
            }
        } else {
            self.dismiss(animated: true)
        }
    }
}
