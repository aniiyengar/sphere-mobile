//
//  AccountViewController.m
//  sphere
//
//  Created by Aniruddh Iyengar on 1/21/17.
//  Copyright © 2017 Aniruddh. All rights reserved.
//

#import "AccountViewController.h"

@interface AccountViewController ()

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"userDict"]);
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://sphere-flask-lol.herokuapp.com/api/profile"]];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"userName"], [[NSUserDefaults standardUserDefaults] valueForKey:@"userPass"]];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:kNilOptions]];
    [req setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *resp, NSError *err) {
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        [self performSelectorOnMainThread:@selector(populate:) withObject:d waitUntilDone:NO];
    }] resume];
    
    
}

- (void)populate:(NSDictionary *)dict{
    NSString *balance = [[dict valueForKey:@"checking_account"] valueForKey:@"balance"];
    NSString *firstName = [dict valueForKey:@"first_name"];
    NSString *lastName = [dict valueForKey:@"last_name"];
    NSString *accountNum = [[dict valueForKey:@"checking_account"] valueForKey:@"account_number"];
    
    NSLog(@"%@ %@ %@ %@", balance, firstName, lastName, accountNum);
    
    self.fullNameLabel.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    self.fullNameLabelBig.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    self.usernameLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"userName"];
    self.emailLabel.text = [NSString stringWithFormat:@"%@@gmail.com", [[NSUserDefaults standardUserDefaults] valueForKey:@"userName"]];
    self.routingLabel.text = accountNum;
    self.acctLabel.text =[NSString stringWithFormat:@"%@ %@", firstName, lastName];
    self.balanceLabel.text = [NSString stringWithFormat:@"$%@", balance];
    self.usernameLabelBig.text =[NSString stringWithFormat:@"@%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"userName"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)upClicked:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.center = CGPointMake(self.view.superview.center.x, -self.view.superview.center.y);
    } completion:^(BOOL finished){
        [self.view removeFromSuperview];
    }];
}
- (IBAction)logoutClicked:(id)sender {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userDict"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userPass"];

}
@end
