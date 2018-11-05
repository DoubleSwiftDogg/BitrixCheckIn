//
//  WebViewController.swift
//  BitrixCheckIn
//
//  Created by MacBook on 26.10.2018.
//  Copyright © 2018 PB. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    let defaults = UserDefaults.standard
    var personId: String?
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Создаем вьюшки
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        
        //Создаем кнопку
        let button = UIButton(frame: CGRect(x: 5, y: 35, width: 200, height: 30))
        button.setTitle("Настройка ИД", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        view.addSubview(button)
        
        //Дефолтное значение ИД при первом запуске
        if defaults.string(forKey: "personId") == nil {
            defaults.set("0", forKey: "personId")
        }
        
        //И в конце мы загружаем страницу согласно ИД
        loadBitrix()
    }
    
    //Нажатие кнопки "Принять"
    @objc func buttonAction(sender: UIButton!) {
        let ac = UIAlertController(title: "Ваш ИД", message: "Введите ваш ИД", preferredStyle: .alert)
        ac.addTextField { (tf) in
            tf.placeholder = self.personId
            tf.keyboardType = UIKeyboardType.numberPad
        }
        let action = UIAlertAction(title: "Принять", style: .default) { (action) in
            if ac.textFields![0].text?.isEmpty == false {
                let id = ac.textFields![0].text
                self.defaults.set(id, forKey: "personId")
                self.loadBitrix()
            } else {
                ac.dismiss(animated: true, completion: nil)
            }
        }
        ac.addAction(action)
        self.present(ac, animated: true, completion: nil)
    }
    
    //Загрузка нужной ссылки
    func loadBitrix() {
        self.personId = self.defaults.string(forKey: "personId")
        let url: URL! = URL(string: "https://bitrix.belbeton.ru/local/zhbk1/apps/hmap/index.php?u=" + personId!)
        let request = URLRequest(url: url)
        self.webView.load(request)
    }
}
