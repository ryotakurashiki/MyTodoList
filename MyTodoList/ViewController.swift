//
//  ViewController.swift
//  MyTodoList
//
//  Created by 倉敷亮太 on 2016/10/27.
//  Copyright © 2016年 倉敷亮太. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var todoList = [MyTodo]()
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func tapAddButton(_ sender: AnyObject) {
        // アラートダイアログを生成
        let alertController = UIAlertController(
            title: "TODO追加",
            message: "TODOを入力して下さい",
            preferredStyle: UIAlertControllerStyle.alert)
        
        // テキストエリアを表示
        alertController.addTextField(configurationHandler: nil)
        
        // OKボタンを追加
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            (action:UIAlertAction) -> Void in
            // OKボタンが押された時の処理
            if let textField = alertController.textFields?.first {
                // TODOの配列に入力した値を挿入。銭湯に挿入する。
                let myTodo = MyTodo()
                myTodo.todoTitle = textField.text!
                self.todoList.insert(myTodo, at: 0)
                
                // テーブルに行が追加されたことをテーブルに通知
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableViewRowAnimation.right)
                
                // 保存
                let data :NSData = NSKeyedArchiver.archivedData(withRootObject: self.todoList) as NSData
                
                let userDefaults = UserDefaults.standard
                userDefaults.set(data, forKey: "todoList")
                //userDefaults.set(textField.text, forKey: "todoList")
                userDefaults.synchronize()
            }
        }
        
        // OKボタンを追加
        alertController.addAction(okAction)
        
        // CANCELボタンがタップされたときの処理
        let cancelAction = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.cancel, handler: nil)
        // CANCELボタンを追加
        alertController.addAction(cancelAction)
        
        // アラートダイアログを表示
        present(alertController, animated: true, completion: nil)
    }
    
    //テーブルの要素数を設定する（sectionの数） ※必須
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //テーブルの行数を設定する ※必須
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    //表示するセルの中身を設定する ※必須
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        // storyboardで指定したtodoCell識別子を利用して再利用可能なセルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath as IndexPath)
        // 行番号に合ったToDoを取得
        let myTodo = todoList[indexPath.row]
        // セルのラベルにToDoのタイトルをセット
        cell.textLabel!.text = myTodo.todoTitle
        // false, trueの確認
        if myTodo.todoDone{
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        return cell
    }
    
    //セルをタップしたときの処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath) {
        print("hogehoeg")
        let todo = todoList[indexPath.row]
        if todo.todoDone {
            todo.todoDone = false
        } else {
            todo.todoDone = true
        }
        //セルの状態を変更
        //self.tableView.reloadData()
        self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        
        // 保存
        let data :NSData = NSKeyedArchiver.archivedData(withRootObject: self.todoList) as NSData
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "todoList")
        //userDefaults.set(textField.text, forKey: "todoList")
        userDefaults.synchronize()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 保存していたtodoListの取得
        //let userDefaults = UserDefaults.init()
        let userDefaults = UserDefaults.standard
        if let todoListData = userDefaults.object(forKey: "todoList") as? NSData {
            if let storedTodoList = NSKeyedUnarchiver.unarchiveObject(with: todoListData as Data) as? [MyTodo] {
                todoList.append(contentsOf: storedTodoList)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

class MyTodo: NSObject, NSCoding {
    var todoTitle :String?
    var todoDone :Bool = false
    
    override init(){
    }
    
    // NSCodingデシリアライズ
    required init?(coder aDecoder: NSCoder) {
        todoTitle = aDecoder.decodeObject(forKey: "todoTitle") as? String
        todoDone = aDecoder.decodeBool(forKey: "todoDone")
    }
    
    //シリアライズ
    func encode(with aCoder: NSCoder) {
        aCoder.encode(todoTitle, forKey: "todoTitle")
        aCoder.encode(todoDone, forKey: "todoDone")
    }
        
}

