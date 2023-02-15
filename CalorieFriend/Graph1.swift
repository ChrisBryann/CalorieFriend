//
//  Graph1.swift
//  CalorieFriend
//
//  Created by Cole Perez on 2/6/23.
//

import Foundation

import SwiftUI
import Charts

let dateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
}()

typealias Model = (date: Date, views: Int)

let data: [Model] = [
    ("2022-06-02",647),
    ("2022-06-03",482),
    ("2022-06-04",424),
    ("2022-06-05",379),
    ("2022-06-06",324),
    ("2022-06-07",1278),
    ("2022-06-08",746),
    ("2022-06-09",503),
    ("2022-06-10",380),
    ("2022-06-11",267),
    ("2022-06-12",330),
    ("2022-06-13",379),
    ("2022-06-14",1336),
    ("2022-06-15",887),
    ("2022-06-16",766),
    ("2022-06-17",456),
    ("2022-06-18",298),
    ("2022-06-19",317),
    ("2022-06-20",363),
    ("2022-06-21",969),
    ("2022-06-22",545),
    ("2022-06-23",448),
    ("2022-06-24",313),
    ("2022-06-25",287),
    ("2022-06-26",366),
    ("2022-06-27",362),
    ("2022-06-28",759),
    ("2022-06-29",490),
].map { (date: dateFormatter.date(from: $0.0)!, views: $0.1) }

let average = data.map(\.views).reduce(0.0) {
    return $0 + Double($1) / Double(data.count)
}
struct Graph1: View {
    var body: some View {
        if #available(iOS 16.0, *){
            Chart(data, id: \.date) { dataPoint in
                LineMark(
                    x: .value("Day", dataPoint.date),
                    y: .value("Views", dataPoint.views)
                )
                
                RuleMark(y: .value("Average", average))
                    .foregroundStyle(.red)
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel(format: .dateTime.day())
                }
            }
            .chartYAxis {
                AxisMarks(values: .stride(by: 250))
            }
        }
    }
}

