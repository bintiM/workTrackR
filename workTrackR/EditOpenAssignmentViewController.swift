//
//  EditOpenAssignmentViewController.swift
//  workTrackR
//
//  Created by Marc Bintinger on 15.10.15.
//  Copyright © 2015 Marc Bintinger. All rights reserved.
//

import UIKit
import CoreData

public extension UITableView {
    
    public func deselectSelectedRowAnimated(animated: Bool) {
        if let indexPath = indexPathForSelectedRow {
            deselectRowAtIndexPath(indexPath, animated: animated)
        }
    }
    
}

extension EditOpenAssignmentViewController : NSFetchedResultsControllerDelegate {
    
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


class EditOpenAssignmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {


    private var updateTimer:NSTimer!
    let unassignedClient = Client.getUnassignedClient()
    var assignment:Assignment!
    
    
    private lazy var fetchedResultsController:NSFetchedResultsController! = {
        let request = NSFetchRequest(entityName: kClientEntity)
        request.sortDescriptors = [NSSortDescriptor(key: kClientOrder, ascending: false)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreData.sharedInstance.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch _ {
        }
        return fetchedResultsController
    } ()
  
    @IBOutlet weak var tableView: UITableView!  //<<-- TableView Outlet
    @IBOutlet weak var assignmentDesc: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.view.backgroundColor = kColorBackground
        self.assignmentDesc.text = assignment.desc
        
        
        // self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: kSelectClientTableViewCell)
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveAssignment:")
        
        navigationItem.setRightBarButtonItems([saveButton], animated: true)
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: kFontThin, NSForegroundColorAttributeName: kColorStandard, NSBackgroundColorAttributeName: kColorBackground]
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        //select first
        //tableView.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: false, scrollPosition: UITableViewScrollPosition.None)
        
    }
    
    func saveAssignment(sender:UIBarButtonItem) {
        CoreData.sharedInstance.saveContext()
        navigationController?.popViewControllerAnimated(true)

    }
    
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sections = fetchedResultsController.sections?[section]
        // print("anzahl rows in section: \(sections?.numberOfObjects)")
        return sections?.numberOfObjects ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier(kSelectClientTableViewCell, forIndexPath: indexPath) as! SelectClientTableViewCell
        
        let client = fetchedResultsController.objectAtIndexPath(indexPath) as! Client
        cell.client = client
        
        if client.name == assignment.client.name {
            cell.backgroundColor = kColorVeryLightGray
        } else {
            cell.backgroundColor = UIColor.whiteColor()
        }
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //set selected client for assignment
        assignment.client = fetchedResultsController.objectAtIndexPath(indexPath) as! Client
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        if (assignmentDesc.text != nil) {
            assignment.desc = assignmentDesc.text!
            CoreData.sharedInstance.saveContext()
        }
    }
    
    
}
