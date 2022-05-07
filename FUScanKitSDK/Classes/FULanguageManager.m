//
//  FULanguageManager.m
//  FUScanKitSDK_Example
//
//  Created by FuHuiCong 傅辉聪 on 2022/5/7.
//  Copyright © 2022 fuhuicong. All rights reserved.
//

#import "FULanguageManager.h"

@implementation FULanguageManager

+ (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName bundle:(NSBundle*)bundle {
    if (!bundle) {
        NSAssert(NO, @"多语言Bundle文件不存在!");
        return @"";
    }
    return [bundle localizedStringForKey:key value:value table:tableName];
}

@end
