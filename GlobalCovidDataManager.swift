//
//  GlobalCovidDataManager.swift
//  Demo14 GlobalCovid19APPWithAPI
//
//  Created by LukeLin on 2022/2/16.
//

import Foundation

protocol GlobalCovid19DataManagerDelegate {
    
    func updateData(covid: GlobalCovid19Model)
    
}

struct GlobalCovid19DataManager {
    
    private let baseURL = "https://corona.lmao.ninja/v3/covid-19/all"
    
    var delegate: GlobalCovid19DataManagerDelegate?
    
    func fetchData() {
        
        let urlString = "https://corona.lmao.ninja/v3/covid-19/all"
        
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) {
                data, respone, error in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    if let covid = self.pareJson(safeData) {
                        delegate?.updateData(covid: covid)
                        print("Global got passed in")
                        print("\(covid.todaycases) people got infected today")
                    }
                }
            }
            task.resume()
        }
    }
    
    func pareJson(_ GlobalData: Data) -> GlobalCovid19Model? {
        
        let decoder = JSONDecoder()
        
        do {
            
            let decodeData = try decoder.decode(GlobalCovid19Data.self, from: GlobalData)
            let country = "GlobalStatus"
            let todayCases = decodeData.todayCases
            let totalCases = decodeData.cases
            let todayDeaths = decodeData.todayDeaths
            let totalDeaths = decodeData.deaths
            
            let covid = GlobalCovid19Model(countryname: country, todaycases: todayCases, totalcases: totalCases, todaydeaths: todayDeaths, totaldeaths: totalDeaths)
            return covid
        } catch {
            print(error)
            return nil
        }
    }
}
