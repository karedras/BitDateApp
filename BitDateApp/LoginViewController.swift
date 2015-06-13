//
//  LoginViewController.swift
//  BitDateApp
//
//  Created by Adriel Carsete on 6/12/15.
//  Copyright (c) 2015 Adriel Carsete. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressedFBLogin(sender: UIButton) {
        
        PFFacebookUtils.logInWithPermissions(["public_profile", "user_about_me", "user_birthday"], block: {
            user, error in
            
            if user == nil {
                println("User cancelled Facebook Login.")
                //Add UIAlertController before pushing to appStore
                return
            }
            else if user!.isNew {
                println("User signed up and logged in through Facebook!")
                
                FBRequestConnection.startWithGraphPath("/me?fields=picture,first_name,birthday,gender", completionHandler: {
                    connection, result, error in
                    var resultDictionary = result as! NSDictionary
                    user!["firstName"] = resultDictionary["first_name"]
                    user!["gender"] = resultDictionary["gender"]
                    user!["picture"] = ((resultDictionary["picture"] as! NSDictionary)["data"] as! NSDictionary)["url"]
                    
                    var dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    user!["birthday"] = dateFormatter.dateFromString(resultDictionary["birthday"] as! String)
                    
                    user!.saveInBackgroundWithBlock({
                      success, error in
                        println(success)
                        println(error)
                    })
                })
                
                
                
            }
            else {
                println("User logged in through Facebook!")
            }
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CardsNavController") as? UIViewController
            self.presentViewController(vc!, animated: true, completion: nil)
            
        })
        
    }
    

}
