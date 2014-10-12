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


@end




@protocol RMDraggableViewDelegate <NSObject>

@required
- (CGSize)cellSizeInDraggableView:(RMDraggableView *)draggableView;


@optional

- (BOOL)canShakeWhenEditing;
- (void)draggableView:(RMDraggableView *)draggableView willSelectCellAtIndex:(NSUInteger)index;
- (void)draggableView:(RMDraggableView *)draggableView didSelectCellAtIndex:(NSUInteger)index;
- (void)draggableView:(RMDraggableView *)draggableView cornerBtnPressedAtIndex:(NSUInteger)index;
- (void)draggableView:(RMDraggableView *)draggableView willResizeWithFrame:(CGRect)frame;
- (void)draggableView:(RMDraggableView *)draggableView didResizeWithFrame:(CGRect)frame;


@end



@interface RMIndexPath : NSObject

@property (nonatomic, assign, readonly) NSUInteger row;
@property (nonatomic, assign, readonly) NSUInteger column;

+ (instancetype)IndexPathWithRow:(NSUInteger)row column:(NSUInteger)column;

@end



@interface RMDraggableView : UIView

@property (nonatomic, assign) id<RMDraggableViewDelegate> delegate;
@property (nonatomic, assign) id<RMDraggableViewDataSource> dataSource;

@property (nonatomic, assign) CGFloat hMargin;
@property (nonatomic, assign) CGFloat vMargin;
@property (nonatomic, assign) RMDraggableViewLayout draggableViewLayout;

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

- (void)startEditing;
- (void)endEditing;
- (void)reloadData;

- (NSUInteger)numberOfItems;


@end
