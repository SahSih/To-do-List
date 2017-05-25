
//
//  DetailViewController.swift
//  ToDoList
//
//  Created by Chris Peng on 3/11/17.
//  Copyright © 2017 Chris Peng. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var event: Event?
    let titleLable: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 30)
        lb.textAlignment = .center
        return lb
    }()
    let detailLable: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 24)
        tv.backgroundColor = .white
        tv.textAlignment = .center
        tv.textColor = .lightGray
        return tv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(titleLable)
        view.addSubview(detailLable)
        titleLable.text = event?.text
        detailLable.text = event?.detail
        titleLable.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(200)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(300)
            make.height.equalTo(50)
        }

        detailLable.snp.makeConstraints { (make) in
            make.top.equalTo(titleLable.snp.bottom).offset(10)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(300)
            make.height.equalTo(250)
        }
        // Do any additional setup after loading the view.
    }

}
