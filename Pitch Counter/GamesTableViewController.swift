//
//  GamesTableViewController.swift
//  Pitch Counter
//
//  Created by Ben Grass on 7/7/15.
//  Copyright (c) 2015 Ben Grass. All rights reserved.
//

import UIKit
import CoreData

class GamesTableViewController: UITableViewController {
    
    @IBOutlet var titleBar: UINavigationItem!
    var games = [NSManagedObject]()
    var pitcher: NSManagedObject!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addGame(sender: AnyObject) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let entity =  NSEntityDescription.entityForName("Game", inManagedObjectContext: managedContext)
        
        let game = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
        
        
        game.setValue(NSDate(), forKey: "date")
        game.setValue([Int](), forKey: "pitches")
        game.setValue(pitcher, forKey: "pitcher")
        
        var error: NSError?
        do {
            try managedContext.save()
        } catch let error1 as NSError {
            error = error1
            print("Could not save \(error), \(error?.userInfo)")
        }
        self.games.append(game)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        tableView.beginUpdates()
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        tableView.endUpdates()
        //self.tableView.reloadData()
    }

    func doPitcher(obj: NSManagedObject) {
        
        games = obj.valueForKey("games")!.allObjects as! [NSManagedObject]
        pitcher = obj
        let name = pitcher.valueForKey("name") as! String
        titleBar!.title = "\(name)'s Games"
        self.tableView.reloadData()
        
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return games.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("gamecell", forIndexPath: indexPath) 
        let date = games[games.count-(indexPath.row+1)].valueForKey("date") as! NSDate
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        cell.textLabel!.font = UIFont.systemFontOfSize(25)
        cell.textLabel!.adjustsFontSizeToFitWidth =  true
        cell.textLabel!.text = dateFormatter.stringFromDate(date)
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
            let game = games.removeAtIndex(games.count-(indexPath.row+1))
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext!
            managedContext.deleteObject(game)
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
        
        let dvc = segue.destinationViewController as! ViewController
        let index = self.tableView.indexPathForSelectedRow!.row
        dvc.loadData(games[games.count-(index+1)])
        
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    

}
