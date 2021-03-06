//
//  LYMDraggableView.m
//  UltimatePractice
//
//  Created by Jerry Ray on 10/8/14.
//  Copyright (c) 2014 雷一鸣. All rights reserved.
//

#import "LYMDraggableView.h"



@interface LYMDraggableView ()
<LYMDraggableViewCellDelegate>

@property (nonatomic, assign) NSUInteger maxColumn;
@property (nonatomic, assign) BOOL isEditing;

@property (nonatomic, retain) NSMutableArray * muArrCells;
@property (nonatomic, retain) LYMIndexPath * destinedIndexPath;
@property (nonatomic, retain) LYMIndexPath * originalIndexPath;


@end

@implementation LYMDraggableView

- (instancetype)initWithFrame:(CGRect)frame layoutType:(LYMDraggableViewLayout)layoutType horizontalMargin:(CGFloat)hMargin verticalMargin:(CGFloat)vMargin vSpace:(CGFloat)vSpace maxColumn:(NSUInteger)maxColumn cornerRadius:(NSNumber *)cornerRadiusValue {
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
        self.cellImageCornerRadius = cornerRadiusValue;
        self.muArrCells = [NSMutableArray arrayWithCapacity:20];
        self.clipsToBounds = YES;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self reloadData];
}

- (void)dealloc {
    for (LYMDraggableViewCell * cell in self.muArrCells) {
        cell.delegate = nil;
    }
}


#pragma mark - property override 



#pragma mark - Private methods
- (LYMIndexPath *)indexPathFromIndex:(NSInteger)index {
    NSInteger row = 0;
    NSInteger column = 0;
    if (self.maxColumn != 0) {
        row = index / self.maxColumn;
        column = index % self.maxColumn;
    }
    LYMIndexPath * indexPath = [LYMIndexPath IndexPathWithRow:row column:column];
    return indexPath;
}

- (NSUInteger)indexFromIndexPath:(LYMIndexPath *)indexPath {
    return indexPath.row * self.maxColumn + indexPath.column;
}

- (void)changeIndexPathValueForCells {
    for (int i = 0; i < self.muArrCells.count; i ++) {
        LYMIndexPath * indexPath = [self indexPathFromIndex:i];
        LYMDraggableViewCell * cell = [self.muArrCells objectAtIndex:i];
        cell.indexPath.row = indexPath.row;
        cell.indexPath.column = indexPath.column;
    }
}

/**
 *  Return draggable view new frame. Set all cells frame.
 *
 *  @return
 */
- (CGRect)resetLayout {
    NSUInteger numberOfItems = [self numberOfItems];
    
    CGSize cellSize        = [self.delegate cellSizeInDraggableView:self];
    CGSize cellContentSize = [self.delegate cellContentViewSizeInDraggableView:self];
    CGSize cornerBtnSize   = [self.delegate cellCornerBtnSizeInDraggableView:self];
    
    CGFloat hSpace = 0.0;
    CGFloat hMargin = 0.0;
    if (self.hMargin == MarginAutoCaled) {
        hMargin = (self.frame.size.width - cellSize.width * self.maxColumn) / (self.maxColumn + 1);
        hSpace = hMargin;
    } else {
        hMargin = self.hMargin;
        hSpace = (self.frame.size.width - cellSize.width * self.maxColumn - hMargin * 2) / (self.maxColumn - 1);
    }
    if (hMargin < 0.0) {
        hMargin = 0.0;
    }
    if (hSpace < 0.0) {
        hSpace = 0.0;
    }
    
    CGFloat vMargin = self.vMargin;
    
    //x and y is to specify coordinate of draggableViewCell
    CGFloat x = hMargin;
    CGFloat y = vMargin;
    
    //Check if cells is out of draggableView
    if (cellSize.width * self.maxColumn + hMargin * 2 + hSpace * (self.maxColumn - 1) > self.frame.size.width) {
        NSLog(@"Warning!!! Draggable cell will be out of draggableView, please check cell size of draggableView!");
    }

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
            LYMIndexPath * indexPath = [LYMIndexPath IndexPathWithRow:row column:column];
            NSUInteger index = [self indexFromIndexPath:indexPath];
            //Reset frame of cells except the cell dragging.
            BOOL needChangeLayout = YES;
            if (self.destinedIndexPath != nil && index == [self indexFromIndexPath:self.destinedIndexPath]) {
                //It won't change frame of dragging cell if it locates the beginning zone.
                needChangeLayout = NO;
            }
            if (index < self.muArrCells.count && needChangeLayout) {
                LYMDraggableViewCell * cell = [self.muArrCells objectAtIndex:index];
                cell.frame = CGRectMake(x, y, cellSize.width, cellSize.height);
                cell.contentView.frame = CGRectMake((cell.frame.size.width - cellContentSize.width) / 2.0,
                                                    cornerBtnSize.height / 2.0,
                                                    cellContentSize.width,
                                                    cellContentSize.height);
            }
            //add up coordinates
            x += cellSize.width + hSpace;
        }
        y += cellSize.height;
        if (row != numberOfRows - 1) {
            y += self.vSpace;
        }
    }
    draggableViewHeight = y + self.vMargin;
    //construct new frame
    CGRect draggableViewNewFrame = self.frame;
    draggableViewNewFrame.size.height = draggableViewHeight;
    return draggableViewNewFrame;
}

