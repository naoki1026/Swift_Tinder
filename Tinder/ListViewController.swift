//
//  ListViewController.swift
//  Tinder
//
//  Created by Naoki Arakawa on 2019/03/03.
//  Copyright © 2019 Naoki Arakawa. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    //情報を受け取るための変数を作る
    var likedName = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

       print(likedName)
       tableView.dataSource = self
    }
    
    //セルの数をいくつにするか
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return likedName.count
        
    }
    
    //セルの中身を表現していく
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //セルを作成するという指示になる
        //withidentifierは識別子のことである
        //indexPathはセルの何番目の情報かということを指している
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        //もしこのようにしたら、likeされるたびにaaaと表示されるようになる
        //cell.textLabel?.text = "a"
        
        //indexPathは今のセルのな番号を指している
        cell.textLabel?.text = likedName[indexPath.row]
        
        //tableView.dequeueReusableCellを代入したcellをここでは返している
        return cell
    }
    
    
}
