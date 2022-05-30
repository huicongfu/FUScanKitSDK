//
//  FUScanCodeViewController.h
//  FUScanKitSDK_Example
//
//  Created by FuHuiCong 傅辉聪 on 2022/5/6.
//  Copyright © 2022 fuhuicong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FUScanCodeDelegate <NSObject>

- (void)scanViewController:(UIViewController *)scanVC recognizeResult:(NSString *)recognizeResult;

@end

@interface FUScanCodeViewController : UIViewController

@property (nonatomic, weak) id<FUScanCodeDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
