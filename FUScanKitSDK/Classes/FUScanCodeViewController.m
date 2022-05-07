//
//  FUScanCodeViewController.m
//  FUScanKitSDK_Example
//
//  Created by FuHuiCong 傅辉聪 on 2022/5/6.
//  Copyright © 2022 fuhuicong. All rights reserved.
//

#import "FUScanCodeViewController.h"
#import <Masonry/Masonry.h>
#import "UIDevice+FUAddition.h"
#import "FUScanKitSDKBundle.h"
#import "FULanguageManager.h"

#define FUScanCodeLanguage(key) [FULanguageManager localizedStringForKey:(key) value:key table:(@"FUScanKitSDKLanguage") bundle:[FUScanKitSDKBundle FUScanKitSDKBundle]]

@interface FUScanCodeViewController ()

@property (strong, nonatomic) UIView * captureContainerView;
@property (strong, nonatomic) UIView * bottomView;
@property (strong, nonatomic) UIButton * btnAlbum;
@property (strong, nonatomic) UILabel  * btnAlbumTitleLabel;
@property (strong, nonatomic) UIButton * btnInput;
@property (strong, nonatomic) UILabel  * btnInputTitleLabel;
@property (strong, nonatomic) UIButton * btnLight;
@property (strong, nonatomic) UILabel  * btnLightTitleLabel;
@property (nonatomic,strong) UILabel * labRemind;
@property (nonatomic,strong) UILabel * labPrompt;

@end

@implementation FUScanCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

- (void)createUI {
    self.captureContainerView = [[UIView alloc] init];
    self.captureContainerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.captureContainerView];
    [self.captureContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, [self getBottomHeight], 0));
    }];
    
    [self createBottomViewUI];
}

- (void)createBottomViewUI {
    self.bottomView = [[UIView alloc] init];
    [self.view addSubview:self.bottomView];
    self.bottomView.backgroundColor = [UIColor blackColor];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([self getBottomHeight]);
        make.bottom.mas_offset(0);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
    }];
    
    CGFloat margin = 56;
    
    
    self.btnAlbum = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bottomView addSubview:self.btnAlbum];
    
    self.btnAlbum.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    self.btnAlbum.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.btnAlbum addTarget:self action:@selector(btnPhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *albumImage = [FUScanKitSDKBundle FUScanKitBundleImage:@"QRCScan_Album"];
    [self.btnAlbum setImage:albumImage forState:UIControlStateNormal];
    [self.btnAlbum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(76);
        make.height.mas_equalTo(76);
        make.centerY.mas_equalTo(self.bottomView.mas_centerY);
        make.left.mas_offset(margin);
    }];
    
    self.btnAlbumTitleLabel = [UILabel new];
    self.btnAlbumTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.btnAlbumTitleLabel.font = [UIFont systemFontOfSize:14.0];
    self.btnAlbumTitleLabel.textColor = [UIColor whiteColor];
    self.btnAlbumTitleLabel.text = FUScanCodeLanguage(@"LK_FUScanKitSDK_Album");
    self.btnAlbumTitleLabel.userInteractionEnabled = NO;
    [self.btnAlbum addSubview:self.btnAlbumTitleLabel];
    [self.btnAlbumTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(22);
        make.left.right.bottom.mas_equalTo(0);
    }];

    
    self.btnLight = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bottomView addSubview:self.btnLight];
           
    self.btnLight.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    self.btnLight.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
           
    UIImage *btnLightimage = [FUScanKitSDKBundle FUScanKitBundleImage:@"QRCScan_OffLight"];
    [self.btnLight setImage:btnLightimage forState:UIControlStateNormal];
    btnLightimage = [FUScanKitSDKBundle FUScanKitBundleImage:@"QRCScan_OnLigh"];
    [self.btnLight setImage:btnLightimage forState:UIControlStateSelected];
           
    [self.btnLight addTarget:self action:@selector(btnLight:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnLight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(76);
        make.height.mas_equalTo(76);
        make.centerY.mas_equalTo(self.bottomView.mas_centerY);
        make.right.mas_offset(-margin);
    }];
    
    self.btnLightTitleLabel = [UILabel new];
    self.btnLightTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.btnLightTitleLabel.font = [UIFont systemFontOfSize:14.0];
    self.btnLightTitleLabel.textColor = [UIColor whiteColor];
    self.btnLightTitleLabel.text = FUScanCodeLanguage(@"LK_FUScanKitSDK_LightOn");
    self.btnLightTitleLabel.userInteractionEnabled = NO;
    [self.btnLight addSubview:self.btnLightTitleLabel];
    [self.btnLightTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(22);
        make.left.right.bottom.mas_equalTo(0);
    }];
}


- (CGFloat)getBottomHeight{
    return [UIDevice safeDistanceBottom]+96;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
