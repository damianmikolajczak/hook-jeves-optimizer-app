//
//  GraphView.swift
//  Hook - Jeves optimazer
//
//  Created by Damian Mikołajczak on 29/03/2021.
//

import Cocoa

@IBDesignable

class GraphView: NSView {
    
    var points: [Point]?
    var optimizedFunction: Int?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        let background = NSColor.init(red: 180, green: 180, blue: 180, alpha: 0.1)
        background.setFill()
        bounds.fill()
        
        let context = NSGraphicsContext.current?.cgContext
        let xmin = CGPoint.init(x: 0, y: 500)
        let xmax = CGPoint.init(x: 1000, y: 500)
        let ymin = CGPoint.init(x: 500, y: 0)
        let ymax = CGPoint.init(x: 500, y: 1000)
        let origin = CGPoint.init(x: 500, y: 500)
        let color = CGColor.white
        let step = CGFloat(100)
        
        func f(_ X: Point) -> Double{
            switch optimizedFunction {
            case 0:
                //Funkcja Himmemblau:
                return (X.x1*X.x1+X.x2-11)*(X.x1*X.x1+X.x2-11)+(X.x1+X.x2*X.x2-7)*(X.x1+X.x2*X.x2-7)
            case 1:
                //Funkcja paraloidy:
                return 1+(X.x1+1)*(X.x1+1)+X.x2*X.x2
            case 2:
                return 0.26*(X.x1*X.x1+X.x2*X.x2)-0.48*X.x1*X.x2
            case 3:
                return -20*exp(-0.2*sqrt(0.5*(X.x1*X.x1+X.x2*X.x2)))-exp(0.5*(cos(2*Double.pi*X.x1)+cos(2*Double.pi*X.x2)))+exp(1)+20
            case 4:
                return -0.0001*pow((abs(sin(X.x1)*sin(X.x2)*exp(abs(100-(sqrt(X.x1*X.x1+X.x2*X.x2))/Double.pi)))+1), 0.1)
            default:
                //Funkcja z zajęć
                return 2*(X.x1*X.x1)+(X.x2*X.x2)+(X.x1*X.x2)
            }
        }


        let horizontalMinValue: Double = -5
        let horizontalMaxValue: Double = 5
        let verticalMinValue: Double = -5
        let verticalMaxValue: Double = 5
        let stepp:Double = 0.05
        var cells = Array<GridCell>()

        for x in stride(from: horizontalMinValue, to: horizontalMaxValue, by: stepp) {
            for y in stride(from: verticalMinValue, to: verticalMaxValue, by: stepp) {
                let firstPoint = Point(x, y)
                let firstValue = f(firstPoint)
                let secondPoint = Point(x+stepp, y)
                let secondValue = f(secondPoint)
                let thirdPoint = Point(x+stepp, y+stepp)
                let thirdValue = f(thirdPoint)
                let fourthPoint = Point(x, y+stepp)
                let fourthValue = f(fourthPoint)
                
                let gridCell = GridCell((firstPoint, firstValue), (secondPoint, secondValue), (thirdPoint, thirdValue), (fourthPoint, fourthValue))
                
                cells.append(gridCell)
            }
        }
        
        var pointArray = Array<(Point, Double)>()
        var pointValue = [Double]()
        for x in stride(from: horizontalMinValue, to: horizontalMaxValue, by: stepp) {
            for y in stride(from: verticalMinValue, to: verticalMaxValue, by: stepp) {
                let point = Point(x, y)
                let value = f(point)
                pointValue.append(value)
                pointArray.append((point, value))
                
                
            }
        }
        
        
        let max = pointValue.max()
        let min = pointValue.min()
        let range = max!-min!
        let potentialSet: [Double] = [(range*0/1024)+min!, (range*1/1024)+min!, (range*2/1024)+min!, (range*4/1024)+min!, (range*8/1024)+min!, (range*16/1024)+min!, (range*32/1024)+min!, (range*64/1024)+min!, (range*128/1024)+min!, (range*256/1024)+min!, (range*512/1024)+min!, (range*1024/1024)+min!]
        
        
        
        if max != nil {
            drawPixels(minValue: min!, maxValue: max!, data: pointArray, context: context)
        }
        
        for potential in potentialSet {
            drawIsolines(grid: cells, context: context, potential: potential)
        }
        
        drawCartesianLines(inContext: context!, origin: origin, xmin: xmin, xmax: xmax, ymin: ymin, ymax: ymax, withColor: color)
        drawHelpLines(inContext: context!, origin: origin, xmin: xmin, xmax: xmax, ymin: ymin, ymax: ymax, withColor: color , step: step)
        
        if let data = points {
            drawPoints(data: data, context: context)
        }
        
        
        
        
        
        
        
        
        
    }
}

extension GraphView {
    
