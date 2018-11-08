//
//  ExamenTableViewController.swift
//  Examen 212
//
//  Created by Rodrigo Martín Martín on 08/11/2018.
//  Copyright © 2018 Rodri. All rights reserved.
//

import UIKit

struct Item: Codable {
    
    let title: String
    let image1: String
    let image2: String
    
}

class ExamenTableViewController: UITableViewController {

    let URLBASE = "https://www.dit.upm.es/santiago/examen/datos711.json"
    
    var items = [Item]()
    
    var imagesCache = [String:UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        download()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item Cell", for: indexPath) as! ItemTableViewCell

        // Configure the cell...
        
        let item = items[indexPath.row]
        
        cell.nameLabel.text = item.title
    
        if let img = imagesCache[item.image1] {
            
            cell.img1.image = img
            
        } else {
            
            cell.img1.image = UIImage(named: "none")
            download(item.image1, cucurucho: indexPath)
        }
        
        if let img = imagesCache[item.image2] {
            
            cell.img2.image = img
            
        } else {
            
            cell.img2.image = UIImage(named: "none")
            download(item.image2, cucurucho: indexPath)
        }

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func download() {
        
        guard let url = URL(string: URLBASE) else {
            print("Error 1")
            return
        }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url){
                let decoder = JSONDecoder()
                if let items = try? decoder.decode([Item].self, from: data) {
                    DispatchQueue.main.async {
                        self.items = items
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func download(_ urls: String, cucurucho indexpath: IndexPath) {
        
        print("Me estoy bajando", urls)
        
        DispatchQueue.global().async {
            
            if let urls2 = urls.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
                let url = URL(string: urls),
                let data = try? Data(contentsOf: url),
                let img = UIImage(data: data) {
                    
                    DispatchQueue.main.async {
                        self.imagesCache[urls] = img
                        self.tableView.reloadRows(at: [indexpath], with: .fade)
                    }
                
            } else {
                
                print("MAL", urls)
            }
        }
    }
}
