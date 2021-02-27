//
//  ViewController.swift
//  Calculator
//
//  Created by takaki-d on 2021/02/15.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var workings: UILabel!
    @IBOutlet weak var results: UILabel!
    
    var value:String = ""
    var nums:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        clearAll()
    }

    func clearAll()
    {
        value = ""
        workings.text = ""
        results.text = ""
        nums = 0
    }
    
    func charFlag(c: Character) -> Bool
    {
        if(c == "*") {
            return true
        }
        if(c == "/") {
            return true
        }
        if(c == "+") {
            return true
        }
        return false
    }
    
    func ToResult(resultValue: Double) -> String
    {
        // resultValue % 1 == 0, つまり小数点の有無
        if(resultValue.truncatingRemainder(dividingBy: 1) == 0) {
            // Stirng(format: "桁数指定", 値)
            return String(format: "%.0f", resultValue)
        }
        // 小数点がある時，下位の5桁まで表示
        var stringValue:String = ""
        stringValue = String(format: "%.5f", resultValue)
        
        if(stringValue.hasSuffix("00000")) {
            return String(stringValue.dropLast(5))
        } else if(stringValue.hasSuffix("0000")) {
            return String(stringValue.dropLast(4))
        } else if(stringValue.hasSuffix("000")) {
            return String(stringValue.dropLast(3))
        }else if(stringValue.hasSuffix("00")) {
            return String(stringValue.dropLast(2))
        } else if(stringValue.hasSuffix("0")) {
            return String(stringValue.dropLast(1))
        }
        return stringValue
    }
    
    
    // 入力文字の判定の関数
    func inputFlag(str :String) ->Bool {
        var count = 0
        // int の配列の宣言
        var idx = [Int]()
        
        for c in str
        {
            if(charFlag(c: c)) {
                // count の値を保持
                idx.append(count)
            }
            count += 1
        }
        
        var pre: Int = -1
        
        for i in idx {
            // 最初に計算式がある
            if(i == 0)
            {
                return false
            }
            // 最後が計算式で終わっている
            if(i == str.count - 1)
            {
                return false
            }
            
            // 計算式の後にすぐ計算式が来る
            if(pre != -1) {
                if(i - pre == 1) {
                    return false
                }
            }
            pre = i
        }
        return true
    }
    
    func add(parm: String) {
        value = value + parm
        workings.text = value
        nums = 0
    }
    
    func add_num(parm: String) {
        if(nums != 0 && nums % 3 == 0) {
            add(parm: ",")
        }
        
        value = value + parm
        workings.text = value
        nums += 1
    }
    
    
    
    // ******************************
    // 以下，オプション部分
    @IBAction func clear(_ sender: Any) {
        if(!value.isEmpty)
            {
                value.removeLast()
                workings.text = value
                nums -= 1
            }
    }
 

    @IBAction func percent(_ sender: Any) {
        add(parm: "%")
    }
    
    
    @IBAction func point(_ sender: Any) {
        add(parm: ".")
    }
    
    // ******************************
    // 以下，電卓の機能部分
    
    @IBAction func allClear(_ sender: Any) {
        clearAll()
    }
    
    @IBAction func devide(_ sender: Any) {
        add(parm: "÷")
    }
    
    @IBAction func times(_ sender: Any) {
        add(parm: "×")
    }
    
    @IBAction func plus(_ sender: Any) {
        add(parm: "+")
    }
    
    @IBAction func minus(_ sender: Any) {
        add(parm: "-")
    }
    
    @IBAction func equal(_ sender: Any) {
        /*if(value.contains("÷0")) {
            let alert = UIAlertController(
                title: "エラー",
                message: "0 では割れません",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"ok", style: .default))
            self.present(alert, animated: true, completion: nil)
        } else */
        
        let change0 = value.replacingOccurrences(of: "%", with: "*0.01")
        let change1 = change0.replacingOccurrences(of: "×", with: "*")
        // NSExpression は Int を与えると割り算が Int で返ってくる
        // 強制的に Double にして，割り算に浮動小数点数が含まれるようにする
        let change2 = change1.replacingOccurrences(of: "÷", with: "*1.0/")
        let change3 = change2.replacingOccurrences(of: ",", with: "")
        let change4 = change3.replacingOccurrences(of: ".+", with: ".0+")
        let change5 = change4.replacingOccurrences(of: ".-", with: ".0-")
        let change6 = change5.replacingOccurrences(of: ".*", with: ".0*")
        var change7 = change6.replacingOccurrences(of: "./", with: ".0/")
        if(change7.hasSuffix(".")) {
            change7.append("0")
        }
        
        if(!value.isEmpty && inputFlag(str: change7)) {
            // 文字列の計算
            let expression = NSExpression(format: change7)
            let sum = expression.expressionValue(with: nil, context: nil) as! Double
            
            //print(sum)
            // 文字列の調整
            let sumString = ToResult(resultValue: sum)
            results.text = sumString
        } else {
            let alert = UIAlertController(
                title: "エラー",
                message: "計算式が間違っています",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"ok", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // ******************************
    // 以下，電卓の数字部分
    
    // 文字列の追加関数

    @IBAction func zero(_ sender: Any) {
        add_num(parm: "0")
    }
    
    
    @IBAction func one(_ sender: Any) {
        add_num(parm: "1")
    }
    
    @IBAction func two(_ sender: Any) {
        add_num(parm: "2")
    }
    
    @IBAction func three(_ sender: Any) {
        add_num(parm: "3")
    }
    
    @IBAction func four(_ sender: Any) {
        add_num(parm: "4")
    }
    
    @IBAction func five(_ sender: Any) {
        add_num(parm: "5")
    }
    
    @IBAction func six(_ sender: Any) {
        add_num(parm: "6")
    }
    @IBAction func seven(_ sender: Any) {
        add_num(parm: "7")
    }
    @IBAction func eight(_ sender: Any) {
        add_num(parm: "8")
    }
    @IBAction func nine(_ sender: Any) {
        add_num(parm: "9")
    }
}