- (void)startEditing {
    self.isEditing = YES;
    [self.muArrCells makeObjectsPerformSelector:@selector(startShaking)];
    if (self.delegate && [self.delegate respondsToSelector:@selector(draggableViewBeginEditing:)]) {
        [self.delegate draggableViewBeginEditing:self];
    }
}

- (void)reorderIndexPathOfCells {
    for (int i = 0; i < self.muArrCells.count; i ++) {
        LYMDraggableViewCell * cell = [self.muArrCells objectAtIndex:i];
        cell.indexPath = [self indexPathFromIndex:i];
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
    [self.muArrCells removeAllObjects];
    //Remove all subviews
    for (UIView * subView in self.subviews) {
        [subView removeFromSuperview];
    }
    [self endShaking];
    
    //Target Item can be reordered
    BOOL targetCanReorder = YES;
    BOOL canEdit = YES;
    BOOL canShakeWhenEditing = YES;
    //Create cells and get draggable view's max frame
    NSInteger numberOfItems = [self numberOfItems];
    for (int index = 0; index < numberOfItems; index ++) {
        LYMDraggableViewCell * cell = [self.dataSource draggableView:self cellForIndex:index];
        cell.delegate = self;
        cell.indexPath = [self indexPathFromIndex:index];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(draggableView:canMoveAtIndex:)]) {
            targetCanReorder = [self.delegate draggableView:self canMoveAtIndex:index];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(draggableView:canEditingAtIndex:)]) {
            canEdit = [self.delegate draggableView:self canEditingAtIndex:index];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(draggableView:canShakeWhenEditingAtIndex:)]) {
            canShakeWhenEditing = [self.delegate draggableView:self canShakeWhenEditingAtIndex:index];
        }
        
        cell.canMove = targetCanReorder;
        cell.canEdit = canEdit;
        cell.canShake = canShakeWhenEditing;
        [self addSubview:cell];
        [self.muArrCells addObject:cell];
    }
    //construct new frame
    CGRect draggableViewNewFrame = [self resetLayout];
    
    //perform call back
    if (self.delegate && [self.delegate respondsToSelector:@selector(draggableView:willResizeWithFrame:)]) {
        [self.delegate draggableView:self willResizeWithFrame:draggableViewNewFrame];
    }
    self.frame = draggableViewNewFrame;
    [self.muArrCells makeObjectsPerformSelector:@selector(setNeedsDisplay)];
    if (self.delegate && [self.delegate respondsToSelector:@selector(draggableView:didResizeWithFrame:)]) {
        [self.delegate draggableView:self didResizeWithFrame:draggableViewNewFrame];
    }
}

- (void)continueShakingWhenEditing {
    if (self.isEditing) {
        [self.muArrCells makeObjectsPerformSelector:@selector(startShaking)];
    }
}

- (void)endEditing {
    self.isEditing = NO;
    [self endShaking];
    if (self.delegate && [self.delegate respondsToSelector:@selector(draggableViewEndEditing:)]) {
        [self.delegate draggableViewEndEditing:self];
    }
}

- (void)endShaking {
    [self.muArrCells makeObjectsPerformSelector:@selector(endShaking)];
}

- (void)removeCellAtIndex:(NSUInteger)index {
    LYMDraggableViewCell * cell = [self.muArrCells objectAtIndex:index];
    //remove cell from view
    [cell removeFromSuperview];
    //remove cell from datasource
    [self.muArrCells removeObject:cell];
    //reorder indexpath of cell
    [self reorderIndexPathOfCells];
    //redraw UI
    CGRect draggableViewNewFrame = [self resetLayout];
    
    //perform call back
    if (self.delegate && [self.delegate respondsToSelector:@selector(draggableView:willResizeWithFrame:)]) {
        [self.delegate draggableView:self willResizeWithFrame:draggableViewNewFrame];
    }
    self.frame = draggableViewNewFrame;
    [self.muArrCells makeObjectsPerformSelector:@selector(setNeedsDisplay)];
    if (self.delegate && [self.delegate respondsToSelector:@selector(draggableView:didResizeWithFrame:)]) {
        [self.delegate draggableView:self didResizeWithFrame:draggableViewNewFrame];
    }

}

- (LYMDraggableViewCell *)cellAtIndex:(NSUInteger)index {
    if (index < self.muArrCells.count) {
        return [self.muArrCells objectAtIndex:index];
    } else {
        return nil;
    }
}

+ (CGFloat)heightOfDraggableViewFromVMargin:(CGFloat)vmargin cellHeight:(CGFloat)cellHeight vSpace:(CGFloat)vSpace itemsCount:(NSUInteger)itemsCount {
    CGFloat numOfRow = ceil(itemsCount / 4.0);
    CGFloat draggableViewHeight = vmargin * 2 + cellHeight * numOfRow + vSpace * (numOfRow - 1);
    return draggableViewHeight;
}

