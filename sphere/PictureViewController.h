//
//  PictureViewController.h
//  sphere
//
//  Created by Aniruddh Iyengar on 1/21/17.
//  Copyright © 2017 Aniruddh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PaymentViewController.h"
#import "NotThemViewController.h"
#import "RecentsViewController.h"
#import "AccountViewController.h"
#import <GLKit/GLKit.h>

@interface PictureViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureMetadataOutputObjectsDelegate, AVCapturePhotoCaptureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *cameraPreview;
@property (nonatomic) AVCaptureSession *session;
@property (nonatomic) dispatch_queue_t sessionQueue;
@property (nonatomic) AVCaptureDeviceInput *input;
@property (nonatomic) AVCapturePhotoOutput *stillOutput;
@property (nonatomic) CALayer *faceHighlightLayer;
@property (nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic) BOOL seesFace;
@property (nonatomic) CGRect facebox;
@property (nonatomic) CALayer *modalBlack;
@property (nonatomic) BOOL modalOpen;
@property (nonatomic) PaymentViewController *payvc;
@property (nonatomic) UIImage *lastImage;
@property (strong, nonatomic) RecentsViewController *rvc;
@property (strong, nonatomic) AccountViewController *avc;

- (void)paymentConfirmed;
- (void)notThem:(UIImage *)img;
- (void)takeImage;
- (void)leftPan:(id)sender;
- (void)upPan:(id)sender;
- (void)imageTaken;
- (void) introducePay:(NSString *)name;
- (void)longPress:(id)sender;

@end
