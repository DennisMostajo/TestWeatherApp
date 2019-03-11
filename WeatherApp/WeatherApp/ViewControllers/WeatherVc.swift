//
//  WeatherVc.swift
//  WeatherApp
//
//  Created by Dennis Mostajo on 3/11/19.
//  Copyright © 2019 Dennis Mostajo. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON
import Toast_Swift
import RealmSwift

class WeatherVc: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate
{
    var count = 0
    var temp = "CELSIUS"
    
    let imgView = UIImageView(frame: CGRect(x: 8, y: 6, width: 33, height: 33))
    let titleLabel = UILabel(frame:CGRect(x:45, y:12, width:180, height:21))
    let celBtn = UIButton(frame:CGRect(x:234, y:12, width:35, height:21))
    let fahBtn = UIButton(frame:CGRect(x:277, y:12, width:35, height:21))
    
    @IBOutlet var weatherTable: UITableView!
    private let locationManager = CLLocationManager()
    var weatherCitiesFromDataBase:Results<CityModel>? = nil
    
    var reachability: Reachability!
    fileprivate var offlineToast: UIView!
    var isToastShowing: Bool {
        get {
            return !((offlineToast?.isHidden) ?? true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherTable.register(UINib(nibName: "CityWeatherCell", bundle: nil), forCellReuseIdentifier: "identifierCityWeatherCell")
        weatherTable.separatorColor = UIColor.init(hex: 0xD66B31)
        weatherTable.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: weatherTable.frame.size.width, height: 1))
        // Do any additional setup after loading the view.
        weatherCitiesFromDataBase = DataBaseHelper.getCities()
        setupCustomNavigationBar()
        checkConnections()
        requestLocationPermision()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        debugPrint("viewWillAppear")
        super.viewWillAppear(animated)
        showNavBarItems()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavBarItems()
    }
    
    // MARK: - Check Connection
    
    func redirectLogToDocuments() -> String {
        
        let allPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = allPaths.first!
        let pathForLog: String = documentsDirectory + "/logs.txt"
        
        return pathForLog
    }
    
