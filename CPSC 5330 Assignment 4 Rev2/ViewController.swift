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
    var timer = Timer()     // Current time timer
    var calender2 = Calendar.current
    
    // Countdown label variables.
    var timer2 = Timer()    // Countdown timer
    var label2On = false    // label2 state
    //var timeLeft : Int?     // Time left on countdown.
    var timeLeft : Date?         // Time left on countdown.
    var hour : Int?
    var min : Int?
    var sec : Int?
    var calendar = Calendar.current
    var timerDone = false
    
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
        
        // Initial state
        // Start Timer
        label2On = true
        
        timeLeft = counterDown.date
        hour = calendar.component(.hour, from: timeLeft!)
        min = calendar.component(.minute, from: timeLeft!)
        sec = 0
        timer2 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startCountDown), userInfo: nil, repeats: true)
        
        
        // play sound if timer is done.
        if (timerDone) {
            playSound()
            sender.setTitle("Stop Music", for: .normal)
        }
        
        // Second state
        //
        
    }
    
    // Function updates clock
    @objc func tick() {
        label1.text = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .medium)
        //calendar2 = Calendar.current
        let calendar2 = Calendar.current
        let hour2 = calendar2.component(.hour, from: Date() )
        
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
        
        sec! -= 1
        if (sec == -1) {
            sec = 59
            min! -= 1
            if (min == -1) {
                hour! -= 1
                if (hour == -1) {
                    sec = 0
                    min = 0
                    hour = 0
                    timerDone = true
                    timer2.invalidate()
                }
            }
        }
        
        // play sound if timer is done.
        if (timerDone) {
            playSound()
            start.setTitle("Stop Music", for: .normal)
        }
        
        label2.text = "Time Remaining: \(String(format: "%02d", hour!)):\(String(format: "%02d", min!)):\(String(format: "%02d", sec!))"
    }
    
    func playSound() {
        let url = Bundle.main.url(forResource: "WS", withExtension: "wav")
        player = try! AVAudioPlayer(contentsOf: url!)
        player!.play()
    }
        

}

