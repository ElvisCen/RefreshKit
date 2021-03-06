//
//  ViewController.swift
//  RefreshKit
//
//  Created by czqasngit on 10/23/2018.
//  Copyright (c) 2018 czqasngit. All rights reserved.
//

import UIKit
import RefreshKit

class MyTableView: UITableView {
    deinit {
        print("MyTableView deinit")
    }
}
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let tableView = MyTableView()
    var count: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "基础测试"
        self.view.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        tableView.delegate = self
        tableView.dataSource = self
        self.automaticallyAdjustsScrollViewInsets = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.refresh.header = RefreshDefaultHeader.make {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                self.count = 10
                self.tableView.reloadData()
                self.tableView.refresh.header?.stopRefresh()
                self.tableView.refresh.footer?.resetNoMoreData()
            })
        }
        self.tableView.refresh.footer = RefreshDefaultFooter.make {
            if self.count >= 20 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    self.tableView.reloadData()
                    self.tableView.refresh.footer?.noMoreData()
                })
            } else {
                print("执行刷新...")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    self.count += 10
                    print("..............")
                    self.tableView.reloadData()
                    print("刷新...")
                    self.tableView.refresh.footer?.stopRefresh()
                })
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//        self.tableView.refresh.header?.toggle()
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = "第 \(indexPath.row) 行"
        return cell
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}

