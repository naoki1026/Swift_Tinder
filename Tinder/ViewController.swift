//
//  ViewController.swift
//  Tinder
//
//  Created by Naoki Arakawa on 2019/03/01.
//  Copyright © 2019 Naoki Arakawa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var basicCard: UIView!
    @IBOutlet weak var likeImageView: UIImageView!
    
    
    
    
    @IBOutlet weak var person4: UIView!
    @IBOutlet weak var person3: UIView!
    @IBOutlet weak var person2: UIView!
    @IBOutlet weak var person1: UIView!
    
    
    //CGPointは、縦、横の位置で指定した点を管理する構造体
    var centerOfCard : CGPoint!
    
    //person1~person4を入れるための変数を宣言する
    //複数の値を入れるための入れ物のこと
    var people = [UIView]()
    
    //この変数の数字を変えることによって、配列から取り出す
    //peopleを切り替えたいタイミングで１をプラスしていく
    var selectedCardCount : Int = 0
    
    //people1~4までの名前、もともとあるカードの情報
    let name = ["ほのか", "あかね", "みほ", "カルロス"]
    
    //選択されたカードの情報をこの中に入れる
    var likedName = [String]()
    

    
    
    //この中に書かれた処理は、アプリが起動した時に一番初めにこの中身が呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //真ん中の情報をcardOfCenterに代入しており、これは最初の初期値に戻す時に使用する
        //つまり初期値に戻す時に使用する
        centerOfCard = basicCard.center
        
        //画面が呼ばれてすぐの場所で、viewを定義した配列の中に入れていく
        //peopleの中にpersonが入った状態
        people.append(person1)
        people.append(person2)
        people.append(person3)
        people.append(person4)
        
    }
    
    //元に戻す処理を関数にしていく
    //繰り返し使用したい処理の場合は、関数にする
    func resetCard() {
        
        //初期値に戻る,これがアニメーションの内容
        //クラスのviewControllerの直下にある変数をクロージャの中で使う場合は、先頭にselfをつけないとエラーになってしまう
        //ここでのselfはviewController自身を指している
        //viewControllerの中のcenterOfCardですよということをselfを使って明示している
        
        //ここのcardは最初は、func swipeCardの中に定義していたため、エラーになってしまうため、basiccardに変更する
        basicCard.center = self.centerOfCard
        
        
        //カードの傾きを元にもどす
        basicCard.transform = .identity
    
    }
    
    
    
    @IBAction func likedButton(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2,  animations: {
            
            //右まで行ったらcardは元の位置に戻す
            self.resetCard()
            
            self.people[self.selectedCardCount].center = CGPoint(x: self.people[self.selectedCardCount].center.x + 500, y: self.people[self.selectedCardCount].center.y)
            
        })
        
        //これを行うことで、名前の情報が変数の中に入る
        //カードをプラス１する前にこの式を記述する
        likedName.append(name[selectedCardCount])
        
        
        //スワイプするタイミングで足していく
        selectedCardCount += 1
        likeImageView.alpha = 0
        
        
        
        //一番最後のカードがスワイプされたとき
        if selectedCardCount >= people.count {
            
            let listViewController : ListViewController = self.storyboard?.instantiateViewController(withIdentifier : "next") as! ListViewController
            
            listViewController.likedName = likedName
            
            //画面遷移
            self.navigationController?.pushViewController(listViewController, animated: true)
            
        }
        
        
    }
    
    
    @IBAction func dislikedButton(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2, animations: {
            
            //左まで行ったらcardは元の位置に戻す
            self.resetCard()
            
            self.people[self.selectedCardCount].center = CGPoint(x: self.people[self.selectedCardCount].center.x - 500, y: self.people[self.selectedCardCount].center.y)
            
        })
        
        //スワイプするタイミングで足していく
        
        selectedCardCount += 1
        likeImageView.alpha = 0
        
        //一番最後のカードがスワイプされたとき
        if selectedCardCount >= people.count {
            
            //print(likedName)
            //withIdentiFierにはセグエのIdentifierの名前、senderにはこのview自身であるためselfと入力する
            //performSegue(withIdentifier: "PushList", sender: self)
            
            
            
            let listViewController : ListViewController = self.storyboard?.instantiateViewController(withIdentifier : "next") as! ListViewController
            
            listViewController.likedName = likedName
            
            //画面遷移
            self.navigationController?.pushViewController(listViewController, animated: true)
            
            
        }
        
    }
    
    //ドラッグ&ドロップされた時にこの中の処理が行われる
    //storyboardにある情報をviewcontrollerに紐づけるために行われている
    //funcは関数を表しており、材料を使って、何かを処理するための一連の処理である（工場のようなもの）
    //引数は工場で例えるならば材料のようなものである、今回の場合はbasicCardに関する情報がsenderの中に入っている
    //senderの中の何か、ドラッグ&ドロップされたものの情報から自分の必要な情報を取り出して、処理していくのが関数の中身
    //関数の引数名の省略
    //senderの中のviewが、つまりbasicCardの中のviewをカードの中に入れている、cardの位置情報を動かすことによってドラッグ&ドロップした時に同じようについてくる
    @IBAction func swipeCard(_ sender: UIPanGestureRecognizer) {
        
        //カードの位置情報をスワイプに合わせてカードも一緒に動かしたい
        let card = sender.view!
    
        
        //どれくらい動いたかを把握したい
        //スワイプに関する情報はsenderの中に入っている
        //pointの中にどれくらい動いたかの位置情報が入る
        //translationのメソッドの中では、一番大元のviewを指しており、viewを基準としてどれくらい動いたかという
        //情報をpointの中に入れている
        let point = sender.translation(in: view)
        
        //この１行を入れることで、指に吸い付いてくるようになる
        sender.setTranslation(CGPoint.zero, in: view)
        
        //X座標とY座標で指定したものを中に入れる
        //カードのセンターに対して、もともとのカードのセンターのX座標とY座標を入れている
        //つまり動かないということであるが、それに対してスワイプした分を足しているので、
        //スワイプした分だけ動くという処理になっている
        card.center = CGPoint(x: card.center.x + point.x, y: card.center.y + point.y)
        
        //person1の位置を変えていく
        people[selectedCardCount].center = CGPoint(x: card.center.x + point.x, y: card.center.y + point.y)
        
        //viewは基準となるviewであるが、その中心と、カードの中心の差分を取っている
        //絶対値は端に行くほど大きくなる、真ん中からどれだけ離れているか
        let xFromCenter = card.center.x - view.center.x
        
        //角度を変える
        //cardのtransformにアクセスする
        //rotationAngleにどれくらい傾けるかという値を入れる
        //ラジアンとは365度が2πであわらされる数字（グーグルでラジアン、45度で検索すると出てきて、それが-0.785)
        //(view.frame.width / 2)で画面の半分の長さを出すことができる
        //xFromCenter / (view.frame.width / 2)で0から１、もしくは0から-1という範囲で値が動く
        card.transform = CGAffineTransform(rotationAngle: xFromCenter / (view.frame.width / 2) * -0.785 )
        
        people[selectedCardCount].transform = CGAffineTransform(rotationAngle: xFromCenter / (view.frame.width / 2) * -0.785 )
        
        //右にスワイプする時の処理内容
        if xFromCenter > 0 {
            
            likeImageView.image = UIImage(named: "good")
            likeImageView.alpha = 1
            
            //ここで色を変えることができる
            likeImageView.tintColor = UIColor.blue
            
            
        //左にスワイプする時の処理内容
        } else if xFromCenter < 0{
            
            likeImageView.image = UIImage(named: "bad")
            likeImageView.alpha = 1
            
            //ここで色を変えることができる
            likeImageView.tintColor = UIColor.red
            
            
        }
        
        //タッチして戻した時にカードを初期値に戻したい、離した時限定の処理を書いていく
        //スワイプして離した時はこの中の処理がおこなれる
        //senderはスワイプされた時の情報でstateを呼んでいる、UIGestureRecognizer.State.endedで指が離れた時ということを示している
        //今のスワイプの状態が指が離れた状態ならということを示している
        if sender.state == UIGestureRecognizer.State.ended {
            
            //左に大きくスワイプする時の処理
            //カードのX座標が75ポイントよりも小さくなった場合
            
            if card.center.x < 75 {
                UIView.animate(withDuration: 0.2, animations: {
                    
                //左まで行ったらcardは元の位置に戻す
                self.resetCard()
                    
                    self.people[self.selectedCardCount].center = CGPoint(x: self.people[self.selectedCardCount].center.x - 350, y: self.people[self.selectedCardCount].center.y)
                    
                })
                
                //スワイプするタイミングで足していく
                
                selectedCardCount += 1
                likeImageView.alpha = 0
                
                //一番最後のカードがスワイプされたとき
                if selectedCardCount >= people.count {
                    
                    //print(likedName)
                    //withIdentiFierにはセグエのIdentifierの名前、senderにはこのview自身であるためselfと入力する
                    //performSegue(withIdentifier: "PushList", sender: self)

                    
                    
                   let listViewController : ListViewController = self.storyboard?.instantiateViewController(withIdentifier : "next") as! ListViewController
                    
                  listViewController.likedName = likedName
                    
                    //画面遷移
                    self.navigationController?.pushViewController(listViewController, animated: true)
                    
                    
                }
            
                //関数から抜ける処理で、これを行わないと元に戻る処理が行われる
                return
                
                //self.viewでデバイス自体のviewを指している
            } else if card.center.x > self.view.frame.width - 75 {
                UIView.animate(withDuration: 0.2,  animations: {
                    
            //右まで行ったらcardは元の位置に戻す
            self.resetCard()
                    
                    self.people[self.selectedCardCount].center = CGPoint(x: self.people[self.selectedCardCount].center.x + 350, y: self.people[self.selectedCardCount].center.y)
                    
            })
                
                //これを行うことで、名前の情報が変数の中に入る
                //カードをプラス１する前にこの式を記述する
                likedName.append(name[selectedCardCount])
                
                
                //スワイプするタイミングで足していく
                selectedCardCount += 1
                likeImageView.alpha = 0
                
              
                
                //一番最後のカードがスワイプされたとき
                if selectedCardCount >= people.count {
                    
                    let listViewController : ListViewController = self.storyboard?.instantiateViewController(withIdentifier : "next") as! ListViewController
                    
                    listViewController.likedName = likedName
                    
                    //画面遷移
                    self.navigationController?.pushViewController(listViewController, animated: true)
                    
                }
            
                    
            
            //関数から抜ける処理で、これを行わないと元の位置に戻る処理が行われる
            return
                
            }
            
            //最初の位置に戻る動きをゆっくりな状態にする
            //animationの中身は無名関数（クロージャ）である
            UIView.animate(withDuration: 0.2, animations: {
                
                //初期値に戻る,これがアニメーションの内容
                //クラスのviewControllerの直下にある変数をクロージャの中で使う場合は、先頭にselfをつけないとエラーになってしまう
                //ここでのselfはviewController自身を指している
                //viewControllerの中のcenterOfCardですよということをselfを使って明示している
               // card.center = self.centerOfCard
                
                
                //カードの傾きを元にもどす
                //card.transform = .identity
                
                self.resetCard()
                self.people[self.selectedCardCount].center = self.centerOfCard
                 self.people[self.selectedCardCount].transform = .identity
               
                
            })
            
            //UIImgeViewを透明な状態に戻す
            likeImageView.alpha = 0
        }
    }

}
