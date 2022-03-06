//
//  PSBookTableViewCell.swift
//  PolestarDemo
//
//  Created by Ajay Awasthi on 04/03/22.
//

import UIKit

class PSBookTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var bookCover: UIImageView!
    
    @IBOutlet weak var publishedDate: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var bookTitle: UILabel!
    
    var bookCellModel : PSBookCellModel? {
        didSet {
            bookTitle.text = bookCellModel?.title
            bookAuthor.text = bookCellModel?.authorName
            publishedDate.text = bookCellModel?.publish_date
            
            if let url =  bookCellModel?.imageUrl {
                if url.count > 0{
                    let formattedUrl = NSString.init(format:"\(PSUrlConstants.BookCoverBaseURL)%@-M.jpg" as NSString, url)
                    guard let imgUrl = URL(string: formattedUrl as String) else { return }
                    self.bookCover.load(urlString: imgUrl.absoluteString)
                }
            } else {
                self.bookCover.image = UIImage(named: "ps_no_image")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
