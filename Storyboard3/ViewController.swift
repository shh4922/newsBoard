//
//  ViewController.swift
//  Storyboard3
//
//  Created by HyeonHo on 2023/02/25.
//

import UIKit


class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var TableViewMain: UITableView!
    
    var newsData : Array<Dictionary<String, Any>>?
    
    //1. http 통신방법 - urlsession
    //2. JSON 데이터 형태
    //3. 테이블뷰에 데이터 매칭하기.
    
    
    
    /**
     신기한게 함수명이 모두 같아.
     전부다 tableView라는 함수인데 매개변수랑 리턴값만다른데, 어케 호출하는거지?
     이건약간 상속받아서 쓰는거같긴한디.. 따로 override라고 된게없으니 좀 헷갈리네
     */
    
    
    //tableview 테이블로된 뷰 -> 여러개의 행이 모인 뷰 -> 리사이클러뷰 느낌
    //1. 데이터 뭐임?
    //2. 데이터가 몇개?
    //3. 데이터 행 event true/false ?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let news = newsData{
            return news.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //무엇을 보여줄건데?
        
        let cell = TableViewMain.dequeueReusableCell(withIdentifier: "Type1", for: indexPath) as! Type1
        
        let idx = indexPath.row
        if let news = newsData {
            
            let row = news[idx]
            
            // as? , as! -> 부모자식 친자확인 -> 상속확인하는듯.
            if let r = row as? Dictionary<String,Any>{
                if let title = r["title"] as? String {
                    cell.LabelText.text = title
                }
                
            }
            
        }
        
        
        
        
        return cell
        
    }
    
    // 클릭 이벤트
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)")
        
    }
    

    
    func getNews(){
        let task = URLSession.shared.dataTask(with: URL(string: "https://newsapi.org/v2/top-headlines?country=kr&apiKey=587e77693c3a41419084d5b0afa9ab0d")!) { data, response, error in
            
            if let jsonData = data{
                
                //Json 파싱
                //android 와 마찬가지로 try catch를 하는데, do안에 try문을넣고 do밑에 catch문
                do {
                    let json = try JSONSerialization.jsonObject(with: jsonData,options: []) as! Dictionary<String, Any>
                    
                    let articles = json["articles"] as! Array<Dictionary<String, Any>>
                    
                    //do안에 들어가있으니 self를 이용하여, "viewController에서 쓰는 newsData야!" 라고 알려줘야함.
                    self.newsData = articles
                    
                    //비동기로 그려라.
                    DispatchQueue.main.async {
                        //새로운게 들어왔을때 테이블을 다시 그리는 느낌
                        self.TableViewMain.reloadData()
                    }
                    
                        
                }catch{
                    print("error")
                }
                
            }
            
        }
        task.resume()
    }
    
    //화면이 Load된 후
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableViewMain.delegate = self
        TableViewMain.dataSource = self
        getNews()
    }
    
    
}

