//
//  OptimazerModel.swift
//  Hook - Jeves optimazer
//
//  Created by Damian Mikołajczak on 30/03/2021.
//

import Foundation
import Cocoa

struct HookJavesOptimazer {
    
    var optimizedFunction: Int
    let directionsBase: [Point]
    var step: Double
    let beta: Double
    let sigma: Double
    var argument: Point
    var foundedPoints: [Point]
    var statusBox: NSView!
    
    init(onDirectionBase base: [Point], forFunction function: Int, withStep step: Double, andBeta beta: Double, andAccuracy sigma: Double, andArgument x: Point, storedTo points: [Point], in statusBox: NSView ) {
        self.optimizedFunction = function
        self.directionsBase = base
        self.step = step
        self.beta = beta
        self.sigma = sigma
        self.argument = x
        self.foundedPoints = points
        self.statusBox = statusBox
    }
    
    func f(_ X: Point) -> Double{
        switch optimizedFunction {
        case 0:
            //Funkcja Himmemblaua:
            return (X.x1*X.x1+X.x2-11)*(X.x1*X.x1+X.x2-11)+(X.x1+X.x2*X.x2-7)*(X.x1+X.x2*X.x2-7)
        case 1:
            //Funkcja paraloidy:
            return 1+(X.x1+1)*(X.x1+1)+X.x2*X.x2
        case 2:
            //Funkcja Matyasa:
            return 0.26*(X.x1*X.x1+X.x2*X.x2)-0.48*X.x1*X.x2
        case 3:
            //Funkcja Ackleya:
            return -20*exp(-0.2*sqrt(0.5*(X.x1*X.x1+X.x2*X.x2)))-exp(0.5*(cos(2*Double.pi*X.x1)+cos(2*Double.pi*X.x2)))+exp(1)+20
        case 4:
            //Funkcja Cross-in-tray:
            return -0.0001*pow((abs(sin(X.x1)*sin(X.x2)*exp(abs(100-(sqrt(X.x1*X.x1+X.x2*X.x2))/Double.pi)))+1), 0.1)
        default:
            //Funkcja z zajęć
            return 2*(X.x1*X.x1)+(X.x2*X.x2)+(X.x1*X.x2)
        }
    }

    // This function is used to search for the next base point. First of all, a log is added that the program started searching.
    func searchPoint(currentBasePoint: Point) -> Point?{
        statusBox.insertText("Searching for new point\n")
        // At the begining we reinitialaze the local parameters.
        var basePoint = currentBasePoint
        var newBasePointFounded: Bool = false
        var nextPoint = Point(0,0)
        var currentMinimalValue = f(basePoint)
        var valueInNextPoint = Double()
        
        /*
         * Using a for loop the program goes through all directions in the directions base array
         * Then we get a point in the given direction and calculate the functions value.
         */
        for k in 0..<(directionsBase.count) {
            nextPoint = basePoint + step * directionsBase[k]
            valueInNextPoint = f(nextPoint)
            // If the value in the new point is lower then in the previous point then we store this point as the new base point as set "true" to the flag that says if a new base point was found.
            if valueInNextPoint < currentMinimalValue {
                currentMinimalValue = valueInNextPoint
                basePoint = nextPoint
                newBasePointFounded = true
            // If the value is bigger that in the previous point then we change the direction and repeat the above described steps.
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
        
        /*
         * After going through the whole directions base we return the new base poin (if one was founded).
         * If no point was founded, then this function returns a nil.
         */
        
        return newBasePointFounded ? basePoint : nil
    }

    // This function implements the main loop of the Hook-Jeves algorithm. First of all we print a log with the start value.
    mutating func startOptimazer() -> (Point, Double, [Point]) {
        statusBox.insertText("Start value: \(f(argument))\n\n")
        /*
         * Ad the begining the main aprameters are initialized with default values.
         * The foundedPoint table is used to print the path in the graph view.
         * Because the user can run multiple search request during on run, the described table should be cleared.
         */
        var iteration: Int = 0
        var direction = Point(0,0)
        foundedPoints.removeAll()
        foundedPoints.append(argument)
        // The algorithm runs as long as the methods step is bigger then the required accuracy.
        while ((step > sigma)){
            /*
             * If a new base point was founded (the returned value is different from 'nil') we go to that point by adding the calculated direction.
             * At this point we can specify an important paramterer - the work step can be bigger than the sampling step by mulitplying the added direction.
             * And at the end we append the new point to foundedPoints array and print some logs.
             */
            if let xB = searchPoint(currentBasePoint: argument), f(xB) < f(argument){
                direction = (xB - argument)
                argument = argument + direction
                foundedPoints.append(argument)
                statusBox.insertText("Current point: \(argument)\n")
                statusBox.insertText("Value in the current point: \(f(argument)) \n\n")
            /*
             * If no new base point was founded then we go back (by going in the oposite direction stored earlier).
             * To stop the algorithm from going more then one step back and force it instead to decrease the step or stop the program in the best point, the direction must be equal to zero!
             * The last part is to decrease the step by the given factor.
             */
            } else {
                argument = argument - direction
                statusBox.insertText("Move back to point: \(argument)\n")
                statusBox.insertText("Decreasing step\n\n")
                direction.x1 = 0
                direction.x2 = 0
                step = step * beta
            }
            iteration += 1
        }
        
        // When the end condition was reached, the function return the founded solution, which consists of the founded best point, the optimized functions value in this point and the path stored in the foundedPoints array.
        statusBox.insertText("Search is complete.\nA solution was finded in point: \(argument) with a value of f(X) = \(f(argument))\n")
        statusBox.insertText("The task took \(iteration) iterations.")
        return (argument, f(argument), foundedPoints)
    }
}



