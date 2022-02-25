//
//  ViewController.swift
//  NewsApp
//
//  Created by Darrien Huntley on 2/25/22.
//

import UIKit
import SafariServices

// Table view

class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource  {

    // You can embed your view into a navigation controller via storybaord
    /*
     1. Click the black bar above the phone
     2. Select Editor at the top | embed in | Navigation Controller
     3. Title defulats to inline but you can select perfers large title to get the large title
     */
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsTableViewCell.self,
                       forCellReuseIdentifier:NewsTableViewCell.identifier)
        return table
    }()     
    
    
    private var articles  = [Article]()
    private var viewModels = [NewsTableViewCellViewModel]()

     
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
        
        APICaller.shared.getTopStories { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(
                        title: $0.title,
                        subtitle: $0.description ?? "No Description",
                        imageURL: URL(string: $0.urlToImage ?? "")
                    )
                })
                
                DispatchQueue.main.async {
                    // Refresh / add to main
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // FRAME
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    // Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsTableViewCell.identifier,
            for: indexPath
        ) as? NewsTableViewCell else {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
     
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
 
        guard let url = URL(string: article.url ?? "") else{
          //  print("error")
            return
        }
        
        print(url)
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    // hightforrow
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

}

