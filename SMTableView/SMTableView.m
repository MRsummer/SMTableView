//
//  SMTableView.m
//  SMTableView
//
//  Created by ZhuGuangwen on 16/2/15.
//  Copyright © 2016年 ZhuGuangwen. All rights reserved.
//

#import "SMTableView.h"

@implementation SMTableViewCell

- (instancetype)initWithIdentifier:(NSString *)identifier
{
    if (self = [super init]) {
        self.identifier = identifier;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithIdentifier:@"SMTableViewCell"];
}

@end

@implementation SMTableView
{
    int64_t     _numberOfCells;
    NSMutableArray *_cellHeights;
    NSMutableArray *_cellYOffsets;
    
    NSRange _displayRange;
    
    NSMutableDictionary* _visibleCellsMap;
    NSMutableSet*  _cacheCells;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _visibleCellsMap = [NSMutableDictionary new];
        _cacheCells = [NSMutableSet new];
    }
    return self;
}

- (void)layoutSubviews
{
    NSRange range = [self displayRange];
    if (! NSEqualRanges(_displayRange, range)) {
        [self layoutNeedDisplayCells];
    }
}

- (void) reloadData
{
    [self reduceContentSize];
    [self layoutNeedDisplayCells];
}

- (void) reduceContentSize
{
    _numberOfCells = [_tableViewDelegate numberOfRowsInTableView:self];
    _cellYOffsets = [NSMutableArray new];
    _cellHeights = [NSMutableArray new];
    
    float height = 0;
    for (int i = 0  ; i < _numberOfCells; i ++) {
        float cellHeight = [_tableViewDelegate heightForRow:i inTableView:self];
        [_cellHeights addObject:@(cellHeight)];
        height += cellHeight;
        [_cellYOffsets addObject:@(height)];
    }
    CGSize size = CGSizeMake(CGRectGetWidth(self.frame), height);
    
    [self setContentSize:size];
}

- (void) layoutNeedDisplayCells
{
    _displayRange = [self displayRange];
    for (int i = (int)_displayRange.location ; i < _displayRange.length + _displayRange.location; i ++) {
        SMTableViewCell* cell = [self _cellForRow:i];
        [self addSubview:cell];
        _visibleCellsMap[@(i)] = cell;
        cell.frame = [self _rectForCellAtRow:i];
    }
    [self cleanUnusedCellsWithDispalyRange:_displayRange];
}

- (NSRange) displayRange
{
    if (_numberOfCells == 0) {
        return NSMakeRange(0, 0);
    }
    int  beginIndex = 0;
    float beiginHeight = self.contentOffset.y;
    
    for (int i = 0 ; i < _numberOfCells; i++) {
        float cellYOffset = [_cellYOffsets[i] floatValue];
        if (cellYOffset > beiginHeight) {
            beginIndex = i;
            break;
        }
    }
    
    int endIndex = beginIndex;
    float displayEndHeight = self.contentOffset.y + CGRectGetHeight(self.frame);
    
    for (int i = beginIndex; i < _numberOfCells; i ++) {
        float cellYoffset = [_cellYOffsets[i] floatValue];
        if (cellYoffset > displayEndHeight) {
            endIndex = i;
            break;
        }
        if (i == _numberOfCells - 1) {
            endIndex = i;
            break;
        }
    }
    return NSMakeRange(beginIndex, endIndex - beginIndex + 1);
}

- (SMTableViewCell *) _cellForRow:(NSInteger)rowIndex
{
    SMTableViewCell *cell = _visibleCellsMap[@(rowIndex)];
    if (!cell) {
        cell = [_tableViewDelegate cellForRow:rowIndex inTableView:self];
    }
    return cell;
}

- (CGRect) _rectForCellAtRow:(int)rowIndex
{
    if (rowIndex < 0 || rowIndex >= _numberOfCells) {
        return CGRectZero;
    }
    float cellYoffSet = [_cellYOffsets[rowIndex] floatValue];
    float cellHeight  = [_cellHeights[rowIndex] floatValue];
    return CGRectMake(0, cellYoffSet - cellHeight, CGRectGetWidth(self.frame), cellHeight);
}

- (void) cleanUnusedCellsWithDispalyRange:(NSRange)range
{
    NSDictionary* dic = [_visibleCellsMap copy];
    NSArray* keys = dic.allKeys;
    for (NSNumber* rowIndex  in keys) {
        int row = [rowIndex intValue];
        if (! NSLocationInRange(row, range)) {
            SMTableViewCell* cell = _visibleCellsMap[rowIndex];
            [_visibleCellsMap removeObjectForKey:rowIndex];
            [_cacheCells addObject:cell];
            [cell removeFromSuperview];
        }
    }
}

- (SMTableViewCell *) dequeueTableViewCellForIdentifier:(NSString*)identifier
{
    if (!identifier) {
        identifier = @"SMTableViewCell";
    }
    SMTableViewCell *cell = nil;
    for (SMTableViewCell *each  in _cacheCells) {
        if ([each.identifier isEqualToString:identifier]) {
            cell = each;
            break;
        }
    }
    if (cell) {
        [_cacheCells removeObject:cell];
    }
    return cell;
}

@end
