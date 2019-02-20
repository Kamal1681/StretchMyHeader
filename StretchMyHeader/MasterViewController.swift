//
//  MasterViewController.swift
//  StretchMyHeader
//
//  Created by Kamal Maged on 2019-02-19.
//  Copyright © 2019 Kamal Maged. All rights reserved.
//

import UIKit

private let kTableHeaderHeight: CGFloat = 250.0

enum Category: String {
    case world
    case europe
    case africa
    case asiaPacific
    case americas
    case middleEast
    
    func toString() -> String {
        switch self {
        case .world:
        return "World"
        case .europe:
        return "Europe"
        case .africa:
        return "Africa"
        case .asiaPacific:
        return "Asia-Pacific"
        case .americas:
        return "Americas"
        case .middleEast:
        return "Middle East"
        }
    }
    func toColor() -> UIColor {
        switch self {
        case .world:
            return UIColor.red
        case .europe:
            return UIColor.green
        case .africa:
            return UIColor.orange
        case .asiaPacific:
            return UIColor.purple
        case .americas:
            return UIColor.blue
        case .middleEast:
            return UIColor.yellow
        }
    }
}
struct NewsItem {
    var headLine: String
    var category: Category
}
class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var headLineLabel: UILabel!
    func configureCell (newsItem: NewsItem) {
        headLineLabel.text = newsItem.headLine
        categoryLabel.text = newsItem.category.toString()
        categoryLabel.textColor = newsItem.category.toColor()
    }
}

class MasterViewController: UITableViewController {

   // @IBOutlet weak var tableHeader: UIView!
   
    @IBOutlet weak var dateLabel: UILabel!
    
    var detailViewController: DetailViewController? = nil
    var headerView: UIView!
    var objects = [NewsItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        objects.append(NewsItem.init(headLine: "Climate change protests, divestments meet fossil fuels realities", category: .world))
        objects.append(NewsItem.init(headLine: "Scotland's 'Yes' leader says independence vote is 'once in a lifetime'", category: .europe))
        objects.append(NewsItem.init(headLine: "Nigeria says 70 dead in building collapse; questions S. Africa victim claim", category: .africa))
        objects.append(NewsItem.init(headLine: "Despite UN ruling, Japan seeks backing for whale hunting", category: .asiaPacific))
        objects.append(NewsItem.init(headLine: "Airstrikes boost, FBI director warns more hostages possible", category: .middleEast))
        objects.append(NewsItem.init(headLine: "Officials: FBI is tracking 100 Americans who fought in Syria", category: .americas))
        objects.append(NewsItem.init(headLine: "South Africa in $40 billion deal for Russian nuclear reactors", category: .world))
        objects.append(NewsItem.init(headLine: "'One million babies' created by EU student exchanges", category: .europe))
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }


        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        
        tableView.contentInset.top = kTableHeaderHeight
        tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)
        updateHeaderView()
         displayDate()
//        tableView.estimatedRowHeight = 110
//       tableView.rowHeight = UITableView.automaticDimension
       
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }


    @objc
    func insertNewObject(_ sender: Any) {
        objects.append(sender as! NewsItem)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell

        let object = objects[indexPath.row]
        cell.configureCell(newsItem: object)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    func displayDate() {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd-MMMM"
        dateFormat.locale = Locale(identifier: "en_US_POSIX")
        dateFormat.dateStyle = .long
        dateFormat.timeStyle = .none
        dateLabel.text = dateFormat.string(from: Date())

    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }
    func updateHeaderView() {
        var headerTableRect = CGRect(x: 0, y: -kTableHeaderHeight, width: tableView.bounds.width, height: tableView.bounds.height)
        if tableView.contentOffset.y < kTableHeaderHeight {
            headerTableRect.origin.y = tableView.contentOffset.y
            headerTableRect.size.height = -tableView.contentOffset.y
        }
            headerView.frame = headerTableRect
      
    }
}

