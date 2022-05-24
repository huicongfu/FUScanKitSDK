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
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "FUScanCoreManager.h"

#define FUScanCodeLanguage(key) [FULanguageManager localizedStringForKey:(key) value:key table:(@"FUScanKitSDKLanguage") bundle:[FUScanKitSDKBundle FUScanKitSDKBundle]]

@interface FUScanCodeViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (retain, nonatomic) UIView * captureContainerView;
@property (retain, nonatomic) UIView * bottomView;
@property (retain, nonatomic) UIButton * btnAlbum;
@property (retain, nonatomic) UILabel  * btnAlbumTitleLabel;
@property (retain, nonatomic) UIButton * btnInput;
@property (retain, nonatomic) UILabel  * btnInputTitleLabel;
@property (retain, nonatomic) UIButton * btnLight;
@property (retain, nonatomic) UILabel  * btnLightTitleLabel;
@property (nonatomic, retain) UILabel * labRemindretain;
@property (nonatomic, retain) UILabel * labPrompt;

@property (nonatomic, retain) FUScanCoreManager * scanCoreManager;
@property (nonatomic, assign) CGRect scanRect;
///是否横屏，YES:横屏屏；NO:竖屏
@property (nonatomic, assign) BOOL isLandScapeMode;
@property (nonatomic,assign)UIInterfaceOrientation preUIInterfaceOrientation;

@end

@implementation FUScanCodeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.preUIInterfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
}

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
    [self initScanCoreManager];
    __weak typeof(self) weakSelf = self;
    [self checkCameraAuthorization:^(BOOL granted) {
        if (granted) {
            [weakSelf.scanCoreManager startSession];
        } else {
            [weakSelf showNoCameraAuthorizationAlert];
        }
    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didChangeRotate:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)showNoCameraAuthorizationAlert {
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:FUScanCodeLanguage(@"LK_FUScanKitSDK_Prompt") message:FUScanCodeLanguage(@"LK_FUScanKitSDK_CameraErrorPrompt") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:FUScanCodeLanguage(@"LK_FUScanKitSDK_GoToSetting") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:FUScanCodeLanguage(@"LK_FUScanKitSDK_Cancel") style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:okAction];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)initScanCoreManager {
    if (!self.scanCoreManager) {
        self.scanCoreManager = [[FUScanCoreManager alloc] init];
    }
    self.scanCoreManager.scanRect = self.scanRect;
    [self.scanCoreManager initCaptureView:self.captureContainerView];
    self.scanCoreManager.curOrientaion = [UIApplication sharedApplication].statusBarOrientation;
    self.scanCoreManager.resultBlock = ^(NSString * _Nonnull resultString) {
        NSLog(@"%@", resultString);
    };
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
    
    UIImage *albumImage = [UIImage imageNamed:@"QRCScan_Album"];//[FUScanKitSDKBundle FUScanKitBundleImage:@"QRCScan_Album"];
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

- (void)btnPhoto:(UIButton *)sender
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) { //判断设备是否支持相册
        
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:FUScanCodeLanguage(@"LK_FUScanKitSDK_Prompt") message:FUScanCodeLanguage(@"LK_FUScanKitSDK_PhotoAlbumAuthority") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:FUScanCodeLanguage(@"LK_FUScanKitSDK_OK") style:UIAlertActionStyleDefault handler:nil];
        [alertVC addAction:okAction];
        [self presentViewController:alertVC animated:YES completion:nil];
        return;
    }
    
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = @[(NSString *)kUTTypeImage];
    picker.allowsEditing = NO;
    picker.delegate = self;
    if (@available(iOS 13.0, *)) {
        picker.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    [self presentViewController:picker animated:YES completion:^{
        
    }];

}

- (void)btnLight:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.isSelected) {
        self.btnLightTitleLabel.text = FUScanCodeLanguage(@"LK_FUScanKitSDK_LightOff");
    } else {
        self.btnLightTitleLabel.text = FUScanCodeLanguage(@"LK_FUScanKitSDK_LightOn");
    }
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash]){
            [device lockForConfiguration:nil];
            if (sender.selected) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
            }
            [device unlockForConfiguration];
        }
    }
}

- (void)didChangeRotate:(NSNotification*)notifi {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
}

- (CGFloat)getBottomHeight{
    return [UIDevice safeDistanceBottom]+96;
}

- (BOOL)isLandScapeMode{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        //横屏
        _isLandScapeMode = YES;
    }
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown ) {
        //竖屏
        _isLandScapeMode = NO;
    }
    return _isLandScapeMode;
}

/**
 *  扫描范围
 */
- (CGRect)scanRect
{
    if (CGRectEqualToRect(_scanRect,CGRectZero)) {
        if ([UIDevice getIsIpad]) {
            if (self.isLandScapeMode) {
                //横屏
                _scanRect = [self getScanRectWhenInLandscape];
            }else{
                //竖屏
                _scanRect = [self getScanRectWhenInProtation];
            }
        } else {
            _scanRect = [self getScanRect];
        }
    }
    return _scanRect;
}

- (CGRect)getScanRect {
    CGFloat captureWidth = [UIApplication sharedApplication].keyWindow.bounds.size.width;
    CGFloat captureHeight = [UIApplication sharedApplication].keyWindow.bounds.size.height - [self getBottomHeight] - [UIDevice navigationFullHeight];
    return CGRectMake((captureWidth - 300)/2.0, (captureHeight - 300)/2.0, 300, 300);
}

- (CGRect)getScanRectWhenInLandscape {
    CGFloat windowWidth = [UIApplication sharedApplication].keyWindow.bounds.size.width;
    CGFloat windowHeight = [UIApplication sharedApplication].keyWindow.bounds.size.height - [self getBottomHeight] - [UIDevice navigationFullHeight];
    return CGRectMake((windowWidth - 300)/2, (windowHeight - 300)/2, 300, 300);
}

- (CGRect)getScanRectWhenInProtation {
    CGFloat captureWidth = [UIApplication sharedApplication].keyWindow.bounds.size.width;
    CGFloat captureHeight = [UIApplication sharedApplication].keyWindow.bounds.size.height - [self getBottomHeight] - [UIDevice navigationFullHeight];
    return CGRectMake((captureWidth - 300)/2.0, (captureHeight - 300)/2.0, 300, 300);
}

- (void)checkCameraAuthorization:(void (^)(BOOL granted))completionHandler {
    BOOL canWork = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    if (canWork) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (authStatus) {
            case AVAuthorizationStatusNotDetermined:
            {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completionHandler) {
                            completionHandler(granted);
                        }
                    });
                }];
                return;
            }
                break;
            case AVAuthorizationStatusRestricted:
            case AVAuthorizationStatusDenied:
            {
                canWork = NO;
            }
                break;
            case AVAuthorizationStatusAuthorized:
            {
                canWork = YES;
            }
                break;
            default:
                break;
        }
        if (completionHandler) {
            completionHandler(canWork);
        }
    }
    
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
