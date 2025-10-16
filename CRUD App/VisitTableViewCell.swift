//
//  VisitTableViewCell.swift
//  CRUD App
//
//  Created by Xufeng Zhang on 10/10/25.
//


import UIKit

class VisitTableViewCell: UITableViewCell {
    
   static let identifier = "VisitTableViewCell"

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
        accessoryType = .disclosureIndicator
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private func setupUI() {
        [titleLabel, detailLabel].forEach{
            contentView.addSubview($0)
        }
    
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            detailLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            detailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        
    }
    
    var visit: Visit? {
        didSet{ updateUI() }
    }
    
    private func updateUI() {
        guard let v = visit else { return }
        titleLabel.text = v.title
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        detailLabel.text = "\(v.mode.description) • \(v.distanceMeters)m • \(df.string(from: v.date))"
    }

    func configure(with visit: Visit) {
        self.visit = visit
    }
    

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
//    }

}


//
//tableView.register(VisitTableViewCell.self, forCellReuseIdentifier: VisitTableViewCell.identifier)
//
//func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let cell = tableView.dequeueReusableCell(withIdentifier: VisitTableViewCell.identifier, for: indexPath) as! VisitTableViewCell
//    cell.configure(with: visits[indexPath.row])
//    return cell
//}
