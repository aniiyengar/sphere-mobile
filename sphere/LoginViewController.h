//
//  LoginViewController.h
//  sphere
//
//  Created by Aniruddh Iyengar on 1/21/17.
//  Copyright © 2017 Aniruddh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)loginClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *incorrectLabel;

- (void)incorrectPass;
- (void)correctPass;
@end