    func drawPixels(minValue: Double, maxValue: Double, data: [(Point, Double)], context: CGContext?) {
        let range = maxValue-minValue
        for cell in data {
            let more = CGFloat((cell.1-minValue) / range)
            let less = 1-more
            let color = CGColor(srgbRed: more, green: less, blue: 1, alpha: 1)
            context!.setFillColor(color)
            context!.fill(CGRect(x: 500+100*cell.0.x1, y: 500+100*cell.0.x2, width: 5, height: 5))
        }
        print("działa")
    }
    
    
    func drawCartesianLines(inContext context: CGContext, origin: CGPoint, xmin: CGPoint, xmax: CGPoint, ymin: CGPoint, ymax: CGPoint, withColor color: CGColor) {
        let path = CGMutablePath()
        
        path.move(to: origin)
        path.addLine(to: xmin)
        path.move(to: origin)
        path.addLine(to: xmax)
        path.move(to: origin)
        path.addLine(to: ymin)
        path.move(to: origin)
        path.addLine(to: ymax)
        
        context.setLineWidth(CGFloat(1.0))
        context.setStrokeColor(color)
        context.addPath(path)
        context.drawPath(using: .stroke)
    }
    
    func drawHelpLines (inContext context: CGContext, origin: CGPoint, xmin: CGPoint, xmax: CGPoint, ymin: CGPoint, ymax: CGPoint, withColor color: CGColor, step: CGFloat) {
        let path = CGMutablePath()
        var nextPoint = CGPoint(x: xmin.x, y: ymin.y)
        
        for k in 0...10 {
            let i = CGFloat(k)
            nextPoint = CGPoint(x: i*step+xmin.x, y: ymax.y)
            path.move(to: nextPoint)
            path.addLine(to: CGPoint(x: nextPoint.x, y: ymin.y))
        }
        
        nextPoint = CGPoint(x: xmin.x, y: ymin.y)
        
        for k in 0...10 {
            let i = CGFloat(k)
            nextPoint = CGPoint(x: xmin.x, y: i*step+ymin.y)
            path.move(to: nextPoint)
            path.addLine(to: CGPoint(x: xmax.x, y: nextPoint.y))
        }
        
        context.setLineWidth(CGFloat(0.25))
        context.setStrokeColor(color)
        context.addPath(path)
        context.drawPath(using: .stroke)
        
    }
    
