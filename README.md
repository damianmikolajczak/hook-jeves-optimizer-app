# Hook-Jeves optimizer app
## Introduction
An macOS app made for my optimization algorithms course. It handles a sort of specified functions looking for the global minimum of them. It also displays the search patch in the cartesian system and allows to specify the algorithms parameters.
The result graph itself is coloured using a gradient based on the function values - there are also some counted isolines.

## Technologies
The optimizer app was written in Swift using Cocoa framework and Xcode. There are only two view controllers made in storyboard - the main view and the result graph view.
The second one was implement using CoreGraphics to present the function with isolines and a gradient.

## Screenshots
In the main view the user can specify the optimization parameters such as the method step, step decrease factor and the required accuracy.
The next step is to give a fixed start point or choose one totaly random. By default the search area is limited to D = {x,y : x∈(-5, 5), y∈(-5, 5)}.
The last thing to do is to choose the optimized function from a fixed list - this can be extended easily in the code. 
Hitting the "Search" labeled button will print the result in the "Founded solution" section.
There will be a log list in the right area appear which shows all of the done steps.

<img src="Hook%20-%20Jeves%20optimazer/Images/startPoint.png" width="330"> <img src="Hook%20-%20Jeves%20optimazer/Images/startPoint.png" width="330"> <img src="Hook%20-%20Jeves%20optimazer/Images/startPoint.png" width="330">

By clicking the "Show result" button, a view with a cartesian system will appear.
The user can then see the optimized function itself together with the path the point was traveled.

<img src="Hook%20-%20Jeves%20optimazer/Images/graph.png" width="500">

## Algorithm implementation

The implemented algorithm is shown at the picture below

<img src="Hook%20-%20Jeves%20optimazer/Images/Algorithm.png" width="500">

The program implementation was defined in the OptimizerModel.Swift file.

```swift
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
```
