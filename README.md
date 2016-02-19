# SMTableView
A simple table view implementation, aimed at explaining how table view works <br/>
本文讲述了一个 table view 的简单实现， 意在解释 table view 是如何工作的

## SMTableView原理概述
SMTableView 继承自 UIScrollView， 直接利用了ScrollView 滑动的特性， 使得代码省去了滑动处理这一块的逻辑。想了解更多ScrollView的原理，请参考 http://oleb.net/blog/2014/04/understanding-uiscrollview/ <br/>
SMTableView逻辑大概可以分为这几块：计算cell位置、 对cell进行布局、cell的重用、ScrollView滑动的处理

- 计算cell位置
根据delegate获取到cell的数量和每个的高度，加起来得到总高度，然后设置ScrollView的contentSize， 就确定了scrollView的滚动区域
```Objective-C
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
```

- 对cell进行布局
首先获取到显示区域，然后获取到显示区域的cell，并设置相应的frame
```Objective-C
_displayRange = [self displayRange];
for (int i = (int)_displayRange.location ; i < _displayRange.length + _displayRange.location; i ++) {
    SMTableViewCell* cell = [self _cellForRow:i];
    [self addSubview:cell];
    _visibleCellsMap[@(i)] = cell;
    cell.frame = [self _rectForCellAtRow:i];
}
```

- cell的重用
对cell布局完成后，这个时候是回收不可见cell的较好时机，获取不可见cell，并将其从visibleCells中移除，加入到cellCache中
```Objective-C
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
```
- ScrollView滑动的处理
当ScrollView滑动的时候，检测displayRange是否发生变化，如果发生变化重新进行布局和回收cell等工作
```
NSRange range = [self displayRange];
if (! NSEqualRanges(_displayRange, range)) {
    [self layoutNeedDisplayCells];
}
```

## SMTableView的使用
SMTableView定义如下
```Objective-C
@interface SMTableView : UIScrollView

@property (nonatomic, strong) id<SMTableViewDelegate> tableViewDelegate;

//获取可重用的Cell
- (SMTableViewCell *) dequeueTableViewCellForIdentifier:(NSString*)identifier;

//刷新tableView
- (void) reloadData;
@end
```
SMTableViewDelegate定义如下
```Objective-C
@protocol SMTableViewDelegate <NSObject>
- (NSInteger) numberOfRowsInTableView:(SMTableView *)tableView;                          //获取行数
- (CGFloat) heightForRow:(NSInteger)row inTableView:(SMTableView *)tableView;            //获取每行行高
- (SMTableViewCell *) cellForRow:(NSInteger)row inTableView:(SMTableView *)tableView;    //获取每行的cell
@end
```

## Sample
```Objective-C
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
    return 100;
}

- (SMTableViewCell *)cellForRow:(NSInteger)row inTableView:(SMTableView *)tableView
{
	SMTableViewCell *cell = [tableView dequeueTableViewCellForIdentifier:@"SMTableViewCell"];
    if (!cell) {
        cell = [[SMTableViewCell alloc] initWithIdentifier:@"SMTableViewCell"];
        UILabel *label = [[UILabel alloc] initWithFrame:cell.bounds];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [cell addSubview:label];
    }
    
    UILabel *label = cell.subviews.firstObject;
    label.text = [NSString stringWithFormat:@"我是第%@行", @(row)];
    cell.backgroundColor = [self randomColor];
    return cell;
}
```


## 参考
本文参考了 DZTableView（ https://github.com/yishuiliunian/DZTableView ） 的实现，并对其进行了精简和改进。
