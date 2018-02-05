//
//  ListViewController.swift
//  MensamaticSMS_Example
//
//  Created by Juantri on 5/2/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import MensamaticSMS

protocol CancelScheduledSMSProtocol {
    func cancelScheduledSMS( _ id: String)
}

class ListSMSViewController: UIViewController, CancelScheduledSMSProtocol, FilterListDataProtocol {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var cells: [[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "List SMS"
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.tableFooterView = UIView()
        self.tableView.reloadData()
        
        self.loadSentSMS()
    }

    //-------------------------------------
    // MARK: - Actions
    //-------------------------------------
    @IBAction func changeData(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.loadSentSMS()
        } else if sender.selectedSegmentIndex == 1 {
            self.loadIncomingSMS()
        }
        self.segmentedControl.isUserInteractionEnabled = false
    }
    
    //-------------------------------------
    // MARK: - Segue
    //-------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FilterSegue", let filterVC = segue.destination as? FilterListViewController {
            filterVC.delegate = self
        }
    }
    
    //-------------------------------------
    // MARK: - Backend
    //-------------------------------------
    private func loadSentSMS() {
        sms_listSentSMS(id: nil, destination: nil, source: nil, from_date: nil, to_date: nil, sent: nil, sent_status: nil) { (result) in
            switch result {
            case .successWithData(let data):
                if let json = data as? [String:Any], let results = json["results"] as? [[String:Any]] {
                    self.cells = results
                    self.tableView.reloadData()
                }
                
            case .error(let error):
                self.present(Common().showAlert(title: "Error", message: error.localizedDescription), animated: true, completion: nil)
                
            }
            self.segmentedControl.isUserInteractionEnabled = true
        }
    }
    
    private func loadIncomingSMS() {
        sms_listIncomingSMS { (result) in
            switch result {
            case .successWithData(let data):
                if let json = data as? [String:Any], let results = json["results"] as? [[String:Any]] {
                    self.cells = results
                    self.tableView.reloadData()
                }
                
            case .error(let error):
                self.present(Common().showAlert(title: "Error", message: error.localizedDescription), animated: true, completion: nil)
                
            }
            self.segmentedControl.isUserInteractionEnabled = true
        }
    }
    
    //-------------------------------------
    // MARK: - Protocols
    //-------------------------------------
    func cancelScheduledSMS(_ id: String) {
        sms_cancelScheduledSMS(id: id) { (result) in
            switch result {
            case .successWithData( _):
                self.present(Common().showAlert(title: "Canceled", message: "The SMS has been canceled"), animated: true, completion: nil)
                self.changeCell(smsID: id)
                
            case .error(let error):
                self.present(Common().showAlert(title: "Error", message: error.localizedDescription), animated: true, completion: nil)
                
            }
        }
    }
    
    func filterListDataWith(_ filter: Filter) {
        print(filter)
    }
    
    //-------------------------------------
    // MARK: - Helpers
    //-------------------------------------
    private func changeCell(smsID: String) {
        if let index = self.cells.index(where: { (JSON) -> Bool in
            if let id = JSON["id"] as? String, id == smsID {
                return true
            }
            return false
        }) {
            var JSON = self.cells[index]
            JSON["sent_status"] = 3
            self.cells[index] = JSON
            self.tableView.reloadData()
        }
    }

}

//-------------------------------------
// MARK: - Table View Data Source
//-------------------------------------
extension ListSMSViewController: UITableViewDataSource {
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cells.count
    }
    
    @objc(tableView:cellForRowAtIndexPath:) func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListSMSCell", for: indexPath) as! ListSMSCell
            cell.configureForCell(cells[indexPath.row])
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListIncomingSMSCell", for: indexPath) as! ListIncomingSMSCell
            cell.configureForCell(cells[indexPath.row])
            return cell
        }
    }
    
}

//-------------------------------------
// MARK: - Table View Delegate
//-------------------------------------
extension ListSMSViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
