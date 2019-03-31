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
    
    //Запуск приложения
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Создаем вьюшки
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        
        //Создаем константы для размеров экрана
        let sizeScreenY = UIScreen.main.bounds.size.height
        let sizeScreenX = UIScreen.main.bounds.size.width
        
        //Создаем кнопку выбора ИД
        let idButton = UIButton(frame: CGRect(x: 5, y: sizeScreenY - 35, width: 160, height: 30))
        idButton.setTitle("Настройка ИД", for: .normal)
        idButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        idButton.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        idButton.addTarget(self, action: #selector(buttonActionID), for: .touchUpInside)
        view.addSubview(idButton)
        
        //Создаем кнопку выбора сотрудников отдела
        let memberButton = UIButton(frame: CGRect(x: sizeScreenX - 165, y: sizeScreenY - 35, width: 160, height: 30))
        memberButton.setTitle("Сотрудники", for: .normal)
        memberButton.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        memberButton.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        memberButton.addTarget(self, action: #selector(buttonActionMember), for: .touchUpInside)
        view.addSubview(memberButton)
        
        //Дефолтное значение ИД при первом запуске
        if defaults.string(forKey: "personId") == nil {
            defaults.set("0", forKey: "personId")
        }
        
        //И в конце мы загружаем страницу согласно ИД
        loadBitrix()
    }
    
    //Функционал кнопки "Настройка ИД"
    @objc func buttonActionID(sender: UIButton!) {
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
        self.present(ac, animated: true) {
            ac.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismiss)))
        }
    }
    
    //Функционал кнопки "Сотрудники"
    @objc func buttonActionMember(sender: UIButton!) {
        let ac = UIAlertController(title: "Выберите сотрудника", message: "", preferredStyle: .actionSheet)
        //Добавляем первым пункт "Назад"
        let backAction = UIAlertAction(title: "Назад", style: .destructive) { (action) in
            ac.dismiss(animated: true, completion: nil)
        }
        ac.addAction(backAction)
        //Затем циклом закатываем в наш алерт сотрудников и действия при выборе каждого из них
        for member in orderListNames {
            let key = member
            let action = UIAlertAction(title: key, style: .default) { (action) in
                let id = listID[member]
                self.defaults.set(id, forKey: "personId")
                self.loadBitrix()
            }
            ac.addAction(action)
        }
        
        self.present(ac, animated: true) {
            ac.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismiss)))
        }
    }
    
    
    //Загрузка нужной ссылки
    func loadBitrix() {
        self.personId = self.defaults.string(forKey: "personId")
        let url: URL! = URL(string: "https://bitrix.belbeton.ru/local/zhbk1/apps/hmap/index.php?u=" + personId!)
        let request = URLRequest(url: url)
        self.webView.load(request)
    }
}
