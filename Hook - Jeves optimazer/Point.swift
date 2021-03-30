//
//  Point.swift
//  Hook - Jeves optimazer
//
//  Created by Damian Mikołajczak on 29/03/2021.
//

import Foundation

struct Point: CustomStringConvertible {
    var description: String {
        return "(\(x1), \(x2))"
    }
    var x1: Double = 0
    var x2: Double = 0
    
    init(_ x1: Double, _ x2: Double) {
        self.x1 = x1
        self.x2 = x2
    }
    
    //Definicja operatorów na egzemplarzach struktury Point
    static func -(lhs: Point, rhs: Point) -> Point {
        let newPoint = Point(lhs.x1-rhs.x1, lhs.x2-rhs.x2)
        return newPoint
    }
    
    static func +(lhs: Point, rhs: Point) -> Point {
        let newPoint = Point(lhs.x1+rhs.x1, lhs.x2+rhs.x2)
        return newPoint
    }
    
    static func *(lhs: Double, rhs: Point) -> Point {
        let newPoint = Point(lhs*rhs.x1, lhs*rhs.x2)
        return newPoint
    }
    
    static func *(lhs: Point , rhs: Double) -> Point {
        let newPoint = Point(lhs.x1*rhs, lhs.x2*rhs)
        return newPoint
    }
}
