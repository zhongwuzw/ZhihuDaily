//
//  CircularCollectionView.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/2.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "CircularView.h"
#import "CircularCollectionViewCell.h"
#import "WeakTarget.h"

@interface CircularView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation CircularView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        self.dataArray = [NSMutableArray arrayWithCapacity:5];
    }
    
    return self;
}

- (UIScrollView *)scrollView{
    return _collectionView;
}

- (void)initUI{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self addSubview:_collectionView];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.contentInset = UIEdgeInsetsZero;
    self.collectionView.bounces = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CircularCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    [_collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_collectionView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_collectionView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
    
    self.pageControl = [UIPageControl new];
    [self addSubview:_pageControl];
    [_pageControl setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_pageControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_pageControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:6]];
}

- (void)setupDataForCollectionViewWithArray:(NSArray<MTLModel<MTLJSONSerializing> *> *)array{
    if (array.count == 0) {
        return;
    }
    
    id firstItem = array[0];
    id lastItem = [array lastObject];
    
    [_dataArray removeAllObjects];
    [_dataArray addObjectsFromArray:array];
    
    [_dataArray insertObject:lastItem atIndex:0];
    [_dataArray addObject:firstItem];
    
    [self.collectionView reloadData];
    
    _pageControl.numberOfPages = array.count;
    _pageControl.hidesForSinglePage = YES;
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];
    
    [self.collectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    if (array.count == 1) {
        self.collectionView.scrollEnabled = NO;
    }
    else{
        self.collectionView.scrollEnabled = YES;
        [self configTimer];
    }

}

- (void)configTimer{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    WeakTarget *target = [[WeakTarget alloc] initWithTarget:self selector:@selector(timerFireMethod:)];
    _timer = [NSTimer scheduledTimerWithTimeInterval:4 target:target selector:@selector(timerDidFire:) userInfo:nil repeats:YES];
}

- (void)timerFireMethod:(NSTimer *)timer{
    CGPoint offsetPoint = _collectionView.contentOffset;
    CGPoint contentPoint = CGPointMake(offsetPoint.x + self.centerX, 0);
    NSIndexPath *path = [_collectionView indexPathForItemAtPoint:contentPoint];
    NSIndexPath *newPath = [NSIndexPath indexPathForItem:path.row + 1 inSection:path.section];
    [_collectionView scrollToItemAtIndexPath:newPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    [self setPageControlIndex:newPath];
}

- (void)startTimerIfNeeded{
    if (_dataArray.count > 1) {
        [self configTimer];
    }
}

- (void)stopTimer{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (void)setPageControlIndex:(NSIndexPath *)path{
    if (path.row == [_dataArray count] - 1) {
        _pageControl.currentPage = 0;
    }
    else if (path.row == 0)
        _pageControl.currentPage = [_dataArray count] - 3;
    else
        _pageControl.currentPage = path.row - 1;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    NSIndexPath *path = [_collectionView indexPathForItemAtPoint:*targetContentOffset];
    [self setPageControlIndex:path];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CircularCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.frame.size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self scrollCollectionViewToCorrectIndexPath];
}

- (void)scrollCollectionViewToCorrectIndexPath{
    float contentOffsetWhenFullyScrolledRight = self.frame.size.width * ([self.dataArray count] -1);
    
    if (self.collectionView.contentOffset.x == contentOffsetWhenFullyScrolledRight) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];
        
        [self.collectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        
    } else if (self.collectionView.contentOffset.x == 0)  {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:([self.dataArray count] -2) inSection:0];
        
        [self.collectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
}

- (void)setFrame:(CGRect)frame
{
    if (self.frame.size.height != frame.size.height) {
        [self.collectionView.collectionViewLayout invalidateLayout];
    }
    [super setFrame:frame];
}

@end