    func checkConnections()
    {
        do {
            reachability = Reachability()
            offlineToast = try self.view.toastViewForMessage(NSLocalizedString("NO_CONNECTION", comment: "You have no connection"), title: "", image: UIImage(named: "navIcon"), style: ToastStyle())
        } catch {
            debugPrint("Unable to create Reachability")
        }
        
        guard let _ = reachability, let _ = offlineToast else {
            return
        }
        
        reachability.whenReachable = { [weak self] reachability in
            DispatchQueue.main.async {
                self?.offlineToast.isHidden = true
            }
        }
        
        reachability.whenUnreachable = { [weak self] reachability in
            DispatchQueue.main.async {
                self?.showConnectiontoast()
                self?.offlineToast.isHidden = false
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func showConnectiontoast(){
        self.view.showToast(self.offlineToast, duration: TimeInterval.infinity, position: .center) { _ in
            self.showConnectiontoast()
        }
    }
    
    func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
    
    // MARK: - IBActions
    
    @objc func showCelsius()
    {
        debugPrint("CELSIUS")
        celBtn.setTitleColor(UIColor.white, for: .normal)
        fahBtn.setTitleColor(UIColor.orange, for: .normal)
        temp = "CELSIUS"
        weatherTable.reloadData()
    }
    
    @objc func showFahrenheit()
    {
        debugPrint("FAHRENHEIT")
        celBtn.setTitleColor(UIColor.orange, for: .normal)
        fahBtn.setTitleColor(UIColor.white, for: .normal)
        temp = "FAHRENHEIT"
        weatherTable.reloadData()
    }
    
    // MARK: - Methods
    
    func setupCustomNavigationBar()
    {
        self.navigationController?.navigationBar.barTintColor = UIColor.init(hex: 0x565655)
        let imgIcon = UIImage(named:"navIcon")
        imgView.contentMode = .scaleAspectFit
        imgView.image = imgIcon
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.textColor = UIColor.orange
        titleLabel.text = "Weather iOS Test"
        celBtn.setTitle("C°", for: .normal)
        celBtn.setTitleColor(UIColor.white, for: .normal)
        celBtn.addTarget(self, action: #selector(showCelsius), for: .touchUpInside)
        fahBtn.setTitle("F°", for: .normal)
        fahBtn.setTitleColor(UIColor.orange, for: .normal)
        fahBtn.addTarget(self, action: #selector(showFahrenheit), for: .touchUpInside)
        self.navigationController?.navigationBar.addSubview(imgView)
        self.navigationController?.navigationBar.addSubview(titleLabel)
        self.navigationController?.navigationBar.addSubview(celBtn)
        self.navigationController?.navigationBar.addSubview(fahBtn)
    }
    
    func showNavBarItems()
    {
        imgView.isHidden = false
        titleLabel.isHidden = false
        celBtn.isHidden = false
        fahBtn.isHidden = false
    }
    
    func hideNavBarItems()
    {
        imgView.isHidden = true
        titleLabel.isHidden = true
        celBtn.isHidden = true
        fahBtn.isHidden = true
    }
    
    func requestLocationPermision() {
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func loadData()
    {
        for city in self.weatherCitiesFromDataBase!
        {
            self.view.makeToastActivity(.center)
            
            _ = NetworkManager.manager.startRequest(OpenWeatherMapAPI.getWeatherCity(latitude: city.latitude, longitude: city.longitude),
                                                    success:
                {
                    responseRequest,responseData in
                    debugPrint("getWeatherCity StatusCode:\(String(describing: responseRequest?.statusCode))")
                    let json = try! JSON(data: responseData! as! Data)
                    //                debugPrint("getWeatherCity response:\(json)")
                    if responseRequest?.statusCode == 200
                    {
                        let temp_celsius = json["main"]["temp"].doubleValue
                        let temp_fahrenheit = (temp_celsius * (9/5))+32
                        DataBaseHelper.updateCityTemp(city_id: city.id, celsius: temp_celsius, fahrenheit: temp_fahrenheit)
                        self.view.hideToastActivity()
                    }
                    else if (responseRequest?.statusCode == 400) || (responseRequest?.statusCode == 403) || (responseRequest?.statusCode == 500)
                    {
                        
                        debugPrint("Error:\(json["msg"])")
                        self.view.makeToast(json["msg"].stringValue)
                    }
            },
                                                    failure:
                {
                    _, _, error in
                    debugPrint("error:\(error)")
                    self.view.hideToastActivity()
            })
        }
        weatherCitiesFromDataBase = DataBaseHelper.getCities()
        weatherTable.reloadData()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first
        {
            let user_city = DataBaseHelper.getUserCity()
            if (user_city?.latitude == location.coordinate.latitude && user_city?.longitude == location.coordinate.longitude)
            {
                loadData()
            }
            else
            {
                let geoCoder = CLGeocoder()
                geoCoder.reverseGeocodeLocation(location, completionHandler:
                    {
                        placemarks, error -> Void in
                        // Place details
                        guard let placeMark = placemarks?.first else { return }
                        var cityName = ""
                        var countryName = ""
                        // City
                        if let city = placeMark.subAdministrativeArea {
                            debugPrint(city)
                            cityName = city
                        }
                        // Zip code
                        if let country = placeMark.isoCountryCode {
                            debugPrint(country)
                            countryName = country
                        }
                        if self.count == 0
                        {
                            DataBaseHelper.updateCityUser(name: cityName, country: countryName, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                            self.count = self.count + 1
                            self.loadData()
                        }
                })
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                showAlert("Please Allow the Location Permision to get weather of your city")
            case .authorizedAlways, .authorizedWhenInUse:
                print("locationEnabled")
            }
        } else {
            showAlert("Please Turn ON the location services on your device")
            print("locationDisabled")
        }
        manager.stopUpdatingLocation()
    }
    
    class func isLocationEnabled() -> (status: Bool, message: String) {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                return (false,"No access")
            case .authorizedAlways, .authorizedWhenInUse:
                return(true,"Access")
            }
        } else {
            return(false,"Turn On Location Services to Allow App to Determine Your Location")
        }
    }
    
    func showAlert(_ message:String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation Londres, Nueva York, Tokio
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - UITableView
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        var height:CGFloat = 0
        if tableView == weatherTable
        {
            height = 25
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        var height:CGFloat = 0
        if tableView == weatherTable
        {
            height = 70
        }
        return height
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var sections:Int = 0
        if tableView == weatherTable
        {
            sections = 1
        }
        return sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var rows:Int = 0
        if tableView == weatherTable
        {
            switch section
            {
            case 0:
                if let cities = weatherCitiesFromDataBase
                {
                    rows = cities.count
                }
                break
            default:
                break
            }
        }
        return rows
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 25))
        headerView.backgroundColor = UIColor.orange
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: view.frame.size.width, height: 25))
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 17)
        headerView.addSubview(label)
        if (section == 0) {
            label.text = "Cities"
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell:CityWeatherCell? = tableView.dequeueReusableCell(withIdentifier:"identifierCityWeatherCell") as? CityWeatherCell
        if cell == nil{
            tableView.register(UINib.init(nibName: "CityWeatherCell", bundle: nil), forCellReuseIdentifier: "identifierCityWeatherCell")
            let arrNib:Array = Bundle.main.loadNibNamed("CityWeatherCell",owner: self, options: nil)!
            cell = arrNib.first as? CityWeatherCell
        }
        if tableView == self.weatherTable
        {
            switch indexPath.section
            {
            case 0:
                let city = self.weatherCitiesFromDataBase![indexPath.row]
                cell!.name.text = city.name
                if temp == "CELSIUS"
                {
                    cell!.temperature.text = "\(ceil((city.temp_celsius*100)/100))°" // rounded
                }
                else
                {
                    cell!.temperature.text = "\(ceil((city.temp_fahrenheit*100)/100))°" // rounded
                }
                
                break
            default:
                break
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView == self.weatherTable
        {
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension UIColor {
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
}
