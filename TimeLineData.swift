//
//  TimeLineData.swift
//  Demo14 GlobalCovid19APPWithAPI
//
//  Created by LukeLin on 2022/2/16.
//

import Foundation

struct TimeLineData: Decodable {
    
    let timeline: CovidData
    
}

struct CovidData: Decodable {

    let cases: [String : Int]
    
}


