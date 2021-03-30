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
    
    override func viewDidLoad() {
        graph.points = self.points
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
}
