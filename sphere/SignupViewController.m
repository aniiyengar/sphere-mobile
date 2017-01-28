//
//  SignupViewController.m
//  sphere
//
//  Created by Aniruddh Iyengar on 1/21/17.
//  Copyright © 2017 Aniruddh. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.session = [[AVCaptureSession alloc] init];
    AVCaptureDevice *frontCamera = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront];
    self.signupButton.hidden = YES;
    NSError *error = nil;
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:&error];
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    
    self.sessionQueue = dispatch_queue_create("sessionQueue", DISPATCH_QUEUE_SERIAL);
    
    self.stillOutput = [[AVCapturePhotoOutput alloc] init];
    if ([self.session canAddOutput:self.stillOutput]) {
        [self.session addOutput:self.stillOutput];
    }
    
    dispatch_async(self.sessionQueue, ^{
        [self.session startRunning];
    });
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageTaken:) name:@"signupImageTaken" object:nil];

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

- (IBAction)takePhoto:(id)sender {
    AVCaptureConnection *conn = [self.stillOutput connectionWithMediaType:AVMediaTypeVideo];
    conn.videoOrientation = AVCaptureVideoOrientationPortrait;
    [self.stillOutput capturePhotoWithSettings:[AVCapturePhotoSettings photoSettings] delegate:self];
}

- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishProcessingPhotoSampleBuffer:(CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(AVCaptureBracketedStillImageSettings *)bracketSettings error:(NSError *)error {
    NSData *imgData = [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer previewPhotoSampleBuffer:previewPhotoSampleBuffer];
    UIImage *img = [[UIImage alloc] initWithData:imgData];
    self.lastImage = img;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"signupImageTaken" object:img];
}

- (void)imageTaken:(NSNotification *)note {
    UIImage *img = [note object];
    [self.view endEditing:YES];
    [self.imageView setImage:img];
    self.signupButton.hidden = NO;
}

- (IBAction)signupClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    PictureViewController *pvc = [[PictureViewController alloc] initWithNibName:@"PictureViewController" bundle:nil];
    [self.navigationController pushViewController:pvc animated:YES];
    
}
@end
