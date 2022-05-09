//
//  ViewController.swift
//  jesonParsing
//
//  Created by Abhay Kmar on 01/05/22.
//

import UIKit
struct User :Codable{
    var id:     Int
    var name:   String?
    var email:  String?
    var gender: String?
    var status: String?
}
class ViewController: UIViewController {
    @IBOutlet weak var userTable: UITableView!
    var userArray = [User]()
    let customQueue = DispatchQueue.init(label: "CustomQueue", qos: .background, attributes: .concurrent, target: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
    }
    func setUpData(){
        readData (fromURLStr: "https://gorest.co.in/public/v2/users")
    }
    func readData(fromURLStr: String){
        // updated code to handle fetch url
        guard let url:URL = URL(string: fromURLStr) else {
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer 7ac80325b16a21741993b2a7d7abaa1df48503016171d0a9b79d89cfe950c7e8", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared.dataTask(with: urlRequest) { data, urlResponse,error in
            if let response = urlResponse as? HTTPURLResponse{
                if(response.statusCode == 200){
                }
                if let responseData = data{
                    if let userArray: [User] = try? JSONDecoder().decode([User].self, from: responseData){
                        self.userArray = userArray
                        DispatchQueue.main.async {
                            self.userTable.reloadData()
                        }
                    }
                }
            }
        }
        session.resume()
    }
    @IBAction func createNewEntry(_ sender: Any) {
        //handle creation of new user
        let headerParams = ["Accept":"appliaction/json","Content-Type": "application/json","Authorization":"Bearer 7ac80325b16a21741993b2a7d7abaa1df48503016171d0a9b79d89cfe950c7e8"]
        let postParams = ["name":"Abhay KR 1 assa","status":"active","email":"abhay12345@gmail.com","gender":"male"]
        createNewUser(urlStr: "https://gorest.co.in/public/v2/users", postParam: postParams, headerParams: headerParams)
    }
    func createNewUser(urlStr:String,postParam:[String:String],headerParams:[String:String]){
        guard let url:URL = URL(string: urlStr) else {
            return
        }
        var request = URLRequest(url: url)
        if let jsonData = try? JSONSerialization.data(withJSONObject: postParam){
            request.httpBody = jsonData
        }
        for (key,value) in headerParams{
            request.addValue(value, forHTTPHeaderField: key)
        }
        request.httpMethod = "POST"
        URLSession.shared.dataTask(with: request){ data,URLResponse,error in
            if let errorExist = error {
                print("Error has occurred while accessing the url -> \(urlStr) for error \(errorExist.localizedDescription)")
                return
            }
            self.readData(fromURLStr: urlStr)
        }.resume()
    }
}
extension ViewController:UITableViewDataSource,UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "jesonTableViewCell") as! jesonTableViewCell
        let user = userArray[indexPath.row]
        if let name = user.name {
            cell.userName.text = name
            cell.userName.isHidden = false
        }
        else{
            cell.userName.isHidden = true
        }
        cell.userId.text =  String(user.id)
        if let status = user.status {
            cell.userStatus.text = status
            cell.userStatus.isHidden = false
        }
        else{
            cell.userStatus.isHidden = true
        }
        
        if let gender = user.gender {
            cell.userGender.text = gender
            cell.userGender.isHidden = false
        }
        else{
            cell.userGender.isHidden = true
        }
        if let email = user.email{
            cell.userEmail.text = email
            cell.userEmail.isHidden = false
        }
        else{
            cell.userEmail.isHidden = true
        }
        return cell
    }
}

