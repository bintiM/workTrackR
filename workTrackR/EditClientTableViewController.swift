//
//  EditClientTableViewController.swift
//  workTrackR
//
//  Created by Marc Bintinger on 11.10.15.
//  Copyright © 2015 Marc Bintinger. All rights reserved.
//

import UIKit
import CoreData

extension EditClientTableViewController : NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
        CommandTunnel.addCommand(kChangedData)
        
        updateTimer?.invalidate()
        updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: tableView, selector: "reloadData", userInfo: nil, repeats: false)
        
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            // println("Insert")
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
        case .Update:
            //println("Update")
            tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        case .Delete:
            //println("Delete")
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
        case .Move:
            //println("Move")
            tableView.moveRowAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
        }
    }
    
}

class EditClientTableViewController: UITableViewController {

    private var fontSizeObserver:NSObjectProtocol!
    private var updateTimer:NSTimer!

    
    private lazy var fetchedResultsController:NSFetchedResultsController! = {
        let request = NSFetchRequest(entityName: kClientEntity)
        request.sortDescriptors = [NSSortDescriptor(key: kClientOrder, ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreData.sharedInstance.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch _ {
        }
        return fetchedResultsController
        } ()

    override func viewDidLoad() {
        super.viewDidLoad()

        super.viewDidLoad()
        self.view.backgroundColor = kColorBackground
        
        //self.title = NSLocalizedString("titleClientViewController", value: "Clients", comment: "the navigation bar title")
        self.title = "Edit Clients"
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addClient:")
        let editButton = UIBarButtonItem(barButtonSystemItem: .Organize, target: editButtonItem().target, action: editButtonItem().action)
        
        navigationItem.setRightBarButtonItems([addButton, editButton], animated: true)
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: kFontThin, NSForegroundColorAttributeName: kColorStandard, NSBackgroundColorAttributeName: kColorBackground]
        
        tableView.tableFooterView = UIView(frame: CGRectZero)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberSectionsInfo:NSFetchedResultsSectionInfo? = fetchedResultsController.sections?[section]
        return numberSectionsInfo?.numberOfObjects ?? 0
        // return (fetchedResultsController.sections?[section] as? NSFetchedResultsSectionInfo)?.numberOfObjects ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kEditClientTableViewCell, forIndexPath: indexPath) as! EditClientTableViewCell
        
        cell.backgroundColor = kColorBackground
        
        cell.client = fetchedResultsController.objectAtIndexPath(indexPath) as! Client
        
        return cell
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    //MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == kEditClientTableViewController {
            if let indexPath = tableView.indexPathForSelectedRow, client = fetchedResultsController.objectAtIndexPath(indexPath) as? Client {
                if let controller = segue.destinationViewController as? EditClientViewController {
                    controller.client = client
                }
            }
        }
    }

}
