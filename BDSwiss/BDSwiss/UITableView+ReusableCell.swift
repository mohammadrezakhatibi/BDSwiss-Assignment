//
//  UITableView+ReusableCell.swift
//  BDSwiss
//
//  Created by mohammadreza on 9/29/22.
//

import UIKit

/// A protocol that all reusable cells must implement.
protocol ReusableCell: AnyObject {
    static var cellIdentifier: String { get }
}

// Default protocol implementation
extension ReusableCell {

    static var cellIdentifier: String {
        return String(describing: self)
    }

}

extension UITableViewCell: ReusableCell {}

extension UITableView {

    /// Registers a set of classes for use in creating new table view cells.
    /// - Parameter cellTypes: The cell types to register
    func registerCells(_ cellTypes: [ReusableCell.Type]) {
        for cellType in cellTypes {
            register(cellType, forCellReuseIdentifier: cellType.cellIdentifier)
        }
    }

    /// Dequeues a reusable table cell object located by its type.
    /// - Parameters:
    ///   - type: The type of the cell to dequeue.
    ///   - indexPath: The index path specifying the location of the cell.
    /// - Returns: A valid cell instance of the specified type.
    func dequeueCell<T: ReusableCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(
            withIdentifier: type.cellIdentifier,
            for: indexPath
        ) as? T else {
            preconditionFailure("Unexpected cell type returned")
        }

        return cell
    }

}
