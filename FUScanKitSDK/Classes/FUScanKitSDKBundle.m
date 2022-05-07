//
//  FUScanKitSDKBundle.m
//  FUScanKitSDK_Example
//
//  Created by FuHuiCong 傅辉聪 on 2022/5/7.
//  Copyright © 2022 fuhuicong. All rights reserved.
//

#import "FUScanKitSDKBundle.h"

@implementation FUScanKitSDKBundle

+ (NSBundle *)FUScanKitSDKBundle {
    static NSBundle * bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"FUScanKitSDKBundle" ofType:@"bundle"]];
    });
    return bundle;
}

+ (UIImage *)FUScanKitBundleImage:(NSString *)name {
    return [UIImage imageNamed:name inBundle:[self FUScanKitSDKBundle] compatibleWithTraitCollection:nil];
}

@end
