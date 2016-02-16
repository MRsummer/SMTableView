//
//  SMTableView.h
//  SMTableView
//
//  Created by ZhuGuangwen on 16/2/15.
//  Copyright © 2016年 ZhuGuangwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMTableView;
@class SMTableViewCell;

@protocol SMTableViewDelegate <NSObject>
- (NSInteger) numberOfRowsInTableView:(SMTableView *)tableView;
- (CGFloat) heightForRow:(NSInteger)row inTableView:(SMTableView *)tableView;
- (SMTableViewCell *) cellForRow:(NSInteger)row inTableView:(SMTableView *)tableView;
@end

@interface SMTableViewCell : UIView
@property (nonatomic, strong) NSString *identifier;
- (instancetype)initWithIdentifier:(NSString *)identifier;
@end

@interface SMTableView : UIScrollView

@property (nonatomic, strong) id<SMTableViewDelegate> tableViewDelegate;

- (SMTableViewCell *) dequeueTableViewCellForIdentifier:(NSString*)identifier;
- (void) reloadData;
@end
