//
//  ViewController.m
//  SMTableView
//
//  Created by ZhuGuangwen on 16/2/15.
//  Copyright © 2016年 ZhuGuangwen. All rights reserved.
//

#import "ViewController.h"
#import "SMLabel.h"
#import "OwnScrollView.h"
#import "SMScrollView.h"
#import "SMTableView.h"

@interface ViewController () <SMTableViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self testTableView];
}

//========================

- (void)testTableView
{
    SMTableView *tableView = [[SMTableView alloc] initWithFrame:self.view.bounds];
    __weak ViewController *wself = self;
    tableView.tableViewDelegate = wself;
    [self.view addSubview:tableView];
    [tableView reloadData];
}

- (NSInteger)numberOfRowsInTableView:(SMTableView *)tableView
{
    return 1000;
}

- (CGFloat)heightForRow:(NSInteger)row inTableView:(SMTableView *)tableView
{
    if (row % 2 == 0) {
        return 100;
    } else {
        return 200;
    }
}

- (SMTableViewCell *)cellForRow:(NSInteger)row inTableView:(SMTableView *)tableView
{
    if (row % 2 == 0) {
        SMTableViewCell *cell = [tableView dequeueTableViewCellForIdentifier:nil];
        if (!cell) {
            cell = [SMTableViewCell new];
            UILabel *label = [[UILabel alloc] initWithFrame:cell.bounds];
            label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [cell addSubview:label];
        }
        
        UILabel *label = cell.subviews.firstObject;
        label.text = [NSString stringWithFormat:@"我是第%@行", @(row)];
        cell.backgroundColor = [self randomColor];
        return cell;
    } else {
        SMTableViewCell *cell = [tableView dequeueTableViewCellForIdentifier:@"ImageCell"];
        if (!cell) {
            cell = [[SMTableViewCell alloc] initWithIdentifier:@"ImageCell"];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
            imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            [cell addSubview:imageView];
        }
        
        UIImageView *imageView = cell.subviews.firstObject;
        NSString *imageName = [NSString stringWithFormat:@"%@", @((row - 1) / 2 % 4 + 1)];
        NSLog(@"row %@, imageName %@", @(row), imageName);
        imageView.image = [UIImage imageNamed:imageName];
        return cell;
    }
}

- (UIColor *)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

//========================

- (void)testScrollView
{
    SMScrollView *scrollView = [[SMScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    
    [self addLabel:CGRectMake(0, 0, 500, 500) color:[UIColor grayColor] toScrollView:scrollView];
    [self addLabel:CGRectMake(500, 0, 500, 500) color:[UIColor yellowColor] toScrollView:scrollView];
    [self addLabel:CGRectMake(0, 500, 500, 500) color:[UIColor redColor] toScrollView:scrollView];
    [self addLabel:CGRectMake(500, 500, 500, 500) color:[UIColor purpleColor] toScrollView:scrollView];
    
    [scrollView setContentSize:CGSizeMake(1000, 1000)];
}

- (void)addLabel:(CGRect)frame color:(UIColor *)bgColor toScrollView:(SMScrollView *)scrollView
{
    SMLabel *label = [[SMLabel alloc] initWithFrame:frame];
    label.text = @"O";
    label.font = [UIFont systemFontOfSize:60];
    label.backgroundColor = bgColor;
    label.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:label];
}

@end
