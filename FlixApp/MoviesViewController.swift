//
//  MoviesViewController.swift
//  FlixApp
//
//  Created by Anika Rawat on 9/25/20.
//  Copyright © 2020 arawat00@icloud.com. All rights reserved.
//

import UIKit
import AlamofireImage

//step 1 - added uitvds and delegate
class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //properties create
    //creation of an array of dictionaries like data is
    var movies = [[String:Any]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //step 3 write these:
        tableView.dataSource = self
        tableView.delegate = self

        // Do any additional setup after loading the view.
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            
            //casting involved here
            //movies stored all data from that chunk^ of code
            self.movies = dataDictionary["results"] as! [[String:Any]]
            self.tableView.reloadData() //calls my two below funcs to update movies and populate data 
              
              print(dataDictionary)
              // TODO: Get the array of movies
              // TODO: Store the movies in a property to use elsewhere
              // TODO: Reload your table view data

           }
        }
        task.resume()
    
    }
    
    //step 2 implement these two functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //lots of memory so if another cell is off screen give me recycled cell and if none left than new cell make
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell //cast to be able to access this as MovieCell
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String //casting again to string
        let synopsis = movie["overview"] as! String
        //swift optionals is the ? eventually learn
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        cell.posterView.af_setImage(withURL: posterUrl!)
  
        return cell
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        //sender is the cell that was tapped on
        
        //P2 first task: find the selected movie
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
        
        //P2 second task: pass the selected movie to the details controller
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie //second movie referring to let movie earlierr
        
        //we dont want to have the movie still selected after back on the scrolling so:
        tableView.deselectRow(at: indexPath, animated: true)
        
    }


}
