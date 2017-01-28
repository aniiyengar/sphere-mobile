//
//  RecentsViewController.h
//  sphere
//
//  Created by Aniruddh Iyengar on 1/21/17.
//  Copyright © 2017 Aniruddh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecentsTableViewCell.h"

@interface RecentsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *recentsData;
- (IBAction)backClicked:(id)sender;

@end
