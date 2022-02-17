//
//  SpecificCountryCovid19Data.swift
//  Demo14 GlobalCovid19APPWithAPI
//
//  Created by LukeLin on 2022/2/16.
//

import Foundation

struct SpecificCountryCovid19Data: Decodable {
    
    let country: String
    let cases: Int
    let todayCases: Int
    let deaths: Int
    let todayDeaths: Int
    let countryInfo: CountryInfo
    
}

struct CountryInfo: Decodable {
    let iso2: String
    let flag: String   
}
