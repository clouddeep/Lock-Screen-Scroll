//
//  SCTScrollingCell.h
//  LockScreenNestScroll
//
//  Created by Shou Cheng Tuan  on 2015/9/29.
//  Copyright (c) 2015年 Shou Cheng Tuan . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCTScrollingCellDelegate;

@interface SCTScrollingCell : UICollectionViewCell
@property (nonatomic, assign) id<SCTScrollingCellDelegate> delegate;
@property (nonatomic, retain) UIColor * color;
@end

@protocol SCTScrollingCellDelegate <NSObject>
- (void)scrollingCellDidBeginPulling:(SCTScrollingCell *)cell;
- (void)scrollingCell:(SCTScrollingCell *)cell didChangePullOffset:(CGFloat)offset;
- (void)scrollingCellDidEndPulling:(SCTScrollingCell *)cell;
@end
