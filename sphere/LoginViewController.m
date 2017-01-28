//
//  LoginViewController.m
//  sphere
//
//  Created by Aniruddh Iyengar on 1/21/17.
//  Copyright © 2017 Aniruddh. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PictureViewController.h"

@interface LoginViewController ()

- (NSString*)encodeStringTo64:(NSString*)fromString;

@end

@implementation LoginViewController

- (NSString*)encodeStringTo64:(NSString*)fromString
{
    NSData *plainData = [fromString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String;
    base64String = [plainData base64EncodedStringWithOptions:kNilOptions];  // iOS 7+
    
    
    return base64String;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UITextField appearance] setTintColor:[UIColor whiteColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incorrectPass) name:@"incorrectPass" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(correctPass) name:@"correctPass" object:nil];
    
    self.incorrectLabel.layer.opacity = 0;
    

    // Do any additional setup after loading the view from its nib.
}
- (void)incorrectPass {
    self.incorrectLabel.layer.opacity = 1;
}
- (void)correctPass {
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://sphere-flask-lol.herokuapp.com/api/profile"]];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", self.usernameField.text, self.passwordField.text];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:kNilOptions]];
    [req setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *resp, NSError *err) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"userDict"];
        [[NSUserDefaults standardUserDefaults] setObject:self.usernameField.text forKey:@"userName"];
        [[NSUserDefaults standardUserDefaults] setObject:self.passwordField.text forKey:@"userPass"];
    }] resume];
    
    self.incorrectLabel.layer.opacity = 0;
    PictureViewController *pvc = [[PictureViewController alloc] initWithNibName:@"PictureViewController" bundle:nil];
    [self.navigationController pushViewController:pvc animated:YES];
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

- (IBAction)loginClicked:(id)sender {
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://sphere-flask-lol.herokuapp.com/api/token"]];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", self.usernameField.text, self.passwordField.text];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:kNilOptions]];
    [req setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *resp, NSError *err) {
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        if ([(NSHTTPURLResponse *)resp statusCode] != 200) {
            //somethinf went wrong
            [self performSelectorOnMainThread:@selector(incorrectPass) withObject:nil waitUntilDone:NO];
        }
        else {
            [self performSelectorOnMainThread:@selector(correctPass) withObject:nil waitUntilDone:NO];
        }
    }] resume];
    
}
@end
