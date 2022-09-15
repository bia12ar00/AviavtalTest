//
//  ViewController.swift
//  aviatal
//
//  Created by Bhavin Kevadia on 15/09/22.
//

import UIKit
import Alamofire
import SDWebImage
import CoreData

class ViewController: UIViewController {
    //MARK: - IBOutlet
    @IBOutlet weak var tblViewAppoiment: UITableView!
    
    var appoimentModelObj : AppointmentsDataModel?
    var appoimentData:[AppointmentsDatas] = []
    var cData = [CoreDataAppoiment]()
   
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Method

    private func setUpUI() {
        self.setTableView()
        getCoreDataFatch()
       getAppoimentsData()
    }
    
    private func setTableView() {
        self.tblViewAppoiment.dataSource = self
        self.tblViewAppoiment.delegate = self
        self.tblViewAppoiment.register(UINib(nibName: "AppointmentsTableViewCell", bundle: nil), forCellReuseIdentifier: "AppointmentsTableViewCell")
    }
    
    private func getCoreDataFatch() {
        let appDe = (UIApplication.shared.delegate) as! AppDelegate
        let context =  appDe.persistentContainer.viewContext
        
        do {
            let cDatas = try context.fetch(CoreDataAppoiment.fetchRequest())
            print(cDatas)
            for data in cDatas {
                print(cDatas)
                cData.append(data)
            }
            self.tblViewAppoiment.reloadData()
        } catch {
            print("Data SuccesFully Save Error")
        }
    }
    
     func removeAppoimentData() {
        let appDe = (UIApplication.shared.delegate) as! AppDelegate
        let context =  appDe.persistentContainer.viewContext
         
            let fetchRequest =
            NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataAppoiment")

            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try context.execute(deleteRequest)
            } catch let error as NSError {
                debugPrint("Could not save. \(error), \(error.userInfo)")
            }
        }
    //MARK: - ApiCalling
    
    private func getAppoimentsData() {
        
        Alamofire.request("https://interview.avital.in/ios_interview.json", method: .post, encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
               case .success:
                   if let value = response.result.value {
                       do {
                               let jsonData = try? JSONSerialization.data(withJSONObject:value as Any)
                               let decoder = JSONDecoder()
                               if let resulData = jsonData {
                                   self.appoimentModelObj = try decoder.decode(AppointmentsDataModel.self, from: resulData)
                                   self.removeAppoimentData()
                                   if let appimentd = self.appoimentModelObj?.data {
                                       self.appoimentData = appimentd
                                    
                                   }
                                   let appDe = (UIApplication.shared.delegate) as! AppDelegate
                                   let context =  appDe.persistentContainer.viewContext
                                 
                                   
                                   for data in self.appoimentData {
                                       let childata = NSEntityDescription.insertNewObject(forEntityName: "CoreDataAppoiment", into: context) as! CoreDataAppoiment
                                       childata.name = data.name ?? ""
                                       childata.imageUrl = data.imageUrl ?? ""
                                       childata.dateTime = data.time ?? ""
                                       childata.id = data.Id ?? ""
                                       do {
                                           try context.save()
                                         //  print("Data SuccesFully Save")
                                       } catch {
                                           print("Data SuccesFully Save Error")
                                       }
                                   }
   
                                   self.tblViewAppoiment.reloadData()
                               }
                            }
                        catch {
                           print("JSONSerialization error:", error)
                       }
                   }
               case .failure(let error):
                   print(error)
               }
        }
        
    }
    
    func convertDateFormater(date: String,fromFormate:String,toFormate:String) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = fromFormate
            let date = dateFormatter.date(from: date)
            dateFormatter.dateFormat = toFormate
            return  dateFormatter.string(from: date!)
        }
    
    func getTimeMituneAgo(startDate:String) -> String {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: startDate)

        let past = calendar.date(byAdding: .minute, value: -15, to: date ?? Date())
        
        dateFormatter.dateFormat = "hh:mm a"
       return dateFormatter.string(from: past!)
   
        

    }
    
}

extension ViewController :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  appoimentData.isEmpty ? cData.count : appoimentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentsTableViewCell", for: indexPath) as! AppointmentsTableViewCell
        if self.appoimentData.isEmpty {
            if self.cData.count > 0 {
                let data  = cData[indexPath.row]
                cell.lblName.text = data.name
                if let times = data.dateTime {
                 let date = convertDateFormater(date: times, fromFormate: "yyyy-MM-dd HH:mm:ss", toFormate: "d MMM")
                     let time = convertDateFormater(date: times, fromFormate: "yyyy-MM-dd HH:mm:ss", toFormate: "hh:mm a")
                    let pastTime = getTimeMituneAgo(startDate: times)
                        cell.lblDataAndTime.text = "\(date) \(time)-\(pastTime)"
                    
                }
                cell.profileImageView.sd_setImage(with: URL(string:data.imageUrl ?? ""), completed: nil)
            }
        } else {
            
        
        if self.appoimentData.count > 0 {
            let data  = appoimentData[indexPath.row]
            cell.lblName.text = data.name
            if let times = data.time {
             let date = convertDateFormater(date: times, fromFormate: "yyyy-MM-dd HH:mm:ss", toFormate: "d MMM")
                 let time = convertDateFormater(date: times, fromFormate: "yyyy-MM-dd HH:mm:ss", toFormate: "hh:mm a")
                let pastTime = getTimeMituneAgo(startDate: times)
                    cell.lblDataAndTime.text = "\(date) \(time)-\(pastTime)"
                
            }
            
            
            cell.profileImageView.sd_setImage(with: URL(string:data.imageUrl ?? ""), completed: nil)
        }
        }
        return cell
    }
    
    
}
