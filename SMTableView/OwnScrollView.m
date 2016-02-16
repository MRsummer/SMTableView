//
//  OwnScrollView.m
//  SMTableView
//
//  Created by ZhuGuangwen on 16/2/15.
//  Copyright © 2016年 ZhuGuangwen. All rights reserved.
//

#import "OwnScrollView.h"

@implementation OwnScrollView

- (void)drawRect:(CGRect)rect
{
    NSLog(@"OwnScrollView drawRect: %@", NSStringFromCGRect(rect));
    [super drawRect:rect];
}

- (void)layoutSubviews
{
    NSLog(@"OwnScrollView layoutSubviews");
    [super layoutSubviews];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self == nil) {
        return nil;
    }
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(handlePanGesture:)];
    [self addGestureRecognizer:gestureRecognizer];
    return self;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:self];
    CGRect bounds = self.bounds;
    
    // Translate the view's bounds, but do not permit values that would violate contentSize
    CGFloat newBoundsOriginX = bounds.origin.x - translation.x;
    CGFloat minBoundsOriginX = 0.0;
    CGFloat maxBoundsOriginX = self.contentSize.width - bounds.size.width;
    bounds.origin.x = fmax(minBoundsOriginX, fmin(newBoundsOriginX, maxBoundsOriginX));
    
    CGFloat newBoundsOriginY = bounds.origin.y - translation.y;
    CGFloat minBoundsOriginY = 0.0;
    CGFloat maxBoundsOriginY = self.contentSize.height - bounds.size.height;
    bounds.origin.y = fmax(minBoundsOriginY, fmin(newBoundsOriginY, maxBoundsOriginY));
    
    self.bounds = bounds;
    [gestureRecognizer setTranslation:CGPointZero inView:self];
}

@end
