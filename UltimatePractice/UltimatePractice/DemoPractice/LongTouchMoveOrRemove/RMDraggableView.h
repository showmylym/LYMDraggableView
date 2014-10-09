//
//  RMDraggableView.h
//  UltimatePractice
//
//  Created by Jerry on 10/8/14.
//  Copyright (c) 2014 RayManning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMDraggableViewCell.h"

typedef enum {
    RMDraggableViewLayoutBySpaceBetweenItems = 0,
    RMDraggableViewLayoutByItemNum = 1,
} RMDraggableViewLayout;


@class RMDraggableView;




@protocol RMDraggableViewDataSource <NSObject>

@required
- (NSInteger)numberOfSectionsInDraggableView:(RMDraggableView *)draggableView;
- (NSInteger)draggableView:(RMDraggableView *)draggableView numberOfItemsInSection:(NSInteger)section;
@optional
- (RMDraggableViewCell *)draggableView:(RMDraggableView *)draggableView cellForIndexPath:(NSIndexPath *)indexPath;

@end




@protocol RMDraggableViewDelegate <NSObject>

- (BOOL)canShakeWhenEditing;
- (void)draggableView:(RMDraggableView *)draggableView willSelectCellAtIndexPath:(NSIndexPath *)indexPath;
- (void)draggableView:(RMDraggableView *)draggableView didSelectCellAtIndexPath:(NSIndexPath *)indexPath;
- (void)draggableView:(RMDraggableView *)draggableView xBtnPressedInCell:(RMDraggableViewCell *)itemCell;
- (void)draggableView:(RMDraggableView *)draggableView willResizeWithFrame:(CGRect)frame;
- (void)draggableView:(RMDraggableView *)draggableView didResizeWithFrame:(CGRect)frame;

- (CGRect)draggableView:(RMDraggableView *)draggableView cellSizeForIndexPath:(NSIndexPath *)indexPath;

@end



@interface NSIndexPath (RMDraggableView)

@property (nonatomic, assign, readonly) NSInteger section;
@property (nonatomic, assign, readonly) NSInteger column;

+ (instancetype)IndexPathWithSection:(NSInteger)section column:(NSInteger)column;

@end



@interface RMDraggableView : UIView

@property (nonatomic, assign) id<RMDraggableViewDelegate> delegate;
@property (nonatomic, assign) id<RMDraggableViewDataSource> dataSource;

@property (nonatomic, assign) CGFloat hMargin;
@property (nonatomic, assign) CGFloat vMargin;
@property (nonatomic, assign) CGFloat hSpace;
@property (nonatomic, assign) CGFloat vSpace;

@property (nonatomic, assign) RMDraggableViewLayout draggableViewLayout;

- (instancetype)initWithHorizontalMargin:(CGFloat)hMargin verticalMargin:(CGFloat)vMargin horizontalSpace:(CGFloat)hSpace verticalSpace:(CGFloat)vSpace;
- (instancetype)initWithColumnNum:(NSInteger)columnNum horizontalMargin:(CGFloat)hMargin verticalMargin:(CGFloat)vMargin;

- (void)startEditing;
- (void)endEditing;
- (void)reloadData;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfCellsInSection:(NSInteger)section;


@end
