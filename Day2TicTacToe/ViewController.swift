//
//  ViewController.swift
//  Day2TicTacToe
//
//  Created by Jon Duenas on 6/15/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var currentTurnLabel: UILabel!
    @IBOutlet weak var player1ScoreLabel: UILabel!
    @IBOutlet weak var player2ScoreLabel: UILabel!
    
    let player1Image = UIImage(systemName: "xmark")
    let player2Image = UIImage(systemName: "circle")
    
    var player1Turn = true {
        didSet {
            currentTurnLabel.text = player1Turn ? "Player 1" : "Player 2"
        }
    }
    
    var player1Score = 0 {
        didSet {
            player1ScoreLabel.text = "\(player1Score)"
        }
    }
    
    var player2Score = 0 {
        didSet {
            player2ScoreLabel.text = "\(player2Score)"
        }
    }
    
    var playedButtons: [UIButton] = []
    var player1Moves: [Int] = []
    var player2Moves: [Int] = []
    var winningMoves: [[Int]] = [
        [0, 1, 2],
        [3, 4, 5],
        [6, 7, 8],
        [0, 3, 6],
        [1, 4, 7],
        [2, 5, 8],
        [0, 4, 8],
        [3, 8, 6],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startNewGame()
    }

    func startNewGame() {
        resetMoves()
        player1Turn = Int.random(in: 0...1) == 0
    }
    
    func resetMoves() {
        for button in playedButtons {
            button.isUserInteractionEnabled = true
            button.setImage(nil, for: .normal)
        }
        
        playedButtons.removeAll()
        player1Moves.removeAll()
        player2Moves.removeAll()
    }
    
    @IBAction func didTapButton(_ sender: UIButton) {
        mark(square: sender)
        
        sender.isUserInteractionEnabled = false
        playedButtons.append(sender)
        
        if isWinningMove() {
            if player1Turn {
                player1Score += 1
            } else {
                player2Score += 1
            }
            showEndGameAlert()
            return
        }
        
        if stalemate() {
            showStalemateAlert()
            return
        }
        
        player1Turn = !player1Turn
    }
    
    func mark(square: UIButton) {
        if player1Turn {
            square.setImage(player1Image, for: .normal)
            player1Moves.append(square.tag)
        } else {
            square.setImage(player2Image, for: .normal)
            player2Moves.append(square.tag)
        }
    }
    
    func isWinningMove() -> Bool {
        let movesToCheck = player1Turn ? player1Moves : player2Moves
        
        for winner in winningMoves {
            let win = winner.allSatisfy { movesToCheck.contains($0) }
            
            if win {
                return true
            } else {
                continue
            }
        }
        return false
    }
    
    func stalemate() -> Bool {
        playedButtons.count == 9
    }
    
    func showEndGameAlert() {
        let winner = player1Turn ? "Player 1" : "Player 2"
        let alert = UIAlertController(title: "\(winner) wins!",
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Play Again",
                                      style: .default,
                                      handler: { _ in
                                        self.startNewGame()
                                      }))
        present(alert, animated: true)
    }
    
    func showStalemateAlert() {
        let alert = UIAlertController(title: "Stalemate",
                                      message: "Nobody wins.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Play Again",
                                      style: .default,
                                      handler: { _ in
                                        self.startNewGame()
                                      }))
        present(alert, animated: true)
    }
}
