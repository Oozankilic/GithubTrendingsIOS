import UIKit
import SnapKit
import Kingfisher
import Rswift

class TrendingReposViewController: UIViewController {
    lazy var repoTable: UITableView = {
        let v = UITableView()
        v.rowHeight = 100
        v.separatorStyle = .none
        v.tintColor = R.color.black()
        v.delegate = self
        v.backgroundColor = R.color.blue()
        return v
    }()
    
    lazy var searchBar: UISearchBar = {
        let s = UISearchBar()
        s.placeholder = R.string.localizable.searchbar_placeholder()
        s.delegate = self
        return s
    }()
    
    
    let pageName: UILabel = {
        let l = UILabel()
        l.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        l.textColor = R.color.white()
        l.textAlignment = .center
        l.text = R.string.localizable.application_name()
        return l
    }()

    var allDescriptions: Initial!  {
        didSet{
            repoNames.removeAll()
            repoNames.append(contentsOf: (0..<30).map { allDescriptions.items[$0].full_name })
        }
    }
    
    var targetedDescriptions: Initial!
 
    var repoNames: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = R.color.backgroundBlack()
        
        repoNames = Array(repeating: R.string.localizable.loading_item(), count: 30)
        decodeAPI()        
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.repoTable.reloadData()
    }
    
    func decodeAPI(){
        guard let url = URL(string: "https://api.github.com/search/repositories?q=language:swift") else{return}

        let task = URLSession.shared.dataTask(with: url){
            data, response, error in
            
            let decoder = JSONDecoder()

            if let data = data{
                do{
                    let task = try decoder.decode(Initial.self, from: data)
                    self.allDescriptions = task
                    self.targetedDescriptions = self.allDescriptions
                }catch{
                    print(error)
                }
                DispatchQueue.main.async{
                    self.repoTable.reloadData()
                }
            }
        }
        task.resume()
    }
    
    

    func setupUI() {
        repoTable.delegate = self
        repoTable.dataSource = self
        repoTable.register(cellType: CustomRepoCell.self)
        
        repoTable.estimatedRowHeight = 85.0
        repoTable.rowHeight = UITableView.automaticDimension
        
        self.view.addSubview(pageName)
        self.view.addSubview(repoTable)
        self.view.addSubview(searchBar)
        
        pageName.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(50)
            make.height.equalTo(50)
            make.leading.trailing.equalTo(self.view)
        }
        
        searchBar.snp.makeConstraints { (make) in
            make.top.equalTo(pageName.snp.bottom)
            make.height.equalTo(55)
            make.leading.trailing.equalTo(self.view)
        }
        
        repoTable.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
    func updateTargetedDescriptions(with indices: [Bool]) {
        targetedDescriptions.items.removeAll()
        repoNames.removeAll()
        indices.indices.forEach { (index) in
            if indices[index]{
                let indexPath = IndexPath(item: index, section: 0)
                targetedDescriptions.items.append(allDescriptions.items[indexPath.row])
                repoNames.append(allDescriptions.items[indexPath.row].full_name)
            }
        }
    }

}


extension TrendingReposViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let userName = searchText.lowercased()
        var searchedIndices = allDescriptions.items.indices.map { allDescriptions.items[$0].full_name.lowercased().contains(userName) }
        
        if userName == "" {
            searchedIndices = []
            allDescriptions.items.forEach { (_) in
                searchedIndices.append(true)
            }
        }
        updateTargetedDescriptions(with: searchedIndices)
        self.repoTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if targetedDescriptions != nil{
            return targetedDescriptions.items.count
        }else{
            return repoNames.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CustomRepoCell.self) 
        let title = repoNames[indexPath.row]
        var imageUrl = URL(string: "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png")!
        var description = ""
        var stars = ""
        if targetedDescriptions != nil {
            if (targetedDescriptions.items[indexPath.row].owner.avatar_url != nil) {
                imageUrl = URL(string: targetedDescriptions.items[indexPath.row].owner.avatar_url)!
               
            }
            if (targetedDescriptions.items[indexPath.row].description != nil) {
                description = targetedDescriptions.items[indexPath.row].description
            }
           stars = "⭐️" + String(targetedDescriptions.items[indexPath.row].stargazers_count)
        }
        cell.prepare(title: title, imageUrl: imageUrl, description: description, stars: stars)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = RepoViewController(informationWith: targetedDescriptions.items[indexPath.row])
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
