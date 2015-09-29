//
//  SCTScrollingCell.m
//  LockScreenNestScroll
//
//  Created by Shou Cheng Tuan  on 2015/9/29.
//  Copyright (c) 2015年 Shou Cheng Tuan . All rights reserved.
//

#import "SCTScrollingCell.h"

#define PULL_THRESHOLD 60

@interface SCTScrollingCell () <UIScrollViewDelegate> {
    UIScrollView * _scrollView;
    UIView * _colorView;
    
    BOOL _pulling;
    BOOL _deceleratingBackToZero;
    CGFloat _decelerationDistanceRatio;
}

@end

@implementation SCTScrollingCell

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.x;
    
    // did we just start pulling?
    if (offset > PULL_THRESHOLD && !_pulling) {
        [_delegate scrollingCellDidBeginPulling:self];
        _pulling = YES;
    }
    
    if (_pulling) {
        CGFloat pullOffset = MAX(0, offset - PULL_THRESHOLD);
        
        [_delegate scrollingCell:self didChangePullOffset:pullOffset];
    }
}

- (void)scrollingEnded
{
    [_delegate scrollingCellDidEndPulling:self];
    _pulling = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self scrollingEnded];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollingEnded];
}


#pragma mark Setup & Layout

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _colorView = [[UIView alloc] init];
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        [self.contentView addSubview:_scrollView];
        [_scrollView addSubview:_colorView];
    }
    return self;
}

- (void)setColor:(UIColor *)color
{
    if (color != _color) {
        _color = color;
    }
    _colorView.backgroundColor = _color;
}

- (void)layoutSubviews
{
    UIView *contentView = self.contentView;
    CGRect bounds = contentView.bounds;
    
    CGFloat pageWidth = bounds.size.width;
    _scrollView.frame = CGRectMake(0, 0, pageWidth, bounds.size.height);
    _scrollView.contentSize = CGSizeMake(pageWidth * 2, bounds.size.height);
    
    _colorView.frame = [_scrollView convertRect:bounds fromView:contentView];
}

@end
