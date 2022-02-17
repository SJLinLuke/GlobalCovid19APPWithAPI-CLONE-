//
//  GlobalCovid19Data.swift
//  Demo14 GlobalCovid19APPWithAPI
//
//  Created by LukeLin on 2022/2/16.
//

import Foundation

struct GlobalCovid19Data: Decodable {
    
    let cases: Int
    let todayCases: Int
    let deaths: Int
    let todayDeaths: Int
    
}
