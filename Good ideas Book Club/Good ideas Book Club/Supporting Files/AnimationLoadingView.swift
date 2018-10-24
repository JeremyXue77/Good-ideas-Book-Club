//
//  AnimationLoadingView.swift
//  Good ideas Book Club
//
//  Created by JeremyXue on 2018/10/18.
//  Copyright © 2018 JeremyXue. All rights reserved.
//

import UIKit
import Foundation

public class AnimationLoadingView {
    
    private static var loadingView: UIView?
    private static var spinner: UIActivityIndicatorView?
    private static var messageLabel: UILabel?
    
    public static func startLoading(message: String?) {
        
        if loadingView == nil, let window = UIApplication.shared.keyWindow {
            loadingView = UIView()
            loadingView?.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            loadingView?.center = window.center
            loadingView?.backgroundColor = .darkGray
            loadingView?.alpha = 0.9
            loadingView?.layer.cornerRadius = 10
            loadingView?.clipsToBounds = true
            spinner = UIActivityIndicatorView()
            spinner?.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            spinner?.center = CGPoint(x: loadingView!.bounds.midX, y: loadingView!.bounds.midY - 15)
            spinner?.style = .whiteLarge
            spinner?.startAnimating()
            messageLabel = UILabel()
            messageLabel?.frame = CGRect(x: 0, y: loadingView!.bounds.midY + 20, width: 200, height: 20)
            messageLabel?.center = CGPoint(x: window.center.x, y: window.center.y + 20)
            messageLabel?.textColor = .white
            messageLabel?.font = UIFont(name: "PingFangTC-Medium", size: 13)
            messageLabel?.textAlignment = .center
            messageLabel?.text = message
            loadingView?.addSubview(spinner!)
            window.addSubview(loadingView!)
            window.addSubview(messageLabel!)
        }
    }
    
    public static func endLoading(message: String?) {
        if let loadingView = loadingView, let window = UIApplication.shared.keyWindow {
            UIView.animate(withDuration: 0.4, animations: {
                loadingView.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
                loadingView.center = window.center
                spinner?.center = CGPoint(x: loadingView.bounds.midX, y: loadingView.bounds.midY)
                messageLabel?.center = window.center
                messageLabel?.text = message
                spinner?.alpha = 0
            }) { _ in
                UIView.animate(withDuration: 1.2, animations: {
                    messageLabel?.center.y -= 50
                    messageLabel?.alpha = 0
                    loadingView.center.y -= 50
                    loadingView.alpha = 0
                }, completion: { _ in
                    remove()
                })
            }
        }
    }
    
    public static func remove() {
        self.loadingView?.removeFromSuperview()
        self.messageLabel?.removeFromSuperview()
        self.spinner?.removeFromSuperview()
        self.loadingView = nil
        self.messageLabel = nil
        self.spinner = nil
    }
}
