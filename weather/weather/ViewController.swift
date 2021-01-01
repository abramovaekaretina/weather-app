//
//  ViewController.swift
//  weather
//
//  Created by Ekaterina Abramova on 12.12.2020.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var cityPickerView: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var getWeatherForecastButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var blurEffectView: UIVisualEffectView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    private let startUrl = "https://api.weatherbit.io/v2.0/forecast/daily?city="
    private let apiKey = "&key=46bd1a25044d4418bfe508574356cc63"
    private var countOfDays = 3
    private var apiURL: String = ""
    private var selectedCity: String = ""
    private var forecasts: ForecastDaily?
    private let locationManager = CLLocationManager()
    private var currentLocation = CLLocation()
    private var cities: [String] = [
        "Current location", "Vienna", "Brussels",
        "Minsk", "London", "Berlin", "Copenhagen",
        "Madrid", "Rome", "Riga", "Monaco",
        "Amsterdam", "Oslo", "Warsaw", "Moscow",
        "Kiev", "Helsinki", "Paris", "Prague",
        "Bern", "Stockholm", "Tallinn"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        blurEffectView.alpha = 0.7

        cityPickerView.delegate = self
        cityPickerView.dataSource = self

        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 15
        getWeatherForecastButton.layer.cornerRadius = 15

        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        currentLocation = locationManager.location ?? CLLocation()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.distanceFilter = 10
            locationManager.startUpdatingLocation()
        }
        getForecast()
    }

    @IBAction func getWeatherForecastButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Select count of days", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "3 days", style: .default, handler: { (_) in
            self.countOfDays = 3
            self.getForecast()
        }))
        alert.addAction(UIAlertAction(title: "1 week", style: .default, handler: { (_) in
            self.countOfDays = 7
            self.getForecast()
        }))
        alert.addAction(UIAlertAction(title: "2 weeks", style: .default, handler: { (_) in
            self.countOfDays = 14
            self.getForecast()
        }))
        present(alert, animated: true)
    }

    func getForecast() {
        print("count - \(countOfDays)")
        if cityPickerView.selectedRow(inComponent: 0) != 0 {
            selectedCity = cities[cityPickerView.selectedRow(inComponent: 0)]
            apiURL = startUrl + selectedCity + apiKey + "&days=\(countOfDays)"
        } else if cityPickerView.selectedRow(inComponent: 0) == 0 {
            let lat = currentLocation.coordinate.latitude
            let lon = currentLocation.coordinate.longitude
            apiURL = "https://api.weatherbit.io/v2.0/forecast/daily?lat=\(lat)&lon=\(lon)" +
                apiKey + "&days=\(countOfDays)"
        }
        print(apiURL)
        sendRequest()
    }

    func sendRequest() {
        activityIndicator.alpha = 1
        activityIndicator.startAnimating()
        if let url = URL(string: apiURL) {
                let urlRequest = URLRequest(url: url)
                let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.alpha = 0
                    }
                    guard error == nil else {
                        print(error?.localizedDescription ?? "Error: not found")
                        return
                    }
                    if let data = data {
                        if let forecastResponse = try? JSONDecoder().decode(ForecastDaily.self, from: data) {
                            self.forecasts = forecastResponse
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        } else {
                            print("error")
                        }
                    }
                }
            dataTask.resume()
        }
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(cities[row])"
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        getForecast()
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = forecasts?.data.count else {
            return 0
        }
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nameCell = String(describing: ForecastTableViewCell.self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: nameCell,
                                                       for: indexPath) as? ForecastTableViewCell else {
            return UITableViewCell()
        }

        if let forecasts = forecasts {
            DispatchQueue.main.async {
                cell.descriptionLabel.text = forecasts.data[indexPath.row].weather.description
                let imageName = forecasts.data[indexPath.row].weather.icon
                cell.weatherImageView.image = UIImage(named: imageName)
                let degrees = forecasts.data[indexPath.row].temperature
                cell.degreesLabel.text = "\(String(degrees))°C"
                let dateFormetter = DateFormatter()
                dateFormetter.dateFormat = "yyyy-MM-dd"
                let string = forecasts.data[indexPath.row].date
                if let date = dateFormetter.date(from: string) {
                    dateFormetter.dateFormat = "MMM d"
                    cell.dateLabel.text = dateFormetter.string(from: date)
                }
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location
            tableView.reloadData()
        }
    }
}
