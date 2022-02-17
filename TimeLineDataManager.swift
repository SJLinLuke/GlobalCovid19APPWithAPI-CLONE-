//
//  TimeLineDataManager.swift
//  Demo14 GlobalCovid19APPWithAPI
//
//  Created by LukeLin on 2022/2/16.
//

import Foundation

protocol TimeLineDataManagerDelegate {
    
    func updateGraph(time: TimeLineModel)
    
}

struct TimeLineDataManager {
    
    private let baseURL = "https://corona.lmao.ninja/v3/covid-19/historical"

    var delegate: TimeLineDataManagerDelegate?
    
    func fetchTimeLineData(_ country: String) {
        let timeURLString = "\(baseURL)/\(country)?lastdays=8"
        print(timeURLString)
        performTimeLineDataRequest(with: timeURLString)
    }
    
    func performTimeLineDataRequest(with urlString: String) {
        
        if let timeURL = URL(string: urlString) {
            
            let timeSession = URLSession(configuration: .default)
            
            let timeTask = timeSession.dataTask(with: timeURL) { data, response, error in
                if error != nil {
                    print(error)
                    return
                }
                
                if let safeData = data {
                    if let time = self.parseTimeJSON(safeData) {
                        delegate?.updateGraph(time: time)
                        print("Should update Graph now")
                    }
                }
            }
            timeTask.resume()
    }
}

//分析並儲存每天的日期和病例數

func parseTimeJSON(_ covidData: Data) -> TimeLineModel? {
    
    let decoder  = JSONDecoder()
    
    //利用do...catch來測試func是否有誤
    do {
        let decodeData = try decoder.decode(TimeLineData.self, from: covidData)
        let dataDict: [String : Int] = decodeData.timeline.cases
        var dataArray = Array(dataDict.values)
        var dayArray = Array(dataDict.keys)
        dataArray.sort()
        dataArray.removeFirst()
        dataArray.sort()
        var afterArray: [Int] = []
        for i in 0..<dataArray.count {
            if i != 0 {
                let result = dataArray[i] - dataArray [i - 1]
                afterArray.append(result)
            }
        }
        print(dataDict)
        print(dataArray)
        print(dayArray)
        print(afterArray)
        let timeData = TimeLineModel(cases: afterArray)
        return timeData
    } catch {
        print(error)
        return nil
        }
    }
}
