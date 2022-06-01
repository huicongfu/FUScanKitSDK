//
//  FUScanResultModel.h
//  FUScanKitSDK
//
//  Created by FuHuiCong 傅辉聪 on 2022/6/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class Resultpoint;

@interface FUScanResultModel : NSObject
/// 放大倍数
@property (nonatomic, assign) NSInteger zoomValue;
/// 码制式
@property (nonatomic, copy) NSString *formatValue;
/// 
@property (nonatomic, copy) NSString *time;
/// 码场景类型
@property (nonatomic, copy) NSString *sceneType;
/// 码图角点坐标位置
@property (nonatomic, strong) NSArray *ResultPoint;

@property (nonatomic, strong) NSArray *rawBytes;
/// 码值
@property (nonatomic, copy) NSString *text;

@property (nonatomic, assign) NSInteger numBits;
/// 码场景
@property (nonatomic, strong) NSDictionary *parserDic;
/// 曝光值
@property (nonatomic, assign) NSInteger exposureAdjustmentValue;

@end


@interface Resultpoint : NSObject

@property (nonatomic, copy) NSString *posY;

@property (nonatomic, copy) NSString *posX;

@end

NS_ASSUME_NONNULL_END
