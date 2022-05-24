//
//  FUScanCoreManager.h
//  FUScanKitSDK_Example
//
//  Created by FuHuiCong 傅辉聪 on 2022/5/10.
//  Copyright © 2022 fuhuicong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUScanCoreManager : NSObject

@property (nonatomic, retain) AVCaptureVideoPreviewLayer * previewLayer;

@property (nonatomic, assign) CGRect scanRect;

@property (nonatomic, assign) UIInterfaceOrientation curOrientaion;

@property (nonatomic, copy) void(^resultBlock)(NSString * resultString);

- (void)initCaptureView:(UIView *)view;

/**
 开始扫描预览画面
 */
- (void)startSession;

/**
 停止扫描预览画面
 */
- (void)stopSession;

@end

NS_ASSUME_NONNULL_END