#pragma mark - LYMDraggableViewCell Delegate
- (void)draggableViewCell:(LYMDraggableViewCell *)cell tappedWithIndexPath:(LYMIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(draggableView:didSelectCellAtIndex:)]) {
        [self.delegate draggableView:self didSelectCellAtIndex:[self indexFromIndexPath:indexPath]];
    }
}

- (void)draggableViewCell:(LYMDraggableViewCell *)cell cornerBtnPressedWithIndexPath:(LYMIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(draggableView:cornerBtnPressedAtIndex:)]) {
        [self.delegate draggableView:self cornerBtnPressedAtIndex:[self indexFromIndexPath:indexPath]];
    }
}

- (CGSize)draggableViewCell:(LYMDraggableViewCell *)cell cornerBtnSizeWithIndexPath:(LYMIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellCornerBtnSizeInDraggableView:)]) {
        return [self.delegate cellCornerBtnSizeInDraggableView:self];
    }
    return CGSizeMake(25.0, 25.0);
}

- (void)draggableViewCell:(LYMDraggableViewCell *)cell longPressedBeginWithIndexPath:(LYMIndexPath *)indexPath {
    if (self.originalIndexPath == nil) {
        self.originalIndexPath = [indexPath copy];
    }
    if (self.isEditing == NO) {
        [self startEditing];
    }
}

- (void)draggableViewCell:(LYMDraggableViewCell *)cell longPressedDidMoveWithIndexPath:(LYMIndexPath *)indexPath {
    //Store the indexpath value of cell which is dragging.
    self.destinedIndexPath = indexPath;

    CGRect draggingCellFrame = cell.frame;
    NSArray * arrCells = [NSArray arrayWithArray:self.muArrCells];
    for (int i = 0; i < arrCells.count; i ++) {
        LYMDraggableViewCell * enumeratedCell = [arrCells objectAtIndex:i];
        if (cell == enumeratedCell) {
            continue;
        }
        CGRect enumeratedCellFrame = enumeratedCell.frame;
        CGFloat draggingCellEndX = draggingCellFrame.origin.x + draggingCellFrame.size.width / 2;
        CGFloat draggingCellEndY = draggingCellFrame.origin.y + draggingCellFrame.size.width / 2;
        
        BOOL isXContain = NO;
        BOOL isYContain = NO;
        BOOL targetCanReorder = YES;
        if (enumeratedCellFrame.origin.x < draggingCellEndX && enumeratedCellFrame.origin.x + enumeratedCellFrame.size.width > draggingCellEndX) {
            isXContain = YES;
        }
        if (enumeratedCellFrame.origin.y < draggingCellEndY && enumeratedCellFrame.origin.y + enumeratedCellFrame.size.height > draggingCellEndY) {
            isYContain = YES;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(draggableView:canMoveAtIndex:)]) {
            targetCanReorder = [self.delegate draggableView:self canMoveAtIndex:i];
        }
        if (isXContain && isYContain && targetCanReorder) {
            //Insert dragging cell into this index
            [self.muArrCells removeObject:cell];
            [self.muArrCells insertObject:cell atIndex:i];
            //Change indexPath value to new for all cells.
            [self changeIndexPathValueForCells];
            break;
        }
    }
    
    //Use easeInOut style to play animation.
    [UIView animateWithDuration:0.4 animations:^{
        [self resetLayout];
    } completion:nil];
}

- (void)draggableViewCell:(LYMDraggableViewCell *)cell longPressedEndWithIndexPath:(LYMIndexPath *)indexPath {
    self.destinedIndexPath = nil;
    //Use easeInOut style to play animation.
    [UIView animateWithDuration:0.4 animations:^{
        [self resetLayout];
    } completion:^(BOOL finished) {
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(draggableView:didMoveCellFromIndex:toIndex:)]) {
            CGFloat fromIndex = [self indexFromIndexPath:self.originalIndexPath];
            CGFloat toIndex = [self indexFromIndexPath:indexPath];
            [self.dataSource draggableView:self didMoveCellFromIndex:fromIndex toIndex:toIndex];
        }
        self.originalIndexPath = nil;
    }];
}

- (CGFloat)draggableViewCell:(LYMDraggableViewCell *)cell cellEditingScaleUpFactorWithIndexPath:(LYMIndexPath *)indexPath {
    CGFloat factor = 1.0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(draggableView:cellEditingScaleUpFactorAtIndex:)]) {
        factor = [self.delegate draggableView:self cellEditingScaleUpFactorAtIndex:[self indexFromIndexPath:indexPath]];
    }
    return factor;
}

- (CGFloat)draggableViewCell:(LYMDraggableViewCell *)cell cellImageCornerRadiusAtIndexPath:(LYMIndexPath *)indexPath {
    CGFloat cornerRadius = cell.imageView.frame.size.width / 2.0;
    if (self.cellImageCornerRadius != nil) {
        cornerRadius = [self.cellImageCornerRadius doubleValue];
    }
    return cornerRadius;
}


@end
