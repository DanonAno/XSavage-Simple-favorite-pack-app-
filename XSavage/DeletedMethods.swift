//
//  DeletedMethods.swift
//  XSavage
//
//  Created by  Даниил on 12.01.2022.
//

import Foundation
//MARK: TableViewDelegateDelete первый
// Удобный метод, но больше подходит для более обьемный приложений, по типу соц сетей, для нашего можно использовать более легкий метод
//    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let place = Places[indexPath.row]
//        let DeleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
//            StorageManager.deleteObject(place)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//        }
//
//        return UISwipeActionsConfiguration(actions: [DeleteAction])
//    }
