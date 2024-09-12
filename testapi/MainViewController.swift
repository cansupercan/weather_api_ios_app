//
//  MainViewController.swift
//  api
//
//  Created by imac 1682's MacBook Pro on 2024/9/11.
//

import UIKit

class MainViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pkvcity: UIPickerView!
    @IBOutlet weak var tbvsee: UITableView!
    
    var weatherDat:weatherData?
    
    let cities = ["臺北市", "新北市", "桃園市", "臺中市", "臺南市", "高雄市", "基隆市", "新竹市", "嘉義市", "苗栗縣", "彰化縣", "南投縣", "雲林縣", "嘉義縣", "屏東縣", "宜蘭縣", "花蓮縣", "台東縣", "澎湖縣", "金門縣", "連江縣"]
    var city = "臺北市"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pkvcity.delegate = self
        pkvcity.dataSource = self
        tableSet()
        callapi()
        // Do any additional setup after loading the view.
        pkvcity.selectRow(0, inComponent: 0, animated: false)
        pickerView(pkvcity, didSelectRow: 0, inComponent: 0)
        //tbvsee.reloadData()
    }
    func tableSet(){
        tbvsee.register(UINib(nibName: "TableViewCell", bundle: nil),
                        forCellReuseIdentifier: TableViewCell.identifier)
        tbvsee.delegate = self
        tbvsee.dataSource = self
        
    }
    // UIPickerViewDataSource - 設定 PickerView 有幾個區段
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // 只有一個區段
    }
    
    // UIPickerViewDataSource - 設定每個區段的行數
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count // 城市數量
    }
    
    // UIPickerViewDelegate - 設定每一行的顯示內容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cities[row] // 顯示城市名稱
    }
    
    // UIPickerViewDelegate - 當選擇某行時觸發
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        city = cities[row]
        print("選擇的城市是：\(city)")
        callapi()
        tbvsee.reloadData()
    }
    
    
    func callapi(){
        
        
        let requestURL = LegitimateURl(requestURL: "https://opendata.cwa.gov.tw/api/v1/rest/datastore/F-C0032-001?Authorization=CWA-A4AA97C5-E3C1-4BEB-B730-688876F81863&locationName=" + city)
        
        URLSession.shared.dataTask(with: requestURL){[self]
            (data,response,error) in
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let response = response {
                print(response as! HTTPURLResponse)
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                do{
                    self.weatherDat = try decoder.decode(weatherData.self, from: data)
                    DispatchQueue.main.async { //在主執行序執行
                        self.tbvsee.reloadData() // 確保在主執行緒更新 UI
                    }
                    print(weatherDat ?? 0)
                }catch{
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    func LegitimateURl(requestURL: String) -> URL {
        let LegitimateURL = requestURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL.init(string: LegitimateURL!)
        
        return url!
    }
}
extension MainViewController: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    //更新畫面
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbvsee.dequeueReusableCell(withIdentifier: "TableViewCell",for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        // 設定文本
        if let weatherDat = weatherDat, weatherDat.records.location.count > 0 {
            let location = weatherDat.records.location[0] // 取第一個 location
            let weatherElements = location.weatherElement
            // 確保 weatherElement 有內容且 time 有內容
            if weatherElements.count > 0, weatherElements[0].time.count > indexPath.row {
                // 設定時間與雲層狀態
                let timeData = weatherElements[0].time[indexPath.row]
                let start = timeData.startTime
                let end = timeData.endTime
                let parameter = timeData.parameter.parameterName
                cell.latime.text = "\(start) ~ \(end)"
                cell.lawx.text = "\(parameter)"
                //設定下雨機率
                let second = location.weatherElement[1]
                let poptext = second.time[indexPath.row].parameter.parameterName
                cell.lapop.text = "\(poptext)%"
                //設定溫度區間
                let thard = location.weatherElement[2]
                let minT = thard.time[indexPath.row].parameter.parameterName
                let five = location.weatherElement[4]
                let maxT = five.time[indexPath.row].parameter.parameterName
                let maxmintext = "\(minT)~\(maxT)°C"
                cell.laminmanT.text = maxmintext
                //設定體感溫度
                let four = location.weatherElement[3]
                let temtext = four.time[indexPath.row].parameter.parameterName
                cell.laci.text = temtext
            }
        }
        return cell
    }
    
}
