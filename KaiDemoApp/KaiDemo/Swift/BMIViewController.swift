//
//  BMIViewController.swift
//  KaiDemo
//
//  Created by KaiKai on 2023/5/10.
//

import UIKit

// 此类被编译成了_TtC7KaiDemo17BMIViewController
@objc(OcBMIViewController)
@available(macCatalyst 13.1, *)
class BMIViewController : UIViewController {
    private var weightEdt: UITextField?
    private var heightEdt: UITextField?
    private var resultLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let weightLabel = UILabel()
        weightLabel.text = "weight(kg): "
        weightLabel.backgroundColor = .lightGray
        weightLabel.textAlignment = .right
        view.addSubview(weightLabel)
//        weightLabel.frame = CGRectMake(62, 150, 100, 30)
        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weightLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40)
            , weightLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: +0)
            , weightLabel.heightAnchor.constraint(equalToConstant: 30)
            , weightLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 120)
//            , weightLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 150)
        ])
        // AutoLayout中的Content Hugging Priority和 Content Compression Resistance Priority解析
        //https://www.cnblogs.com/ludashi/p/7373051.html
//        weightLabel.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
        
        let weightEdt = UITextField.init()
        weightEdt.placeholder = "please input weight"
//        weightEdt.frame = CGRectMake(100, 100, 200, 30)
        weightEdt.text = "65"
        weightEdt.backgroundColor = .orange.withAlphaComponent(0.2)
        weightEdt.keyboardType = .numberPad
        view.addSubview(weightEdt)
        weightEdt.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weightEdt.topAnchor.constraint(equalTo: weightLabel.topAnchor, constant: 0)
            , weightEdt.leadingAnchor.constraint(equalTo: weightLabel.trailingAnchor, constant: 12)
            , weightEdt.heightAnchor.constraint(equalToConstant: 30)
//            , weightEdt.widthAnchor.constraint(equalToConstant: 100)
            , weightEdt.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -0)
        ])
        self.weightEdt = weightEdt;
        
        let heightLabel = UILabel.init()
        heightLabel.text = "height(m):"
        heightLabel.backgroundColor = .lightGray
        heightLabel.textAlignment = .right
//        heightLabel.frame = CGRectMake(12, 150, 100, 30)
        view.addSubview(heightLabel)
        heightLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heightLabel.topAnchor.constraint(equalTo: weightLabel.bottomAnchor, constant: 20)
            , heightLabel.leadingAnchor.constraint(equalTo: weightLabel.leadingAnchor, constant: 0)
            , heightLabel.heightAnchor.constraint(equalTo: weightLabel.heightAnchor)
            , heightLabel.trailingAnchor.constraint(equalTo: weightLabel.trailingAnchor)
        ])
//        heightLabel.setContentHuggingPriority(UILayoutPriority(251), for: horizontal)
        
        let heightEdt = UITextField()
        heightEdt.placeholder = "please input height"
        heightEdt.backgroundColor = .orange.withAlphaComponent(0.1)
//        heightEdt.frame = CGRectMake(100, 150, 200, 30)
        heightEdt.text = "1.7"
        heightEdt.keyboardType = .numberPad
        view.addSubview(heightEdt)
        heightEdt.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heightEdt.topAnchor.constraint(equalTo: heightLabel.topAnchor, constant: 0)
            , heightEdt.leadingAnchor.constraint(equalTo: heightLabel.trailingAnchor, constant: 12)
            , heightEdt.heightAnchor.constraint(equalTo: weightEdt.heightAnchor)
            , heightEdt.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        self.heightEdt = heightEdt;
        
        let calcBtn: UIButton = UIButton.init()
        calcBtn.setTitle("Calc", for: .normal)
        calcBtn.setTitleColor(.black, for: .normal)
        calcBtn.backgroundColor = .lightGray
//        calcBtn.frame = CGRectMake(100, 200, 100, 40)
        view.addSubview(calcBtn)
        calcBtn.addTarget(self, action: #selector(onClickCalcButton4(_:)), for: .touchUpInside)
        calcBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            calcBtn.topAnchor.constraint(equalTo: heightLabel.bottomAnchor, constant: 20)
            , calcBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            , calcBtn.heightAnchor.constraint(equalToConstant: 40)
            , calcBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5, constant: 0)
        ])
        
        let _resultLabel = UILabel()
