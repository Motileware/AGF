//
//  FinderViewController.swift
//  AGF
//
//  Created by WeyHan Ng on 15/12/2015.
//
//

import UIKit

let textCellIdentifier = "dirItemCell"

class ItemCell: UITableViewCell {
    @IBOutlet var itemIcon: UILabel!
    @IBOutlet var itemName: UILabel!
    @IBOutlet var itemPath: UILabel!

    func fillCell(name: String, path: String, icon: String) {
        itemIcon.font = UIFont(name: "FontAwesome", size: 30.0)
        itemIcon.textColor = UIColor(red: 0, green: 0.478, blue: 1.0, alpha: 1.0)

        itemIcon.text = icon
        itemName.text = name
        itemPath.text = path
    }
}

class FinderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let container: Container = Container()

    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorColor = UIColor.clearColor()

        tableView.delegate = self
        tableView.dataSource = self
    }

    @IBAction func export() {
        container.mirrorGroupContainer()
    }

    @IBAction func deleteContainer() {
        container.wipe()
        tableView.reloadData()
    }

    @IBAction func reload() {
        container.scanGroupContainer()
        tableView.reloadData()
    }

    // MARK: UITableViewDelegate protocol methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let row = indexPath.row
        print(container.itemNameAtIndex(row))
    }

    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let button = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: NSLocalizedString("Delete", comment: "Delete"), handler: { (rowAction, indexPath) -> Void in
            self.tableView(self.tableView!, commitEditingStyle: UITableViewCellEditingStyle.Delete, forRowAtIndexPath: indexPath)
        })
        button.backgroundColor = UIColor.redColor()
        return [button]
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            container.removeItemAtIndexPath(indexPath.row)
            container.scanGroupContainer()
            tableView.reloadData()
        }
    }

    // MARK: UITableViewDataSource protocol methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return container.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! ItemCell

        let item = container.itemAtIndex(indexPath.row)
        cell.fillCell(item["name"] as! String, path: item["path"] as! String, icon: item["icon"] as! String)

        return cell
    }

}
