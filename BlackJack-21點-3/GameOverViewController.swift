//
//  GameOverViewController.swift
//  BlackJack-21點-3
//
//  Created by Rose on 2021/5/24.
//

import UIKit
import AVFoundation

class GameOverViewController: UIViewController {
    
    var player: AVAudioPlayer?
    
    @IBOutlet weak var gameOverLabel: UILabel!
    @IBOutlet weak var gameOverImage: UIImageView!
    @IBOutlet weak var playAgainBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        playSound()
    }
    @IBAction func playAgain(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "gameover", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
