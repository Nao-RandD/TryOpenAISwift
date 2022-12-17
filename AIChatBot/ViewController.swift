//
//  ViewController.swift
//  AIChatBot
//
//  Created by naoyuki.kan on 2022/12/16.
//

import UIKit

class ViewController: UIViewController {
    
    private let field: UITextField = {
        let textField = UITextField()
        textField.placeholder = "話したい内容を記載してね"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .gray
        textField.returnKeyType = .done
        return textField
    }()
    
    private let table: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var models: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(field)
        view.addSubview(table)
        field.delegate = self
        table.delegate = self
        table.dataSource = self
        NSLayoutConstraint.activate([
            field.heightAnchor.constraint(equalToConstant: 50),
            field.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            field.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            field.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            
            table.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            table.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.bottomAnchor.constraint(equalTo: field.topAnchor)
        ])
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, !text.isEmpty {
            APICaller.shared.getRespose(input: text, completion: { result in
                switch result {
                case .success(let output):
                    self.models.append("質問: \(text)---回答：\(output)")
                    DispatchQueue.main.async {
                        self.table.reloadData()
                        self.field.text = ""
                    }
                case .failure(let err):
                    print("失敗", err)
                }
            })
        }
        return true
    }
}
