//
//  ClientTableViewController.swift
//  workTrackR
//
//  Created by Marc Bintinger on 29.08.15.
//  Copyright (c) 2015 Marc Bintinger. All rights reserved.
//

import UIKit
import CoreData

extension ClientTableViewController : NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
        CommandTunnel.addCommand(kPhoneChangedData)
        
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


class ClientTableViewController: UITableViewController {

    private var fontSizeObserver:NSObjectProtocol!
    private var updateTimer:NSTimer!
  
    private lazy var fetchedResultsController:NSFetchedResultsController! = {
        let request = NSFetchRequest(entityName: kClient)
        request.sortDescriptors = [NSSortDescriptor(key: kClientOrder, ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreData.sharedInstance.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        fetchedResultsController.performFetch(nil)
        return fetchedResultsController
    } ()

/* statt lazy var
    private var _fetchedResultsController:NSFetchedResultsController!
    private var fetchedResultsController:NSFetchedResultsController! {
        if _fetchedResultsController != nil {
            return _fetchedResultsController
        }
        
        let request = NSFetchRequest(entityName: kClient)
        request.sortDescriptors = [NSSortDescriptor(key: kClientOrder, ascending: true)]
        
        _fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreData.sharedInstance.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        _fetchedResultsController.delegate = self
        _fetchedResultsController.performFetch(nil)
        return _fetchedResultsController
    }
*/
    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("titleClientViewController", tableName: nil, bundle: NSBundle.mainBundle(), value: "Clients", comment: "the navigation bar title")
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addClient:")
        let editButton = UIBarButtonItem(barButtonSystemItem: .Organize, target: editButtonItem().target, action: editButtonItem().action)
        let deleteAllButton = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: "deleteAll:")
        
        navigationItem.setRightBarButtonItems([addButton, editButton, deleteAllButton], animated: true)
        
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        CommandTunnel.deleteAllCommands()
        
        tableView.reloadData()
        fontSizeObserver = NSNotificationCenter.defaultCenter().addObserverForName(UIContentSizeCategoryDidChangeNotification, object: nil, queue: NSOperationQueue.mainQueue()) { [weak self](notification) -> Void in
            self?.tableView.reloadData()
            
        }

    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(fontSizeObserver)
    }

    //MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == kAssignmentTableViewController {
            if let indexPath = tableView.indexPathForSelectedRow(), client = fetchedResultsController.objectAtIndexPath(indexPath) as? Client {
                if let controller = segue.destinationViewController as? AssignmentTableViewController {
                    controller.client = client
                }
            }
        }
    }
    
    // MARK: - barButtonItemActions
    func addClient(sender:UIBarButtonItem) {
        
        let title = NSLocalizedString("titleCreateClientDialog", tableName: nil, bundle: NSBundle.mainBundle(), value: "Create new Client", comment: "titel in alert view controller")
        let placeholder = NSLocalizedString("placeholderCreateClientDialog", tableName: nil, bundle: NSBundle.mainBundle(), value: "Client", comment: "placeholder for inputTextField in alert view controller")
        let message = NSLocalizedString("messageCreateClientDialog", tableName: nil, bundle: NSBundle.mainBundle(), value: "Type in your Clientname", comment: "messager in alert view controller")
        let ok = NSLocalizedString("okButton", tableName: nil, bundle: NSBundle.mainBundle(), value: "Ok", comment: "ok Button Label")
        let cancel = NSLocalizedString("cancelButton", tableName: nil, bundle: NSBundle.mainBundle(), value: "Cancel", comment: "cancel button label")

        let dialog = bMHelper.singleTextFieldDialogWithTitle(title, message: message, placeholder: placeholder, textFieldValue: "", ok: ok, cancel: cancel) { [weak self] (text) -> Void in
            Client.createWithName(text)
            
            /* let insertClient popup again
            bMHelper.delayOnMainQueue(0.3) { () -> Void in
                self?.addClient(sender)
            }*/
        }

        presentViewController(dialog, animated: true, completion: nil)
    }
    
    
    func deleteAll(sender:UIBarButtonItem) {
        
        let title = NSLocalizedString("titleDeleteAllClientDialog", tableName: nil, bundle: NSBundle.mainBundle(), value: "Delete all Clients", comment: "titel in alert view controller")
        let message = NSLocalizedString("messageDeleteAllClientDialog", tableName: nil, bundle: NSBundle.mainBundle(), value: "Do you want to delete all Clients?", comment: "messager in alert view controller")
        let ok = NSLocalizedString("okButtonDeleteAllClients", tableName: nil, bundle: NSBundle.mainBundle(), value: "Yes, delete all Clients", comment: "delete all clients ok Button Label")
        let cancel = NSLocalizedString("cancelButtonDeleteAllClients", tableName: nil, bundle: NSBundle.mainBundle(), value: "Cancel", comment: "cancel button label")
        
        let dialog = bMHelper.dialogWithTitle(title, message: message, ok: ok, cancel: cancel) {
            Client.deleteAll()
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
        let cell = tableView.dequeueReusableCellWithIdentifier(kClientTableViewCell, forIndexPath: indexPath) as! ClientTableViewCell
        
        cell.client = fetchedResultsController.objectAtIndexPath(indexPath) as! Client
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let client = fetchedResultsController.objectAtIndexPath(indexPath) as! Client
            client.delete()
        }
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        if (sourceIndexPath.row == destinationIndexPath.row) { return }
        
        let source = fetchedResultsController.objectAtIndexPath(sourceIndexPath) as! NSManagedObject
        let destination = fetchedResultsController.objectAtIndexPath(destinationIndexPath) as! NSManagedObject
        
        CoreData.move(kClient, orderAttributeName: kClientOrder, source: source, toDestination: destination)
        
        //den move update erzwingend im tableView updaten
        // tableView.reloadData()
        
        
        
    }
    

}