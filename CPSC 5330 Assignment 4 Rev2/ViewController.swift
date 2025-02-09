//
//  ViewController.swift
//  CPSC 5330 Assignment 4 Rev2
//
//  Created by user273384 on 2/7/25.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    
    // Current time label.
    @IBOutlet weak var label1: UILabel!
    // Countdown label.
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var start: UIButton!
    
    @IBOutlet weak var backgroundImage2: UIImageView!
    @IBOutlet weak var counterDown: UIDatePicker!
    
    // Current time variables.
    var timer = Timer()             // Current time timer
    var calender2 = Calendar.current
    
    // Countdown label variables.
    var timer2 = Timer()            // Countdown timer
    var label2On = false            // label2 state
    var timeLeft : Date?            // Time left on countdown.
    var hour : Int?                 // hours in countdown timer.
    var min : Int?                  // minutes in countdown timer.
    var sec : Int?                  // seconds in countdown timer.
    var calendar = Calendar.current
    var timerDone = false           // Timer done flag.
    var stopMusic = false           // Stop music flag.
    
    // I changed my logic to use var to keep track of button state
    // I havent removed the flags from the logic... yet.
    var buttonState = 1             // State of Start Timer/Stop Music
     
    // Audio variables
    var player: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Current Time
        label1.text = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .medium)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.tick), userInfo: nil, repeats: true)
        
        // Initial label2 test.
        label2.text = ""
        timeLeft = counterDown.date
        // Do any additional setup after loading the view.
    }


    @IBAction func datePicker(_ sender: UIDatePicker) {
        print(sender.date)
    }
    
    @IBAction func startButton(_ sender: UIButton) {
        
        if (buttonState == 1) {         // Start Timer
            
            label2On = true
            
            timeLeft = counterDown.date
            hour = calendar.component(.hour, from: timeLeft!)
            min = calendar.component(.minute, from: timeLeft!)
            sec = 0
            timer2 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startCountDown), userInfo: nil, repeats: true)
            sender.isUserInteractionEnabled = false
            
        } else if (buttonState == 2) {  // Timer Done
            
            if (stopMusic) {
                player.stop()
                print("music stopped")
                sender.setTitle("Start Timer", for: .normal)
                buttonState = 1
                label2.text = ""
            }
        } else {                        // Stop Music
            //buttonState = 3
            buttonState = 1
        }
        
    }
    
    // Function updates clock
    @objc func tick() {
        
        // Display date/time
        label1.text = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .medium)
        //calendar2 = Calendar.current
        let calendar2 = Calendar.current
        let hour2 = calendar2.component(.hour, from: Date() )
        
        // Set background based on AM/PM
        if (hour2 > 11) {
            backgroundImage.isHidden = true
            backgroundImage2.isHidden = false
        } else {
            backgroundImage.isHidden = false
            backgroundImage2.isHidden = true
        }
    }
    
    // Function updates timer.
    @objc func startCountDown() {
        
        // Manual countdown timer logic.
        sec! -= 1
        if (sec == -1) {
            sec = 59
            min! -= 1
            if (min == -1) {
                hour! -= 1
                if (hour == -1) {       // Timer = 0.
                    sec = 0
                    min = 0
                    hour = 0
                    timerDone = true
                    // Stop timer.
                    timer2.invalidate()
                    // play sound.
                    playSound()
                    // Change button text.
                    start.setTitle("Stop Music", for: .normal)
                    // Turn button on.
                    start.isUserInteractionEnabled = true
                    // Stop music flag.
                    stopMusic = true
                    // Button state.
                    buttonState = 2
                }
            }
        }
        
        label2.text = "Time Remaining: \(String(format: "%02d", hour!)):\(String(format: "%02d", min!)):\(String(format: "%02d", sec!))"
    }
    
    func playSound() {
        let url = Bundle.main.url(forResource: "WS", withExtension: "wav")
        player = try! AVAudioPlayer(contentsOf: url!)
        player!.play()
        print("playing sound!")
    }
}

