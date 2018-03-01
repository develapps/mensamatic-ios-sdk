//
//  FilterListViewController.swift
//  MensamaticSMS_Example
//
//  Created by Juantri on 5/2/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import MensamaticSMS

struct Filter {
    var userFilter: Bool = false
    var destination: String?
    var sender: String?
    var fromDate: Date?
    var toDate: Date?
    var sent: Bool?
    var sentStatus: Int?
}

protocol FilterListDataProtocol {
    func filterListDataWith( _ filter: Filter)
}

class FilterListViewController: UIViewController, FilterTextFieldCellProtocol, FilterSentCellProtocol, FilterStatusCellProtocol {

    @IBOutlet weak var tableView: UITableView!
    
    var destination: String?
    var sender: String?
    var fromDateSelected: Date?
    var toDateSelected: Date?
    
    var delegate: FilterListDataProtocol?
    
    var filter: Filter?
    var dontSaveFilter: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Filter"
        
        self.filter = Filter()
        
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if !self.dontSaveFilter {
            self.filter?.userFilter = true
            self.filter?.destination = self.destination
            self.filter?.sender = self.sender
            self.filter?.fromDate = self.fromDateSelected
            self.filter?.toDate = self.toDateSelected
        }
        
        self.delegate?.filterListDataWith(self.filter!)
        
        super.viewWillDisappear(animated)
    }
    
    //-------------------------------------
    // MARK: - Actions
    //-------------------------------------
    @IBAction func restartListWithoutFilters(_ sender: UIBarButtonItem) {
        self.dontSaveFilter = true
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //-------------------------------------
    // MARK: - TextFieldCell Protocol
    //-------------------------------------
    func textChanged(typeOfCell: FilterTextFieldCellType, text: String?, field: Int, date: Date?) {
        if typeOfCell == .text, let text = text {
            if field == 0 {
                self.destination = text
            } else {
                self.sender = text
            }
        } else if let date = date {
            if field == 0 {
                self.fromDateSelected = date
            } else {
                self.toDateSelected = date
            }
        }
    }
    
    //-------------------------------------
    // MARK: - SentCell Protocol
    //-------------------------------------
    func switchChanged(sent: Bool, sentSwitch: Int) {
        if !sent {
            self.filter?.sent = nil
        } else {
            if sentSwitch == 0 {
                self.filter?.sent = true
            } else {
                self.filter?.sent = false
            }
        }
    }
    
    //-------------------------------------
    // MARK: - StatusCell Protocol
    //-------------------------------------
    func switchChanged(isActive: Bool, sentStatus: Int) {
        if isActive {
            self.filter?.sentStatus = nil
        } else {
            self.filter?.sentStatus = sentStatus
        }
    }
    
}

extension FilterListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTextFieldCell", for: indexPath) as! FilterTextFieldCell
            cell.setupCell(type: .text)
            cell.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTextFieldCell", for: indexPath) as! FilterTextFieldCell
            cell.setupCell(type: .date)
            cell.delegate = self
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterSentCell", for: indexPath) as! FilterSentCell
            cell.delegate = self
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterStatusCell", for: indexPath) as! FilterStatusCell
            cell.delegate = self
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTextFieldCell", for: indexPath) as! FilterTextFieldCell
            cell.setupCell(type: .text)
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Destinatario"
        case 1:
            return "Date"
        case 2:
            return "Sent"
        case 3:
            return "Status"
        default:
            return ""
        }
    }
    
}
