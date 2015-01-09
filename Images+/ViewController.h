//
//  ViewController.h
//  Images+
//
//  Created by Erick Bennett on 1/8/15.
//  Copyright (c) 2015 Erick Bennett. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionsButton;
@property UIImage *originalImage;

@end

