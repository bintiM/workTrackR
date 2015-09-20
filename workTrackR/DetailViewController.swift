//
//  DetailViewController.swift
//  
//
//  Created by Marc Bintinger on 14.09.15.
//
//

import UIKit
import CoreData

class DetailViewController: UIViewController {

    var assignment:Assignment! {
        didSet {
            title = assignment.desc
        }
    }
    
    
    @IBOutlet weak var descTextFieldOutlet: UITextField!
    @IBOutlet weak var beginDateTextFieldOutlet: UITextField!
    @IBOutlet weak var endDateTextFieldOutlet: UITextField!
    
    @IBOutlet weak var didNotEndLabelOutlet: UILabel!
    @IBOutlet weak var durationLabelOutlet: UILabel!
    @IBOutlet weak var switchEndDatePickerOutlet: UISwitch!

    @IBOutlet weak var descLabelOutlet: UILabel!
    @IBOutlet weak var beginDateLabelOulet: UILabel!
    @IBOutlet weak var endDateLabelOutlet: UILabel!
   
    var beginDatePickerView:UIDatePicker = UIDatePicker()
    var endDatePickerView:UIDatePicker = UIDatePicker()
    var dateFormatter = NSDateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        
        descTextFieldOutlet.text = assignment.desc
        
        beginDateTextFieldOutlet.text = dateFormatter.stringFromDate(assignment.begin)
        
        beginDatePickerView.setDate(assignment.begin, animated: false)
        
        //check if there is an enddate
        if assignment.end.timeIntervalSince1970.distanceTo(0.0) != 0.0 {
            endDatePickerView.setDate(assignment.end, animated: false)
            switchEndDatePickerOutlet.on = false
            endDateTextFieldOutlet.text = dateFormatter.stringFromDate(assignment.end)

        } else {
            switchEndDatePickerOutlet.on = true
            endDateTextFieldOutlet.text = ""
        }

        // set initial borders for DatePickers
        beginDatePickerView.maximumDate = endDatePickerView.date
        endDatePickerView.minimumDate = beginDatePickerView.date

        
        updateDuration()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func beginDateTextFieldAction(sender: UITextField) {
        
        
        beginDatePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        
        
        sender.inputView = beginDatePickerView
        
        beginDatePickerView.addTarget(self, action: Selector("beginDatePickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    @IBAction func endDateTextFieldAction(sender: UITextField) {
        
        endDatePickerView.datePickerMode = UIDatePickerMode.DateAndTime
    
        sender.inputView = endDatePickerView
        
        endDatePickerView.addTarget(self, action: Selector("endDatePickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }

    
    func beginDatePickerValueChanged(sender:UIDatePicker) {
        beginDateTextFieldOutlet.text = dateFormatter.stringFromDate(sender.date)
        updateDuration()
    }
    
    func endDatePickerValueChanged(sender:UIDatePicker) {
        endDateTextFieldOutlet.text = dateFormatter.stringFromDate(sender.date)
        switchEndDatePickerOutlet.on = false
        updateDuration()
    }
    
    override func viewWillDisappear(animated: Bool) {
        //save data
        assignment.desc = descTextFieldOutlet.text
        assignment.begin = beginDatePickerView.date

        if switchEndDatePickerOutlet.on {
            let endDate = NSDate(timeIntervalSince1970: 0.0)
            assignment.end = endDate
        } else {
            assignment.end = endDatePickerView.date
        }
        
        CoreData.sharedInstance.saveContext()
    }
    
    @IBAction func toggleEndDate(sender: AnyObject) {
        if switchEndDatePickerOutlet.on {
            //did not end yet
            let endDate = NSDate(timeIntervalSince1970: 0.0)
            assignment.end = endDate
            endDateTextFieldOutlet.text = ""
            endDateTextFieldOutlet.resignFirstResponder()
        } else {
            assignment.end = endDatePickerView.date
        }
        
    }
    func updateDuration() {
        if assignment.end.timeIntervalSince1970.distanceTo(0.0) != 0.0 {
            var timeInterval = endDatePickerView.date.timeIntervalSinceDate(beginDatePickerView.date)
            durationLabelOutlet.text = stringFromTimeInterval(timeInterval) + " hh:mm"
        } else {
            durationLabelOutlet.text = "00:00 hh:mm"
        }
    }
    
    func stringFromTimeInterval(interval: NSTimeInterval) -> String {
        let interval = Int(interval)
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d", hours, minutes)
    }


}
