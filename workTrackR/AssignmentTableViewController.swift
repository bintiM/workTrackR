//
//  AssignmentTableViewController.swift
//  workTrackR
//
//  Created by Marc Bintinger on 03.09.15.
//  Copyright (c) 2015 Marc Bintinger. All rights reserved.
//

import UIKit
import CoreData

extension AssignmentTableViewController : NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
        //sag der Uhr, dass sich etwas geändert hat
        CommandTunnel.addCommand(kChangedData)
        
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



class AssignmentTableViewController: UITableViewController {

    private var fontSizeObserver:NSObjectProtocol!
    private var updateTimer:NSTimer!
    private var commandTunnelTimer:NSTimer!
    
    var connectivityHandler : ConnectivityHandler!
    
    var client:Client! {
        didSet {
            title = client.name
        }
    }
    
    private lazy var fetchedResultsController:NSFetchedResultsController! = {
        let request = NSFetchRequest(entityName: kAssignmentEntity)
        request.sortDescriptors = [NSSortDescriptor(key: kAssignmentOrder, ascending: false)]
        request.predicate = NSPredicate(format: "client == %@", self.client)
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
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addAssignment:")
        let deleteAllButton = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: "deleteAll:")
        
        navigationItem.setRightBarButtonItems([addButton, deleteAllButton], animated: true)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: kFontThin, NSForegroundColorAttributeName: kColorStandard, NSBackgroundColorAttributeName: kColorBackground]
        
        // keine leere Zeile im TableView unterhalb
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
    }
    
    deinit {
        // zum zeigen des weak self beim observer für die sytem fonts
        // println(__FUNCTION__ + " : " + __FILE__.lastPathComponent)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        CommandTunnel.deleteAllCommands()
        
        fontSizeObserver = NSNotificationCenter.defaultCenter().addObserverForName(UIContentSizeCategoryDidChangeNotification, object: nil, queue: NSOperationQueue.mainQueue()) { [weak self](notification) -> Void in
            self?.tableView.reloadData()
            
        }
        
        //check new Commands for Updates from Watch
        commandTunnelTimer?.invalidate()
        commandTunnelTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "checkCommand", userInfo: nil, repeats: true)

        tableView.reloadData()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(fontSizeObserver)
        
        updateTimer?.invalidate()
        commandTunnelTimer?.invalidate()

    }
    
    //MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == kDetailViewController {
            if let indexPath = tableView.indexPathForSelectedRow, assignment = fetchedResultsController.objectAtIndexPath(indexPath) as? Assignment {
                if let controller = segue.destinationViewController as? DetailViewController {
                    controller.assignment = assignment
                }
            }
        }
    }

    
    func checkCommand() {
        if CommandTunnel.wasCommandAvailable(kChangedData) {
            CoreData.sharedInstance.managedObjectContext?.reset()
            tableView.reloadData()
        }
    }

    
    // MARK: - barButtonItemActions
    func addAssignment(sender:UIBarButtonItem) {
        
        let title = NSLocalizedString("titleCreateAssignmentDialog", value: "Create new Assignment", comment: "titel in alert view controller")
        let placeholder = NSLocalizedString("placeholderCreateAssignmentDialog", value: "Assignment", comment: "placeholder for inputTextField in alert view controller")
        let message = NSLocalizedString("messageCreateAssignmentDialog", value: "Type in your Assignment desicription", comment: "messager in alert view controller")
        let ok = NSLocalizedString("okButton", value: "Ok", comment: "ok Button Label")
        let cancel = NSLocalizedString("cancelButton", value: "Cancel", comment: "cancel button label")
        
        let dialog = bMHelper.singleTextFieldDialogWithTitle(title, message: message, placeholder: placeholder, textFieldValue: "", ok: ok, cancel: cancel) { [weak self] (text) -> Void in
            
            Assignment.createAssignmentForClientNow(self!.client, withDescription: text)
            try! self!.connectivityHandler.session.updateApplicationContext(["msg" : "\(text) started", "running" : true])
        }
        
        presentViewController(dialog, animated: true, completion: nil)
    }
    
    
    func deleteAll(sender:UIBarButtonItem) {
        
        let title = NSLocalizedString("titleDeleteAllAssignmentDialog", value: "Delete all Assignment for this Client", comment: "titel in alert view controller")
        let message = NSLocalizedString("messageDeleteAllAssignmentDialog", value: "Do you want to delete all Assignment?", comment: "messager in alert view controller")
        let ok = NSLocalizedString("okButtonDeleteAllAssignment", value: "Yes, delete all Assignment", comment: "delete all Assignment ok Button Label")
        let cancel = NSLocalizedString("cancelButtonDeleteAllAssignment", value: "Cancel", comment: "cancel button label")
        
        let dialog = bMHelper.dialogWithTitle(title, message: message, ok: ok, cancel: cancel) {
            Assignment.deleteAllForClient(self.client)
        }
        
        presentViewController(dialog, animated: true, completion: nil)
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
        let cell = tableView.dequeueReusableCellWithIdentifier(kAssignmentTableViewCell, forIndexPath: indexPath) as! AssignmentTableViewCell
        
        cell.backgroundColor = kColorBackground
        cell.assignment = fetchedResultsController.objectAtIndexPath(indexPath) as! Assignment
        
        return cell
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let assignment = fetchedResultsController.objectAtIndexPath(indexPath) as! Assignment
            assignment.delete()
        }
    }
    
    override func tableView(tableView: UITableView, willBeginEditingRowAtIndexPath indexPath: NSIndexPath) {
        if let assignmentCell = tableView.cellForRowAtIndexPath(indexPath) as? AssignmentTableViewCell {
            assignmentCell.disableEndButton()
        }
    }
    override func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
        if let assignmentCell = tableView.cellForRowAtIndexPath(indexPath) as? AssignmentTableViewCell {
            assignmentCell.enableEndButton()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // hier kommt wahrscheinlich die edit function mit einem subview hinein
        let assignment = fetchedResultsController.objectAtIndexPath(indexPath) as! Assignment
        assignment.switchState()
    }

}
