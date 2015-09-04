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
    
    var client:Client! {
        didSet {
            title = client.name
        }
    }
    
    private lazy var fetchedResultsController:NSFetchedResultsController! = {
        let request = NSFetchRequest(entityName: kAssignmentEntity)
        request.sortDescriptors = [NSSortDescriptor(key: kAssignmentOrder, ascending: true)]
        request.predicate = NSPredicate(format: "client == %@", self.client)
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreData.sharedInstance.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        fetchedResultsController.performFetch(nil)
        return fetchedResultsController
        } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addAssignment:")
        let deleteAllButton = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: "deleteAll:")
        
        navigationItem.setRightBarButtonItems([addButton, deleteAllButton], animated: true)
    }
    
    deinit {
        // zum zeigen des weak self beim observer für die sytem fonts
        // println(__FUNCTION__ + " : " + __FILE__.lastPathComponent)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fontSizeObserver = NSNotificationCenter.defaultCenter().addObserverForName(UIContentSizeCategoryDidChangeNotification, object: nil, queue: NSOperationQueue.mainQueue()) { [weak self](notification) -> Void in
            self?.tableView.reloadData()
            
        }
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        updateTimer?.invalidate()
        NSNotificationCenter.defaultCenter().removeObserver(fontSizeObserver)
    }
    
    // MARK: - barButtonItemActions
    func addAssignment(sender:UIBarButtonItem) {
        
        let title = NSLocalizedString("titleCreateAssignmentDialog", tableName: nil, bundle: NSBundle.mainBundle(), value: "Create new Assignment", comment: "titel in alert view controller")
        let placeholder = NSLocalizedString("placeholderCreateAssignmentDialog", tableName: nil, bundle: NSBundle.mainBundle(), value: "Assignment", comment: "placeholder for inputTextField in alert view controller")
        let message = NSLocalizedString("messageCreateAssignmentDialog", tableName: nil, bundle: NSBundle.mainBundle(), value: "Type in your Assignment desicription", comment: "messager in alert view controller")
        let ok = NSLocalizedString("okButton", tableName: nil, bundle: NSBundle.mainBundle(), value: "Ok", comment: "ok Button Label")
        let cancel = NSLocalizedString("cancelButton", tableName: nil, bundle: NSBundle.mainBundle(), value: "Cancel", comment: "cancel button label")
        
        let dialog = bMHelper.singleTextFieldDialogWithTitle(title, message: message, placeholder: placeholder, textFieldValue: "", ok: ok, cancel: cancel) { [weak self] (text) -> Void in
            Assignment.createAssignmentForClient(self!.client, withDescription: text)
        }
        
        presentViewController(dialog, animated: true, completion: nil)
    }
    
    
    func deleteAll(sender:UIBarButtonItem) {
        
        let title = NSLocalizedString("titleDeleteAllAssignmentDialog", tableName: nil, bundle: NSBundle.mainBundle(), value: "Delete all Assignment for this Client", comment: "titel in alert view controller")
        let message = NSLocalizedString("messageDeleteAllAssignmentDialog", tableName: nil, bundle: NSBundle.mainBundle(), value: "Do you want to delete all Assignment?", comment: "messager in alert view controller")
        let ok = NSLocalizedString("okButtonDeleteAllAssignment", tableName: nil, bundle: NSBundle.mainBundle(), value: "Yes, delete all Assignment", comment: "delete all Assignment ok Button Label")
        let cancel = NSLocalizedString("cancelButtonDeleteAllAssignment", tableName: nil, bundle: NSBundle.mainBundle(), value: "Cancel", comment: "cancel button label")
        
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
        return (fetchedResultsController.sections?[section] as? NSFetchedResultsSectionInfo)?.numberOfObjects ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kAssignmentTableViewCell, forIndexPath: indexPath) as! AssignmentTableViewCell
        
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
            assignmentCell.disableNameButton()
        }
    }
    override func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
        if let assignmentCell = tableView.cellForRowAtIndexPath(indexPath) as? AssignmentTableViewCell {
            assignmentCell.enableNameButton()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // hier kommt wahrscheinlich die edit function mit einem subview hinein
    }

}