//        _resultLabel.frame = CGRectMake(12, 250, 200, 30)
        _resultLabel.backgroundColor = .lightGray
        _resultLabel.text = "will show result";
        view.addSubview(_resultLabel);
        resultLabel = _resultLabel;
        _resultLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _resultLabel.topAnchor.constraint(equalTo: calcBtn.bottomAnchor, constant: 20)
            , _resultLabel.leadingAnchor.constraint(equalTo: weightLabel.leadingAnchor)
            , _resultLabel.trailingAnchor.constraint(equalTo: weightEdt.trailingAnchor)
        ])
        
        let inputBtn: UIButton = UIButton.init()
        inputBtn.setTitle(" Demo InputView ", for: .normal)
        inputBtn.setTitleColor(.black, for: .normal)
        inputBtn.backgroundColor = .lightGray
        view.addSubview(inputBtn)
        inputBtn.addTarget(self, action: #selector(onClickInputButton(_:)), for: .touchUpInside)
        inputBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inputBtn.topAnchor.constraint(equalTo: _resultLabel.bottomAnchor, constant: 20)
            , inputBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
            , inputBtn.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        let syntaxBtn: UIButton = UIButton.init()
        syntaxBtn.setTitle(" Swift Syntax ", for: .normal)
        syntaxBtn.setTitleColor(.black, for: .normal)
        syntaxBtn.backgroundColor = .lightGray
        view.addSubview(syntaxBtn)
        syntaxBtn.addTarget(self, action: #selector(onClickSyntaxButton(_:)), for: .touchUpInside)
        syntaxBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            syntaxBtn.topAnchor.constraint(equalTo: inputBtn.topAnchor)
            , syntaxBtn.leadingAnchor.constraint(equalTo: inputBtn.trailingAnchor, constant: 20)
            , syntaxBtn.heightAnchor.constraint(equalTo: inputBtn.heightAnchor)
        ])
    }
    
    @objc func onClickCalcButton4(_ sender: UIButton) {
        NSLog("lookKai clickCalcButton %@", sender);
        let weight = convertEditTextToInt(weightEdt);
        let height = convertEditTextToInt(heightEdt);
        let calc = BMICalc();
        let bmi = calc.toBmi(weight: weight, height: height)
        if (bmi == .invalid) {
            NSLog("value invalid, weight=%.2f height=%.2f", weight, height)
            resultLabel?.text = "invalid input"
        } else {
            resultLabel?.text = String(format: "bmi=%.2f enum=%@ rawValue=%d", calc.bmiValue!, calc.bmiString(bmi: bmi), bmi.rawValue)
        }
//        let bmi2: BMICalc.BMI = .fat;
//        bmi2.rawValue;
        DemoToast.toast(bmi == .invalid ? "bmi invalid" : "bmi = \(calc.bmiValue!)", duration: 3)
    }
    
    func convertEditTextToInt(_ edt: UITextField?) -> Float {
//        let text = edt?.text
//        guard let text else { return 0 }
//        let value = Float(text)
//        return value ?? 0
        return Float(edt?.text ?? "0") ?? 0;
    }
    
    @objc func onClickInputButton(_ sender: UIButton) {
        let inputView = DemoTextInputView()
//        inputView.completion = { (content: String) -> Void in
//            print("lookKai inputView callback1, content=\(content)")
//        }
//        inputView.completion = { content in
//            print("lookKai inputView callback2, content=\(content)")
//        }
        inputView.completion = {
            print("lookKai inputView callback2, content=\($0)")
        }
        inputView.showKeyboard(withParentView: view)
    }
    
    @objc func onClickSyntaxButton(_ sender: UIButton) {
        TestSwiftSyntax().demoEntryFunction()
        ControlFlowEntry.entry()
    }
    
    @objc func onClickCalcButton1(_ sender: UIButton) {
        if (weightEdt == nil || heightEdt == nil || resultLabel == nil) {
            return
        }
        let xxx1 = weightEdt!
        let weight = Int(xxx1.text ?? "0") ?? 0
//            resultLabel!.text = "\(weight)";
//            resultLabel!.text = (weight as? String) ?? "error_kai";
    }
    
    @objc func onClickCalcButton2(_ sender: UIButton) {
        NSLog("lookKai clickCalcButton %@", sender);
        guard let weightEdt = weightEdt, let heightEdt = heightEdt, let resultLabel = resultLabel else {
            NSLog("")
            return
        }
        NSLog("valid ui: %@", weightEdt);
    }
    
    @objc func onClickCalcButton3(_ sender: UIButton) {
        NSLog("lookKai clickCalcButton %@", sender);
        let weight = convertEditTextToInt(weightEdt);
        let height = convertEditTextToInt(heightEdt);
        if (weight <= 0.01 || height <= 0.01) {
            NSLog("value invalid, weight=%.2f height=%.2f", weight, height)
            resultLabel?.text = "invalid input"
            return
        }
        let bmiValue: Float = weight / (height * height)
        resultLabel?.text = String(format: "bmi=%.2f", bmiValue)
    }
}
