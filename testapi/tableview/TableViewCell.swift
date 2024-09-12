//
//  TableViewCell.swift
//  testapi
//
//  Created by imac 1682's MacBook Pro on 2024/9/12.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var latime: UILabel!
    @IBOutlet weak var lawx: UILabel!
    @IBOutlet weak var lapop: UILabel!
    @IBOutlet weak var laci: UILabel!
    @IBOutlet weak var laminmanT: UILabel!
    static let identifier = "TableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
