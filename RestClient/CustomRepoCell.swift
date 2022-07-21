//
//  CustomCell.swift
//  RestClient
//
//  Created by ozan kilic on 19.07.2022.
//

import Rswift
import Reusable
import Foundation
import UIKit
import Kingfisher

class CustomRepoCell: UITableViewCell, Reusable {
    let mainStack = UIStackView()
    let stackImageView = UIImageView()
    
    let labelInfo: UILabel = {
        let v = UILabel()
        v.backgroundColor = R.color.backgroundBlack()
        v.layer.cornerRadius = 5
        v.layer.masksToBounds = true
        return v
    }()
    
    let labelDescription : UILabel = {
        let v = UILabel()
        v.textColor = R.color.white()
        v.font = UIFont.preferredFont(forTextStyle: .callout)
        return v
    }()
    
    let labelTitle: UILabel = {
        let v = UILabel()
        v.textColor = R.color.white()
        v.font = UIFont.preferredFont(forTextStyle: .title2)
        return v
    }()
    
    let labelStars: UILabel = {
        let v = UILabel()
        v.textColor = R.color.yellow()
        v.font = UIFont.preferredFont(forTextStyle: .callout)
        return v
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(mainStack)
        mainStack.backgroundColor = R.color.gray()
        mainStack.layer.cornerRadius = 5
        
        mainStack.snp.makeConstraints{ (make) in
            make.top.leading.equalTo(2)
            make.bottom.trailing.equalTo(-2)
        }
        
        mainStack.addSubview(labelInfo)
        labelInfo.snp.makeConstraints{ (make) in
            make.top.equalTo(10)
            make.trailing.bottom.equalTo(-10)
        }
        
        labelInfo.addSubview(labelTitle)
        labelTitle.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.leading.equalTo(5)
        }
        
        labelInfo.addSubview(labelDescription)
        labelDescription.snp.makeConstraints{ (make) in
            make.top.equalTo(labelTitle.snp.bottom)
            make.leading.equalTo(10)
        }
        
        labelInfo.addSubview(labelStars)
        labelStars.snp.makeConstraints{ (make) in
            make.top.equalTo(labelDescription.snp.bottom)
            make.leading.equalTo(10)
        }

        
        mainStack.addSubview(stackImageView)
        stackImageView.snp.makeConstraints{ (make) in
            make.top.leading.equalTo(10)
            make.bottom.equalTo(-10)
            make.trailing.equalTo(labelInfo.snp.leading).offset(-5)
            make.width.height.equalTo(75)
        }
        
    }
    
    func prepare(title: String, imageUrl: URL, description: String, stars: String) {
        labelTitle.text = title
        let processor = RoundCornerImageProcessor(cornerRadius: 150)
        stackImageView.kf.setImage(with: imageUrl, options: [.processor(processor)])
        labelDescription.text = description
        labelStars.text = stars
    }
    
    override func prepareForReuse() {
        labelTitle.text = ""
    }
}

