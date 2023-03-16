//
//  Graph1.swift
//  CalorieFriend
//
//  Created by Cole Perez on 2/6/23.
//

import Foundation
import Firebase
import SwiftUI
import Charts

let dateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
}()
let database = Database.database().reference()


func getLastSevenDays() ->[String] {
    var dates: [String] = []
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd"
    for i in -7 ... -1{
        dates.append(df.string(from: Calendar.current.date(byAdding: .day, value: i, to: Date())!))
    }
    return dates;

}
func getFromDatabse() async throws -> [(String, Int)] {
    var scoresForLastSeven: [(String, Int)] = []
    let dates: [String] = getLastSevenDays()
    for date in dates {
        let data = try await database.child(date).getData();
        if let value = data.value as? [String: Any] {
            let caloriesConsumedStr = value["Calories"] as! String
            let goalStr = value["Goal"] as! String
            if caloriesConsumedStr == "0" || goalStr == "0"{
                scoresForLastSeven.append((date,0));
                continue;
            }
            let caloriesConsumedDouble = Double(caloriesConsumedStr) ?? 0.0
            let goalDouble = Double(goalStr) ?? 1.0
            let score = Int(round(caloriesConsumedDouble/goalDouble * 100))
            print(date, caloriesConsumedDouble, goalDouble, score)

            scoresForLastSeven.append((date, score))
        } else {
            scoresForLastSeven.append((date,0))
            continue;
        }
    }
    return scoresForLastSeven
}

typealias Model = (date: Date, views: Int)
struct Graph1: View {
    @State public var data:[Model]
    var body: some View {
        
        if #available(iOS 16.0, *){
            Chart{
                RuleMark(y:.value("Goal", 100))
                    .foregroundStyle(Color.mint)
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                    .annotation(alignment: .leading) {
                        Text("Goal")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                ForEach(data, id: \.date) { dataPoint in
                    BarMark(
                        x: .value("Day", dataPoint.date, unit: .weekday),
                        y: .value("Score", dataPoint.views)
                    )
                    .foregroundStyle(Color.pink.gradient)
                    
                    
                }
            }
            .task{
                do{
                    let scores = try await getFromDatabse()
                    data = scores.map {(date: dateFormatter.date(from: $0.0)!, views: $0.1) }
                    
                    let y = print("IN GRAPH")
                    let x = print(scores)
                }
                catch{
                    print("Failed")
                }
            }
            .chartXAxisLabel("Day", position:.bottom, alignment: .center)
            .chartYAxisLabel("Score", position: .trailing, alignment: .center)
            .chartYScale(domain: 0...105)
            .chartXAxis {
                AxisMarks(values:data.map{$0.date}){date in
                    AxisTick()
                    AxisValueLabel(format:.dateTime.day())
                }
            }
            .chartYAxis {
                AxisMarks()
            }
        }
    }
}

