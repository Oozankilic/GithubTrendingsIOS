//
//  CustomCell.swift
//  RestClient
//
//  Created by ozan kilic on 19.07.2022.
//

import Foundation
import UIKit

class CustomCell: UITableViewCell {
    static var cellId = "cell"
    
    let lblStack = UIStackView()
    
    let lblImageView = UIImageView()
    
    let lblInfo: UILabel = {
        let v = UILabel()
        v.backgroundColor = #colorLiteral(red: 0.1195272843, green: 0.1195272843, blue: 0.1195272843, alpha: 1)
        v.layer.cornerRadius = 5
        v.layer.masksToBounds = true
        return v
    }()
    
    let lblDescription : UILabel = {
        let v = UILabel()
        v.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        v.font = UIFont.preferredFont(forTextStyle: .callout)
        return v
    }()
    
    let lblTitle: UILabel = {
        let v = UILabel()
        v.textColor = .white
        v.font = UIFont.preferredFont(forTextStyle: .title2)
        return v
    }()
    
    let lblStars: UILabel = {
        let v = UILabel()
        v.textColor = .yellow
        v.font = UIFont.preferredFont(forTextStyle: .callout)
        return v
    }()
    
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        
        self.addSubview(lblStack)
        
        lblStack.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        lblStack.layer.cornerRadius = 5
        
        lblStack.snp.makeConstraints{ (make) in
            make.top.leading.equalTo(2)
            make.bottom.trailing.equalTo(-2)
        }
        
        lblStack.addSubview(lblInfo)
        lblInfo.snp.makeConstraints{ (make) in
            make.top.equalTo(10)
            make.trailing.bottom.equalTo(-10)
        }
        
        lblInfo.addSubview(lblTitle)
        lblTitle.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.leading.equalTo(5)
        }
        
        lblInfo.addSubview(lblDescription)
        lblDescription.snp.makeConstraints{ (make) in
            make.top.equalTo(lblTitle.snp.bottom)
            make.leading.equalTo(10)
        }
        
        lblInfo.addSubview(lblStars)
        lblStars.snp.makeConstraints{ (make) in
            make.top.equalTo(lblDescription.snp.bottom)
            make.leading.equalTo(10)
        }

        
        lblStack.addSubview(lblImageView)
        lblImageView.snp.makeConstraints{ (make) in
            make.top.leading.equalTo(10)
            make.bottom.equalTo(-10)
            make.trailing.equalTo(lblInfo.snp.leading).offset(-5)
            make.width.height.equalTo(75)
        }
        
    }
}

