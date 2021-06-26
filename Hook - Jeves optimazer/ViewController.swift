//
//  ViewController.swift
//  Hook - Jeves optimazer
//
//  Created by Damian Mikołajczak on 29/03/2021.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet var stepText: NSTextField!
    @IBOutlet var betaText: NSTextField!
    @IBOutlet var sigmaText: NSTextField!
    @IBOutlet var startPointX1: NSTextField!
    @IBOutlet var startPointX2: NSTextField!
    @IBOutlet var statusBox: NSView!
    @IBOutlet var selectFunctionBox: NSComboBox!
    @IBOutlet var solutionTextX1: NSTextField!
    @IBOutlet var solutionTextX2: NSTextField!
    @IBOutlet var solutionTextValue: NSTextField!
    
    let sourceData = ["Himmemblau", "Paraloid", "Matyas", "Ackley", "Cross-in-tray", "Funk. z zaj."]
    var foundedPoints = [Point]()

    
    @IBAction func drawButtonClicked(sender: NSButton) {
        performSegue(withIdentifier: "showGraph", sender: self)
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        let vc = segue.destinationController as! GraphViewController
        vc.points = foundedPoints
        vc.optimizedFunction = selectFunctionBox.indexOfSelectedItem
    }
    
    @IBAction func getRandomStartPoint(sender: NSButton) {
        let x1 = Double.random(in: -5...5)
        let x2 = Double.random(in: -5...5)
        startPointX1.doubleValue = x1
        startPointX2.doubleValue = x2
    }
    
    @IBAction func searchButtonClicked(sender: NSButton) {
        //Wczytanie danych wejściowych:
        
        let directionsBase: [Point] = [Point(0,1), Point(1,0)]
        let step = stepText.doubleValue
        let beta = betaText.doubleValue
        let sigma = sigmaText.doubleValue
        let x = Point(startPointX1.doubleValue, startPointX2.doubleValue)
        let function = selectFunctionBox.indexOfSelectedItem
        let result: (point: Point, value: Double, storedPoints: [Point])
        
        var hookJavesOptimizer = HookJavesOptimazer(onDirectionBase: directionsBase, forFunction: function, withStep: step, andBeta: beta, andAccuracy: sigma, andArgument: x, storedTo: foundedPoints, in: statusBox)
        
        result = hookJavesOptimizer.startOptimazer()
        
        solutionTextX1.stringValue = String(format: "%5.5f", result.point.x1)
        solutionTextX2.stringValue = String(format: "%5.5f", result.point.x2)
        solutionTextValue.stringValue = String(format: "%5.5f", result.value)
        foundedPoints = result.storedPoints

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Load window with default values:
        stepText.stringValue = "0.2"
        betaText.stringValue = "0.5"
        sigmaText.stringValue = "0.01"
        startPointX1.stringValue = "2"
        startPointX2.stringValue = "3"
        selectFunctionBox.usesDataSource = true
        selectFunctionBox.dataSource = self
    }
}

extension ViewController: NSComboBoxDataSource {
    
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return sourceData.count
    }
    
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        return sourceData[index]
    }
}

