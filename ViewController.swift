//
//  ViewController.swift
//  Demo14 GlobalCovid19APPWithAPI
//
//  Created by LukeLin on 2022/2/16.
//

import UIKit
import SDWebImage
import Charts

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var Searchtextfield: UITextField!
    @IBOutlet var flagImage: UIImageView!
    @IBOutlet var countrynameLabel: UILabel!
    @IBOutlet var statusView: [UIView]! {
        didSet {
            for i in 0...statusView.count - 1 {
                statusView[i].layer.cornerRadius = 15
                statusView[i].layer.masksToBounds = true
                 }
               }
            }
    @IBOutlet var todaycasesLabel: UILabel!
    @IBOutlet var totalcasesLabel: UILabel!
    @IBOutlet var todaydeathsLabel: UILabel!
    @IBOutlet var totaldeathsLabel: UILabel!
    @IBOutlet var lineChartView: LineChartView!
    
    var globalcovid19datamanager = GlobalCovid19DataManager()
    var specificcountrycovid19datamanager = SpecificCountryCovid19DataManager()
    var timelinedatamanager = TimeLineDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        flagImage.image = UIImage(named: "earth")
        countrynameLabel.text = "Global"
        
        Searchtextfield.delegate = self
        globalcovid19datamanager.delegate = self
        globalcovid19datamanager.fetchData()
        specificcountrycovid19datamanager.delegate = self
        timelinedatamanager.delegate = self
        
        
        lineChartView = LineChartView()
        lineChartView.frame = CGRect(x: 25, y: 630, width: self.view.bounds.width - 50,
                                         height: 151)
        lineChartView.layer.cornerRadius = 15
        lineChartView.layer.masksToBounds = true
        lineChartView.backgroundColor = .systemGray4
        lineChartView.isHidden = true
        
        self.view.addSubview(lineChartView)
        
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        Searchtextfield.endEditing(true)
        return true
        
    }

    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if Searchtextfield.text != "" {
            return true
        } else {
            return false
        }
    }
    
    //編輯後的動作
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        lineChartView.isHidden = false
        
        if let country = Searchtextfield.text {
            
            specificcountrycovid19datamanager.fetchData(country)
            
            timelinedatamanager.fetchTimeLineData(country)
            
        }
        
        Searchtextfield.text = ""
        
    }
    
    @IBAction func searchButtonpress (_ sender: UIButton) {
        
        Searchtextfield.endEditing(true)
    }

}


extension ViewController: GlobalCovid19DataManagerDelegate {
    
    func updateData(covid: GlobalCovid19Model) {
        DispatchQueue.main.async {
            
            self.todaycasesLabel.text = String(covid.todaycases)
            self.totalcasesLabel.text = String(covid.totalcases)
            self.todaydeathsLabel.text = String(covid.todaydeaths)
            self.totaldeathsLabel.text = String(covid.totaldeaths)
            
        }
    }
}


extension ViewController: SpecificCovid19DataManagerDelegate {
    
    func updateData(covid: SpecificCountryCovid19Model) {
        DispatchQueue.main.async {
            
            self.todaycasesLabel.text = String(covid.todaycases)
            self.totalcasesLabel.text = String(covid.totalcases)
            self.todaydeathsLabel.text = String(covid.todaydeaths)
            self.totaldeathsLabel.text = String(covid.totaldeaths)
            self.countrynameLabel.text = covid.id
            self.flagImage.sd_setImage(with: URL(string: covid.countryflag), completed: nil)
            
        }
    }
}

extension ViewController: TimeLineDataManagerDelegate {
    
    //更新chart
    func updateGraph(time: TimeLineModel) {
        
        //建立chart資料陣列
        var lineChartEntry = [ChartDataEntry]()
        
        //輸入chart資料
        for i in 0..<time.cases.count {
            
            let value = ChartDataEntry(x: Double(i+1), y: Double(time.cases[i]))
            lineChartEntry.append(value)
            
        }
        
        let line = LineChartDataSet(entries: lineChartEntry)
        line.colors = [NSUIColor.init(displayP3Red: 0.8928110003, green: 0.1367270052, blue: 0.2764109969, alpha: 1)]
        line.setCircleColor(NSUIColor.init(displayP3Red: 0.8928110003, green: 0.1367270052, blue: 0.2764109969, alpha: 1))
        line.circleHoleColor = UIColor.white
        line.circleRadius = 1.0
        
        
        let gradientColors = [UIColor.init(displayP3Red: 0.8928110003, green: 0.1367270052, blue: 0.2764109969, alpha: 1).cgColor, UIColor.clear.cgColor] as CFArray
        let colorLocation: [CGFloat] = [1.0, 0.0]
        guard let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocation) else {
            print("gradient eroor")
            return
        }
        line.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
        line.drawFilledEnabled = true
                
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.drawAxisLineEnabled = false
        lineChartView.legend.enabled = false
        lineChartView.rightAxis.enabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.drawLabelsEnabled = false
        lineChartView.leftAxis.drawAxisLineEnabled = false
        
        let data = LineChartData()
        data.addDataSet(line)
    
        DispatchQueue.main.async {
                   print("Graph should change by now!!!")
                   //self.lineChart.backgroundColor = UIColor.white
                   self.lineChartView.data = data
                   self.lineChartView.chartDescription?.text = "Last 7 Days Data"
               
        }
    
}
}
