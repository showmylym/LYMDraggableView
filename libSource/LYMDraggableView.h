//
//  LYMDraggableView.h
//  UltimatePractice
//
//  Created by Jerry Ray on 10/8/14.
//  Copyright (c) 2014 雷一鸣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYMDraggableViewCell.h"

#define MarginAutoCaled   -1.0
#define SpaceAutoCaled    -1.0


typedef enum {
    /**
     *  保持cell的size不变，cell之间的列间距自适应。如果有足够空间，在当前行再插入一个cell。
     *  Keep cell size consistent, auto-calculate the space between columns. If there is enough space, then put into current row one more cell.
     */
//    LYMDraggableViewLayoutByCellSize = 0,
    /**
     *  保持cell的size和列数不变，cell之间的列间距按照比例系数自适应。边距仍然保持不变，使用初始值。
     *  Keep the number of columns and size consistent, auto-calculate the space between columns by scale-factor. Margin to draggableView is set by default value from initialization.
     */
    LYMDraggableViewLayoutByColumnNum = 1,
} LYMDraggableViewLayout;


@class LYMDraggableView;




@protocol LYMDraggableViewDataSource <NSObject>

@required
- (NSInteger)numberOfCellsInDraggableView:(LYMDraggableView *)draggableView;
- (LYMDraggableViewCell *)draggableView:(LYMDraggableView *)draggableView cellForIndex:(NSUInteger)index;

@optional
- (void)draggableView:(LYMDraggableView *)draggableView moveItemAndTouchUpFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

@end




@protocol LYMDraggableViewDelegate <NSObject>

@required
- (CGSize)cellContentViewSizeInDraggableView:(LYMDraggableView *)draggableView;
- (CGSize)cellCornerBtnSizeInDraggableView:(LYMDraggableView *)draggableView;
- (CGSize)cellSizeInDraggableView:(LYMDraggableView *)draggableView;

@optional

//corner btn callback
- (void)draggableView:(LYMDraggableView *)draggableView cornerBtnPressedAtIndex:(NSUInteger)index;

//appearance callback
- (BOOL)draggableView:(LYMDraggableView *)draggableView canShakeWhenEditingAtIndex:(NSUInteger)index;
- (BOOL)draggableView:(LYMDraggableView *)draggableView canEditingAtIndex:(NSUInteger)index;
- (BOOL)draggableView:(LYMDraggableView *)draggableView canMoveAtIndex:(NSUInteger)index;

- (CGFloat)draggableView:(LYMDraggableView *)draggableView cellEditingScaleUpFactorAtIndex:(NSUInteger)index;

//operation callback
- (void)draggableView:(LYMDraggableView *)draggableView willSelectCellAtIndex:(NSUInteger)index;
- (void)draggableView:(LYMDraggableView *)draggableView didSelectCellAtIndex:(NSUInteger)index;
- (void)draggableView:(LYMDraggableView *)draggableView willResizeWithFrame:(CGRect)frame;
- (void)draggableView:(LYMDraggableView *)draggableView didResizeWithFrame:(CGRect)frame;

//state callback
- (void)draggableViewBeginEditing:(LYMDraggableView *)draggableView;
- (void)draggableViewEndEditing:(LYMDraggableView *)draggableView;

@end




@interface LYMDraggableView : UIView

@property (nonatomic, weak) id<LYMDraggableViewDelegate> delegate;
@property (nonatomic, weak) id<LYMDraggableViewDataSource> dataSource;

@property (nonatomic, assign) CGFloat hMargin;
@property (nonatomic, assign) CGFloat vMargin;
@property (nonatomic, assign) CGFloat vSpace;
@property (nonatomic, assign) LYMDraggableViewLayout draggableViewLayout;
/**
 *  value will be auto-calculated if nil.
 */
@property (nonatomic, strong) NSNumber * cellImageCornerRadius;

@property (nonatomic, assign, readonly) BOOL isEditing;
@property (nonatomic, assign, readonly) NSUInteger maxColumn;

/**
 *  Initialize draggable view.
 *
 *  @param frame      view frame. Height can be 0.0, as it will auto-adapt.
 *  @param layoutType For layout UI
 *  @param hMargin    Margin of Horizontality
 *  @param vMargin    Margin of Verticality, must set value and can't be MarginAutoCaled.
 *  @param vSpace     Space between Columns
 *  @param maxColumn  accepted max column value.
 *  @param cornerRadius  cornerRadius of cell image. The value is cellImageWidth/2.0 if set nil.
 *  @return
 */
- (instancetype)initWithFrame:(CGRect)frame layoutType:(LYMDraggableViewLayout)layoutType horizontalMargin:(CGFloat)hMargin verticalMargin:(CGFloat)vMargin vSpace:(CGFloat)vSpace maxColumn:(NSUInteger)maxColumn cornerRadius:(NSNumber *)cornerRadiusValue;

- (void)resizeWithFrame:(CGRect)frame;

- (void)continueShakingWhenEditing;
- (void)endEditing;
- (void)reloadData;
- (void)removeCellAtIndex:(NSUInteger)index;

- (NSUInteger)numberOfItems;
- (LYMDraggableViewCell *)cellAtIndex:(NSUInteger)index;

/**
 *  Calculate height of DraggableView for initialization.
 *
 *  @param vmargin    Margin to top or bottom.
 *  @param cellHeight Height of draggableCell.
 *  @param vSpace     Span between cells.
 *  @param itemsCount total items number.
 *
 *  @return
 */
- (CGFloat)heightOfDraggableViewFromVMargin:(CGFloat)vmargin cellHeight:(CGFloat)cellHeight vSpace:(CGFloat)vSpace itemsCount:(NSUInteger)itemsCount;

@end
