//
//  ListViewController.swift
//  CRUD App
//
//  Created by Xufeng Zhang on 10/10/25.
//

import UIKit

class ListViewController: UIViewController {
    
    private var visits: [Visit] = [
        Visit(title: "Ngee Ann", mode: .bike, distanceMeters: 1200),
        Visit(title: "Bukit Timah", mode: .walk, distanceMeters: 800),
        Visit(title: "City Hall", mode: .train, distanceMeters: 5400, note: "Peak hour")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        // Do any additional setup after loading the view.
        
        title = "Visits"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.leftBarButtonItem = editButtonItem
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBlue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        
        //view.addSubview(stackView)
        view.addSubview(tableView)
        view.addSubview(footerbar)
        
        stackView.addArrangedSubview(helperLabel)
        //stackView.addArrangedSubview(actionButton)
        footerbar.addSubview(stackView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(VisitTableViewCell.self, forCellReuseIdentifier: VisitTableViewCell.identifier)
        
        //actionButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
    }


    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: footerbar.topAnchor),
            
            footerbar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            footerbar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            footerbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            footerbar.heightAnchor.constraint(equalToConstant: 60),
            
            stackView.topAnchor.constraint(equalTo: footerbar.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: footerbar.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: footerbar.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: footerbar.bottomAnchor, constant: -10)
            
        ])
    }
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 64
        return tableView
    }()
    
    private let helperLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tip: Tap + to add a new Visit. Swipe left on a row to delete."
        return label
    }()
    
//    private let actionButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
//        button.setTitle("Add Visit", for: .normal)
//        button.setContentHuggingPriority(.required, for: .horizontal)
////        tells auto layout how strongly a view wants to keep its intrinsic size
////        .requied = priority 1000 the strongest prossible resistance
////        So if Auto Layout tries to make the button wider to fill space, the button will refuse and stay as small as needed to fit its content.
//        return button
//    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    
    
    private let footerbar: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
//    private let stackView: UIStackView = {
//        let sv = UIStackView()
//        sv.translatesAutoresizingMaskIntoConstraints = false
//        sv.axis = .vertical
//        sv.spacing = 16
//        return sv
//    }()
    
   @objc private func addButtonTapped() {
//        let vc = VisitFormViewController(visit: nil)
//        visits.append(new)
//        tableView.insertRows(at: [IndexPath(row: visits.count - 1, section: 0)], with: .automatic)
//       navigationController?.pushViewController(vc, animated: true)
       let form = VisitFormViewController(visit: nil)
       form.delegate = self
       let nav = UINavigationController(rootViewController: form)
       present(nav, animated: true)
    }
    
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visits.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: VisitTableViewCell.identifier,
            for: indexPath
        ) as! VisitTableViewCell
        
        // NOTE: your cell uses `comfigure(with:)` (typo in file), so we call that exact name.
        cell.configure(with: visits[indexPath.row]) // ADDED
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let v  = visits[indexPath.row]
        let vc = VisitDetailController(Visit: v)
        navigationController?.pushViewController(vc, animated: true)
//        tableView.deselectRow(at: indexPath, animated: true)
//        //let v  = visits[indexPath.row]
//        //let vc = VisitDetailController(Visit: v)
//        let vc = VisitDetailController(visit: visits[indexPath.row])
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    // ADDED: swipe to delete
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            visits.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        64
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let moved = visits.remove(at: sourceIndexPath.row)
        visits.insert(moved, at: destinationIndexPath.row)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
}

extension ListViewController: VisitFormViewControllerDelegate {
    func didAddVisit(_ visit: Visit) {
        visits.append(visit)
        tableView.insertRows(at: [IndexPath(row: visits.count-1, section: 0)], with: .automatic)
    }
    func didUpdateVisit(_ visit: Visit) {
        if let row = visits.firstIndex(where: { $0 === visit }) {
            tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
        }
    }
}

//#Preview {
//    ListViewController()
//}

