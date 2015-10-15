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
        self.view.backgroundColor = kColorBackground
        
        descLabelOutlet.font = kFontThin
        descLabelOutlet.textColor = kColorStandard
        
        beginDateTextFieldOutlet.font = kFontThin
        beginDateTextFieldOutlet.textColor = kColorStandard
        beginDateTextFieldOutlet.backgroundColor = kColorBackground
        beginDateTextFieldOutlet.layer.borderColor = kColorStandard.CGColor
        beginDateTextFieldOutlet.layer.borderWidth = 1.0
        
        endDateTextFieldOutlet.font = kFontThin
        endDateTextFieldOutlet.textColor = kColorStandard
        endDateTextFieldOutlet.backgroundColor = kColorBackground
        endDateTextFieldOutlet.layer.borderColor = kColorStandard.CGColor
        endDateTextFieldOutlet.layer.borderWidth = 1.0
        
        durationLabelOutlet.font = kFontThin
        durationLabelOutlet.textColor = kColorStandard
        
        descTextFieldOutlet.textColor = kColorStandard
        descTextFieldOutlet.font = kFontThin
        descTextFieldOutlet.backgroundColor = kColorBackground
        descTextFieldOutlet.layer.borderColor = kColorStandard.CGColor
        descTextFieldOutlet.layer.borderWidth = 1.0
        
        beginDateLabelOulet.font = kFontThin
        beginDateLabelOulet.textColor = kColorStandard
        
        endDateLabelOutlet.font = kFontThin
        endDateLabelOutlet.textColor = kColorStandard
        
        didNotEndLabelOutlet.font = kFontThin
        didNotEndLabelOutlet.textColor = kColorStandard
        
        switchEndDatePickerOutlet.onTintColor = kColorGreen
        switchEndDatePickerOutlet.tintColor = kColorStandard
        
        
        beginDatePickerView.backgroundColor = kColorBackground
        beginDatePickerView.tintColor = kColorStandard
        
        // beginDatePickerView.setValue(kColorStandard, forKeyPath: "textColor")
        // beginDatePickerView.setValue(1.0, forKeyPath: "alpha")

        endDatePickerView.backgroundColor = kColorBackground
        endDatePickerView.tintColor = kColorStandard

        // endDatePickerView.setValue(kColorStandard, forKeyPath: "textColor")
        // endDatePickerView.setValue(1.0, forKeyPath: "alpha")

        
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

        print("da:" + assignment.getCSV())
        
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
        assignment.desc = descTextFieldOutlet.text!
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
            let timeInterval = endDatePickerView.date.timeIntervalSinceDate(beginDatePickerView.date)
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
