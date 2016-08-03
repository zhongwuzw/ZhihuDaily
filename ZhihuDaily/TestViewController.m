//
//  TestViewController.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/2.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "TestViewController.h"
#import "CircularCollectionView.h"
#import "UINavigationBar+BackgroundColor.h"

#define NAVBAR_CHANGE_POINT 50

static const CGFloat TestViewControllerHeadScrollHeight = 240.0f;

@interface TestViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) CircularCollectionView *collectionView;
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initTableView];
    [self initCollectionView];
}

- (void)initTableView{
    self.tableView = [UITableView new];
    [self.view addSubview:_tableView];
    
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    
    self.tableView.contentInset = UIEdgeInsetsMake(TestViewControllerHeadScrollHeight, 0, 0, 0);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.tableView reloadData];

    [self.tableView setContentOffset:CGPointMake(0, -TestViewControllerHeadScrollHeight) animated:NO];
}

- (void)initCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    
    self.collectionView = [[CircularCollectionView alloc] initWithFrame:CGRectMake(0, -TestViewControllerHeadScrollHeight, CGRectGetWidth(self.view.bounds), TestViewControllerHeadScrollHeight) collectionViewLayout:layout];
    [self.collectionView setupDataForCollectionView];
    [self.collectionView reloadData];
    
    [self.tableView addSubview:self.collectionView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text = @"haha";
    
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset  = scrollView.contentOffset.y;
    if (yOffset < - TestViewControllerHeadScrollHeight) {
        CGRect f = self.collectionView.frame;
        f.origin.y = yOffset;
        f.size.height =  -yOffset;
        self.collectionView.frame = f;
    }
    else{
        if (yOffset > NAVBAR_CHANGE_POINT - TestViewControllerHeadScrollHeight) {
            CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT - TestViewControllerHeadScrollHeight + 64 - yOffset) / 64));
            [self.navigationController.navigationBar setBarBGColor:[UIColor colorWithRed:0.175f green:0.458f blue:0.831f alpha:alpha]];
        } else {
            [self.navigationController.navigationBar setBarBGColor:[UIColor colorWithRed:0.175f green:0.458f blue:0.831f alpha:0]];
        }
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
