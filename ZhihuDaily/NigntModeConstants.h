//
//  NigntModeConstants.h
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/18.
//  Copyright © 2016年 钟武. All rights reserved.
//

#ifndef NigntModeConstants_h
#define NigntModeConstants_h

#define kThemeDidChangeNotification @"kThemeDidChangeNotification"

#define kStyleID        @"id"
#define kStyleConfig    @"configPath"
#define kStyleName      @"name"
#define kStyleIcon      @"icon"
#define kStylePath      @"themePath"
#define kStyleDetail    @"detail"

#define THEME_STYLE_CLASSIC		1
#define THEME_STYLE_NIGHT		2

#define TResource(name)     [[ThemeManager sharedInstance].skinInstance fullResourcePathForName:name]
#define TColor(name) [[ThemeManager sharedInstance].skinInstance colorForName:name]
#define TImage(name) [UIImage imageNamed:TResource(name)]

#endif /* NigntModeConstants_h */
