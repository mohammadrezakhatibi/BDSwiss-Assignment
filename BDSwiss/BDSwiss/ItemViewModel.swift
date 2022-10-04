//
//  ItemViewModel.swift
//  BDSwiss
//
//  Created by mohammadreza on 10/4/22.
//

import UIKit

struct ItemViewModel: Codable, Equatable {
    var title: String
    var subtitle: String
    
    var color: ItemColor = .gray
    
    enum ItemColor: Codable {
        case green
        case red
        case gray
    }
}


extension UITableViewCell {
    func configure(_ vm: ItemViewModel) {
        var content = UIListContentConfiguration.sidebarCell()
        
        content.text = vm.title
        
        let attributes = [NSAttributedString.Key.foregroundColor: vm.color == .red ? UIColor.red : UIColor.green]
        content.secondaryAttributedText = NSAttributedString(string: vm.subtitle, attributes: attributes)
        
        contentConfiguration = content
    }
}
