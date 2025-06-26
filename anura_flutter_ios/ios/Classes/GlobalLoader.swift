//
//  GlobalLoader.swift
//  
//
//  Created by Anand A S on 26/06/25.
//


// GlobalLoader.swift
import UIKit

class GlobalLoader {
    private static var containerView: UIView?
    
    static func show(message: String? = nil) {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
            
            let container = UIView(frame: window.bounds)
            container.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            
            let indicator = UIActivityIndicatorView(style: .large)
            indicator.color = .white
            indicator.startAnimating()
            
            container.addSubview(indicator)
            indicator.center = container.center
            
            if let message = message {
                let label = UILabel()
                label.text = message
                label.textColor = .white
                label.numberOfLines = 0
                label.textAlignment = .center
                label.frame = CGRect(x: 20, y: indicator.frame.maxY + 16, 
                                   width: container.bounds.width - 40, height: 60)
                container.addSubview(label)
            }
            
            window.addSubview(container)
            containerView = container
        }
    }
    
    static func hide() {
        DispatchQueue.main.async {
            containerView?.removeFromSuperview()
            containerView = nil
        }
    }
}