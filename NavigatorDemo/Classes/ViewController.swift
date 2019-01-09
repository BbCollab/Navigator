//
//  ViewController.swift
//  NavigatorDemo
//
//  Created by Kris Liu on 5/11/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import UIKit
import Navigator

class ViewController: UIViewController, DataProtocol {

    private typealias TupleType = (greeting: String, message: UInt32)
    private var dataModel: DataModel?
    private var tuple: TupleType?
    
    func onDataReceiveBeforeShow(_ data: DataModel, fromViewController: UIViewController?) {
        print("Received data before show from \(String(describing: fromViewController)): \(data)")
        
        dataModel = data
        title = data.title ?? "Favorites"
        tuple = data.additionalData as? TupleType
        
        tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
    }
    
    func onDataReceiveAfterBack(_ data: DataModel, fromViewController: UIViewController?) {
        print("Received data after back: \(data)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: .random(), green: .random(), blue: .random(), alpha: 1.0)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapShowViewControler)))
        
        guard let tuple = tuple else { return }
        let label = UILabel()
        label.frame = view.frame
        label.autoresizingMask = [.flexibleWidth, .flexibleWidth]
        label.textAlignment = .center
        label.text = tuple.greeting + String(tuple.message)
        view.addSubview(label)
    }
    
    @objc func onTapShowViewControler() {
        let data = DataModel(viewController: NSStringFromClass(ViewController.self), navigationController: NSStringFromClass(UINavigationController.self),
                             mode: .present, title: String(arc4random()), transitionClass: NSStringFromClass(ScaleTransition.self))
        self.navigator?.show(data)
    }
    
    deinit {
        debugPrint("FREE MEMORY: \(self)")
        navigator?.sendDataAfterBack(dataModel)
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}