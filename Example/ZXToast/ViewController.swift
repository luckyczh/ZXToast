//
//  ViewController.swift
//  ZXToast
//
//  Created by luckyczh on 01/06/2022.
//  Copyright (c) 2022 luckyczh. All rights reserved.
//

import UIKit
import ZXToast
class ViewController: UIViewController, CAAnimationDelegate {
    
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
    var lock = NSConditionLock(condition: 1)
    let dispatchSem = DispatchSemaphore(value: 1)
    var lab = UILabel(frame: CGRect(x: 100, y: 100, width: 100, height: 30))
    var desLabel = UILabel(frame: CGRect(x: 100, y: 130, width: 100, height: 30))
    var lockObj = "fewfe"
    
    var group = CAAnimationGroup()
    var group1 = CAAnimationGroup()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        lab.textColor = .red
//        lab.font = UIFont.systemFont(ofSize: 15)
//        lab.text = "动画文字"
//        view.addSubview(lab)
//        desLabel.font = UIFont.systemFont(ofSize: 13)
//        desLabel.textColor = .systemRed
//        desLabel.text = "下面是描述问法兰克福节微积分"
//        view.addSubview(desLabel)
//
//        let btn = UIButton(frame: CGRect(x: 100, y: 200, width: 100, height: 100))
//        btn.backgroundColor = .blue
//        btn.addTarget(self, action: #selector(loading), for: .touchUpInside)
//        view.addSubview(btn)
//        lab.layer.opacity = 0
//        desLabel.layer.opacity = 0
//        loading()
        tableView.reloadData()
    }
    
    @objc func loading() {
        let vi = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        view.addSubview(vi)
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 100, height: 100), cornerRadius: 50).cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 2
        layer.strokeColor = UIColor.red.cgColor
        vi.layer.addSublayer(layer)
        
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = -1
        strokeStartAnimation.toValue = 1

        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1.0

        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 2
        animationGroup.repeatCount = Float.infinity
        animationGroup.animations = [strokeStartAnimation, strokeEndAnimation]
        layer.add(animationGroup, forKey: "animationGroup")
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0
        rotateAnimation.toValue = Float.pi * 2
        rotateAnimation.repeatCount = Float.infinity
        rotateAnimation.duration = 2
        rotateAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        vi.layer.add(rotateAnimation, forKey: "rotateAnimation")
        
    }
    
   
    
    //// MARK: - 使用示例
    //// 显示加载指示器
   
    //
    //// 显示带进度的Toast
    
    //
    //// 显示成功提示
    
    
    
  @objc  func startAnimation() {
//        let group = CAAnimationGroup()
      group.duration = 0.3
       group.delegate = self
        let alAn = CABasicAnimation(keyPath: "opacity")
        alAn.fromValue = 0
        alAn.toValue = 1
      alAn.duration = 0.8
        alAn.isRemovedOnCompletion = false
        let moveAn = CABasicAnimation(keyPath: "position.x")
        moveAn.fromValue = 200
        moveAn.toValue = 150
      moveAn.duration = 0.3
        group.animations = [alAn, moveAn]
        group.isRemovedOnCompletion = false
        lab.layer.add(group, forKey: nil)
      
//      let group1 = CAAnimationGroup()
      group1.duration = 0.3
      group1.beginTime = 0.2
      group1.delegate = self
      let alAn1 = CABasicAnimation(keyPath: "opacity")
      alAn1.fromValue = 0
      alAn1.toValue = 1
      alAn1.duration = 0.8
      alAn1.isRemovedOnCompletion = false
      let moveAn1 = CABasicAnimation(keyPath: "position.x")
      moveAn1.fromValue = 200
      moveAn1.toValue = 150
      moveAn1.duration = 0.3
      group1.animations = [alAn1, moveAn1]
      group1.isRemovedOnCompletion = false
      desLabel.layer.add(group1, forKey: nil)
        
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
//        if anim == group {
            lab.layer.opacity = 1

//        }
//        if anim == group1 {
            desLabel.layer.opacity = 1

//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        

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
            NEToast.showLoading()
        case 1:
            NEToast.showError("这是错误")
        case 2:
            NEToast.showSuccess("这是成功")
        case 3:
            NEToast.showMessage("这是6朱可夫哈伦裤额哈看立法会快乐发货爱了黑发可怜合法快乐合法可怜合法快乐合法来看合法快乐和阿里开发哈立刻合法快乐发哈了客服哈伦裤和法兰克福啊立刻合法啊立刻哈")

        default:
            break
        }
        

    }
}

