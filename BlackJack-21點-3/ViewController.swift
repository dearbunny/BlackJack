//
//  ViewController.swift
//  BlackJack-21點-3
//
//  Created by Rose on 2021/5/24.
//

import UIKit
import GameplayKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet var bankerCards: [UIImageView]!
    @IBOutlet var playerCards: [UIImageView]!
    
    // 籌碼
    @IBOutlet weak var playerChipLabel: UILabel!
    // 點數
    @IBOutlet weak var bankerScoreLabel: UILabel!
    @IBOutlet weak var playerScoreLabel: UILabel!
    @IBOutlet weak var bankerScoreBG: UIImageView!
    @IBOutlet weak var playerScoreBG: UIImageView!
    
    // 發牌
    @IBOutlet weak var dealButton: UIButton!
    // 要牌
    @IBOutlet weak var hitButton: UIButton!
    // 開牌
    @IBOutlet weak var openButton: UIButton!
    // 投降
    @IBOutlet weak var giveUpButton: UIButton!
    // 咪牌
    @IBOutlet weak var openFoldCardButton: UIButton!
    // 訊息
    @IBOutlet weak var alertTextLabel: UILabel!
    // 下注金額
    @IBOutlet weak var betLabel: UILabel!
    // 加減注
    @IBOutlet weak var plusBetBtn: UIButton!
    @IBOutlet weak var minusBetBtn: UIButton!
    
    var playerCloseCard = ""
    var bankerCloseCard = ""
    var playerOpenedCard = ""
    var bankerOpenedCard = ""
    // 玩家/莊家卡
    var pCards = [String]()
    var cCards = [String]()
    
    let distribution = GKShuffledDistribution(lowestValue: 0, highestValue: cards.count - 1)
    //  玩家點數
    var playerScore = 0
    var bankerScore = 0
    //  莊家點數
    var bankerTotalScore = 0
    // 玩家籌碼
    var playerChip = 1000
    
    var count = 2
    // 玩家牌
    var playerAceCount = 0
    // 莊家牌
    var bankerAceCount = 0
    // 下注
    var bet = 100
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        speech(_sender: "welcome to black jack, let's play")
        alertTextLabel.text = "請先下注！"
        bankerScoreBG.isHidden = true
        playerScoreBG.isHidden = true
        giveUpButton.isHidden = true
        hitButton.isHidden = true
        openButton.isHidden = true
    }
    
    // 顯示蓋牌
    @IBAction func closeCard(_ sender: Any) {
        playerCards[0].isHighlighted = false
        UIView.transition(with: playerCards[0], duration: 0.2, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        
        if playerScore == 21 && pCards.count == 2{
            hitButton.isEnabled = false
        }
    }
    
    @IBAction func seeCard(_ sender: Any) {
        playerCards[0].isHighlighted = true
        playerScoreLabel.isHidden = false
        playerScoreBG.isHidden = false
        UIView.transition(with: playerCards[0], duration: 0.2, options: .transitionFlipFromRight, animations: nil, completion: nil)
        
        hitButton.isEnabled = true
        if playerScore >= 15{
            openButton.isEnabled = true
            //alertTextLabel.isHidden = true
            alertTextLabel.text = ""
        }else{
            //alertTextLabel.isHidden = false
            alertTextLabel.text = "當你的點數低於15點時,你不能打開"
        }
    }
    

    
    // Deal 發牌
    @IBAction func deal(_ sender: Any) {
        giveUpButton.isHidden = false
        hitButton.isHidden = false
        openButton.isHidden = false
        alertTextLabel.text = ""
        
        if playerChip >= bet{
            playerCloseCard = cards[distribution.nextInt()]
            playerOpenedCard = cards[distribution.nextInt()]
            bankerCloseCard = cards[distribution.nextInt()]
            bankerOpenedCard = cards[distribution.nextInt()]
            
            pCards += ["\(playerCloseCard)","\(playerOpenedCard)"]
            cCards += ["\(bankerCloseCard)","\(bankerOpenedCard)"]
            
            bankerCards[0].isHidden = false
            playerCards[0].image = UIImage(named: "back")
            playerCards[0].highlightedImage = UIImage(named: playerCloseCard)
            playerCards[0].isHidden = false
            playerCards[1].image = UIImage(named: playerOpenedCard)
            playerCards[1].isHidden = false
            bankerCards[1].image = UIImage(named: bankerOpenedCard)
            bankerCards[1].isHidden = false
            
            playerScore += scoreCal(card: playerOpenedCard)
            playerScore += scoreCal(card: playerCloseCard)
            if (playerOpenedCard.contains("A") || playerCloseCard.contains("A")) && playerScore > 21{
                playerScore -= 10
            }
            
            playerScoreLabel.text = "\(playerScore)"
            
            bankerScore += scoreCal(card: bankerOpenedCard)
            bankerScoreLabel.text = "\(bankerScore)"
            bankerScoreLabel.isHidden = false
            bankerScoreBG.isHidden = false
            //playerScoreBG.isHidden = false
            
            dealButton.isEnabled = false
            openFoldCardButton.isEnabled = true
            giveUpButton.isEnabled = true
            plusBetBtn.isHidden = true
            minusBetBtn.isHidden = true
            
            bankerTotalScore = bankerScore + scoreCal(card: bankerCloseCard)
            if (bankerCloseCard.contains("A") || bankerOpenedCard.contains("A")) && bankerTotalScore > 21{
                bankerTotalScore -= 10
            }
            
            for pCard in pCards{
                if pCard.contains("A"){
                    playerAceCount += 1
                }
            }
            
            for cCard in cCards{
                if cCard.contains("A"){
                    bankerAceCount += 1
                }
            }
        }else{
            noEnougnMoney()
        }
        
    }
    
    // 加牌
    @IBAction func hit(_ sender: Any) {
        var addCard = ""
        addCard = cards[distribution.nextInt()]
        playerCards[count].isHidden = false
        playerCards[count].image = UIImage(named: addCard)
        UIView.transition(with: playerCards[count], duration: 0.8, options: .transitionCurlDown, animations: nil, completion: nil)
        pCards += ["\(addCard)"]
        
        if addCard.contains("A"){
            playerAceCount += 1
        }
        
        playerScore += scoreCal(card: addCard)
        for pCard in pCards{
            if pCard.contains("A") && playerScore > 21{
                playerScore -= 10
                pCards = pCards.filter({(card : String) -> Bool in return !card.contains("A")})
            }
        }
        if addCard.contains("A") && playerAceCount >= 2{
            pCards += ["\(addCard)"]
        }
        
        playerScoreLabel.text = "\(playerScore)"
        
        if playerScore >= 15{
            openButton.isEnabled = true
            //alertTextLabel.isHidden = true
            alertTextLabel.text = ""
        }else {
            //alertTextLabel.isHidden = false
            alertTextLabel.text = "當你的點數低於15點時,你不能打開"
        }
        if playerScore == 21{
            hitButton.isEnabled = false
        }
        
        count += 1
        if (count == 5 && playerScore <= 21) && !(bankerTotalScore == 21){
            fiveCardTrick()
        }else if (count == 5 && playerScore <= 21) && (bankerTotalScore == 21){
            bankerBlackJack()
        }else if playerScore > 21{
            bust()
        }
    }
    
    // 開牌
    @IBAction func open(_ sender: Any) {
        playerCards[0].image = UIImage(named: playerCloseCard)
        UIView.transition(with: playerCards[0], duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
        bankerCards[0].image = UIImage(named: bankerCloseCard)
        UIView.transition(with: bankerCards[0], duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
        bankerScoreLabel.text = "\(bankerTotalScore)"
        
        
        
        count = 2
        var comAddCard = ""
        while (bankerTotalScore < 17 && count < 6) || (bankerTotalScore == 17 && cCards.contains("A") && count == 2){
            comAddCard = cards[distribution.nextInt()]
            bankerCards[count].isHidden = false
            bankerCards[count].image = UIImage(named: comAddCard)
            UIView.transition(with: bankerCards[count], duration: 0.8, options: .transitionCurlDown, animations: nil, completion: nil)
            cCards += ["\(comAddCard)"]
            
            if comAddCard.contains("A"){
                bankerAceCount += 1
            }
            
            bankerTotalScore += scoreCal(card: comAddCard)
            for cCard in cCards{
                if cCard.contains("A") && bankerTotalScore > 21{
                    bankerTotalScore -= 10
                    cCards = cCards.filter({(card : String) -> Bool in return !card.contains("A")})
                }
            }
            if comAddCard.contains("A") && bankerAceCount >= 2{
                cCards += ["\(comAddCard)"]
            }
            
            bankerScoreLabel.text = "\(bankerTotalScore)"
            count += 1
        }
        
        if bankerTotalScore == 21 && cCards.count == 2{
            bankerScoreLabel.text = "\(bankerTotalScore)"
            bankerBlackJack()
        }else if playerScore == 21 && pCards.count <= 2{
            playerBlackJack()
        }else if bankerTotalScore > 21 || playerScore > bankerTotalScore{
            win()
        }else if bankerTotalScore > playerScore{
            lose()
        }else if bankerTotalScore == playerScore{
            tie()
        }else if count == 5 && bankerTotalScore < 21{
            bankerFiveCardTrick()
        }
    }
    
    
    
    
    
    
    // 投降
    @IBAction func giveUp(_ sender: Any) {
        playerScore = 0
        playerScoreLabel.text = "\(playerScore)"
        giveUp()
    }
    
    @IBAction func plusBetBtnPressed(_ sender: Any) {
        if bet >= 100 && bet < 300{
            bet += 100
            betLabel.text = "\(bet)"
        }
    }
    @IBAction func minusBetBtnPressed(_ sender: Any) {
        if bet > 100 && bet <= 300{
            bet -= 100
            betLabel.text = "\(bet)"
        }
    }
    
    
    
    
    // 下一輪(參數歸零重置)
    func nextRound () {
        if playerChip <= 0 {
            performSegue(withIdentifier: "gameOverSegue", sender: nil)
        }
        
        playerCards[0].isHidden = true
        playerCards[1].isHidden = true
        playerCards[2].isHidden = true
        playerCards[3].isHidden = true
        playerCards[4].isHidden = true
        
        bankerCards[0].image = UIImage(named:"back")
        bankerCards[0].isHidden = true
        bankerCards[1].isHidden = true
        bankerCards[2].isHidden = true
        bankerCards[3].isHidden = true
        bankerCards[4].isHidden = true
        
        bankerScore = 0
        bankerTotalScore = 0
        playerScore = 0
        bankerScoreLabel.text = "0"
        bankerScoreLabel.isHidden = true
        bankerScoreBG.isHidden = true
        playerScoreLabel.text = "0"
        playerScoreLabel.isHidden = true
        playerScoreBG.isHidden = true
        pCards.removeAll()
        cCards.removeAll()
        
        dealButton.isEnabled = true
        hitButton.isEnabled = false
        openButton.isEnabled = false
        giveUpButton.isEnabled = false
        openFoldCardButton.isEnabled = false
        
        playerCloseCard = ""
        bankerCloseCard = ""
        playerOpenedCard = ""
        bankerOpenedCard = ""
        count = 2
        playerAceCount = 0
        bankerAceCount = 0
        
        bet = 100
        betLabel.text = "\(bet)" //Bet: 
        plusBetBtn.isHidden = false
        minusBetBtn.isHidden = false
        
        alertTextLabel.text = "請先下注！"
    }
    
    // 各種牌面情況
    func nextHandler(action: UIAlertAction) {
        nextRound()
    }
    
    func bust () {
        playerCards[0].image = UIImage(named: playerCloseCard)
        UIView.transition(with: playerCards[0], duration: 0.2, options: .transitionFlipFromRight, animations: nil, completion: nil)
        let controller = UIAlertController(title: "爆了！", message: "扣除 \(bet)! Score: \(playerScore)", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "下一局", style: UIAlertAction.Style.default, handler: nextHandler)
        controller.addAction(action)
        show(controller, sender: nil)
        playerChip -= bet
        playerChipLabel.text = "\(playerChip)" //你的籌碼：
        speech(_sender: controller.title!)
    }
    
    // 平手
    func tie () {
        let controller = UIAlertController(title: "平手", message: "Lost \(bet)! Score: \(playerScore)", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "下一局", style: UIAlertAction.Style.default, handler: nextHandler)
        controller.addAction(action)
        show(controller, sender: nil)
        playerChip -= bet
        playerChipLabel.text = "\(playerChip)" //你的籌碼：
        speech(_sender: controller.title!)
    }
    
    // 五張卡
    func fiveCardTrick () {
        playerCards[0].image = UIImage(named: playerCloseCard)
        UIView.transition(with: playerCards[0], duration: 0.2, options: .transitionFlipFromRight, animations: nil, completion: nil)
        let controller = UIAlertController(title: "Five cards trick", message: "Won \(bet * 2)! Score: \(playerScore)", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "下一局", style: UIAlertAction.Style.default, handler: nextHandler)
        controller.addAction(action)
        show(controller, sender: nil)
        playerChip += (bet * 2)
        playerChipLabel.text = "\(playerChip)" //你的籌碼：
        speech(_sender: controller.title!)
    }
    
    // 輸了
    func lose () {
        let controller = UIAlertController(title: "你輸了！", message: "Lost \(bet)! Score: \(playerScore)", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "下一局", style: UIAlertAction.Style.default, handler: nextHandler)
        controller.addAction(action)
        show(controller, sender: nil)
        playerChip -= bet
        playerChipLabel.text = "\(playerChip)" //你的籌碼：
        speech(_sender: controller.title!)
    }
    
    func win () {
        let controller = UIAlertController(title: "你贏了！", message: "Won \(bet)! Score: \(playerScore)", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "下一局", style: UIAlertAction.Style.default, handler: nextHandler)
        controller.addAction(action)
        show(controller, sender: nil)
        playerChip += bet
        playerChipLabel.text = "\(playerChip)" //你的籌碼：
        speech(_sender: controller.title!)
    }
    
    func playerBlackJack () {
        playerCards[0].image = UIImage(named: playerCloseCard)
        UIView.transition(with: playerCards[0], duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
        let controller = UIAlertController(title: "Black Jack", message: "Won \(bet * 2)! Score: \(playerScore)", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "下一局", style: UIAlertAction.Style.default, handler: nextHandler)
        controller.addAction(action)
        show(controller, sender: nil)
        playerChip += (bet * 2)
        playerChipLabel.text = "\(playerChip)" //你的籌碼：
        speech(_sender: controller.title!)
    }
    
    func bankerBlackJack () {
        bankerCards[0].image = UIImage(named: bankerCloseCard)
        UIView.transition(with: bankerCards[0], duration: 0.2, options: .transitionFlipFromRight, animations: nil, completion: nil)
        bankerScoreLabel.text = "\(bankerTotalScore)"
        let controller = UIAlertController(title: "Com Black Jack", message: "Lost \(bet * 2)! Score: \(playerScore)", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "下一局", style: UIAlertAction.Style.default, handler: nextHandler)
        controller.addAction(action)
        show(controller, sender: nil)
        playerChip -= (bet * 2)
        playerChipLabel.text = "\(playerChip)" //你的籌碼：
        speech(_sender: "computer black jack")
    }
    
    func bankerFiveCardTrick () {
        bankerCards[0].image = UIImage(named: bankerCloseCard)
        UIView.transition(with: bankerCards[0], duration: 0.2, options: .transitionFlipFromRight, animations: nil, completion: nil)
        bankerScoreLabel.text = "\(bankerTotalScore)"
        let controller = UIAlertController(title: "Com five cards trick", message: "Lost \(bet * 2)! Score: \(playerScore)", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "下一局", style: UIAlertAction.Style.default, handler: nextHandler)
        controller.addAction(action)
        show(controller, sender: nil)
        playerChip -= (bet * 2)
        playerChipLabel.text = "\(playerChip)" //你的籌碼：
        speech(_sender: "computer five cards trick")
    }
    
    func giveUp () {
        let controller = UIAlertController(title: "投降", message: "Lost \(bet / 2)! Score: \(playerScore)", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "下一局", style: UIAlertAction.Style.default, handler: nextHandler)
        controller.addAction(action)
        show(controller, sender: nil)
        playerChip -= (bet / 2)
        playerChipLabel.text = "\(playerChip)" //你的籌碼：
        speech(_sender: controller.title!)
    }
    
    func noEnougnMoney () {
        let controller = UIAlertController(title: "籌碼不足", message: "You can't bet more than you have!", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "下一局", style: UIAlertAction.Style.default, handler: nextHandler)
        controller.addAction(action)
        show(controller, sender: nil)
        speech(_sender: controller.title!)
    }
    
    //牌面轉換分數
    func scoreCal(card: String) -> Int {
        var score = 0
        if card.contains("A") {
            score = 11
        } else if card.contains("2") {
            score = 2
        } else if card.contains("3"){
            score = 3
        } else if card.contains("4"){
            score = 4
        } else if card.contains("5"){
            score = 5
        } else if card.contains("6"){
            score = 6
        } else if card.contains("7"){
            score = 7
        } else if card.contains("8"){
            score = 8
        } else if card.contains("9"){
            score = 9
        } else if card.contains("10"){
            score = 10
        } else if card.contains("J"){
            score = 10
        } else if card.contains("Q"){
            score = 10
        } else if card.contains("K"){
            score = 10
        }
        return score
    }
    
    // speech 語音
    func speech(_sender: String){
        let speechUtterence = AVSpeechUtterance(string: _sender)
        let synth = AVSpeechSynthesizer()
        synth.speak(speechUtterence)
    }


}

