//
//  CommentViewController.swift
//  
//
//  Created by Garrett Head on 6/19/18.
//

import UIKit


class CommentViewController: UIViewController {

    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewBottomConstraint: NSLayoutConstraint!
    var postId :String!
    var comments = [Comment]()
    var users = [RepHubUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Comments"
        tableView.dataSource = self
        tableView.estimatedRowHeight = 77
        tableView.rowHeight = UITableView.automaticDimension
        self.empty()
        self.validateTextFields()
        self.loadComments()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.comments.removeAll()
        self.users.removeAll()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification){
        print("showing keyboard" )
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        UIView.animate(withDuration: 0.3, animations: {
            self.viewBottomConstraint.constant = keyboardFrame!.height
            self.view.layoutIfNeeded()
        })
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification){
        UIView.animate(withDuration: 0.1, animations: {
            self.viewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    
    private func loadComments(){

    API.PostComments.POST_COMMENT_DB_REF.child(self.postId).observe(.childAdded, with: {
            snapshot in
            print("post-comment key: \(snapshot.key)")
            API.Comment.observeComments(withCommentId: snapshot.key, completion: {
                comment in
                self.fetchUser(uid: comment.uid!, completed: {
                    self.comments.append(comment)
                    self.tableView.reloadData()
                })
            })
            
        })
    }
    
    private func fetchUser(uid : String, completed: @escaping() -> Void ){
        // helps to fetch all posts and users simultaniously to help the cells not have to do all the work.
       
            API.RepHubUser.observeUser(withId: uid, completion: {
                user in
                self.users.append(user)
                completed()
            })
    }
 
    private func validateTextFields() {
        self.commentTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
    }
    
    @objc private func textFieldDidChange(){
        // checks any of the textfields has input
        if let comment = commentTextField.text, !comment.isEmpty {
            self.sendButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            self.sendButton.isEnabled = true
            return
        }

            self.sendButton.setTitleColor(UIColor.lightText, for: UIControl.State.normal)
            self.sendButton.isEnabled = false

    }
    
    
    // MARK: IBActions
    @IBAction func sendComment(_ sender: Any) {
        let commentsReference = API.Comment.COMMENT_DB_REF
        let newCommentId = commentsReference.childByAutoId().key
        let newCommentReference = commentsReference.child(newCommentId)
        guard let currentUser = API.RepHubUser.CURRENT_USER else {
            return
        }
        let currentUserId = currentUser.uid
        newCommentReference.setValue(["uid": currentUserId, "comment": commentTextField.text!],  withCompletionBlock: {
            (error, ref) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            let words = self.commentTextField.text!.components(separatedBy: CharacterSet.whitespacesAndNewlines)
            for var word in words {
                if word.hasPrefix("#") {
                    word = word.trimmingCharacters(in: CharacterSet.punctuationCharacters)
                    let newHashTagRef = API.HashTag.HASHTAG_DB_REF.child(word.lowercased())
                    newHashTagRef.updateChildValues([self.postId:true])
                }
            }
            let postCommentsReference = API.PostComments.POST_COMMENT_DB_REF.child(self.postId).child(newCommentId)
            postCommentsReference.setValue(true, withCompletionBlock: { (error, ref) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                API.Post.observePost(withId: self.postId, completion: { (post) in
                    if post.uid! != API.RepHubUser.CURRENT_USER!.uid {
                        let timestamp = NSNumber(value: Int(Date().timeIntervalSince1970))
                        let newNotificationId = API.Notification.NOTIFICATION_DB_REF.child(post.uid!).childByAutoId().key
                        let newNotificationReference = API.Notification.NOTIFICATION_DB_REF.child(post.uid!).child(newNotificationId)
                        newNotificationReference.setValue(["from": API.RepHubUser.CURRENT_USER!.uid, "objectId": self.postId!, "type": "comment", "timestamp": timestamp])
                    }
                    
                })
                
            })
            self.empty()
            self.view.endEditing(true)
        })
    }
    
    private func empty() {
        commentTextField.text = ""
        self.sendButton.isEnabled = false
        self.sendButton.setTitleColor(UIColor.lightText, for: UIControl.State.normal)
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewLocker" {
            let userLockerVC = segue.destination as! UserLockerViewController
            let userId = sender as! String
            userLockerVC.userId = userId
        }
        if segue.identifier == "HashTag" {
            let hashTagVC = segue.destination as! HashTagViewController
            let hashTag = sender as! String
            hashTagVC.hashTag = hashTag
        }
    }

}

extension CommentViewController : UITableViewDataSource {
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count
    }
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Comment", for: indexPath) as! CommentTableViewCell
        let comment = self.comments[indexPath.row]
        let user = self.users[indexPath.row]
        cell.comment = comment
        cell.user = user
        cell.delegate = self
        return cell
    }
}

extension CommentViewController : CommentCellDelegate {
    func goToUserLockerVC(userId: String) {
        performSegue(withIdentifier: "ViewLocker", sender: userId)
    }
    func goToHashTagVC(hashtag: String) {
        performSegue(withIdentifier: "HashTag", sender: hashtag)
    }
}
