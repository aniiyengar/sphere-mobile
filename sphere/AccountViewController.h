//
//  AccountViewController.h
//  sphere
//
//  Created by Aniruddh Iyengar on 1/21/17.
//  Copyright © 2017 Aniruddh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountViewController : UIViewController
- (IBAction)upClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *routingLabel;
@property (strong, nonatomic) IBOutlet UILabel *acctLabel;
@property (strong, nonatomic) IBOutlet UILabel *balanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *fullNameLabelBig;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabelBig;
- (IBAction)logoutClicked:(id)sender;

- (void)populate:(NSDictionary *)dict;

@end
