//
//  FUScanKitSDKBundle.h
//  FUScanKitSDK_Example
//
//  Created by FuHuiCong 傅辉聪 on 2022/5/7.
//  Copyright © 2022 fuhuicong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUScanKitSDKBundle : NSObject

+ (NSBundle *)FUScanKitSDKBundle;

+ (UIImage *)FUScanKitBundleImage:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
