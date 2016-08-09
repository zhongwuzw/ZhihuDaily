//
//  CircleProgressView.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/5.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "CircleProgressView.h"

@interface CircleShapeView : UIView

@property (nonatomic, readonly) CAShapeLayer *shapeLayer;

@end

@implementation CircleShapeView

+ (Class)layerClass
{
    return [CAShapeLayer class];
}

- (CAShapeLayer *)shapeLayer
{
    return (CAShapeLayer *)self.layer;
}

@end

@interface CircleProgressView ()

@property (nonatomic, strong) CircleShapeView *backgroundCircleView;
@property (nonatomic, strong) CircleShapeView *foregroundCircleView;

@end

@implementation CircleProgressView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.backgroundCircleView = [CircleShapeView new];
    [self.backgroundCircleView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_backgroundCircleView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_backgroundCircleView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backgroundCircleView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_backgroundCircleView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backgroundCircleView)]];
    
    self.foregroundCircleView = [CircleShapeView new];
    [self.foregroundCircleView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_foregroundCircleView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_foregroundCircleView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_foregroundCircleView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_foregroundCircleView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_foregroundCircleView)]];
    
    _backgroundCircleView.shapeLayer.strokeColor = [UIColor darkGrayColor].CGColor;
    _backgroundCircleView.shapeLayer.lineWidth = 1.5;
    _backgroundCircleView.shapeLayer.fillColor = nil;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 20, 20) cornerRadius:10];
    //    [path addArcWithCenter:CGPointMake(10, 10) radius:10 startAngle:M_PI_2 + M_PI/6 endAngle:2 * M_PI + M_PI/3 clockwise:YES];
    _backgroundCircleView.shapeLayer.path = path.CGPath;
    _backgroundCircleView.hidden = YES;
    
    _foregroundCircleView.shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    _foregroundCircleView.shapeLayer.lineWidth = 2;
    _foregroundCircleView.shapeLayer.fillColor = nil;
}

- (void)updateProgress:(CGFloat)progress{
    if (progress > 0) {
        _backgroundCircleView.hidden = NO;
    }
    else
        _backgroundCircleView.hidden = YES;
    
    progress = MIN(progress, 1);
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path addArcWithCenter:CGPointMake(10, 10) radius:10 startAngle:M_PI_2 endAngle:M_PI_2 + 2*M_PI*progress clockwise:YES];
    _foregroundCircleView.shapeLayer.path = path.CGPath;
}

@end
