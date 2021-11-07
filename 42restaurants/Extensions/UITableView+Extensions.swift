//
//  UITableView+Extensions.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/11/07.
//

import UIKit

extension UITableView {

    func setBackgroundWhenNoData() {
        let emptyView: UIView = {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
            return view
        }()
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "noData")
        
        emptyView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: self.frame.size.width),
            imageView.heightAnchor.constraint(equalToConstant: self.frame.size.height),
            imageView.topAnchor.constraint(equalTo: emptyView.topAnchor, constant: 0),
            imageView.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 0)
        ])
        
        self.backgroundView = emptyView
    }
    
    func resetBackground() {
        self.backgroundView = nil
    }

}
