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
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        let background = NSColor.init(red: 180, green: 180, blue: 180, alpha: 0.1)
        background.setFill()
        bounds.fill()
        
        let context = NSGraphicsContext.current?.cgContext
        let xmin = CGPoint.init(x: 0, y: 250)
        let xmax = CGPoint.init(x: 500, y: 250)
        let ymin = CGPoint.init(x: 250, y: 0)
        let ymax = CGPoint.init(x: 250, y: 500)
        let origin = CGPoint.init(x: 250, y: 250)
        let color = CGColor.white
        let step = CGFloat(50)
        
        drawCartesianLines(inContext: context!, origin: origin, xmin: xmin, xmax: xmax, ymin: ymin, ymax: ymax, withColor: color)
        drawHelpLines(inContext: context!, origin: origin, xmin: xmin, xmax: xmax, ymin: ymin, ymax: ymax, withColor: color , step: step)
        
        if let data = points {
            drawPoints(data: data, context: context)
        }
    }
}

extension GraphView {
    
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
        context.drawPath(using: .fillStroke)
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
        context.drawPath(using: .fillStroke)
        
    }
    
    func drawPoints(data: [Point], context: CGContext?) {
        let color = CGColor.init(red: 1, green: 0, blue: 0, alpha: 1)
        let path = CGMutablePath()
        let startPoint = CGPoint(x: 250+50*data[0].x1, y: 250+50*data[0].x2)
        
        path.move(to: startPoint)
        
        for index in 0..<(data.count) {
            let nextPoint = CGPoint(x: 250+50*data[index].x1, y: 250+50*data[index].x2)
            print(nextPoint)
            path.addLine(to: nextPoint)
        }
        
        context!.setLineWidth(CGFloat(1.0))
        context!.setStrokeColor(color)
        context!.addPath(path)
        context!.drawPath(using: .stroke)
    }
}


