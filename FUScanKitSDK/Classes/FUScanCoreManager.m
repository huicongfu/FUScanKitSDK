//
//  FUScanCoreManager.m
//  FUScanKitSDK_Example
//
//  Created by FuHuiCong 傅辉聪 on 2022/5/10.
//  Copyright © 2022 fuhuicong. All rights reserved.
//

#import "FUScanCoreManager.h"
#import "UIDevice+FUAddition.h"
#import <ScanKitFrameWork/ScanKitFrameWork.h>
#import <MJExtension/MJExtension.h>

@interface FUScanCoreManager ()<AVCaptureVideoDataOutputSampleBufferDelegate>
{
    AVCaptureDevice *captureDevice;
    AVCaptureVideoDataOutput *stillVideoDataOutput;
    AVCaptureConnection *videoConnect;
    
    NSArray *resultList;
}
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureDeviceInput *captureDeviceInput;

@property (nonatomic, retain) dispatch_queue_t decodeQueue;

@end

@implementation FUScanCoreManager

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)initCaptureView:(UIView *)view {
    self.captureSession = [[AVCaptureSession alloc] init];
    if ([self.captureSession canSetSessionPreset:AVCaptureSessionPreset1920x1080]) {
        [self.captureSession setSessionPreset:AVCaptureSessionPreset1920x1080];
    }
    if (self.decodeQueue == NULL) {
        // 所有对 capture session 的调用都是阻塞的，因此建议将它们分配到后台串行队列中
        self.decodeQueue = dispatch_queue_create("com.FUScanKitSDK.searialQueue", NULL);
    }
    // 获取视频输入设备，该方法默认返回iPhone的后置摄像头
    captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!captureDevice) {
        // TODO
        return;
    }
    if (captureDevice.isFocusPointOfInterestSupported && [captureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError * error = nil;
        [captureDevice lockForConfiguration:&error];
        [captureDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        [captureDevice unlockForConfiguration];
    }
    [captureDevice lockForConfiguration:nil];
    captureDevice.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
    BOOL exposureBool = [captureDevice isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure];
    if (!exposureBool) {
        // TODO
    }
    
    NSError * inputError = nil;
    // 将捕捉设备加入到捕捉会话中
    _captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&inputError];
    if ([self.captureSession canAddInput:_captureDeviceInput]) {
        [self.captureSession addInput:_captureDeviceInput];
    }
    
    stillVideoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    [stillVideoDataOutput setVideoSettings:@{(id)kCVPixelBufferPixelFormatTypeKey : [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]}];
    [stillVideoDataOutput setSampleBufferDelegate:self queue:_decodeQueue];
    if ([self.captureSession canAddOutput:stillVideoDataOutput]) {
        [self.captureSession addOutput:stillVideoDataOutput];
    }
    
    videoConnect = [stillVideoDataOutput connectionWithMediaType:AVMediaTypeVideo];
    if ([videoConnect isVideoOrientationSupported]) {
        [videoConnect setVideoOrientation:AVCaptureVideoOrientationPortrait];
    }
    
    
    if (!self.previewLayer) {
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    }
    CALayer * layer = view.layer;
    layer.masksToBounds = YES;
    self.previewLayer.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);//view.bounds;
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [layer addSublayer:self.previewLayer];
}


- (void)startSession {
    if (!_captureSession.isRunning) {
        [self.captureSession startRunning];
    }
}

- (void)stopSession {
    if (_captureSession.isRunning) {
        [_captureSession stopRunning];
    }
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    @autoreleasepool {
        if (output == stillVideoDataOutput) {
            CFRetain(sampleBuffer);
            HmsScanOptions * scanOptions = [[HmsScanOptions alloc] initWithScanFormatType:ALL Photo:NO];
            resultList = [HmsBitMap multiDecodeBitMapForSampleBuffer:sampleBuffer withOptions:scanOptions];
            if (resultList.count == 0) {
                CFRelease(sampleBuffer);
                return;
            }
            if (_captureSession.isRunning) {
                [_captureSession stopRunning];
            }
            NSDictionary * resultDict = resultList.firstObject;
            FUScanResultModel * model = [FUScanResultModel mj_objectWithKeyValues:resultDict];
            if (model) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self handleScanResult:model];
                });
            } else {
                NSLog(@"无效扫码结果");
            }
            CFRelease(sampleBuffer);
        }
    }
}

- (NSArray<FUScanResultModel *> *)multipleResultParseImage:(UIImage *)image {
    if (!image) {
        return nil;
    }
    NSArray * resultArr = [HmsBitMap multiDecodeBitMapForImage:image withOptions:[[HmsScanOptions alloc] initWithScanFormatType:ALL Photo:YES]];
    resultArr = [FUScanResultModel mj_objectArrayWithKeyValuesArray:resultArr];
    return resultArr;
}

- (FUScanResultModel *)parseIamge:(UIImage *)image {
    if (!image) {
        return nil;
    }
    NSDictionary * resultDict = [HmsBitMap bitMapForImage:image withOptions:[[HmsScanOptions alloc] initWithScanFormatType:ALL Photo:YES]];
    FUScanResultModel * model = [FUScanResultModel mj_objectWithKeyValues:resultDict];
    return model;
}

- (void)handleScanResult:(FUScanResultModel *)result {
    if (self.resultBlock) {
        self.resultBlock(result);
    }
}

- (void)dealloc {
    NSLog(@"fuscancoremannager - dealloc");
    [self.captureSession removeInput:self.captureDeviceInput];
    self.captureSession = nil;
    self.captureDeviceInput = nil;
    self->stillVideoDataOutput = nil;
    if (_decodeQueue != NULL) {
        _decodeQueue = NULL;
    }
}

@end
