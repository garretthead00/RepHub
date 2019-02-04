//
//  PostSettingsTableViewController.swift
//  RepHub
//
//  Created by Garrett Head on 2/3/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

class PostSettingsTableViewController: UITableViewController {

    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var shareToInstagramSwitch: UISwitch!
    @IBOutlet weak var shareToFacebookSwitch: UISwitch!
    @IBOutlet weak var shareToSnapchatSwitch: UISwitch!
    @IBOutlet weak var disableCommentsSwitch: UISwitch!
    
    @IBOutlet weak var postCell: UITableViewCell!
    @IBOutlet weak var captionCell: UITableViewCell!
    @IBOutlet weak var locationCell: UITableViewCell!
    @IBOutlet weak var shareCell: UITableViewCell!
    @IBOutlet weak var settingsCell: UITableViewCell!
    
    var selectedImage : UIImage?
    var videoUrl : URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.clean()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelPost))
         self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(self.sharePost))
    }
    
    @objc private func sharePost(){
        view.endEditing(true)
        ProgressHUD.show("Posting...", interaction: false)
        if let photoImg = selectedImage, let imageData = photoImg.jpegData(compressionQuality: 1) {
            let ratio = photoImg.size.width / photoImg.size.height
            HelperService.uploadToServer(data: imageData, videoUrl: self.videoUrl, ratio: ratio, caption: captionTextView.text, isCommentsDisabled: self.disableCommentsSwitch.isOn, onSuccess: {
                self.clean()
                self.navigationController?.popToRootViewController(animated: true)
                self.tabBarController?.selectedIndex = 0
            })
        }
        else {
            ProgressHUD.showError("Please select an image.")
        }
    }
    
    @objc private func cancelPost(){
        self.clean()
        self.navigationController?.popViewController(animated: true)
        
    }
    
    private func clean(){
        
        self.selectedImage = nil
        self.videoUrl = nil
        captionTextView.text = ""
        shareToFacebookSwitch.isOn = false
        shareToSnapchatSwitch.isOn = false
        shareToInstagramSwitch.isOn = false
        disableCommentsSwitch.isOn = false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {
            case 0 : return 3
            default: return 1
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell!
        let section = indexPath.section
        let row = indexPath.row
        
        switch section {
            case 0 :
                if row == 0 {
                   cell = postCell
                    self.postImage.image = self.selectedImage
                } else if row == 1 {
                    cell = captionCell
                    captionTextView.text = ""
                    captionTextView.placeholder = "Caption"
                } else {
                    cell = locationCell
                    
                }
        case 1:
            cell = shareCell
            shareToFacebookSwitch.isOn = false
            shareToSnapchatSwitch.isOn = false
            shareToInstagramSwitch.isOn = false

        default:
            cell = settingsCell
            disableCommentsSwitch.isOn = false
        }
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
