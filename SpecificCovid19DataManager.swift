//
//  SpecificCovid19DataManager.swift
//  Demo14 GlobalCovid19APPWithAPI
//
//  Created by LukeLin on 2022/2/16.
//

import Foundation

protocol SpecificCovid19DataManagerDelegate {
    
    func updateData(covid: SpecificCountryCovid19Model)
    
}

struct SpecificCountryCovid19DataManager {
    
    private let baseURL = "https://corona.lmao.ninja/v3/covid-19/countries"
    
    var delegate: SpecificCovid19DataManagerDelegate?
    
    func fetchData(_ country: String) {
        
        let urlString = "\(baseURL)/\(country)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    if let covid = self.parseJson(safeData) {
                        delegate?.updateData(covid: covid)
                        print("\(covid.country) is the country that got passed in")
                        print("\(covid.todaycases) people got infected today")
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJson(_ SpecificCountryData: Data) -> SpecificCountryCovid19Model? {
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(SpecificCountryCovid19Data.self, from: SpecificCountryData)
            
            let country = decodedData.country
            let todaycases = decodedData.todayCases
            let totalcases = decodedData.cases
            let todaydeaths = decodedData.todayDeaths
            let totaldeaths = decodedData.deaths
            let countryid = decodedData.countryInfo.iso2
            let countryflag = decodedData.countryInfo.flag
            
            let covid = SpecificCountryCovid19Model(country: country, todaycases: todaycases, totalcases: totalcases, todaydeaths: todaydeaths, totaldeaths: totaldeaths, id: countryid, countryflag: countryflag)
            return covid
        } catch {
            print(error)
            return nil
        }
    }
}
