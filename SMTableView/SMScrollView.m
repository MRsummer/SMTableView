//
//  SMScrollView.m
//  SMTableView
//
//  Created by ZhuGuangwen on 16/2/15.
//  Copyright © 2016年 ZhuGuangwen. All rights reserved.
//

#import "SMScrollView.h"

@implementation SMScrollView

- (void)drawRect:(CGRect)rect
{
    NSLog(@"SMScrollView drawRect: %@", NSStringFromCGRect(rect));
    [super drawRect:rect];
}

- (void)layoutSubviews
{
    NSLog(@"SMScrollView layoutSubviews");
    [super layoutSubviews];
}

@end
