//
//  NewsTableViewCell.swift
//  iOS_assignment
//
//  Created by Yasir Khan on 02/02/2025.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsHeadLineLabel: UILabel!
    
    @IBOutlet weak var newsReportedByLabel: UILabel!
    
    @IBOutlet weak var newsSourceLabel: UILabel!
    @IBOutlet weak var newsPublishDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newsImageView.roundView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateNewsCell(news : NewsResult) {
        newsHeadLineLabel.text  = news.title
        newsReportedByLabel.text = news.byline
        newsSourceLabel.text = news.source.rawValue
        newsPublishDateLabel.text = news.publishedDate
    }
}

