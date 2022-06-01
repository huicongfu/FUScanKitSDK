//
//  FUScanCodeViewController.h
//  FUScanKitSDK_Example
//
//  Created by FuHuiCong 傅辉聪 on 2022/5/6.
//  Copyright © 2022 fuhuicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUScanCoreManager.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FUScanCodeDelegate <NSObject>

- (void)scanViewController:(UIViewController *)scanVC recognizeResult:(FUScanResultModel *)resultModel;

@end

@interface FUScanCodeViewController : UIViewController

@property (nonatomic, weak) id<FUScanCodeDelegate> delegate;

/**
 扫码识别之后是否声音提示
 */
@property (nonatomic, assign) BOOL hasSound;

/**
 扫码识别之后是否震动
 */
@property (nonatomic, assign) BOOL hasShake;

@end

NS_ASSUME_NONNULL_END
