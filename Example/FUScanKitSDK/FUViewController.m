//
//  FUViewController.m
//  FUScanKitSDK
//
//  Created by fuhuicong on 05/01/2022.
//  Copyright (c) 2022 fuhuicong. All rights reserved.
//

#import "FUViewController.h"
#import "FUScanCodeViewController.h"
#import <ScanKitFrameWork/ScanKitFrameWork.h>

@interface FUViewController ()<DefaultScanDelegate, FUScanCodeDelegate>
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;

@end

@implementation FUViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)scanButtonAction:(UIButton *)sender {
    FUScanCodeViewController * scanCodeVC = [[FUScanCodeViewController alloc] init];
    scanCodeVC.delegate = self;
    [self.navigationController pushViewController:scanCodeVC animated:YES];
}

- (void)scanViewController:(UIViewController *)scanVC recognizeResult:(FUScanResultModel *)resultModel {
    self.resultTextView.text = nil;
    self.resultTextView.text = resultModel.text;
}

- (IBAction)defaultViewButtonAction:(UIButton *)sender {
    // 初始化HmsDefaultScanViewController，实现代理
//    HmsDefaultScanViewController *hmsDefaultScanViewController = [[HmsDefaultScanViewController alloc] init];
    // "QR_CODE | DATA_MATRIX"表示只扫描QR和DataMatrix的码
//    HmsScanOptions *options = [[HmsScanOptions alloc] initWithScanFormatType:QR_CODE | DATA_MATRIX Photo:FALSE];
    HmsScanOptions *options = [[HmsScanOptions alloc] initWithScanFormatType:ALL Photo:FALSE];
    HmsDefaultScanViewController *hmsDefaultScanViewController = [[HmsDefaultScanViewController alloc] initDefaultScanWithFormatType:options];
    hmsDefaultScanViewController.defaultScanDelegate = self;
    [self.view addSubview:hmsDefaultScanViewController.view];
    [self addChildViewController:hmsDefaultScanViewController];
    [self didMoveToParentViewController:hmsDefaultScanViewController];
    // 隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
}

- (void)defaultScanDelegateForDicResult:(NSDictionary *)resultDic{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString * resultStr = resultDic[@"text"];
        if (resultStr && resultStr.length > 0) {
            NSLog(@"扫码结果：%@",resultStr);
        }
    });
  
}
- (void)defaultScanImagePickerDelegateForImage:(UIImage *)image{
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
