//
//  HomeADCircularView.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/7.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "HomeTopNewsCircularView.h"
#import "TopNewsResponseModel.h"
#import "CircularCollectionViewCell.h"
#import <UIImageView+WebCache.h>

@implementation HomeTopNewsCircularView

- (void)setupDataForCollectionViewWithArray:(NSArray<TopNewsResponseModel *> *)array{
    [super setupDataForCollectionViewWithArray:array];
}

- (CircularCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CircularCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    TopNewsResponseModel *model = (TopNewsResponseModel *)self.dataArray[indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"Home_Image"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    cell.textLabel.text = model.title;
    cell.model = model;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.TapActionBlock) {
        TopNewsResponseModel *model = (TopNewsResponseModel *)((CircularCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath]).model;
        self.TapActionBlock(model);
    }
}

@end
