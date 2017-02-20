//
//  CommonMacros.h
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/2.
//  Copyright © 2016年 钟武. All rights reserved.
//

#ifndef CommonMacros_h
#define CommonMacros_h

//颜色宏定义
#define ColorRedGreenBlue(r, g, b)				[UIColor colorWithRed : (r) / 255.0f green : (g) / 255.0f blue : (b) / 255.0f alpha : 1.0f]
#define ColorRedGreenBlueWithAlpha(r, g, b, a)	[UIColor colorWithRed : (r) / 255.0f green : (g) / 255.0f blue : (b) / 255.0f alpha : a]

#define UIColorFromRGB(rgbValue)				[UIColor colorWithRed : ((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green : ((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue : ((float)(rgbValue & 0xFF)) / 255.0 alpha : 1.0]
#define UIColorFromRGBAndAlpha(rgbValue,a)				[UIColor colorWithRed : ((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green : ((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue : ((float)(rgbValue & 0xFF)) / 255.0 alpha : a]
#define UIColorFromRGBA(rgbValue)[UIColor colorWithRed:((float)((rgbValue&0xFF000000)>>24))/255.0 green:((float)((rgbValue&0xFF0000)>>16))/255.0 blue:((float)((rgbValue&0xFF00)>>8))/255.0 alpha:((float)(rgbValue&0xFF))/255.0]

//weak、strong创建
#define WEAK_REF(self) \
__block __weak typeof(self) self##_ = self; (void) self##_;

#define STRONG_REF(self) \
__block __strong typeof(self) self##_ = self; (void) self##_;


//创建单例方法
#define SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(__CLASSNAME__)	\
\
+ (__CLASSNAME__*) sharedInstance;

#define SYNTHESIZE_SINGLETON_FOR_CLASS(__CLASSNAME__)	\
+ (__CLASSNAME__ *)sharedInstance\
{\
    static __CLASSNAME__ *shared##className = nil;\
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
    shared##className = [[super allocWithZone:NULL] init]; \
    }); \
    return shared##className; \
}\
+ (id)allocWithZone:(NSZone*)zone {\
    return [self sharedInstance];\
}\
- (id)copyWithZone:(NSZone *)zone {\
    return self;\
}


//安全main queue 执行
#define dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
    block();\
} else {\
    dispatch_sync(dispatch_get_main_queue(), block);\
}

#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
    block();\
} else {\
    dispatch_async(dispatch_get_main_queue(), block);\
}

#define STATUS_BAR_TAP_NOTIFICATION @"STATUS_BAR_TAP_NOTIFICATION"

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#pragma mark - PATH

#define HomePath NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0]
#define DocumentPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
#define CachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
#define TempPath NSTemporaryDirectory()

#endif /* CommonMacros_h */
