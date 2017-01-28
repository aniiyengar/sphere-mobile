//
//  SignupViewController.h
//  sphere
//
//  Created by Aniruddh Iyengar on 1/21/17.
//  Copyright © 2017 Aniruddh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "NiceButton.h"
#import "PictureViewController.h"

@interface SignupViewController : UIViewController <AVCapturePhotoCaptureDelegate>
- (IBAction)takePhoto:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)signupClicked:(id)sender;

@property (strong, nonatomic) AVCaptureInput *input;
@property (strong, nonatomic) AVCaptureSession *session;
@property (nonatomic) dispatch_queue_t sessionQueue;

@property (strong, nonatomic) AVCapturePhotoOutput *stillOutput;
@property (strong, nonatomic) UIImage *lastImage;
@property (strong, nonatomic) IBOutlet NiceButton *signupButton;

- (void)imageTaken:(NSNotification *)note;

@end
