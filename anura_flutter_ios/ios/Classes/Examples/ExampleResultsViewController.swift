//
//  Copyright (c) 2016-2023, Nuralogix Corp.
//  All Rights reserved
//  THIS SOFTWARE IS LICENSED BY AND IS THE CONFIDENTIAL AND
//  PROPRIETARY PROPERTY OF NURALOGIX CORP. IT IS
//  PROTECTED UNDER THE COPYRIGHT LAWS OF THE USA, CANADA
//  AND OTHER FOREIGN COUNTRIES. THIS SOFTWARE OR ANY
//  PART THEREOF, SHALL NOT, WITHOUT THE PRIOR WRITTEN CONSENT
//  OF NURALOGIX CORP, BE USED, COPIED, DISCLOSED,
//  DECOMPILED, DISASSEMBLED, MODIFIED OR OTHERWISE TRANSFERRED
//  EXCEPT IN ACCORDANCE WITH THE TERMS AND CONDITIONS OF A
//  NURALOGIX CORP SOFTWARE LICENSE AGREEMENT.
//

import UIKit
import AnuraCore

class ExampleResultsViewController : UITableViewController {
    
    var results : [String: MeasurementResults.SignalResult] = [:] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var measurementID : String = "" {
        didSet {
            navigationItem.prompt = measurementID
        }
    }
    
    var dismissBlock : () -> () = {
        
    }
    
    private var resultsToDisplay : [(key: String, value: Double)] {
        return results
                .map({ ($0.key, $0.value.value) })
                .sorted(by: { (element1, element2) in return element1.key < element2.key  })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Results"
        navigationItem.prompt = "Loading..."
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                           target: self,
                                                           action: #selector(close))
        tableView.register(SubtitleTableViewCell.self,
                           forCellReuseIdentifier: "cell")
    }
    
    @objc func close() {
        presentingViewController?.dismiss(animated: true, completion: dismissBlock)
    }
    
    func setLoadingMessage(currentChunk: Int, totalChunks: Int) {
        navigationItem.prompt = "Loading (\(currentChunk + 1) of \(totalChunks))"
    }
    
    func measurementDidCancel() {
        navigationItem.prompt = "Measurement Cancelled"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsToDisplay.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let element = resultsToDisplay[indexPath.row]
        
        cell.textLabel?.text = element.key
        cell.detailTextLabel?.text = String(element.value)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

class SubtitleTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
