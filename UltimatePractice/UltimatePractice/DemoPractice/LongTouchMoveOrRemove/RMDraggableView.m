//
//  RMDraggableView.m
//  UltimatePractice
//
//  Created by Jerry Ray on 10/8/14.
//  Copyright (c) 2014 RayManning. All rights reserved.
//

#import "RMDraggableView.h"



@implementation NSIndexPath (RMDraggableView)

static NSInteger _row;
static NSInteger _column;

+ (instancetype)IndexPathWithRow:(NSInteger)row column:(NSInteger)column {
    NSIndexPath * indexPath = [[NSIndexPath alloc] init];
    _row = row;
    _column = column;
    return indexPath;
}

- (NSInteger)row {
    return _row;
}

- (NSInteger)column {
    return _column;
}

@end




@interface RMDraggableView ()

@property (nonatomic, assign) CGFloat vSpace;
@property (nonatomic, assign) NSUInteger maxColumn;

@end

@implementation RMDraggableView

- (instancetype)initWithFrame:(CGRect)frame layoutType:(RMDraggableViewLayout)layoutType horizontalMargin:(CGFloat)hMargin verticalMargin:(CGFloat)vMargin vSpace:(CGFloat)vSpace maxColumn:(NSUInteger)maxColumn {
    self = [super init];
    if (self) {
        self.frame = frame;
        self.draggableViewLayout = layoutType;
        self.hMargin = hMargin;
        if (vMargin == MarginAutoCaled) {
            self.vMargin = 0.0;
        } else {
            self.vMargin = vMargin;
        }
        self.vSpace = vSpace;
        self.maxColumn = maxColumn;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self reloadData];
}



#pragma mark - property override 



#pragma mark - Private methods

#pragma mark - Public methods
- (NSInteger)numberOfRows {
    NSInteger number = 1;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfRowsInDraggableView:)]) {
        number = [self.dataSource numberOfRowsInDraggableView:self];
    }
    return number;
}

- (NSInteger)numberOfColumnsInRow:(NSInteger)section {
    NSInteger number = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(draggableView:numberOfColumnsInRow:)]) {
        number = [self.dataSource draggableView:self numberOfColumnsInRow:section];
    }
    return number;
}

- (void)resizeWithFrame:(CGRect)frame {
    self.frame = frame;
    [self reloadData];
}

- (void)reloadData {
    //Remove all subviews
//    for (UIView * subView in self.subviews) {
//        [subView removeFromSuperview];
//    }
    
    
    CGSize cellSize = [self.delegate cellSizeInDraggableView:self];
    CGFloat viewWidth = self.frame.size.width;
    CGFloat hSpace = 0.0;
    CGFloat hMargin = 0.0;
    if (self.hMargin == MarginAutoCaled) {
        hMargin = (viewWidth - (cellSize.width * self.maxColumn)) / (self.maxColumn + 1);
        hSpace = hMargin;
    } else {
        hMargin = self.hMargin;
        hSpace = (viewWidth - (cellSize.width * self.maxColumn) - hMargin * 2) / (self.maxColumn - 1);
    }
    
    CGFloat vMargin = self.vMargin;
    
    //x and y is to specify coordinate of draggableViewCell
    CGFloat x = hMargin;
    CGFloat y = vMargin;

    CGFloat draggableViewHeight = 0.0;
    //Create cells and get draggable view's max frame
    NSInteger numberOfRows = [self numberOfRows];
    for (int row = 0; row < numberOfRows; row ++) {
        x = hMargin;
        NSInteger numberOfColumns = [self numberOfColumnsInRow:row];
        for (int coloumn = 0; coloumn < numberOfColumns; coloumn ++) {
            NSIndexPath * indexPath = [NSIndexPath IndexPathWithRow:row column:coloumn];
            RMDraggableViewCell * cell = [self.dataSource draggableView:self cellForColumnAtIndexPath:indexPath];
            cell.frame = CGRectMake(x, y, cellSize.width, cellSize.height);
            [cell setNeedsDisplay];
            [self addSubview:cell];
            //add up coordinates
            x += cellSize.width + hSpace;
        }
        if (row != numberOfColumns - 1) {
            y += cellSize.height + self.vSpace;
        }
    }
    draggableViewHeight = y + self.vMargin;
    //construct new frame
    CGRect draggableViewNewFrame = self.frame;
    draggableViewNewFrame.size.height = draggableViewHeight;

    //perform call back
    if (self.delegate && [self.delegate respondsToSelector:@selector(draggableView:willResizeWithFrame:)]) {
        [self.delegate draggableView:self willResizeWithFrame:draggableViewNewFrame];
    }
    self.frame = draggableViewNewFrame;
    if (self.delegate && [self.delegate respondsToSelector:@selector(draggableView:didResizeWithFrame:)]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.delegate draggableView:self didResizeWithFrame:draggableViewNewFrame];
        });
    }
}

@end
