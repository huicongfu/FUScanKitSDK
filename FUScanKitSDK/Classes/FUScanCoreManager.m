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

@interface FUScanCoreManager ()<AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, assign) BOOL decoding;
@property (nonatomic, retain) dispatch_queue_t decodeQueue;
@property (nonatomic, retain) AVCaptureSession * captureSession;

@end

@implementation FUScanCoreManager

- (instancetype)init {
    if (self = [super init]) {
        self.decoding = YES;
    }
    return self;
}

- (void)initCaptureView:(UIView *)view {
    if (self.decodeQueue == NULL) {
        // 所有对 capture session 的调用都是阻塞的，因此建议将它们分配到后台串行队列中
        self.decodeQueue = dispatch_queue_create("com.FUScanKitSDK.searialQueue", NULL);
    }
    // 获取视频输入设备，该方法默认返回iPhone的后置摄像头
    AVCaptureDevice * inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 设置对焦模式
    if ([inputDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
        if ([inputDevice lockForConfiguration:NULL]) {
            inputDevice.focusMode = AVCaptureFocusModeContinuousAutoFocus;
            [inputDevice unlockForConfiguration];
        }
    }
    // 设置曝光模式
    if ([inputDevice isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
        if ([inputDevice lockForConfiguration:NULL]) {
            [inputDevice setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
            [inputDevice unlockForConfiguration];
        }
    }
    // 白平衡
    if ([inputDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
        if ([inputDevice lockForConfiguration:NULL]) {
            [inputDevice setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
            [inputDevice unlockForConfiguration];
        }
    }
    // 弱光
    if ([inputDevice isLowLightBoostSupported]) {
        if ([inputDevice lockForConfiguration:NULL]) {
            [inputDevice setAutomaticallyEnablesLowLightBoostWhenAvailable:YES];
            [inputDevice unlockForConfiguration];
        }
    }
    
    NSError * inputError = nil;
    // 将捕捉设备加入到捕捉会话中
    AVCaptureDeviceInput * captureInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&inputError];
    if (inputError && inputError.code == AVErrorApplicationIsNotAuthorizedToUseDevice) {
        return;
    } else if (inputError || captureInput == nil) {
        return;
    }
    AVCaptureVideoDataOutput * captureVideoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    captureVideoDataOutput.alwaysDiscardsLateVideoFrames = YES;
    [captureVideoDataOutput setSampleBufferDelegate:self queue:_decodeQueue];
    [captureVideoDataOutput setVideoSettings:@{(NSString *)kCVPixelBufferPixelFormatTypeKey : [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA]}];
    self.captureSession = [[AVCaptureSession alloc] init];
    
    AVCaptureSessionPreset preset = nil;
    if (NSClassFromString(@"NSOrderedSet") &&
        [UIScreen mainScreen].scale > 1 &&
        [inputDevice supportsAVCaptureSessionPreset:AVCaptureSessionPreset1280x720] && [UIDevice getIsIpad]) {
        preset = AVCaptureSessionPreset1280x720;
    }
    if (!preset) {
        if ([inputDevice supportsAVCaptureSessionPreset:AVCaptureSessionPreset1920x1080]) {
            preset = AVCaptureSessionPreset1920x1080;
        } else {
            preset = AVCaptureSessionPresetMedium;
        }
    }
    if ([self.captureSession canSetSessionPreset:preset]) {
        self.captureSession.sessionPreset = preset;
    }
    if ([self.captureSession canAddInput:captureInput]) {
        [self.captureSession addInput:captureInput];
    }
    if ([self.captureSession canAddOutput:captureVideoDataOutput]) {
        [self.captureSession addOutput:captureVideoDataOutput];
    }
    
    if (!self.previewLayer) {
        self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    }
    self.previewLayer.frame = view.bounds;
    self.previewLayer.connection.videoOrientation = (AVCaptureVideoOrientation)[UIApplication sharedApplication].statusBarOrientation;
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [view.layer insertSublayer:self.previewLayer atIndex:0];
}


- (void)startSession {
    self.decoding = YES;
    [self.captureSession startRunning];
}

- (void)stopSession {
    self.decoding = NO;
    [self.captureSession stopRunning];
}

- (void)stopCapture {
    self.decoding = NO;
    [self.captureSession stopRunning];
    AVCaptureInput * input = [self.captureSession.inputs firstObject];
    [self.captureSession removeInput:input];
    AVCaptureVideoDataOutput * output = (AVCaptureVideoDataOutput *)[self.captureSession.outputs firstObject];
    [output setSampleBufferDelegate:nil queue:NULL];
    [self.captureSession removeOutput:output];
    [self.previewLayer removeFromSuperlayer];
//    self.previewLayer = nil;
    self.captureSession = nil;
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    HmsScanOptions * scanOptions = [[HmsScanOptions alloc] initWithScanFormatType:ALL Photo:NO];
    NSDictionary * resultDict = [HmsBitMap bitMapForSampleBuffer:sampleBuffer withOptions:scanOptions];
    NSString * resultStr = resultDict[@"text"];
    if (resultStr && resultStr.length > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self handleScanResult:resultStr];
        });
    } else {
        
    }
}

- (void)handleScanResult:(NSString *)result {
    if (self.resultBlock) {
        self.resultBlock(result);
    }
}

- (void)dealloc {
    NSLog(@"dealloc");
//    [self stopCapture];
//    if (_decodeQueue != NULL) {
//        _decodeQueue = NULL;
//    }
}

@end
