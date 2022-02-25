//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Darrien Huntley on 2/25/22.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    static let identifier = "NewsTableViewCell"
    
    // title view
    private let newsTitleLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0 // line wraps
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    // sub title view
    private let newsSubTitleLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0 // line wraps
        label.font = .systemFont(ofSize: 17, weight: .light)
        return label
    }()
    
    // Image view
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground // gray color
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
   
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        // add to view...
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(newsSubTitleLabel)
        contentView.addSubview(newsImageView)
    }
    
    required init?(coder: NSCoder) { // short cut - require...
        fatalError()
    }
    
    // Sizing and Position
    override func layoutSubviews() { // short cut - layout...
        super.layoutSubviews()
        
        newsTitleLabel.frame = CGRect(
            x: 10,
            y: 0,
            width: contentView.frame.size.width - 170,
            height:  70
        )
        
        newsSubTitleLabel.frame = CGRect(
            x: 10,
            y: 70,
            width: contentView.frame.size.width - 170,
            height:  contentView.frame.size.height / 2
        )
        
        newsImageView.frame = CGRect(
            x: contentView.frame.size.width - 150,
            y: 5,
            width: 140,
            height:  contentView.frame.size.height - 10
        )
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitleLabel.text = nil
        newsSubTitleLabel.text = nil
        newsImageView.image = nil
    }
    
    func configure(with viewModel: NewsTableViewCellViewModel) {
        newsTitleLabel.text = viewModel.title
        newsSubTitleLabel.text = viewModel.subtitle
        
        // Image
        if let data = viewModel.imageData {
            newsImageView.image = UIImage(data: data)
        } else if let url = viewModel.imageURL{
            // fetch images...
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                viewModel.imageData = data
                
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
            
        }
    }
}
