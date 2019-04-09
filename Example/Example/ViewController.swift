//
//  ViewController.swift
//  Example
//
//  Created by 陈乐辉 on 2019/4/9.
//  Copyright © 2019年 CLH. All rights reserved.
//

import UIKit
import ReusableCell

class ViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: view.bounds, style: .plain)
        tv.dataSource = self
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.addSubview(tableView)
    }

}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            return tableView.rc.dequeueReusableCell(with: Cell1.self, configure: { (cell) in
                cell.textLabel?.text = "cell1"
            })
        } else {
            return tableView.rc.dequeueReusableCell(with: Cell2.self, configure: { (cell) in
                cell.textLabel?.text = "cell2"
            })
        }
    }
}

class Cell1: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .gray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Cell2: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

