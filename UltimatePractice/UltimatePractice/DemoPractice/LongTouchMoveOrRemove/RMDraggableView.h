//
//  RMDraggableView.h
//  UltimatePractice
//
//  Created by Jerry Ray on 10/8/14.
//  Copyright (c) 2014 RayManning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMDraggableViewCell.h"

#define MarginAutoCaled   -1.0
#define SpaceAutoCaled    -1.0


typedef enum {
    /**
     *  Keep cell size consistent, auto-adapt the space between columns. If there is enough space, then put into current row one more cell.
     */
    //    RMDraggableViewLayoutByCellSize = 0,
    /**
     *  Keep the number of columns consistent, auto-adapt the size of cell and the space between items as the same scale-factor.
     */
    RMDraggableViewLayoutByColumnNum = 1,
} RMDraggableViewLayout;


@class RMDraggableView;




@protocol RMDraggableViewDataSource <NSObject>

@required
- (NSInteger)numberOfCellsInDraggableView:(RMDraggableView *)draggableView;
- (RMDraggableViewCell *)draggableView:(RMDraggableView *)draggableView cellForIndex:(NSUInteger)index;

@optional
- (BOOL)draggableView:(RMDraggableView *)draggableView canMoveAtIndex:(NSUInteger)index;
- (void)draggableView:(RMDraggableView *)draggableView moveItemAndTouchUpFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

@end




@protocol RMDraggableViewDelegate <NSObject>

@required
- (CGSize)cellSizeInDraggableView:(RMDraggableView *)draggableView;


@optional

- (BOOL)draggableView:(RMDraggableView *)draggableView canShakeWhenEditingAtIndex:(NSUInteger)index;
- (BOOL)draggableView:(RMDraggableView *)draggableView canEditingAtIndex:(NSUInteger)index;
- (void)draggableView:(RMDraggableView *)draggableView willSelectCellAtIndex:(NSUInteger)index;
- (void)draggableView:(RMDraggableView *)draggableView didSelectCellAtIndex:(NSUInteger)index;
- (void)draggableView:(RMDraggableView *)draggableView cornerBtnPressedAtIndex:(NSUInteger)index;
- (void)draggableView:(RMDraggableView *)draggableView willResizeWithFrame:(CGRect)frame;
- (void)draggableView:(RMDraggableView *)draggableView didResizeWithFrame:(CGRect)frame;
- (CGSize)draggableView:(RMDraggableView *)draggableView cornerBtnSizeAtIndex:(NSUInteger)index;
- (CGFloat)draggableView:(RMDraggableView *)draggableView cellEditingScaleFactor:(NSUInteger)index;

- (void)draggableViewBeginEditing;
- (void)draggableViewEndEditing;

@end




@interface RMDraggableView : UIView

@property (nonatomic, weak) id<RMDraggableViewDelegate> delegate;
@property (nonatomic, weak) id<RMDraggableViewDataSource> dataSource;

@property (nonatomic, assign) CGFloat hMargin;
@property (nonatomic, assign) CGFloat vMargin;
@property (nonatomic, assign) RMDraggableViewLayout draggableViewLayout;
@property (nonatomic, assign) BOOL isEditing;

/**
 *  Initialize draggable view.
 *
 *  @param frame      view frame. Height can be 0.0, as it will auto-adapt.
 *  @param layoutType For layout UI
 *  @param hMargin    Margin of Horizontality
 *  @param vMargin    Margin of Verticality, must set value and can't be MarginAutoCaled.
 *  @param vSpace     Space between Columns
 *  @param maxColumn  accepted max column value.
 *  @return
 */
- (instancetype)initWithFrame:(CGRect)frame layoutType:(RMDraggableViewLayout)layoutType horizontalMargin:(CGFloat)hMargin verticalMargin:(CGFloat)vMargin vSpace:(CGFloat)vSpace maxColumn:(NSUInteger)maxColumn;

- (void)resizeWithFrame:(CGRect)frame;

- (void)continueShakingWhenEditing;
- (void)endEditing;
- (void)reloadData;
- (void)removeCellAtIndex:(NSUInteger)index;

- (NSUInteger)numberOfItems;


@end
