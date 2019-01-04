//
//  JournalTableViewController.swift
//  RepHub
//
//  Created by Garrett Head on 12/14/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

class JournalTableViewController: UITableViewController {

    private var journalEntries = [JournalEntry]()
    private var workoutLogs = [WorkoutLog]()
    private var workoutNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadJournalEntries()
        
        self.tableView.estimatedRowHeight = 500
        self.tableView.rowHeight = UITableView.automaticDimension
    }

    private func loadJournalEntries(){
        
        guard let currentUser = API.RepHubUser.CURRENT_USER else {
            return
        }

        API.UserJournalEntries.USER_JOURNAL_ENTRIES_DB_REF.child(currentUser.uid).observe(.childAdded, with: {
            snapshot in
            API.WourkoutJournal.observeWorkoutJournalEntry(withId: snapshot.key, completion: {
                entry in
                self.journalEntries.append(entry)
                // get workout logs
                API.WorkoutLog.observeWorkoutLog(withId: entry.workoutLogId!, completion: {
                    log in
                    self.workoutLogs.append(log)
                    API.Workout.observeWorkout(withId: log.workoutId!, completion: {
                        workout in
                        print("workout found")
                        self.workoutNames.append(workout.name!)
                        self.tableView.reloadData()

                    })

                })
            })

        })
    
    }

    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.workoutNames.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500.0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "JournalEntry", for: indexPath) as! JournalEntryTableViewCell
        print("---Journal Counts----")
        print("journalEntries: \(self.journalEntries.count)")
        print("workoutLogs: \(self.workoutLogs.count)")
        print("workouts: \(self.workoutNames.count)")
        print("workouts: \(self.workoutNames.count)")
        let entry = self.journalEntries[indexPath.row]
        let workoutLog = self.workoutLogs[indexPath.row]
        let workoutName = self.workoutNames[indexPath.row]
        cell.journalEntry = entry
        cell.workoutLog = workoutLog
        cell.workoutName = workoutName
        return cell
    }
}
