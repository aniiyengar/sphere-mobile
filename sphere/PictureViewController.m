//
//  PictureViewController.m
//  sphere
//
//  Created by Aniruddh Iyengar on 1/21/17.
//  Copyright © 2017 Aniruddh. All rights reserved.
//

#import "PictureViewController.h"

@interface PictureViewController ()

@end

@implementation PictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftPan:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.cameraPreview addGestureRecognizer:leftSwipe];
    
    UISwipeGestureRecognizer *upSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(upPan:)];
    upSwipe.direction = UISwipeGestureRecognizerDirectionDown;
    [self.cameraPreview addGestureRecognizer:upSwipe];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageTaken) name:@"imageTaken" object:nil];
    
    UITapGestureRecognizer *longPress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPress.numberOfTapsRequired = 2;
    [self.cameraPreview addGestureRecognizer:longPress];
    
}

- (void)longPress:(id)sender {
    [self.modalBlack setOpacity:0.7];
    UIActivityIndicatorView *av = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [av startAnimating];
    av.center = self.view.center;
    [self.modalBlack addSublayer:av.layer];
    [self takeImage];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    self.seesFace = NO;
    self.modalBlack = [CALayer layer];
    self.modalBlack.backgroundColor=[UIColor blackColor].CGColor;
    self.modalBlack.opacity=0;
    self.modalBlack.frame = self.cameraPreview.frame;
    
    self.session = [[AVCaptureSession alloc] init];
    AVCaptureDevice *frontCamera = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
    
    NSError *error = nil;
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:&error];
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    
    self.sessionQueue = dispatch_queue_create("sessionQueue", DISPATCH_QUEUE_SERIAL);
    
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.previewLayer.frame = self.cameraPreview.bounds;
    [self.cameraPreview.layer addSublayer:self.previewLayer];
    
    AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [metadataOutput setMetadataObjectsDelegate:self queue:self.sessionQueue];
    if ([self.session canAddOutput:metadataOutput]) {
        [self.session addOutput:metadataOutput];
    }
    metadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeFace];
    
    self.stillOutput = [[AVCapturePhotoOutput alloc] init];
    if ([self.session canAddOutput:self.stillOutput]) {
        [self.session addOutput:self.stillOutput];
    }
    
    self.faceHighlightLayer = [CALayer layer];
    self.faceHighlightLayer.backgroundColor = [UIColor colorWithRed:0 green:0.724 blue:0.588 alpha:1].CGColor;
    self.faceHighlightLayer.opacity = 0;
    
    [self.previewLayer addSublayer:self.faceHighlightLayer];
    
    dispatch_async(self.sessionQueue, ^{
        [self.session startRunning];
    });
    
    EAGLContext *ctx = [EAGLContext currentContext];
    GLKView *view = [[GLKView alloc] initWithFrame:[[UIScreen mainScreen] bounds] context:ctx];
    CIContext *ctx2 = [CIContext contextWithEAGLContext:ctx];
    
    [self.previewLayer addSublayer:self.modalBlack];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    AVMetadataObject *tObject = nil;
    
    for (AVMetadataObject *mObject in metadataObjects) {
        if (mObject.type == AVMetadataObjectTypeFace) {
            tObject = [self.previewLayer transformedMetadataObjectForMetadataObject:mObject];
            [CATransaction begin];
            if (self.seesFace) {
                self.faceHighlightLayer.opacity = 0.4;
            }
            float size = MAX(tObject.bounds.size.width, tObject.bounds.size.height);
            self.faceHighlightLayer.frame = CGRectMake(tObject.bounds.origin.x-size*0.25, tObject.bounds.origin.y-size*0.25, size*1.5, size*1.5);
            self.faceHighlightLayer.cornerRadius = size*0.75;
            [CATransaction commit];
            self.seesFace = YES;
            self.facebox = tObject.bounds;
            break;
        }
    }
    
    if (tObject == nil) {
        self.seesFace = NO;
        self.facebox = CGRectNull;
        [CATransaction begin];
        self.faceHighlightLayer.opacity = 0;
        [CATransaction commit];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (touches.count == 1 && !self.modalOpen) {
        for (UITouch *touch in touches) {
            CGPoint pt = [touch locationInView:touch.view];
            pt = [touch.view convertPoint:pt toView:nil];
            if (CGRectContainsPoint(self.facebox, pt)) {
                [self.modalBlack setOpacity:0.7];
                UIActivityIndicatorView *av = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
                [av startAnimating];
                av.center = self.view.center;
                [self.modalBlack addSublayer:av.layer];
                [self takeImage];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden { return YES; }

- (void)paymentConfirmed {
    NSLog(@"SDFSD");
    [self.payvc.view removeFromSuperview];
    self.modalBlack.opacity = 0;
    self.modalOpen = NO;
    
}

- (void)notThem:(UIImage *)img{
    NotThemViewController *nvm = [[NotThemViewController alloc] initWithNibName:@"NotThemViewController" bundle:nil];
    nvm.offendingPic = img;
    [self.navigationController pushViewController:nvm animated:YES];
}

- (void)takeImage {
    AVCaptureConnection *conn = [self.stillOutput connectionWithMediaType:AVMediaTypeVideo];
    conn.videoOrientation = AVCaptureVideoOrientationPortrait;
    [self.stillOutput capturePhotoWithSettings:[AVCapturePhotoSettings photoSettings] delegate:self];
}

- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishProcessingPhotoSampleBuffer:(CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(AVCaptureBracketedStillImageSettings *)bracketSettings error:(NSError *)error {
    NSData *imgData = [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer previewPhotoSampleBuffer:previewPhotoSampleBuffer];
    UIImage *img = [[UIImage alloc] initWithData:imgData];
    self.lastImage = img;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"imageTaken" object:nil];
}

- (void)leftPan:(id)sender {
    self.rvc = [[RecentsViewController alloc] initWithNibName:@"RecentsViewController" bundle:nil];
    [self.view addSubview:self.rvc.view];
    self.rvc.view.frame = self.view.frame;
    self.rvc.view.center = CGPointMake(-self.view.center.x, self.view.center.y);
    
    
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.3];
    self.rvc.view.center = self.view.center;
    [UIView commitAnimations];
}

- (void)upPan:(id)sender {
    self.avc = [[AccountViewController alloc] initWithNibName:@"AccountViewController" bundle:nil];
     [self.view addSubview:self.avc.view];
    self.avc.view.frame = self.view.frame;
    self.avc.view.center = CGPointMake(self.view.center.x, -self.view.center.y);
    
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.3];
    self.avc.view.center = self.view.center;
    [UIView commitAnimations];
}

- (void)imageTaken {
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://sphere-flask-lol.herokuapp.com/api/compare"]];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"userName"], [[NSUserDefaults standardUserDefaults] valueForKey:@"userPass"]];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    [req setHTTPMethod:@"POST"];
    
    NSData *imgDat = UIImagePNGRepresentation(self.lastImage);
    NSData *strDat = [imgDat base64EncodedDataWithOptions:NSDataBase64Encoding76CharacterLineLength];
    
    [req setHTTPBody:strDat];
    
    [req setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:kNilOptions]];
    
    [req setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *resp, NSError *err) {
        
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"%@", d);
        NSString *username = [d valueForKey:@"username"];
        NSString *uid = [[d valueForKey:@"data"] valueForKey:@"_id"];
        
        NSLog(@"%@\n", [[d valueForKey:@"data"] valueForKey:@"_id"]);
        [self performSelectorOnMainThread:@selector(introducePay:) withObject:username waitUntilDone:NO];
        self.payvc.personID = uid;
        
        
        
        
    }] resume];
}

- (void)introducePay:(NSString *)name {
    self.payvc = [[PaymentViewController alloc] initWithNibName:@"PaymentViewController" bundle:nil];
    self.payvc.superviewController = self;
    [self.view addSubview:self.payvc.view];
    [self.payvc.view setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height*1.5)];
    self.payvc.recipientLabel.text = name;
    self.modalOpen = YES;
    [CATransaction begin];
    
    [CATransaction commit];
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.5];
    self.payvc.view.center = CGPointMake(self.view.center.x, self.view.center.y*0.7);
    [UIView commitAnimations];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
