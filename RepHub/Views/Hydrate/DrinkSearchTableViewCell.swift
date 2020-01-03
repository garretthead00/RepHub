//
//  DrinkSearchTableViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 1/1/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import UIKit

protocol DrinkSearchDelegate {
    func updateSearchText(text: String)
}

class DrinkSearchTableViewCell: UITableViewCell {
    

    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var searchText : String?
    var isSearching: Bool = false
    var delegate : DrinkSearchDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func updateView(){
    }
    
    

}

extension DrinkSearchTableViewCell : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.isSearching = false
        } else {
            self.isSearching = true
        }
        self.delegate?.updateSearchText(text: searchText)
    }
}
