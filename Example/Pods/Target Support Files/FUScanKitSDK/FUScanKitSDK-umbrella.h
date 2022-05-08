#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "HmsBitMap.h"
#import "HmsCustomScanViewController.h"
#import "HmsDefaultScanViewController.h"
#import "HmsMultiFormatWriter.h"
#import "HmsScanFormat.h"
#import "ScanKitFrameWork.h"

FOUNDATION_EXPORT double FUScanKitSDKVersionNumber;
FOUNDATION_EXPORT const unsigned char FUScanKitSDKVersionString[];

