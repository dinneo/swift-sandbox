//
//  postViewController.swift
//  Instagram
//
//  Created by David Leonard on 3/24/15.
//  Copyright (c) 2015 DrkSephy. All rights reserved.
//

import UIKit

class postViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    func displayAlert(title:String, error:String) {
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    var photoSelected: Bool = false;
    
    @IBOutlet weak var imageToPost: UIImageView!
    
    
    
    @IBAction func chooseImage(sender: AnyObject) {
        var image = UIImagePickerController();
        image.delegate = self;
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        image.allowsEditing = false;
        self.presentViewController(image, animated: true, completion: nil);
    }
    
    @IBOutlet weak var shareText: UITextField!
    
    @IBAction func postImage(sender: AnyObject) {
        var error = "";
        if photoSelected == false {
            error = "Please select an image to post!";
        } else if shareText.text == "" {
            error = "Please enter a message";
        }
        
        if error != "" {
            displayAlert("Cannot Post Image", error: error);
        } else {
            var post = PFObject(className: "Post"); // Store each of our images as "Post" classes
            // save the text
            post["Title"] = shareText.text;
            
            post.saveInBackgroundWithBlock{(success: Bool!, error: NSError!) -> Void in
                if success == false {
                    self.displayAlert("Could not post image!", error: "Please try again later");
                } else {
                    let imageData = UIImagePNGRepresentation(self.imageToPost.image);
                    let imageFile = PFFile(name: "image.png", data: imageData);
                    post["imageFile"] = imageFile;
                    
                    post.saveInBackgroundWithBlock{(success: Bool!, error: NSError!) -> Void in
                        if success == false {
                            self.displayAlert("Could not post image!", error: "Please try again later");
                        } else {
                            println("Posted successfully!");
                    }
                    
                }
            }
            
            
            }
        }
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        println("Image Selected");
        self.dismissViewControllerAnimated(true, completion: nil);
        imageToPost.image = image;
        photoSelected = true;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
