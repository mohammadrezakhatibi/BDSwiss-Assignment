//
//  UIViewController+Alert.swift
//  BDSwiss
//
//  Created by mohammadreza on 9/30/22.
//

import UIKit

extension UIViewController {
    func show(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        presenterVC.present(alert, animated: true)
    }
}

extension UIViewController {
    var presenterVC: UIViewController {
        parent?.presenterVC ?? parent ?? self
    }
}
