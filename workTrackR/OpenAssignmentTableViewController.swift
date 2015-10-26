//
//  OpenAssignmentTableViewController.swift
//  workTrackR
//
//  Created by Marc Bintinger on 05.10.15.
//  Copyright © 2015 Marc Bintinger. All rights reserved.
//

import UIKit
import CoreData

extension OpenAssignmentTableViewController : NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()

        
        //ist updateTimer != nil dann invalidate
        updateTimer?.invalidate()
        updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: tableView, selector: "reloadData", userInfo: nil, repeats: false)
        
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            //println("Insert")
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


class OpenAssignmentTableViewController: UITableViewController {

    private var updateTimer:NSTimer!
    // let unassignedClient = Client.getUnassignedClient()
    

    
    
    private lazy var fetchedResultsController:NSFetchedResultsController! = {
        
        let components = NSCalendar.currentCalendar().components(kAllCalendarUnits, fromDate: NSDate())
        components.hour = 0
        components.minute = 0
        components.second = 0
        let dateAtStartOfDay = NSCalendar.currentCalendar().dateFromComponents(components)!
        
        let request = NSFetchRequest(entityName: kAssignmentEntity)
        request.sortDescriptors = [NSSortDescriptor(key: kAssignmentOrder, ascending: false)]
        request.predicate = NSPredicate(format: "begin >= %@", dateAtStartOfDay)
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

        self.view.backgroundColor = kColorBackground
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: kFontThin, NSForegroundColorAttributeName: kColorStandard, NSBackgroundColorAttributeName: kColorBackground]
        
        // keine leere Zeile im TableView unterhalb
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.title = "Day View"

        
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
        let sections = fetchedResultsController.sections?[section]
        return sections?.numberOfObjects ?? 0
        //        return (fetchedResultsController.sections?[section] as? NSFetchedResultsSectionInfo)?.numberOfObjects ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kOpenAssignmentTableViewCell, forIndexPath: indexPath) as! OpenAssignmentTableViewCell
        
        cell.backgroundColor = kColorBackground
        cell.assignment = fetchedResultsController.objectAtIndexPath(indexPath) as! Assignment
        
        return cell
    }
    
    //MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        /*
        let editOpenAssignmentViewController = self.storyboard!.instantiateViewControllerWithIdentifier("EditOpenAssignmentViewController") as! EditOpenAssignmentViewController
        
        self.navigationController!.pushViewController(editOpenAssignmentViewController, animated: true)
        */
        if segue.identifier == kOpenAssignmentTableViewControllerSegue {
            if let indexPath = tableView.indexPathForSelectedRow, assignment = fetchedResultsController.objectAtIndexPath(indexPath) as? Assignment {
                if let controller = segue.destinationViewController as? EditOpenAssignmentViewController {
                    controller.assignment = assignment
                }
            }
        }

    }
    
    override func viewWillDisappear(animated: Bool) {
        //save data
        CoreData.sharedInstance.saveContext()
    }

}
