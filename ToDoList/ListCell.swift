//
//  ListCell.swift
//  ToDoList
//
//  Created by Chris Peng on 3/11/17.
//  Copyright © 2017 Chris Peng. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {
    var event: Event? {
        didSet {

            setupName()

            self.detailTextLabel?.text = event?.text

            if let seconds = event?.timestamp?.doubleValue {
                let timestampDate = Date(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                self.timeLabel.text = dateFormatter.string(from: timestampDate)
            }
        }
    }

    func setupName() {
        textLabel?.text = event?.text
        detailTextLabel?.text = event?.detail
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }

    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(timeLabel)

        timeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right)
            make.top.equalTo(self.snp.top).offset(18)
            make.width.equalTo(100)
            make.height.equalTo((textLabel?.snp.height)!)
        }
        // x,y,w,h
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
