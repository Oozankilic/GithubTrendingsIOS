import UIKit
import SnapKit
import Kingfisher

class TrendingReposViewController: UIViewController {
    lazy var tbl: UITableView = {
        let v = UITableView()
        v.rowHeight = 100
        v.separatorStyle = .none
        v.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        v.delegate = self
        v.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        return v
    }()
    
    lazy var searchBar: UISearchBar = {
        let s = UISearchBar()
        s.placeholder = "Search by username"
        s.delegate = self
        return s
    }()
    
    
    let pageName: UILabel = {
        let l = UILabel()
        l.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        l.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        l.textAlignment = .center
        l.text = "Swift Trends"
        return l
    }()

    var allDescriptions: Initial!  {
        didSet{
            items.removeAll()
            items.append(contentsOf: (0..<30).map { allDescriptions.items[$0].full_name })
        }
    }
    
    var targetedDescriptions: Initial!
 
    var items: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.1195272843, green: 0.1195272843, blue: 0.1195272843, alpha: 1)
        
        items.append(contentsOf: (1...30).map { "Item \($0) loading.." })
        decodeAPI()        
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tbl.reloadData()
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
                    self.tbl.reloadData()
                }
            }
        }
        task.resume()
    }
    
    

    func setupUI() {
        tbl.delegate = self
        tbl.dataSource = self
        tbl.register(CustomCell.self, forCellReuseIdentifier: CustomCell.cellId)
        
        self.view.addSubview(pageName)
        self.view.addSubview(tbl)
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
        
        tbl.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
    func updateTargetedDescriptions(with indices: [Bool]) {
        targetedDescriptions.items.removeAll()
        items.removeAll()
        indices.indices.forEach { (index) in
            if indices[index]{
                let indexPath = IndexPath(item: index, section: 0)
                targetedDescriptions.items.append(allDescriptions.items[indexPath.row])
                items.append(allDescriptions.items[indexPath.row].full_name)
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
        self.tbl.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if targetedDescriptions != nil{
            return targetedDescriptions.items.count
        }else{
            return items.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.cellId, for: indexPath) as! CustomCell
        cell.lblTitle.text = items[indexPath.row]
        
        if targetedDescriptions != nil {
            if (targetedDescriptions.items[indexPath.row].owner.avatar_url != nil) {
                let url = URL(string: targetedDescriptions.items[indexPath.row].owner.avatar_url)
                let processor = RoundCornerImageProcessor(cornerRadius: 150)
                cell.lblImageView.kf.setImage(with: url, options: [.processor(processor)])
            }
            if (targetedDescriptions.items[indexPath.row].description != nil) {
                cell.lblDescription.text = targetedDescriptions.items[indexPath.row].description
            }
            cell.lblStars.text = "⭐️" + String(targetedDescriptions.items[indexPath.row].stargazers_count)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = RepoViewController(informationWith: targetedDescriptions.items[indexPath.row])
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
