//
//  DataCell.swift
//  LocalDatabase (Homework)
//
//  Created by Ivan Kuzmenkov on 9.11.22.
//

import UIKit

class DataCell: UITableViewCell {
    
    static let id = String(describing: DataCell.self)

    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longtitudeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
