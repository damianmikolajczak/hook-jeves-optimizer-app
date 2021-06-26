//
//  GridCell.swift
//  Hook - Jeves optimazer
//
//  Created by Damian Mikołajczak on 10/04/2021.
//

import Cocoa

struct GridCell {
    let c1: (point: Point, value: Double)
    let c2: (point: Point, value: Double)
    let c3: (point: Point, value: Double)
    let c4: (point: Point, value: Double)
    var corners = Array<(Point, Double)>()
    
    init(_ c1: (Point, Double), _ c2: (Point, Double), _ c3: (Point, Double), _ c4: (Point, Double)) {
        self.c1 = c1
        self.c2 = c2
        self.c3 = c3
        self.c4 = c4
        corners.append(c1)
        corners.append(c2)
        corners.append(c3)
        corners.append(c4)
    }
    
    func lookUp(potential: Double) -> Double {
            var codedIso:Double = 0
            for index in 0...3 {
                if corners[index].1 >= potential {
                    codedIso += pow(2, Double(index))
                }
            }
            return codedIso
    }
}








