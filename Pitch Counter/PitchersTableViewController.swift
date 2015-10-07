//
//  PitchersTableViewController.swift
//  Pitch Counter
//
//  Created by Ben Grass on 7/7/15.
//  Copyright (c) 2015 Ben Grass. All rights reserved.
//

import UIKit
import CoreData

class PitchersTableViewController: UITableViewController {
    
    var pitchers = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        loadTableContents()
        
        
        
    }
    
    func loadTableContents() {
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"Pitcher")
        //3
        do {
            let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            pitchers = fetchedResults!
        
            self.tableView.reloadData()
            
        } catch _ as NSError {}
    }


    @IBAction func addPitcher(sender: AnyObject) {
        let alert = UIAlertController(title: "Add Pitcher", message: "Enter Name", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
            textField.placeholder = "Name"
            textField.autocapitalizationType = .Words
            textField.autocorrectionType = .No
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Enter", style: .Default, handler: { (action: UIAlertAction) -> Void in
            let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
            
            let managedContext = appDelegate.managedObjectContext!
            
            //2
            let entity =  NSEntityDescription.entityForName("Pitcher",
                inManagedObjectContext:
                managedContext)
            
            let pitcher = NSManagedObject(entity: entity!,
                insertIntoManagedObjectContext:managedContext)
            
            //3
            let textField: UITextField = alert.textFields![0] 
            
            pitcher.setValue(textField.text, forKey: "name")
            
            //4
            var error: NSError?
            do {
                try managedContext.save()
            } catch let error1 as NSError {
                error = error1
                print("Could not save \(error), \(error?.userInfo)")
            } catch {
                fatalError()
            }
            self.pitchers.append(pitcher)
            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.pitchers.count-1, inSection: 0)], withRowAnimation: .Automatic)
            self.tableView.endUpdates()

            //self.tableView.reloadData()

        }))
        presentViewController(alert, animated: true, completion: nil)

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return pitchers.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("pitchercell", forIndexPath: indexPath) 
        cell.textLabel!.font = UIFont.systemFontOfSize(25)
        cell.textLabel!.adjustsFontSizeToFitWidth =  true
        cell.textLabel!.text = (pitchers[indexPath.row].valueForKey("name") as! String)
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let pitcher = pitchers.removeAtIndex(indexPath.row)
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext!
            managedContext.deleteObject(pitcher)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dvc = segue.destinationViewController as! GamesTableViewController
        dvc.doPitcher(pitchers[self.tableView.indexPathForSelectedRow!.row])
        
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    

}
