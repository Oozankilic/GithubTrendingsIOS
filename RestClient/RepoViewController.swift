//
//  RepoViewController.swift
//  RestClient
//
//  Created by ozan kilic on 19.07.2022.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

class RepoViewController: UIViewController {
    
    init(informationWith info: RepositoryInformation){
        self.repoDetails = info
        super.init(nibName: nil, bundle: nil)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var repoDetails: RepositoryInformation
    let containerView = UIView(frame: .zero)
    let backgroundView = UIView(frame: .zero)
    let subContainerView = UIView(frame: .zero)
    
    func setUp(){
        containerView.backgroundColor = R.color.gray()
        backgroundView.backgroundColor = R.color.backgroundBlack()
        containerView.layer.cornerRadius = 10
        subContainerView.backgroundColor = R.color.white()
        
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        view.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(50.0)
            make.top.bottom.equalToSuperview().inset(100.0)
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissal))
        backgroundView.addGestureRecognizer(tapGestureRecognizer)
        
        let repoName: UILabel = {
            let l = UILabel()
            l.text = repoDetails.full_name
            l.font = UIFont.preferredFont(forTextStyle: .title1)
            l.baselineAdjustment = .alignCenters
            l.textAlignment = .center
            
            return l
        }()
        
        let watchers: UILabel = {
            let l = UILabel()
            l.backgroundColor = R.color.gray()
            l.textColor = R.color.black()
            l.text = "  Watchers \t" + String(repoDetails.stargazers_count)
            l.font = UIFont.preferredFont(forTextStyle: .headline)
            l.layer.cornerRadius = 100
            return l
        }()
        
        let size: UILabel = {
            let l = UILabel()
            l.backgroundColor = R.color.gray()
            l.textColor = R.color.black()
            l.text = "  Size     \t" + String(repoDetails.size) + " KB"
            l.font = UIFont.preferredFont(forTextStyle: .headline)
            l.layer.cornerRadius = 100
            return l
        }()
        
        let forks_count: UILabel = {
            let l = UILabel()
            l.backgroundColor = R.color.gray()
            l.textColor = R.color.black()
            l.text = "  Forks    \t" + String(repoDetails.forks_count)
            l.font = UIFont.preferredFont(forTextStyle: .headline)
            l.layer.cornerRadius = 100
            return l
        }()
        
        let stargazers_count: UILabel = {
            let l = UILabel()
            l.backgroundColor = R.color.gray()
            l.textColor = R.color.black()
            l.text = "  Stars    \t" + String(repoDetails.stargazers_count)
            l.font = UIFont.preferredFont(forTextStyle: .headline)
            l.layer.cornerRadius = 100
            return l
        }()
        
        let created_at : UILabel = {
            let l = UILabel()
            l.backgroundColor = R.color.gray()
            l.textColor = R.color.black()
            l.text = "  Created at \t" + dateEditor(from: repoDetails.created_at)
            l.font = UIFont.preferredFont(forTextStyle: .headline)
            l.layer.cornerRadius = 100
            return l
        }()
        
        let updated_at : UILabel = {
            let l = UILabel()
            l.backgroundColor = R.color.gray()
            l.textColor = R.color.black()
            l.text = "  Updated at \t" + dateEditor(from: repoDetails.updated_at)
            l.font = UIFont.preferredFont(forTextStyle: .headline)
            l.layer.cornerRadius = 100
            return l
        }()
        
        let imageView = UIImageView()
        
        let url = URL(string: repoDetails.owner.avatar_url)
        let processor = RoundCornerImageProcessor(cornerRadius: 100)
        imageView.kf.setImage(with: url, options: [.processor(processor)])
        
        containerView.addSubview(imageView)
        imageView.snp.makeConstraints{ (make) in
            make.top.equalTo(containerView.snp.top).offset(10)
            make.height.width.equalTo(100)
            make.centerX.equalTo(containerView.snp.centerX)
        }
        
        containerView.addSubview(repoName)
        repoName.snp.makeConstraints{ (make) in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(containerView)
        }
        
        containerView.addSubview(subContainerView)
        subContainerView.snp.makeConstraints{ (make) in
            make.top.equalTo(repoName.snp.bottom).offset(10)
            make.bottom.trailing.leading.equalTo(containerView)
        }
        
        subContainerView.addSubview(watchers)
        watchers.snp.makeConstraints{ (make) in
            make.top.equalTo(subContainerView).offset(4)
            make.height.equalTo(70)
            make.leading.equalTo(subContainerView).offset(4)
            make.trailing.equalTo(subContainerView).offset(-4)
        }
        subContainerView.addSubview(size)
        size.snp.makeConstraints{ (make) in
            make.top.equalTo(watchers.snp.bottom).offset(4)
            make.height.equalTo(watchers)
            make.leading.equalTo(subContainerView).offset(4)
            make.trailing.equalTo(subContainerView).offset(-4)
        }
        subContainerView.addSubview(forks_count)
        forks_count.snp.makeConstraints{ (make) in
            make.top.equalTo(size.snp.bottom).offset(4)
            make.height.equalTo(watchers)
            make.leading.equalTo(subContainerView).offset(4)
            make.trailing.equalTo(subContainerView).offset(-4)
        }
        
        subContainerView.addSubview(stargazers_count)
        stargazers_count.snp.makeConstraints{ (make) in
            make.top.equalTo(forks_count.snp.bottom).offset(4)
            make.height.equalTo(watchers)
            make.leading.equalTo(subContainerView).offset(4)
            make.trailing.equalTo(subContainerView).offset(-4)
        }
        
        subContainerView.addSubview(created_at)
        created_at.snp.makeConstraints{ (make) in
            make.top.equalTo(stargazers_count.snp.bottom).offset(4)
            make.height.equalTo(watchers)
            make.leading.equalTo(subContainerView).offset(4)
            make.trailing.equalTo(subContainerView).offset(-4)
        }

        subContainerView.addSubview(updated_at)
        updated_at.snp.makeConstraints{ (make) in
            make.top.equalTo(created_at.snp.bottom).offset(4)
            make.height.equalTo(watchers)
            make.leading.equalTo(subContainerView).offset(4)
            make.trailing.equalTo(subContainerView).offset(-4)
        }
        
    }
    
    func dateEditor(from str: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") 
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:str)!
        dateFormatter.dateFormat = "YYYY/MM/dd"
        return dateFormatter.string(from:date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    @objc func dismissal() {
        dismiss(animated: true, completion: nil)
    }
}
