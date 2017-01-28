//
//  RecentsViewController.m
//  sphere
//
//  Created by Aniruddh Iyengar on 1/21/17.
//  Copyright © 2017 Aniruddh. All rights reserved.
//

#import "RecentsViewController.h"


@interface RecentsViewController ()

@end

@implementation RecentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://sphere-flask-lol.herokuapp.com/capital_one/recent_deposits"]];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"], [[NSUserDefaults standardUserDefaults] objectForKey:@"userPass"]];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:kNilOptions]];
    [req setValue:authValue forHTTPHeaderField:@"Authorization"];
    [[[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *resp, NSError *err) {
        NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
        self.recentsData = [[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil] valueForKey:@"results"];
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        
    }] resume];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [[self tableView] registerNib:[UINib nibWithNibName:@"RecentsTableViewCell" bundle:nil] forCellReuseIdentifier:@"recentsCell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RecentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recentsCell"];
    if (!cell) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"RecentsTableViewCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    NSDictionary *dict = [self.recentsData objectAtIndex:indexPath.row];
    NSString *username = [NSString stringWithFormat:@"@%@%@", [dict valueForKey:@"first_name"], [dict valueForKey:@"last_name"]];
    NSString *amount = [NSString stringWithFormat:@"%@$%@", ([[dict valueForKey:@"amount"] floatValue] > 0) ? @"+" : @"-", [dict valueForKey:@"amount"]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *transDate =[formatter dateFromString: [[dict valueForKey:@"transaction_date"] substringWithRange:NSMakeRange(0, 10)]];
    NSLog(@"%@",transDate);
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:transDate];
    NSString *date = [NSString stringWithFormat:@"%@ %ld", [[@"Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec" componentsSeparatedByString:@" "] objectAtIndex:([components month]-1)], (long)[components day]];
    
    cell.dateLabel.text = date;
    cell.amtLabel.text = amount;
    cell.fromLabel.text = username;
    
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.recentsData.count;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backClicked:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.center = CGPointMake(-self.view.superview.center.x, self.view.superview.center.y);
    } completion:^(BOOL finished){
        [self.view removeFromSuperview];
    }];
}
@end
