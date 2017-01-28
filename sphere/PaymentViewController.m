//
//  PaymentViewController.m
//  sphere
//
//  Created by Aniruddh Iyengar on 1/21/17.
//  Copyright © 2017 Aniruddh. All rights reserved.
//

#import "PaymentViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PictureViewController.h"

@interface PaymentViewController ()

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.layer.cornerRadius = 15;
    [self.confirmButton setEnabled:NO];
    [self.amountField addTarget:self
                  action:@selector(textFieldChanged)
        forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldChanged {
    if (self.amountField.text.floatValue == 0 || self.amountField.text.length == 0) {
        [self.confirmButton setEnabled:NO];
    }
    else [self.confirmButton setEnabled:YES];
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

- (IBAction)confirmClicked:(id)sender {
    [self.superviewController paymentConfirmed];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://sphere-flask-lol.herokuapp.com/api/deposit"]];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"userName"], [[NSUserDefaults standardUserDefaults] valueForKey:@"userPass"]];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:kNilOptions]];
    [req setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    NSString *str = [NSString stringWithFormat:@"{\"amount\":%f, \"account_id\":\"%@\"}", [self.amountField.text floatValue], self.personID];
    
    
    
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    [req setHTTPBody:jsonData];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSLog(@"%@", self.personID);
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *resp, NSError *err) {
        
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
    }] resume];
}

- (IBAction)xClicked:(id)sender {
    [self.superviewController paymentConfirmed];
}
- (IBAction)notThemClicked:(id)sender {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageReceivedFromPicture:) name:@"imageCaptured" object:nil];
//    [self.superviewController takeImage];
    [self.superviewController paymentConfirmed];
    [self.superviewController notThem:self.superviewController.lastImage];
}

//- (void)imageReceivedFromPicture:(NSNotification *)note {
//    UIImage *img = [note object];
////    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"imageCaptured" object:nil];
//    [self.superviewController notThem:img];
//}
@end
