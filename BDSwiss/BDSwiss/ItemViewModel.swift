//
//  ItemViewModel.swift
//  BDSwiss
//
//  Created by mohammadreza on 10/4/22.
//

import UIKit

struct ItemViewModel {
    var title: String
    var subtitle: String
    
    var image = ""
    var color = UIColor.gray
}


extension UITableViewCell {
    func configure(_ vm: ItemViewModel) {
        var content = UIListContentConfiguration.sidebarCell()
        
        content.text = vm.title
        content.secondaryText = vm.subtitle
        content.image = UIImage(systemName: vm.image)
        content.imageProperties.tintColor = vm.color
        
        contentConfiguration = content
    }
}
