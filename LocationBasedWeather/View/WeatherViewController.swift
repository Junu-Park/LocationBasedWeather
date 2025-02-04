//
//  WeatherViewController.swift
//  LocationBasedWeather
//
//  Created by 박준우 on 2/3/25.
//

import UIKit
import SnapKit
import MapKit
import Alamofire

final class WeatherViewController: UIViewController {
    
    private let defaultCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.6544, longitude: 127.0499)
    
    private lazy var defaultRegion: MKCoordinateRegion = MKCoordinateRegion(center: self.defaultCoordinate, latitudinalMeters: 300, longitudinalMeters: 300)
    
    private lazy var locationManager: CLLocationManager = CLLocationManager()
    
    private let mapView: MKMapView = {
        let view = MKMapView()
        return view
    }()
    
    private let weatherInfoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        label.text = "날씨 정보를 불러오는 중..."
        return label
    }()
    
    private let currentLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "location.fill"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .systemBlue
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 4
        return button
    }()
    
    private let refreshButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .systemBlue
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 4
        return button
    }()
    
    private var requestData: WeatherRequest = WeatherRequest(lat: 37.6544, lon: 127.0499)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupConstraints()
        self.setupActions()
        self.configureLocationManagerConnection()
        self.configureNavigationItem()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        [mapView, weatherInfoLabel, currentLocationButton, refreshButton].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        mapView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.snp.height).multipliedBy(0.5)
        }
        
        weatherInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        currentLocationButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.width.height.equalTo(50)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.width.height.equalTo(50)
        }
    }
    
    private func setupActions() {
        currentLocationButton.addTarget(self, action: #selector(currentLocationButtonTapped), for: .touchUpInside)
        refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
    }
    
    private func configureNavigationItem() {
        let rightItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "photo"), style: .plain, target: self, action: #selector(self.imageButtonTapped))
        
        self.navigationItem.setRightBarButton(rightItem, animated: true)
    }
    
    // MARK: - Actions
    @objc private func currentLocationButtonTapped() {
        // 현재 위치 가져오기 구현
        self.checkLocationService()
    }
    
    @objc private func refreshButtonTapped() {
        // 날씨 새로고침 구현
        NetworkManager.shared.requestWeatherData(params: self.requestData) { (response: Result<WeatherResponse, AFError>) in
            switch response {
            case .success(let success):
                self.weatherInfoLabel.text = "\(Date().convertToString())\n현재온도:\(success.main.temp.convertToCelsius())℃\n최저온도:\(success.main.temp_min.convertToCelsius())℃\n최고온도:\(success.main.temp_max.convertToCelsius())℃\n풍속:\(success.wind.speed)m/s\n습도:\(success.main.humidity)%"
            case .failure:
                self.weatherInfoLabel.text = "날씨 정보 가져오기 실패"
            }
        }
    }
    
    @objc private func imageButtonTapped() {
        self.navigationController?.pushViewController(ImagePickerViewController(), animated: true)
    }
    
    // MARK: - Location
    // 위치 서비스 가능 여부 체크
    private func checkLocationService() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.checkLocationAuthorization()
            } else {
                self.presentLocationServiceAlert()
            }
        }
    }
    
    // 위치 권한 체크
    private func checkLocationAuthorization() {
        switch self.locationManager.authorizationStatus {
        case .notDetermined:
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .denied:
            self.mapView.setRegion(self.defaultRegion, animated: true)
            self.requestData.lat = self.defaultRegion.center.latitude
            self.requestData.lon = self.defaultRegion.center.longitude
            self.presentLocationAuthorizationAlert()
        case .authorizedAlways:
            self.locationManager.startUpdatingLocation()
        case .authorizedWhenInUse:
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.startUpdatingLocation()
        default:
            break
        }
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    
    func configureLocationManagerConnection() {
        self.locationManager.delegate = self
    }
    
    // 위치 권한 상태가 바뀐 경우
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.checkLocationService()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let coor = locations.first?.coordinate else { return }
        
        let region: MKCoordinateRegion = MKCoordinateRegion(center: coor, latitudinalMeters: 300, longitudinalMeters: 300)
        self.mapView.setRegion(region, animated: true)
        
        let annotation: MKPointAnnotation = MKPointAnnotation()
        annotation.coordinate = coor
        self.mapView.addAnnotation(annotation)
        self.requestData.lat = coor.latitude
        self.requestData.lon = coor.longitude
        self.locationManager.stopUpdatingLocation()
        self.refreshButtonTapped()
    }
}

extension WeatherViewController {
    // TODO: 실기기에서만 동작
    func presentLocationServiceAlert() {
        DispatchQueue.main.async {
            let ac: UIAlertController = UIAlertController(title: "위치 사용 설정", message: "위치 기반 날씨를 받아오기 위해서는 위치 사용이 필요합니다. 위치 사용 설정으로 이동하시겠습니까?", preferredStyle: .alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "취소", style: .cancel)
            let confirmAction: UIAlertAction = UIAlertAction(title: "확인", style: .default) { _ in
                if let url = NSURL(string:"App-prefs:Privacy&path=LOCATION") as? URL {
                    UIApplication.shared.open(url)
                     /* 동작하는 URL
                    "App-prefs:Privacy&path=LOCATION"
                    "App-Prefs:Privacy&path=LOCATION"
                     */
                }
            }
            ac.addAction(cancelAction)
            ac.addAction(confirmAction)
            self.present(ac, animated: true)
        }
    }
    
    
    func presentLocationAuthorizationAlert() {
        DispatchQueue.main.async {
        let ac: UIAlertController = UIAlertController(title: "위치 권한 설정", message: "위치 기반 날씨를 받아오기 위해서는 위치 권한이 필요합니다. 위치 권한 설정으로 이동하시겠습니까?", preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "취소", style: .cancel)
        let confirmAction: UIAlertAction = UIAlertAction(title: "확인", style: .default) { _ in
            if let settingURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingURL)
            }
        }
        ac.addAction(cancelAction)
        ac.addAction(confirmAction)
            self.present(ac, animated: true)
        }
    }
}
