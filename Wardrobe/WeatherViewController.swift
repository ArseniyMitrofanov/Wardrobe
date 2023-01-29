//
//  ViewController.swift
//  Wardrobe
//
//  Created by Арсений on 26.11.22.
//

import UIKit

enum Section: Hashable {
    case main
    case hat
    case outerwear
    case sweater
    case tshirt
    case trousers
    case shoes
}

class WeatherViewController: UIViewController{
    var currentTemperature: Double = 0
    let locationWeatherService = LocationWeatherService()
    let currentTemperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "--"
        label.font = .systemFont(ofSize: 50)
        return label
    }()
    let currentWeatherLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "..."
        label.font = .systemFont(ofSize: 25)
        label.numberOfLines = 2
        return label
    }()
    let currentDayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "..."
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.backgroundColor = .red
        label.textColor = .white
        return label
    }()
    let weatherStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var weatherCollectionView: UICollectionView!
    var weatherDataSourse: UICollectionViewDiffableDataSource<Section, HourWeather>!
    let showWardrobeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Показать гардероб", for: .normal)
        button.layer.cornerRadius = 20
        button.backgroundColor = .red
        button.titleLabel?.font =  .systemFont(ofSize: 30)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateCollectionViewLayout())
        weatherCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        showWardrobeButton.addTarget(self, action: #selector(showWardrobeButtonTapped), for: .touchUpInside)
        locationWeatherService.delegate = self
        locationWeatherService.getLocation()
        makeConstraints()
        fillWeatherStackView()
        
        createDataSource()
    }
    
    func fillWeatherStackView(){
        let time = UILabel()
        time.numberOfLines = 2
        time.text = "День \nВремя"
        let temperature = UILabel()
        temperature.numberOfLines = 2
        temperature.text = "Температура \n℃"
        let windSpeed = UILabel()
        windSpeed.numberOfLines = 2
        windSpeed.text = "Скорость \nветра км/ч"
        let precipitation = UILabel()
        precipitation.numberOfLines = 2
        precipitation.text = "Осадки \nмм"
        weatherStackView.addArrangedSubview(time)
        weatherStackView.addArrangedSubview(temperature)
        weatherStackView.addArrangedSubview(windSpeed)
        weatherStackView.addArrangedSubview(precipitation)
    }
    
    func makeConstraints(){
        
        self.view.addSubview(currentTemperatureLabel)
        self.view.addSubview(currentWeatherLabel)
        self.view.addSubview(currentDayLabel)
        self.view.addSubview(weatherStackView)
        self.view.addSubview(separator)
        self.view.addSubview(weatherCollectionView!)
        self.view.addSubview(showWardrobeButton)
        NSLayoutConstraint.activate([
            currentTemperatureLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            currentTemperatureLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 22),
            currentWeatherLabel.topAnchor.constraint(equalTo: currentTemperatureLabel.topAnchor),
            currentWeatherLabel.leadingAnchor.constraint(equalTo: currentTemperatureLabel.trailingAnchor, constant: 30),
            currentWeatherLabel.bottomAnchor.constraint(equalTo: currentTemperatureLabel.bottomAnchor),
            currentWeatherLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -22),
            currentDayLabel.topAnchor.constraint(equalTo: currentTemperatureLabel.bottomAnchor, constant: 25),
            currentDayLabel.leadingAnchor.constraint(equalTo: currentTemperatureLabel.leadingAnchor),
            currentDayLabel.trailingAnchor.constraint(equalTo: currentWeatherLabel.trailingAnchor),
            currentDayLabel.heightAnchor.constraint(equalToConstant: 35),
            weatherStackView.topAnchor.constraint(equalTo: currentDayLabel.bottomAnchor, constant: 10),
            weatherStackView.leadingAnchor.constraint(equalTo: currentTemperatureLabel.leadingAnchor),
            //            weatherStackView.trailingAnchor.constraint(equalTo: currentWeatherLabel.trailingAnchor),
            weatherStackView.widthAnchor.constraint(equalToConstant: 120),
            weatherStackView.bottomAnchor.constraint(equalTo: showWardrobeButton.topAnchor, constant: -10),
            
            separator.topAnchor.constraint(equalTo: weatherStackView.topAnchor, constant: 25),
            separator.bottomAnchor.constraint(equalTo: weatherStackView.bottomAnchor, constant: -25),
            separator.leadingAnchor.constraint(equalTo: weatherStackView.trailingAnchor),
            separator.widthAnchor.constraint(equalToConstant: 1),
            
            weatherCollectionView.topAnchor.constraint(equalTo: currentDayLabel.bottomAnchor, constant: 10),
            weatherCollectionView.leadingAnchor.constraint(equalTo: weatherStackView.trailingAnchor, constant: 3),
            weatherCollectionView.trailingAnchor.constraint(equalTo: currentWeatherLabel.trailingAnchor),
            weatherCollectionView.bottomAnchor.constraint(equalTo: showWardrobeButton.topAnchor, constant: -10),
            showWardrobeButton.leadingAnchor.constraint(equalTo: currentTemperatureLabel.leadingAnchor),
            showWardrobeButton.trailingAnchor.constraint(equalTo: currentWeatherLabel.trailingAnchor),
            showWardrobeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            showWardrobeButton.heightAnchor.constraint(equalToConstant: 65)
        ])
        
        
    }
    func generateCollectionViewLayout() -> UICollectionViewLayout {
        let sectionProvider = {
            (int: Int, enviroment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/4), heightDimension: .fractionalHeight(1))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            return section
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    func createDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, HourWeather> { cell, indexPath, hourWeather in
            if !cell.subviews.isEmpty{
                cell.contentView.subviews.forEach {$0.removeFromSuperview()}
            }
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.frame = cell.bounds
            stackView.distribution = .fillEqually
            let time = UILabel()
            let Tindex = hourWeather.time.firstIndex(of: "T")!
            let dayAndYear = hourWeather.time[..<Tindex]
            self.currentDayLabel.text = String(dayAndYear)
            let minusIndex = dayAndYear.firstIndex(of: "-")!
            var day = dayAndYear[minusIndex...]
            day.remove(at: day.startIndex)
            var dayTime = hourWeather.time[Tindex...]
            dayTime.remove(at: dayTime.startIndex)
            time.text = day + "\n" + dayTime
            time.numberOfLines = 2
            let temperature = UILabel()
            temperature.text = String(hourWeather.temperature2M)
            let precipitation = UILabel()
            precipitation.text = String(hourWeather.precipitation)
            let windSpeed = UILabel()
            windSpeed.text = String(hourWeather.windspeed10M)
            stackView.addArrangedSubview(time)
            stackView.addArrangedSubview(temperature)
            stackView.addArrangedSubview(windSpeed)
            stackView.addArrangedSubview(precipitation)
            cell.contentView.addSubview(stackView)
        }
        
        weatherDataSourse = UICollectionViewDiffableDataSource(collectionView: weatherCollectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
            
        }
    }
    func loadData(hoursWeather: [HourWeather]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, HourWeather>()
        snapshot.appendSections([.main])
        snapshot.appendItems(hoursWeather, toSection: .main)
        weatherDataSourse.applySnapshotUsingReloadData(snapshot)
    }
    @objc func showWardrobeButtonTapped(){
        let vc = SortedWardrobeViewController()
        vc.view.backgroundColor = .white
        vc.currentTemperature = self.currentTemperature
        vc.view.frame.origin = CGPoint(x: 0, y: 100)
        present(vc, animated: true)
    }
}

extension WeatherViewController: LocationWeatherServiceDelegate {
    func didFetchWeather(hoursWeather: [HourWeather]){
        loadData(hoursWeather: hoursWeather)
        let currentTime   = (Calendar.current.component(.hour, from: Date()))
        currentTemperature = hoursWeather[currentTime].temperature2M
        self.currentTemperatureLabel.text = String(currentTemperature) + "℃"
        switch hoursWeather[currentTime].cloudcover{
        case 0...25: currentWeatherLabel.text = "Ясно"
        case 26...75:  currentWeatherLabel.text = "Переменная  облачность"
        default: currentWeatherLabel.text = "Облачно"
            
        }
    }
    
    func didFailToFetchWeather(with error: Error) {
        //warning
    }
    
}
