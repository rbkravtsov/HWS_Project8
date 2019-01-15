//
//  ViewController.swift
//  HWS_Project8
//
//  Created by Roman Kravtsov on 14/01/2019.
//  Copyright © 2019 Roman Kravtsov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cluesLabel: UILabel!
    
    @IBOutlet weak var answersLabel: UILabel!
    
    @IBOutlet weak var currentAnswer: UITextField!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBAction func submitTapped(_ sender: UIButton) {
        if let solutionPosition = solutions.index(of: currentAnswer.text!) {
            activatedButtons.removeAll()
            
            var splitAnswers = answersLabel.text!.components(separatedBy: "\n")
            splitAnswers[solutionPosition] = currentAnswer.text!
            answersLabel.text! = splitAnswers.joined(separator: "\n")
            
            currentAnswer.text! = ""
            score += 1
            
            if score % 7 == 0 {
                let ac = UIAlertController(title: "Well done", message: "Are you ready for next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Lets go", style: .default, handler: levelUp))
                present(ac, animated: true)
            }
        }
    
    }
    
    @IBAction func clearTapped(_ sender: UIButton) {
        currentAnswer.text! = ""
        
        for btn in activatedButtons {
            btn.isHidden = false
        }
        
        activatedButtons.removeAll()
    }
    
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for subview in view.subviews where subview.tag == 1001 {
            let btn = subview as! UIButton
            letterButtons.append(btn)
            btn.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
        }
        loadLevel()
    }
    
    @objc func letterTapped(btn: UIButton) {
        currentAnswer.text! = currentAnswer.text! + btn.titleLabel!.text!
        activatedButtons.append(btn)
        btn.isHidden = true
    }
    
    func loadLevel() {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        if let levelPath = Bundle.main.path(forResource: "level\(level)", ofType: "txt") {
            if let levelContents = try? String(contentsOfFile: levelPath) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                
                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    clueString += "\(index + 1).\(clue)\n"
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.count) letters \n"
                    solutions.append(solutionWord)
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }
        
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        letterBits.shuffle()
        if letterBits.count == letterButtons.count {
            for i in 0..<letterButtons.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }
    
    func levelUp(action: UIAlertAction) {
        level += 1
        solutions.removeAll()
        
        loadLevel()
        
        for btn in letterButtons {
            btn.isHidden = false
        }
    }



}

