//
//  VisitDetailController.swift
//  CRUD App
//
//  Created by Xufeng Zhang on 10/10/25.
//

import UIKit

private let reuseIdentifier = "Cell"

class VisitDetailController: UITableViewController {
    
    var Visit: Visit
    
    init(Visit: Visit) {
        self.Visit = Visit
        super.init(style: .insetGrouped)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum Section: Int, CaseIterable {
        case main, notes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Visit Details"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self,
                                                            action: #selector(editTapped))
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60

    }

    // MARK: - Table view data source
    
    @objc private func editTapped() {
        let form = VisitFormViewController(visit: Visit)
        form.delegate = self
        let nav = UINavigationController(rootViewController: form)
        present(nav, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
     return Section.allCases.count
        // #warning Incomplete implementation, return the number of sections
        //return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section){
        case .main: return 3
        case .notes: return(Visit.note == nil) ? 0 : 1
        case .none : return 0
        }
        // #warning Incomplete implementation, return the number of rows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        switch (Section(rawValue: indexPath.section), indexPath.row){
        case (.main, 0): cell.textLabel?.text = "Title"; cell.detailTextLabel?.text = Visit.title
        case (.main, 1): cell.textLabel?.text = "Mode"; cell.detailTextLabel?.text = Visit.mode.description
        case (.main, 2):
            let df = DateFormatter(); df.dateStyle = .medium; df.timeStyle = .short
            cell.textLabel?.text = "When / Distance"
            cell.detailTextLabel?.text = "\(df.string(from: Visit.date)) ~ \(Visit.distanceMeters)m"
            cell.detailTextLabel?.numberOfLines = 0
            cell.detailTextLabel?.lineBreakMode = .byWordWrapping
            cell.textLabel?.setContentHuggingPriority(.required, for: .horizontal)
            cell.detailTextLabel?.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        case (.notes, 0):
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = Visit.note
            cell.selectionStyle = .none
        default : break
        }
        return cell
    }
}

extension VisitDetailController: VisitFormViewControllerDelegate {
    func didUpdateVisit(_ visit: Visit) {
        self.Visit = visit
        //title = "Visit Details"
        //tableView.reloadData()
        tableView.reloadData()
    }
}
