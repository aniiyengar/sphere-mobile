//
//  EntryViewController.h
//  sphere
//
//  Created by Aniruddh Iyengar on 1/21/17.
//  Copyright © 2017 Aniruddh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NiceButton.h"
#import "SignupViewController.h"

@interface EntryViewController : UIViewController
@property (weak, nonatomic) IBOutlet NiceButton *loginButton;
@property (weak, nonatomic) IBOutlet NiceButton *signupButton;

- (IBAction)loginClicked:(id)sender;
- (IBAction)signupClicked:(id)sender;

@end
