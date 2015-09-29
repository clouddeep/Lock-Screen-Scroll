//
//  SpringyFlowLayout.m
//  LockScreenNestScroll
//
//  Created by Shou Cheng Tuan  on 2015/9/29.
//  Copyright (c) 2015年 Shou Cheng Tuan . All rights reserved.
//

#import "SpringyFlowLayout.h"

@interface SpringyFlowLayout () {
    UIDynamicAnimator *_dynamicAnimator;
}

@end

@implementation SpringyFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    
    if (!_dynamicAnimator) {
        _dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
        
        CGSize contentSize = self.collectionViewContentSize;
        // If you got 1000 or more cells, it may not be a good idea
        // to handle it all in a single step.
        NSArray *items = [super layoutAttributesForElementsInRect:CGRectMake(0, 0, contentSize.width, contentSize.height)];
        
        for (UICollectionViewLayoutAttributes *item in items) {
            UIAttachmentBehavior *spring = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:item.center];
            
            spring.length = 0;
            spring.damping = 0.5;
            spring.frequency = 0.8;
            
            [_dynamicAnimator addBehavior:spring];
        }
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [_dynamicAnimator itemsInRect:rect];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [_dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    UIScrollView *scrollView = self.collectionView;
    CGFloat scrollDelta = newBounds.origin.y - scrollView.bounds.origin.y;
    CGPoint touchLocation = [scrollView.panGestureRecognizer locationInView:scrollView];
    
    for (UIAttachmentBehavior *spring in _dynamicAnimator.behaviors) {
        CGPoint anchorPoint = spring.anchorPoint;
        CGFloat distanceFromTouch = fabsf(touchLocation.y - anchorPoint.y);
        CGFloat scrollResistance = distanceFromTouch / 500;
        
        UICollectionViewLayoutAttributes *item = spring.items.firstObject;
        CGPoint center = item.center;
        center.y += scrollDelta * scrollResistance;
        item.center = center;
        
        [_dynamicAnimator updateItemUsingCurrentState:item];
    }
    
    return NO;
}

@end
