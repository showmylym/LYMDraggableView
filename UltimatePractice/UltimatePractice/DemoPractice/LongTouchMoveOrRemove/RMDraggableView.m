//
//  RMDraggableView.m
//  UltimatePractice
//
//  Created by Jerry on 10/8/14.
//  Copyright (c) 2014 RayManning. All rights reserved.
//

#import "RMDraggableView.h"

@interface NSIndexPath ()

@property (nonatomic, assign, readwrite) NSInteger section;
@property (nonatomic, assign, readwrite) NSInteger column;

@end

@implementation NSIndexPath (RMDraggableView)


+ (instancetype)IndexPathWithSection:(NSInteger)section column:(NSInteger)column {
    NSIndexPath * indexPath = [[NSIndexPath alloc] init];
    indexPath.section = section;
    indexPath.column = column;
    return indexPath;
}

@end




@implementation RMDraggableView


- (instancetype)initWithHorizontalMargin:(CGFloat)hMargin
                          verticalMargin:(CGFloat)vMargin
                         horizontalSpace:(CGFloat)hSpace
                           verticalSpace:(CGFloat)vSpace {
    self = [super init];
    if (self) {
        self.draggableViewLayout = RMDraggableViewLayoutBySpaceBetweenItems;
        self.hMargin = hMargin;
        self.vMargin = vMargin;
        self.hSpace = hSpace;
        self.vSpace = vSpace;
        [self reloadData];
    }
    return self;
}

- (instancetype)initWithColumnNum:(NSInteger)columnNum horizontalMargin:(CGFloat)hMargin verticalMargin:(CGFloat)vMargin {
    self = [super init];
    if (self) {
        self.draggableViewLayout = RMDraggableViewLayoutByItemNum;
        self.hMargin = hMargin;
        self.vMargin = vMargin;
        [self reloadData];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


#pragma mark - property override 
// Set value of space between items if only this draggable view layout by space. Otherwise value of hSpace and vSpace are calculated by other data, for example margin and the number of items.
- (void)setHSpace:(CGFloat)hSpace {
    if (self.draggableViewLayout == RMDraggableViewLayoutBySpaceBetweenItems) {
        _hSpace = hSpace;
    }
}
- (void)setVSpace:(CGFloat)vSpace {
    if (self.draggableViewLayout == RMDraggableViewLayoutBySpaceBetweenItems) {
        _vSpace = vSpace;
    }
}

#pragma mark - Private methods

#pragma mark - Public methods
- (NSInteger)numberOfSections {
    return [self.dataSource numberOfSectionsInDraggableView:self];
}

- (NSInteger)numberOfCellsInSection:(NSInteger)section {
    return [self.dataSource draggableView:self numberOfItemsInSection:section];
}

- (void)reloadData {
    //x and y is to specify coordinate of draggableViewCell
    CGFloat x = self.hMargin;
    CGFloat y = self.vMargin;
    
    NSInteger numberOfSections = [self numberOfSections];
    for (int section = 0; section < numberOfSections; section ++) {
        NSInteger numberOfCells = [self numberOfCellsInSection:section];
        for (int coloumn = 0; coloumn < numberOfCells; coloumn ++) {
            NSIndexPath * indexPath = [NSIndexPath IndexPathWithSection:section column:coloumn];
            RMDraggableViewCell * cell = [self.dataSource draggableView:self cellForIndexPath:indexPath];
            [self addSubview:cell];
        }
    }
}

@end
