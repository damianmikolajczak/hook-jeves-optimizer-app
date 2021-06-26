//
//  GraphViewController.swift
//  Hook - Jeves optimazer
//
//  Created by Damian Mikołajczak on 30/03/2021.
//

import Cocoa

class GraphViewController: NSViewController {
    
    @IBOutlet var graph: GraphView!
    var points: [Point]?
    var optimizedFunction: Int?
    
    override func viewDidLoad() {
        graph.points = self.points
        graph.optimizedFunction = self.optimizedFunction
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
}
