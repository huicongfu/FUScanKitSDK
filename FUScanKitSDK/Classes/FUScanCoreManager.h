//
//  FUScanCoreManager.h
//  FUScanKitSDK_Example
//
//  Created by FuHuiCong 傅辉聪 on 2022/5/10.
//  Copyright © 2022 fuhuicong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "FUScanResultModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUScanCoreManager : NSObject

@property (nonatomic, retain) AVCaptureVideoPreviewLayer * previewLayer;

@property (nonatomic, copy) void(^resultBlock)(FUScanResultModel * resultModel);

- (void)initCaptureView:(UIView *)view;

/**
 开始扫描预览画面
 */
- (void)startSession;

/**
 停止扫描预览画面
 */
- (void)stopSession;

/// 解析图片二维码，可以返回多个结果
/// @param image 要解析的图片
- (NSArray<FUScanResultModel *> *)multipleResultParseImage:(UIImage *)image;

/// 解析图片二维码，返回单个结果
/// @param image 要解析的图片
- (FUScanResultModel *)parseIamge:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
