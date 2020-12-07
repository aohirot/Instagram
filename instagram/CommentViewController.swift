//
//  CommentViewController.swift
//  instagram
//
//  Created by Hiromichi Aoki on 11/30/20.
//  Copyright © 2020 Hiromichi Aoki. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import SVProgressHUD

class CommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentText: UITextField!
    
    var commentPostArray: [String] = []
    
    var postData: PostData!

    //投稿ボタンをタップした時に呼ばれるメソッド
    @IBAction func commentPostButton(_ sender: Any) {
       
        //コメント入力欄に文字が入力されているか確認する
        if let typedComment = commentText.text {
        //文字が無い場合は
            if typedComment.isEmpty {
                SVProgressHUD.showError(withStatus: "コメントを入力するでござるよ。ニンニン！！")
                SVProgressHUD.dismiss(withDelay: 3)
                return
            }
           
            //ユーザ名
           let userName = Auth.auth().currentUser?.displayName

            //更新データ作成
            var updateValue: FieldValue
            
            //name　ユーザ名データを追加する更新データを作成
 //          updateValue = FieldValue.arrayUnion([userName as Any])
            let commentName = userName! + ": " + typedComment
             //コメントデータを追加する更新データを作成
            updateValue = FieldValue.arrayUnion([commentName])
            //commentに更新データを書き込む
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            
            //コメント用
            postRef.updateData(["comment": updateValue])
            
            //ユーザ名用
            //postRef.updateData(["userName": updateValue])
            
            commentPostArray = postData.comment
            
            //HUDで完了報告
                  SVProgressHUD.showSuccess(withStatus: "コメント投稿しました")
                  //入力欄を空にする
                  commentText.text = ""
            
                       //tableViewの表示を更新する
                       self.tableView.reloadData()
            
                  //HUDを消す
                  //キーボードを引っ込ませる
                  dismissKeyboard()
           SVProgressHUD.dismiss(withDelay: 1)
            
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "コメント"
        let backbutton = UIButton(type: .custom)
        backbutton.setImage(UIImage(named: "BackButton.png"), for: .normal) // Image can be downloaded from here below link
        backbutton.setTitle("戻る", for: .normal)
        backbutton.setTitleColor(backbutton.tintColor, for: .normal) // You can change the TitleColor
        backbutton.addTarget(self, action: #selector(self.backAction), for: .touchUpInside)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
        
        commentPostArray = postData.comment
        
        tableView.delegate = self
        tableView.dataSource = self
        commentText.delegate = self
        
        //カスタムセルを登録する
        let nib = UINib(nibName: "CommentTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CommentCell")
        
        // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
      
        // Listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    //MARK: Back Button related
    @objc func backAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
   //MARK: Keyboard related
    @objc func dismissKeyboard(){
        // キーボードを閉じる
        view.endEditing(true)
    }
    
    deinit {
        //Stop listening for keyboard hide/show events
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func hideKeyboard(){
        commentText.resignFirstResponder()
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
    
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
        view.frame.origin.y = -keyboardRect.height
        } else {
            view.frame.origin.y = 0
        }
    }


    //MARK: - UITableViewDataSource methods
    
    //データの数（=セルの数）を返すメソッドセルの配列の要素数を返します。
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentPostArray.count
    }
    
    //dequeueReusableCell(withIdentifier:for:)メソッドでを使ってセルを取得し、setCommentPostDataメソッドを呼び出してindexPathに対応するPostDataをセルへ表示するようにします。
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let commentCell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        commentCell.commentLabel.text = commentPostArray[indexPath.row]
        //commentCell.setCommentPostData(commentPostArray[indexPath.row])
    return commentCell
    }
 
    //画面を閉じてタブ画面に戻る↓
   // self.dismiss(animated: true, completion: nil)
}
