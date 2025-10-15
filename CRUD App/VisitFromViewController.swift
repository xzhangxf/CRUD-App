//
//  VisitFromViewController.swift
//  CRUD App
//
//  Created by Xufeng Zhang on 10/10/25.
//

import UIKit

protocol VisitFormViewControllerDelegate: AnyObject {
    func didAddVisit(_ visit: Visit)
    func didUpdateVisit(_ visit: Visit)
}

extension VisitFormViewControllerDelegate {
    func didAddVisit(_ visit: Visit) {}
    func didUpdateVisit(_ visit: Visit) {}
}

private let reuseIdentifier = "Cell"

class VisitFormViewController: UITableViewController {
    
    var visit: Visit? //nil = add, nonnil = edit
    weak var delegate: VisitFormViewControllerDelegate?
    
    init(visit: Visit?) {
        self.visit = visit
        super.init(style: .insetGrouped)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleField = UITextField()
    private lazy var modeControl : UISegmentedControl = {
        let items = Visit.TransportMode.allCases.map { $0.description }
        let sc = UISegmentedControl(items: items)
        return sc
    }()
    private let distanceField = UITextField()
    private let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if visit == nil {
            titleField.becomeFirstResponder()
        }
        addDoneToolbar(to: distanceField)
        title = (visit == nil) ? "New Visit" : "Edit Visit"
        navigationItem.leftBarButtonItem  = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,   target: self, action: #selector(saveTapped))

        distanceField.keyboardType = .numberPad
        datePicker.datePickerMode = .dateAndTime
        
        if let v = visit {
            titleField.text = v.title
            if let idx = Visit.TransportMode.allCases.firstIndex(of: v.mode) { modeControl.selectedSegmentIndex = idx }
            distanceField.text = String(v.distanceMeters)
            datePicker.date = v.date
        } else {
            modeControl.selectedSegmentIndex = 0
            datePicker.date = Date()
        }
        
        if let v = visit {
            noteView.text = v.note
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 4 {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.selectionStyle = .none

            let title = UILabel()
            title.text = "Notes"
            title.font = .systemFont(ofSize: 20)

            noteView.isEditable = true
            noteView.isUserInteractionEnabled = true
            noteView.translatesAutoresizingMaskIntoConstraints = false
            title.translatesAutoresizingMaskIntoConstraints = false

            cell.contentView.addSubview(title)
            cell.contentView.addSubview(noteView)

            NSLayoutConstraint.activate([
                title.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 12),
                title.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                title.trailingAnchor.constraint(lessThanOrEqualTo: cell.contentView.trailingAnchor, constant: -16),

                noteView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
                noteView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                noteView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                noteView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -6),
                noteView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80)
            ])

            return cell
        }

        // ----- Other sections (Title / Mode / Distance / Date) keep the .value1 layout
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        let view: UIView

        switch indexPath.section {
        case 0:
            cell.textLabel?.text = "Title"
            view = titleField
        case 1:
            cell.textLabel?.text = "Mode"
            view = modeControl
        case 2:
            cell.textLabel?.text = "Distance (m)"
            view = distanceField
        default: // case 3
            cell.textLabel?.text = "Date"
            view = datePicker
        }

        cell.selectionStyle = .none
        view.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(view)

        NSLayoutConstraint.activate([
            view.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            view.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
            view.widthAnchor.constraint(greaterThanOrEqualToConstant: 160)
        ])

        if let tf = view as? UITextField {
            tf.borderStyle = .roundedRect
        }

        return cell
    }
    
    @objc private func cancelTapped() { dismiss(animated: true) }

    @objc private func saveTapped() {
        let title = (titleField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { return } // show an alert in a real app
        let mode = Visit.TransportMode.allCases[modeControl.selectedSegmentIndex]
        let distance = Int(distanceField.text ?? "") ?? 0
        let date = datePicker.date
        
        let noteText = noteView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let note     = noteText.isEmpty ? nil : noteText

        if let v = visit {
            // update
            v.title = title
            v.mode = mode
            v.distanceMeters = distance
            v.date = date
            v.note = note
            delegate?.didUpdateVisit(v)
        } else {
            // add
            let new = Visit(title: title, mode: mode, date: date, distanceMeters: distance, note: note)
            delegate?.didAddVisit(new)
        }
        dismiss(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if visit == nil {
            titleField.becomeFirstResponder()
        }
    }
        
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return indexPath.section == 4 ? 120 : 44
        }

    
    private func addDoneToolbar(to textField: UITextField) {
        let tb = UIToolbar()
        tb.sizeToFit()
        tb.items = [
            UIBarButtonItem(systemItem: .flexibleSpace),
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(endEditingNow))
        ]
        textField.inputAccessoryView = tb
    }

    @objc private func endEditingNow() { view.endEditing(true) }
    
    private let noteView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 16)
        tv.isScrollEnabled = false
        tv.backgroundColor = .clear
        tv.textContainerInset = .init(top: 8, left: 4, bottom: 8, right: 4)
        return tv
    }()

}
