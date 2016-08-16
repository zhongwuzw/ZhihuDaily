//
//  ThemeEditorTableHeaderView.h
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/16.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ThemeEditorResponseModel;

@interface ThemeEditorTableHeaderView : UIView

- (void)installEditorListWithArray:(NSArray <ThemeEditorResponseModel *> *)imageArray;

@end
