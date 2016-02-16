//
//  SMLabel.m
//  SMTableView
//
//  Created by ZhuGuangwen on 16/2/15.
//  Copyright © 2016年 ZhuGuangwen. All rights reserved.
//

#import "SMLabel.h"

@implementation SMLabel

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    NSLog(@"SMLabel drawRect: %@", NSStringFromCGRect(rect));
    [super drawRect:rect];
}

@end
