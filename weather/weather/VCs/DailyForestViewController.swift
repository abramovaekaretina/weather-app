//
//  DailyForestViewController.swift
//  weather
//
//  Created by Ekaterina Abramova on 09.01.2021.
//

import UIKit

class DailyForestViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var averageTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var nextForecastButton: UIButton!
    @IBOutlet weak var previousForecastButton: UIButton!
    let activeButtonAlpha: CGFloat = 0.8
    let inactiveButtonAlpha: CGFloat = 0.4

    // MARK: - Public properties

    var forecast: ForecastDaily?
    var index = 0
    var totalDays = 0

    // MARK: - Lifecycle functions

    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.layer.cornerRadius = 15
        blurEffect.alpha = 0.5
        previousForecastButton.alpha = activeButtonAlpha
        nextForecastButton.alpha = activeButtonAlpha
        showForecast(for: index)

        let swipeGesture = UISwipeGestureRecognizer()
        swipeGesture.addTarget(self, action: #selector(swipeToBack(_:)))
        swipeGesture.direction = .right
        view.addGestureRecognizer(swipeGesture)

    }

    // MARK: - IBActions

    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func showPreviousForecastButtonPressed(_ sender: Any) {
        index -= 1
        if index == 0 {
            nextForecastButton.alpha = activeButtonAlpha
            previousForecastButton.alpha = inactiveButtonAlpha
        } else if index == totalDays - 1 {
            nextForecastButton.alpha = inactiveButtonAlpha
            previousForecastButton.alpha = activeButtonAlpha
        } else if (index > 0) && (index < totalDays - 1) {
            nextForecastButton.alpha = activeButtonAlpha
            previousForecastButton.alpha = activeButtonAlpha
        }
        showForecast(for: index)
    }

    @IBAction func showNextForecastButtonPressed(_ sender: Any) {
        index += 1
        if index == totalDays - 1 {
            nextForecastButton.alpha = inactiveButtonAlpha
            previousForecastButton.alpha = activeButtonAlpha
        } else if index == 0 {
            nextForecastButton.alpha = activeButtonAlpha
            previousForecastButton.alpha = inactiveButtonAlpha
        } else if (index > 0) && (index < totalDays - 1) {
            nextForecastButton.alpha = activeButtonAlpha
            previousForecastButton.alpha = activeButtonAlpha
        }
        showForecast(for: index)
    }

    // MARK: - Flow functions

    func showForecast(for index: Int) {
        if (index != -1) && (index < totalDays) {
            let dateFormetter = DateFormatter()
            dateFormetter.dateFormat = "yyyy-MM-dd"
            if let string = forecast?.data[index].date {
                if let date = dateFormetter.date(from: string) {
                    dateFormetter.dateFormat = "MMM d, yyyy"
                    dayLabel.text = dateFormetter.string(from: date)
                }
            }

            if let temp = forecast?.data[index].temperature {
                averageTemperatureLabel.text = "\(temp)°C"
            }
            if let minTemp = forecast?.data[index].minTemperature {
                minTemperatureLabel.text = "\(minTemp)°C"
            }
            if let maxTemp = forecast?.data[index].maxTemperature {
                maxTemperatureLabel.text = "\(maxTemp)°C"
            }

            if let sunrise = forecast?.data[index].sunrise {
                let sunriseTime = Date(timeIntervalSince1970: sunrise)
                dateFormetter.dateFormat = "h:mm a"
                let time = dateFormetter.string(from: sunriseTime)
                sunriseLabel.text = time
            }

            if let sunset = forecast?.data[index].sunset {
                let sunsetTime = Date(timeIntervalSince1970: sunset)
                dateFormetter.dateFormat = "h:mm a"
                let time = dateFormetter.string(from: sunsetTime)
                sunsetLabel.text = time
            }

            if let pressure = forecast?.data[index].pressure {
                let pressureRounded = round(pressure)
                pressureLabel.text = "Pressure : \(Int(pressureRounded)) millibars"
            }

            if let precipitation = forecast?.data[index].precipitation {
                let precipitationRounded = round(precipitation * 100) / 100
                precipitationLabel.text = "Precipitation : \(precipitationRounded) mm"
            }

            cityLabel.text = forecast?.city
        } else {
            showErrorAlert()
        }
    }

    func showErrorAlert() {
        let errorAlert = UIAlertController(title: "Attention", message: "Count of days is over", preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(errorAlert, animated: true)
    }

    @objc func swipeToBack(_ gestureRecognizer: UISwipeGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }
}
