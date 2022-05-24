//
//  UIDevice+FUAddition.m
//  FUScanKitSDK_Example
//
//  Created by FuHuiCong 傅辉聪 on 2022/5/6.
//  Copyright © 2022 fuhuicong. All rights reserved.
//

#import "UIDevice+FUAddition.h"

@implementation UIDevice (FUAddition)

/// 顶部安全区高度
+ (CGFloat)safeDistanceTop {
    if (@available(iOS 13.0, *)) {
        NSSet *set = [UIApplication sharedApplication].connectedScenes;
        UIWindowScene *windowScene = [set anyObject];
        UIWindow *window = windowScene.windows.firstObject;
        return window.safeAreaInsets.top;
    } else if (@available(iOS 11.0, *)) {
        UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
        return window.safeAreaInsets.top;
    }
    return 0;
}

/// 底部安全区高度
+ (CGFloat)safeDistanceBottom {
    if (@available(iOS 13.0, *)) {
        NSSet *set = [UIApplication sharedApplication].connectedScenes;
        UIWindowScene *windowScene = [set anyObject];
        UIWindow *window = windowScene.windows.firstObject;
        return window.safeAreaInsets.bottom;
    } else if (@available(iOS 11.0, *)) {
        UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
        return window.safeAreaInsets.bottom;
    }
    return 0;
}


/// 顶部状态栏高度（包括安全区）
+ (CGFloat)statusBarHeight {
    if (@available(iOS 13.0, *)) {
        NSSet *set = [UIApplication sharedApplication].connectedScenes;
        UIWindowScene *windowScene = [set anyObject];
        UIStatusBarManager *statusBarManager = windowScene.statusBarManager;
        return statusBarManager.statusBarFrame.size.height;
    } else {
        return [UIApplication sharedApplication].statusBarFrame.size.height;
    }
}

/// 导航栏高度
+ (CGFloat)navigationBarHeight {
    return 44.0f;
}

/// 状态栏+导航栏的高度
+ (CGFloat)navigationFullHeight {
    return [UIDevice statusBarHeight] + [UIDevice navigationBarHeight];
}

/// 底部Tabbar高度
+ (CGFloat)tabBarHeight {
    return 49.0f;
}

/// 底部导航栏高度（包括安全区）
+ (CGFloat)tabBarFullHeight {
    return [UIDevice statusBarHeight] + [UIDevice safeDistanceBottom];
}

/// 是否是iPad
+ (BOOL)getIsIpad {
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
}

@end
