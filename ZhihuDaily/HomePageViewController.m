//
//  TestViewController.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/2.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "HomePageViewController.h"
#import "CircularCollectionView.h"
#import "UINavigationBar+BackgroundColor.h"
#import "LatestNewsResponseModel.h"
#import "NewsResponseModel.h"
#import "TopNewsResponseModel.h"
#import "NewsTableViewCell.h"

#define NAVBAR_CHANGE_POINT 50
#define REUSE_TABLE_VIEW_CELL @"REUSE_TABLE_VIEW_CELL"
#define REUSE_TABLE_Header_VIEW_CELL @"REUSE_TABLE_Header_VIEW_CELL"

static const CGFloat TestViewControllerHeadScrollHeight = 190.0f;

@interface HomePageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) CircularCollectionView *collectionView;
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<NewsResponseModel *> *newsArray;
@property (nonatomic, copy) NSArray<TopNewsResponseModel *> *topNewsArray;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setBarBGColor:[UIColor colorWithRed:0.175f green:0.458f blue:0.831f alpha:0]];
    
    [self initTableView];
    [self initCollectionView];
    [self loadData];
}

- (void)initTableView{
    self.tableView = [UITableView new];
    [self.view addSubview:_tableView];
    
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    
//    self.tableView.contentInset = UIEdgeInsetsMake(TestViewControllerHeadScrollHeight, 0, 0, 0);
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), TestViewControllerHeadScrollHeight)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[NewsTableViewCell class] forCellReuseIdentifier:REUSE_TABLE_VIEW_CELL];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:REUSE_TABLE_Header_VIEW_CELL];
    
    [self.tableView reloadData];
    
    self.tableView.rowHeight = 82;
    self.tableView.sectionHeaderHeight = 35;

//    [self.tableView setContentOffset:CGPointMake(0, -TestViewControllerHeadScrollHeight) animated:NO];
    
    self.newsArray = [NSMutableArray arrayWithCapacity:8];
}

- (void)initCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    
    self.collectionView = [[CircularCollectionView alloc] initWithFrame:CGRectMake(0, -20, CGRectGetWidth(self.view.bounds), TestViewControllerHeadScrollHeight) collectionViewLayout:layout];
    [self.collectionView setupDataForCollectionView];
    [self.collectionView reloadData];
    
    [self.tableView addSubview:self.collectionView];
}

- (void)loadData{
    WEAK_REF(self)
    
    [[HTTPClient sharedInstance] getLatestNewsWithSuccess:^(NSURLSessionDataTask *task, BaseResponseModel *model){
        STRONG_REF(self_)
        if (self__) {
            if ([model isKindOfClass:[LatestNewsResponseModel class]]) {
                [self__.newsArray addObjectsFromArray:((LatestNewsResponseModel *)model).stories];
                [self__.tableView reloadData];
            }
        }
    }fail:^(NSURLSessionDataTask *task,BaseResponseModel *model){
    }];
}

#pragma mark - UITableViewDelegate Method

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:REUSE_TABLE_Header_VIEW_CELL];
    view.textLabel.text = @"测试！";
    return view;
}

#pragma mark - UITableViewDataSource Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.newsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REUSE_TABLE_VIEW_CELL];
    
    NewsResponseModel *model = self.newsArray[indexPath.row];
    
    [cell setTitleLabel:model.title imageURL:[model.images firstObject]];
    
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset  = scrollView.contentOffset.y;
    if (yOffset < 0) {
        CGRect f = self.collectionView.frame;
        f.origin.y += yOffset;
        f.size.height -=  yOffset;
        self.collectionView.frame = f;
    }
    else{
//        if (yOffset > NAVBAR_CHANGE_POINT) {
//            CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - yOffset) / 64));
//            [self.navigationController.navigationBar setBarBGColor:[UIColor colorWithRed:0.175f green:0.458f blue:0.831f alpha:alpha]];
//        } else {
//            [self.navigationController.navigationBar setBarBGColor:[UIColor colorWithRed:0.175f green:0.458f blue:0.831f alpha:0]];
//        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
