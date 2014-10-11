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
- (NSInteger)draggableView:(RMDraggableView *)draggableView numberOfColumnsInRow:(NSInteger)row;
@optional
- (NSInteger)numberOfRowsInDraggableView:(RMDraggableView *)draggableView;
- (RMDraggableViewCell *)draggableView:(RMDraggableView *)draggableView cellForColumnAtIndexPath:(RMIndexPath *)indexPath;

@end




@protocol RMDraggableViewDelegate <NSObject>

@required
- (CGSize)cellSizeInDraggableView:(RMDraggableView *)draggableView;


@optional

- (BOOL)canShakeWhenEditing;
- (void)draggableView:(RMDraggableView *)draggableView willSelectCellAtIndexPath:(RMIndexPath *)indexPath;
- (void)draggableView:(RMDraggableView *)draggableView didSelectCellAtIndexPath:(RMIndexPath *)indexPath;
- (void)draggableView:(RMDraggableView *)draggableView xBtnPressedInCell:(RMDraggableViewCell *)itemCell;
- (void)draggableView:(RMDraggableView *)draggableView willResizeWithFrame:(CGRect)frame;
- (void)draggableView:(RMDraggableView *)draggableView didResizeWithFrame:(CGRect)frame;


@end



@interface RMIndexPath : NSObject

@property (nonatomic, assign, readonly) NSInteger row;
@property (nonatomic, assign, readonly) NSInteger column;

+ (instancetype)IndexPathWithRow:(NSInteger)row column:(NSInteger)column;

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

- (NSInteger)numberOfRows;
- (NSInteger)numberOfColumnsInRow:(NSInteger)section;


@end
