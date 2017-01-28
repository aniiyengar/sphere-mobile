//
//  EntryViewController.m
//  sphere
//
//  Created by Aniruddh Iyengar on 1/21/17.
//  Copyright © 2017 Aniruddh. All rights reserved.
//

#import "EntryViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LoginViewController.h"

@interface EntryViewController ()

@end

@implementation EntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginButton.layer.cornerRadius = 10;
    self.signupButton.layer.cornerRadius = 10;
    
    self.loginButton.clipsToBounds = YES;
    self.loginButton.clipsToBounds = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)highlightSender:(id)sender {
    [sender setAlpha:0.7];
}

-(void)unhighlightSender:(id)sender {
    [sender setAlpha:1];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)loginClicked:(id)sender {
    LoginViewController *lvc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:lvc animated:YES];
}

- (IBAction)signupClicked:(id)sender {
    SignupViewController *svc = [[SignupViewController alloc] initWithNibName:@"SignupViewController" bundle:nil];
    [self.navigationController pushViewController:svc animated:YES];
}
@end
