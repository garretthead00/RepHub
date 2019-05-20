//
//  ExerciseSearchTableViewCell.swift
//  RepHub
//
//  Created by Garrett on 4/13/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

protocol ExerciseSearchFilterDelegate {
    func filterBy(searchText: String)
}

class ExerciseSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var searchBar: UISearchBar!
    private var isSearching: Bool = false
    var delegate : ExerciseSearchFilterDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.searchBar.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension ExerciseSearchTableViewCell : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            print("not searching")
        } else {
            isSearching = true
            print("searching...")
            print(searchText)
            delegate?.filterBy(searchText: searchText)
            
        }
    }
}
