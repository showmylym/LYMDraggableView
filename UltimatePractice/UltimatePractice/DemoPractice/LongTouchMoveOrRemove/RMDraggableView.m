//
//  RMDraggableView.m
//  UltimatePractice
//
//  Created by Jerry Ray on 10/8/14.
//  Copyright (c) 2014 RayManning. All rights reserved.
//

#import "RMDraggableView.h"


@interface RMIndexPath ()

@property (nonatomic, assign, readwrite) NSUInteger row;
@property (nonatomic, assign, readwrite) NSUInteger column;

@end

@implementation RMIndexPath


+ (instancetype)IndexPathWithRow:(NSUInteger)row column:(NSUInteger)column {
    RMIndexPath * indexPath = [[RMIndexPath alloc] init];
    indexPath.row = row;
    indexPath.column = column;
    return indexPath;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"row (%ld), column (%ld).", (long)self.row, (long)self.column];
}

@end




@interface RMDraggableView ()
<RMDraggableViewCellDelegate>

@property (nonatomic, assign) CGFloat vSpace;
@property (nonatomic, assign) NSUInteger maxColumn;

@property (nonatomic, retain) NSMutableArray * muArrCells;
@property (nonatomic, retain) RMIndexPath * indexPathCellDragging;

@end

@implementation RMDraggableView

- (instancetype)initWithFrame:(CGRect)frame layoutType:(RMDraggableViewLayout)layoutType horizontalMargin:(CGFloat)hMargin verticalMargin:(CGFloat)vMargin vSpace:(CGFloat)vSpace maxColumn:(NSUInteger)maxColumn {
    self = [super init];
    if (self) {
        if (frame.size.height != 0.0) {
            self.frame = frame;
        } else {
            frame.size.height = 1.0;
            self.frame = frame;
        }
        self.draggableViewLayout = layoutType;
        self.hMargin = hMargin;
        if (vMargin == MarginAutoCaled) {
            self.vMargin = 0.0;
        } else {
            self.vMargin = vMargin;
        }
        self.vSpace = vSpace;
        self.maxColumn = maxColumn;
        self.muArrCells = [NSMutableArray arrayWithCapacity:20];
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
- (RMIndexPath *)indexPathFromIndex:(NSInteger)index {
    NSInteger row = 0;
    NSInteger column = 0;
    if (self.maxColumn != 0) {
        row = index / self.maxColumn;
        column = index % self.maxColumn;
    }
    RMIndexPath * indexPath = [RMIndexPath IndexPathWithRow:row column:column];
    return indexPath;
}

- (NSUInteger)indexFromIndexPath:(RMIndexPath *)indexPath {
    return indexPath.row * self.maxColumn + indexPath.column;
}

- (void)changeIndexPathValueForCells {
    for (int i = 0; i < self.muArrCells.count; i ++) {
        RMIndexPath * indexPath = [self indexPathFromIndex:i];
        RMDraggableViewCell * cell = [self.muArrCells objectAtIndex:i];
        cell.indexPath.row = indexPath.row;
        cell.indexPath.column = indexPath.column;
    }
}

#pragma mark - Public methods
- (NSUInteger)numberOfItems {
    NSUInteger number = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfCellsInDraggableView:)]) {
        number = [self.dataSource numberOfCellsInDraggableView:self];
    }
    return number;
}

- (void)resizeWithFrame:(CGRect)frame {
    self.frame = frame;
    [self reloadData];
}

