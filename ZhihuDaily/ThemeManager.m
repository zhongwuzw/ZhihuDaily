//
//  ThemeManager.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/18.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "ThemeManager.h"
#import "NigntModeConstants.h"
#import "SkinStyle.h"

@implementation ThemeManager

SYNTHESIZE_SINGLETON_FOR_CLASS(ThemeManager)

- (id)init
{
    if (self = [super init]) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
        if (filePath == nil) {
            NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
            filePath = [resourcePath stringByAppendingPathComponent:@"/res/themes/theme.plist"];
            if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                NSLog(@"ERROR %@", filePath);
            }
        }
        self.allStyleArray = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    }
    return self;
}

- (void)loadConfig:(NSInteger)skinID
{
    NSDictionary *skinInfo = [self getSkinInfo:THEME_STYLE_CLASSIC];
    SkinStyle *skinStyle = [[SkinStyle alloc] initWithContentOfFile:[self getSkinConfigPath:skinInfo[kStyleConfig]] withPathPrefix:skinInfo[kStylePath]];
    
    if (skinID != THEME_STYLE_CLASSIC) {
        skinInfo = [self getSkinInfo:skinID];
        SkinStyle *skinMerge = [[SkinStyle alloc] initWithContentOfFile:[self getSkinConfigPath:skinInfo[kStyleConfig]] withPathPrefix:skinInfo[kStylePath]];
        [skinStyle merge:skinMerge];
    }
    skinStyle.skinID = skinID;
    skinStyle.skinName = skinInfo[kStyleName];
    skinStyle.icon = skinInfo[kStyleIcon];
    self.skinInstance = skinStyle;
}

- (void)resetConfig
{
    [self loadConfig:THEME_STYLE_CLASSIC];
}

- (NSDictionary *)getSkinInfo:(NSInteger)skinID
{
    NSDictionary *themeInfo = nil;
    
    for (themeInfo in self.allStyleArray) {
        if ([themeInfo[kStyleID] intValue] == skinID) {
            break;
        }
    }
    return themeInfo;
}

- (NSString *)getSkinConfigPath:(NSString *)name
{
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    return [resourcePath stringByAppendingPathComponent:name];
}

- (void)switchToStyleByID:(NSInteger)skinID
{
    [self loadConfig:skinID];
    [[NSNotificationCenter defaultCenter] postNotificationName:kThemeDidChangeNotification object:nil];
}

- (void)switchToStyle{
    switch (self.skinInstance.skinID) {
        case 1:
            [self switchToStyleByID:2];
            break;
        case 2:
            [self switchToStyleByID:1];
            break;
        default:
            break;
    }
}

@end
