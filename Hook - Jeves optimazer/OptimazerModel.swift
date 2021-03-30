//
//  OptimazerModel.swift
//  Hook - Jeves optimazer
//
//  Created by Damian Mikołajczak on 30/03/2021.
//

import Foundation

struct HookJavesOptimazer {
    
    var optimizedFunction: Int
    let directionsBase: [Point]
    var step: Double
    let beta: Double
    let sigma: Double
    var argument: Point
    var foundedPoints: [Point]
    
    init(onDirectionBase base: [Point], forFunction function: Int, withStep step: Double, andBeta beta: Double, andAccuracy sigma: Double, andArgument x: Point, storedTo points: [Point] ) {
        self.optimizedFunction = function
        self.directionsBase = base
        self.step = step
        self.beta = beta
        self.sigma = sigma
        self.argument = x
        self.foundedPoints = points
    }
    
    func f(_ X: Point) -> Double{
        switch optimizedFunction {
        case 0:
            //Funkcja Himmemblau:
            return (X.x1*X.x1+X.x2-11)*(X.x1*X.x1+X.x2-11)+(X.x1+X.x2*X.x2-7)*(X.x1+X.x2*X.x2-7)
        case 1:
            //Funkcja paraloidy:
            return 1+(X.x1+1)*(X.x1+1)+X.x2*X.x2
        default:
            //Funkcja z zajęć
            return 2*(X.x1*X.x1)+(X.x2*X.x2)+(X.x1*X.x2)
        }
    }

    func searchPoint(currentBasePoint: Point) -> Point?{
        //statusBox.insertText("Szukam punktu\n")
        var basePoint = currentBasePoint
        var newBasePointFounded: Bool = false
        var nextPoint = Point(0,0)
        var currentMinimalValue = f(basePoint)
        var valueInNextPoint = Double()
        
        for k in 0..<(directionsBase.count) {
            nextPoint = basePoint + step * directionsBase[k]
            valueInNextPoint = f(nextPoint)
            if valueInNextPoint < currentMinimalValue {
                currentMinimalValue = valueInNextPoint
                basePoint = nextPoint
                newBasePointFounded = true
            } else {
                nextPoint = basePoint - step * directionsBase[k]
                valueInNextPoint = f(nextPoint)
                if valueInNextPoint < currentMinimalValue {
                    currentMinimalValue = valueInNextPoint
                    basePoint = nextPoint
                    newBasePointFounded = true
                }
            }
        }
        return newBasePointFounded ? basePoint : nil
    }

    mutating func startOptimazer() -> (Point, Double, [Point]) {
        //Etap roboczy: statusBox.insertText("")
        //statusBox.insertText("Wartość początkowa: \(f(x))\n\n")
        var iteration: Int = 0
        var direction = Point(0,0)
        foundedPoints.removeAll()
        foundedPoints.append(argument)         //Dodanie punktu startowego
        while ((step > sigma)){
            if let xB = searchPoint(currentBasePoint: argument), f(xB) < f(argument){
                direction = (xB - argument)
                argument = argument + direction
                foundedPoints.append(argument)
                //statusBox.insertText("Aktualny punkt: \(x)\n")
                //statusBox.insertText("Wartość w aktualnym punkcie: \(f(x)) \n\n")
            } else {
                argument = argument - direction
                //statusBox.insertText("Cofam się do punktu: \(x)\n")
                //statusBox.insertText("Zmniejszam krok\n\n")
                direction.x1 = 0
                direction.x2 = 0
                step = step * beta
            }
            iteration += 1
        }
        return (argument, f(argument), foundedPoints)
    }
}