- (void)reloadData {
    //Remove all subviews
    for (UIView * subView in self.subviews) {
        [subView removeFromSuperview];
    }
    [self.muArrCells removeAllObjects];
    
    //Create cells and get draggable view's max frame
    NSInteger numberOfItems = [self numberOfItems];
    for (int index = 0; index < numberOfItems; index ++) {
        RMDraggableViewCell * cell = [self.dataSource draggableView:self cellForIndex:index];
        cell.delegate = self;
        cell.indexPath = [self indexPathFromIndex:index];
        [self addSubview:cell];
        [self.muArrCells addObject:cell];
    }
    //construct new frame
    CGRect draggableViewNewFrame = [self resetLayout];
    [self.muArrCells makeObjectsPerformSelector:@selector(setNeedsDisplay)];

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

/**
 *  Return draggable view new frame. Set all cells frame.
 *
 *  @return
 */
- (CGRect)resetLayout {
    NSUInteger numberOfItems = [self numberOfItems];

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
    NSInteger numberOfRows = numberOfItems / self.maxColumn;
    if (numberOfItems % self.maxColumn > 0) {
        //Treat it as the last line
        numberOfRows ++;
    }
    for (int row = 0; row < numberOfRows; row ++) {
        x = hMargin;
        NSUInteger numberOfColumns = numberOfItems - row * self.maxColumn;
        if (numberOfColumns > self.maxColumn) {
            //Column number of the line which is not the last line
            numberOfColumns = self.maxColumn;
        }

        for (int column = 0; column < numberOfColumns; column ++) {
            RMIndexPath * indexPath = [RMIndexPath IndexPathWithRow:row column:column];
            NSUInteger index = [self indexFromIndexPath:indexPath];
            //Reset frame of cells except the cell dragging.
            BOOL needChangeLayout = YES;
            if (self.indexPathCellDragging != nil && index == [self indexFromIndexPath:self.indexPathCellDragging]) {
                //The cell is dragging, needn't to reset its frame. It locates where is finger staying.
                needChangeLayout = NO;
            }
            if (index < self.muArrCells.count && needChangeLayout) {
                RMDraggableViewCell * cell = [self.muArrCells objectAtIndex:index];
                cell.frame = CGRectMake(x, y, cellSize.width, cellSize.height);
            }
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
    return draggableViewNewFrame;
}

#pragma mark - RMDraggableViewCell Delegate
- (void)draggableViewCell:(RMDraggableViewCell *)cell tappedWithIndexPath:(RMIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(draggableView:didSelectCellAtIndex:)]) {
        [self.delegate draggableView:self didSelectCellAtIndex:[self indexFromIndexPath:indexPath]];
    }
}

- (void)draggableViewCell:(RMDraggableViewCell *)cell cornerBtnPressedWithIndexPath:(RMIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(draggableView:cornerBtnPressedAtIndex:)]) {
        [self.delegate draggableView:self cornerBtnPressedAtIndex:[self indexFromIndexPath:indexPath]];
    }
}

- (CGSize)draggableViewCell:(RMDraggableViewCell *)cell cornerBtnSizeWithIndexPath:(RMIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(draggableView:cornerBtnSizeAtIndex:)]) {
        return [self.delegate draggableView:self cornerBtnSizeAtIndex:[self indexFromIndexPath:indexPath]];
    }
    return CGSizeMake(15.0, 15.0);
}

- (void)draggableViewCell:(RMDraggableViewCell *)cell longPressedBeginWithIndexPath:(RMIndexPath *)indexPath {
    [cell startShakingWithCornerBtnStyle:RMDraggableViewCellCornerBtnStyleTopRight];
}

- (void)draggableViewCell:(RMDraggableViewCell *)cell longPressedDidMoveWithIndexPath:(RMIndexPath *)indexPath {
    //Store the indexpath value of cell which is dragging.
    self.indexPathCellDragging = indexPath;
    
    CGRect draggingCellFrame = cell.frame;
    NSArray * arrCells = [NSArray arrayWithArray:self.muArrCells];
    for (int i = 0; i < arrCells.count; i ++) {
        RMDraggableViewCell * enumeratedCell = [arrCells objectAtIndex:i];
        if (cell == enumeratedCell) {
            continue;
        }
        CGRect enumeratedCellFrame = enumeratedCell.frame;
        CGFloat draggingCellEndX = draggingCellFrame.origin.x + draggingCellFrame.size.width / 2;
        CGFloat draggingCellEndY = draggingCellFrame.origin.y + draggingCellFrame.size.width / 2;
        
        BOOL isXContain = NO;
        BOOL isYContain = NO;
        if (enumeratedCellFrame.origin.x < draggingCellEndX && enumeratedCellFrame.origin.x + enumeratedCellFrame.size.width > draggingCellEndX) {
            isXContain = YES;
        }
        if (enumeratedCellFrame.origin.y < draggingCellEndY && enumeratedCellFrame.origin.y + enumeratedCellFrame.size.height > draggingCellEndY) {
            isYContain = YES;
        }
        if (isXContain && isYContain) {
            //Insert dragging cell into this index
            [self.muArrCells removeObject:cell];
            [self.muArrCells insertObject:cell atIndex:i];
            //Change indexPath value to new for all cells.
            [self changeIndexPathValueForCells];
            break;
        }
    }
    
    //Use easyInOut style to play animation.
    [UIView animateWithDuration:0.4 animations:^{
        [self resetLayout];
    } completion:nil];
}

- (void)draggableViewCell:(RMDraggableViewCell *)cell longPressedEndWithIndexPath:(RMIndexPath *)indexPath {
    self.indexPathCellDragging = nil;
    [cell endShaking];
    
    //Use easyInOut style to play animation.
    [UIView animateWithDuration:0.4 animations:^{
        [self resetLayout];
    } completion:nil];
}

@end
