//
//  NotThemViewController.h
//  sphere
//
//  Created by Aniruddh Iyengar on 1/21/17.
//  Copyright © 2017 Aniruddh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotThemViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *fullNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
- (IBAction)confirmClicked:(id)sender;
@property (nonatomic) UIImage *offendingPic;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
