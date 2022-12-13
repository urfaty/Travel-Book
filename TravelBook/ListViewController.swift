//
//  ListViewController.swift
//  TravelBook
//
//  Created by Tayfur Salih Şen on 21.07.2022.
//

import UIKit
import CoreData

class ListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var titleArray = [String]()
    var idArray = [UUID]()
    
    var selectedTitle = ""
    var selectedTitleID : UUID?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))

        
        tableView.delegate = self
        tableView.dataSource = self
        
        getData()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newPlace"), object: nil)

    }
    
    
    
    
    
    
    
    @objc func getData(){
        

      
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      let context = appDelegate.persistentContainer.viewContext
      
      let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
      fetchRequest.returnsObjectsAsFaults = false
      
      do{
          let results = try context.fetch(fetchRequest)
          if results.count > 0{
              
              self.titleArray.removeAll(keepingCapacity: false)
              self.idArray.removeAll(keepingCapacity: false)
              
              for result in results as! [NSManagedObject]{
                  
                  if let title = result.value(forKey: "title") as? String{
                      self.titleArray.append(title)
                  }
                  
                  if let id = result.value(forKey: "id") as? UUID{
                      self.idArray.append(id)
                  }

                  self.tableView.reloadData()
              }
          
          }
          
          }catch{
          print("error")
      }
    }
    
    
    @objc func addButtonClicked(){
        selectedTitle = ""
        performSegue(withIdentifier: "toListViewController", sender: nil)
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = titleArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTitle = titleArray[indexPath.row]
        selectedTitleID = idArray[indexPath.row]
        performSegue(withIdentifier: "toListViewController", sender: nil)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toListViewController"{
            let destinationVC = segue.destination as! ViewController
            destinationVC.chosenTitle = selectedTitle
            destinationVC.chosenTitleID = selectedTitleID
            
            }
        
    }
   
}
