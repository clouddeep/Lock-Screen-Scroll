//
//  ViewController.m
//  LockScreenNestScroll
//
//  Created by Shou Cheng Tuan  on 2015/9/29.
//  Copyright (c) 2015年 Shou Cheng Tuan . All rights reserved.
//

#import "ViewController.h"
#import "SCTScrollingCell.h"

#define ROW_HEIGHT 50

static NSString * cellIdentifier = @"CellIdentifier";

@interface ViewController () <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, SCTScrollingCellDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) UIView *rightSlideView;
@end

CGFloat _random() { return (float)rand() / (float)RAND_MAX;}

@implementation ViewController

- (void)scrollingCellDidBeginPulling:(SCTScrollingCell *)cell
{
    [self.scrollView setScrollEnabled:NO];
    
    self.rightSlideView.backgroundColor = cell.color;
}

- (void)scrollingCell:(SCTScrollingCell *)cell didChangePullOffset:(CGFloat)offset
{
    [self.scrollView setContentOffset:CGPointMake(offset, 0)];
}

- (void)scrollingCellDidEndPulling:(SCTScrollingCell *)cell
{
    [self.scrollView setScrollEnabled:YES];
}


- (void)loadView
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    scrollView.delegate = self;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(screenSize.width, ROW_HEIGHT);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height) collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(screenSize.width, 0, screenSize.width, screenSize.height)];
    
    self.scrollView = scrollView;
    self.flowLayout = flowLayout;
    self.collectionView = collectionView;
    self.rightSlideView = view;
    
    self.view = scrollView;
    [self.scrollView addSubview:self.collectionView];
    [self.scrollView addSubview:self.rightSlideView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.backgroundColor = [UIColor redColor];
    self.rightSlideView.backgroundColor = [UIColor yellowColor];
    self.collectionView.backgroundColor = [UIColor greenColor];
    
    [self.collectionView registerClass:[SCTScrollingCell class] forCellWithReuseIdentifier:cellIdentifier];
}

#pragma mark - UICollectionView Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

#pragma mark - UICollectionView Delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SCTScrollingCell * cell = (SCTScrollingCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    
    CGFloat red = _random();
    CGFloat green = _random();
    CGFloat blue = _random();
    cell.color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
    
    return cell;
}

@end
