//
//  ViewController.swift
//  ZXToast
//
//  Created by luckyczh on 01/06/2022.
//  Copyright (c) 2022 luckyczh. All rights reserved.
//

import UIKit
import ZXToast
class ViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let table = UITableView.init(frame: view.bounds, style: .plain)
        table.rowHeight = 30
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(table)
        return table
    }()
    
    let titles = ["提示1","多个提示","成功","失败","loading"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        ZXToast.showError("这是错误")

    }

}

extension ViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = titles[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 0:
            ZXToast.showText("提示1")
        case 1:
            ZXToast.showText("提示2")
            ZXToast.showText("提示3")
            ZXToast.showText("提示4")
            ZXToast.showText("提示5")
        case 2:
            ZXToast.showSuccess("成功")
        case 3:
            ZXToast.showError("失败")
        case 4:
            ZXToast.showActivity("加载中...")
        default:
            break
        }
        

    }
}

