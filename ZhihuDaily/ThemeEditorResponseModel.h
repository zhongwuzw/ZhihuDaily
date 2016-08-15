//
//  ThemeEditorResponseModel.h
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/15.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface ThemeEditorResponseModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *url;
@property (nonatomic, copy, readonly) NSString *bio;
@property (nonatomic, assign, readonly) NSInteger editorID;
@property (nonatomic, copy, readonly) NSString *avatar;
@property (nonatomic, copy, readonly) NSString *name;

@end