    func drawPoints(data: [Point], context: CGContext?) {
        var color = CGColor.init(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
        let path = CGMutablePath()
        let startPoint = CGPoint(x: 500+100*data[0].x1, y: 500+100*data[0].x2)
        
        //Rysuj początkowy:
        context!.setFillColor(color)
        context!.fill(CGRect(x: startPoint.x, y: startPoint.y, width: 2, height: 2))
        
        //Rysuje punkty:
        
        path.move(to: startPoint)
        for index in 0..<(data.count) {
            let nextPoint = CGPoint(x: 500+100*data[index].x1, y: 500+100*data[index].x2)
            print(nextPoint)
            path.addLine(to: nextPoint)
            context!.fill(CGRect(x: nextPoint.x, y: nextPoint.y, width: 2, height: 2))
        }
        
        context!.setLineWidth(CGFloat(0.5))
        context!.setStrokeColor(color)
        context!.addPath(path)
        context!.drawPath(using: .stroke)
    }
    
    func drawIsolines(grid: [GridCell], context: CGContext?, potential: Double) {
        let color = CGColor.init(red: 1, green: 1, blue: 1, alpha: 0.5)
        let path = CGMutablePath()
        let step: CGFloat = 0.025*100
        
        for cell in grid {
            let basePoint = CGPoint(x: 500+100*cell.c1.point.x1, y: 500+100*cell.c1.point.x2)
            
            var firstStartPoint: CGPoint
            var firstEndPoint: CGPoint
            var secondStartPoint: CGPoint
            var secondEndPoint: CGPoint
            
            
            switch cell.lookUp(potential: potential) {
            case 0:
                firstStartPoint = CGPoint(x: basePoint.x, y: basePoint.y)
                firstEndPoint = CGPoint(x: basePoint.x, y: basePoint.y)
                secondStartPoint = CGPoint(x: basePoint.x, y: basePoint.y)
                secondEndPoint = CGPoint(x: basePoint.x, y: basePoint.y)
            case 1:
                firstStartPoint = CGPoint(x: basePoint.x, y: basePoint.y+step)
                firstEndPoint = CGPoint(x: basePoint.x+step, y: basePoint.y)
                secondStartPoint = CGPoint(x: basePoint.x, y: basePoint.y+step)
                secondEndPoint = CGPoint(x: basePoint.x+step, y: basePoint.y)
            case 2:
                firstStartPoint = CGPoint(x: basePoint.x+step, y: basePoint.y)
                firstEndPoint = CGPoint(x: basePoint.x+step*2, y: basePoint.y+step)
                secondStartPoint = CGPoint(x: basePoint.x+step, y: basePoint.y)
                secondEndPoint = CGPoint(x: basePoint.x+step*2, y: basePoint.y+step)
            case 3:
                firstStartPoint = CGPoint(x: basePoint.x, y: basePoint.y+step)
                firstEndPoint = CGPoint(x: basePoint.x+step*2, y: basePoint.y+step)
                secondStartPoint = CGPoint(x: basePoint.x, y: basePoint.y+step)
                secondEndPoint = CGPoint(x: basePoint.x+step*2, y: basePoint.y+step)
            case 4:
                firstStartPoint = CGPoint(x: basePoint.x+step, y: basePoint.y+step*2)
                firstEndPoint = CGPoint(x: basePoint.x+step*2, y: basePoint.y+step)
                secondStartPoint = CGPoint(x: basePoint.x+step, y: basePoint.y+step*2)
                secondEndPoint = CGPoint(x: basePoint.x+step*2, y: basePoint.y+step)
            case 5:
                firstStartPoint = CGPoint(x: basePoint.x, y: basePoint.y+step)
                firstEndPoint = CGPoint(x: basePoint.x+step, y: basePoint.y+step*2)
                secondStartPoint = CGPoint(x: basePoint.x+step, y: basePoint.y)
                secondEndPoint = CGPoint(x: basePoint.x+step*2, y: basePoint.y+step)
            case 6:
                firstStartPoint = CGPoint(x: basePoint.x+step, y: basePoint.y)
                firstEndPoint = CGPoint(x: basePoint.x+step, y: basePoint.y+step*2)
                secondStartPoint = CGPoint(x: basePoint.x+step, y: basePoint.y)
                secondEndPoint = CGPoint(x: basePoint.x+step, y: basePoint.y+step*2)
            case 7:
                firstStartPoint = CGPoint(x: basePoint.x, y: basePoint.y+step)
                firstEndPoint = CGPoint(x: basePoint.x+step, y: basePoint.y+step*2)
                secondStartPoint = CGPoint(x: basePoint.x, y: basePoint.y+step)
                secondEndPoint = CGPoint(x: basePoint.x+step, y: basePoint.y+step*2)
            case 8:
                firstStartPoint = CGPoint(x: basePoint.x, y: basePoint.y+step)
                firstEndPoint = CGPoint(x: basePoint.x+step, y: basePoint.y+step*2)
                secondStartPoint = CGPoint(x: basePoint.x, y: basePoint.y+step)
                secondEndPoint = CGPoint(x: basePoint.x+step, y: basePoint.y+step*2)
            case 9:
                firstStartPoint = CGPoint(x: basePoint.x+step, y: basePoint.y)
                firstEndPoint = CGPoint(x: basePoint.x+step, y: basePoint.y+step*2)
                secondStartPoint = CGPoint(x: basePoint.x+step, y: basePoint.y)
                secondEndPoint = CGPoint(x: basePoint.x+step, y: basePoint.y+step*2)
            case 10:
                firstStartPoint = CGPoint(x: basePoint.x, y: basePoint.y+step)
                firstEndPoint = CGPoint(x: basePoint.x+step, y: basePoint.y)
                secondStartPoint = CGPoint(x: basePoint.x+step, y: basePoint.y+step*2)
                secondEndPoint = CGPoint(x: basePoint.x+step*2, y: basePoint.y+step)
            case 11:
                firstStartPoint = CGPoint(x: basePoint.x+step, y: basePoint.y+step*2)
                firstEndPoint = CGPoint(x: basePoint.x+step*2, y: basePoint.y+step)
                secondStartPoint = CGPoint(x: basePoint.x+step, y: basePoint.y+step*2)
                secondEndPoint = CGPoint(x: basePoint.x+step*2, y: basePoint.y+step)
            case 12:
                firstStartPoint = CGPoint(x: basePoint.x, y: basePoint.y+step)
                firstEndPoint = CGPoint(x: basePoint.x+step*2, y: basePoint.y+step)
                secondStartPoint = CGPoint(x: basePoint.x, y: basePoint.y+step)
                secondEndPoint = CGPoint(x: basePoint.x+step*2, y: basePoint.y+step)
            case 13:
                firstStartPoint = CGPoint(x: basePoint.x+step, y: basePoint.y)
                firstEndPoint = CGPoint(x: basePoint.x+step*2, y: basePoint.y+step)
                secondStartPoint = CGPoint(x: basePoint.x+step, y: basePoint.y)
                secondEndPoint = CGPoint(x: basePoint.x+step*2, y: basePoint.y+step)
            case 14:
                firstStartPoint = CGPoint(x: basePoint.x, y: basePoint.y+step)
                firstEndPoint = CGPoint(x: basePoint.x+step, y: basePoint.y)
                secondStartPoint = CGPoint(x: basePoint.x, y: basePoint.y+step)
                secondEndPoint = CGPoint(x: basePoint.x+step, y: basePoint.y)
            case 15:
                firstStartPoint = CGPoint(x: basePoint.x, y: basePoint.y)
                firstEndPoint = CGPoint(x: basePoint.x, y: basePoint.y)
                secondStartPoint = CGPoint(x: basePoint.x, y: basePoint.y)
                secondEndPoint = CGPoint(x: basePoint.x, y: basePoint.y)
            default:
                return
            }
            
            path.move(to: firstStartPoint)
            path.addLine(to: firstEndPoint)
            path.move(to: secondStartPoint)
            path.addLine(to: secondEndPoint)
        }
        
        context!.setLineWidth(CGFloat(1.0))
        context!.setStrokeColor(color)
        context!.addPath(path)
        context!.drawPath(using: .stroke)
    }
}


