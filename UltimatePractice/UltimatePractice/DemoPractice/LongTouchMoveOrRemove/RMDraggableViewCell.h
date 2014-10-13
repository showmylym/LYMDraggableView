//
//  RMDraggableViewCell.h
//  UltimatePractice
//
//  Created by Jerry Ray on 10/9/14.
//  Copyright (c) 2014 RayManning. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RMDraggableViewCell;
@class RMIndexPath;

typedef enum {
    RMDraggableViewCellTypeDefault = 0,
} RMDraggableViewCellType;

typedef enum {
    RMDraggableViewCellCornerBtnStyleTopLeft = 0,
    RMDraggableViewCellCornerBtnStyleTopRight = 1,
} RMDraggableViewCellCornerBtnStyle;


@protocol RMDraggableViewCellDelegate <NSObject>

@optional
- (void)draggableViewCell:(RMDraggableViewCell *)cell cornerBtnPressedWithIndexPath:(RMIndexPath *)indexPath;
- (CGSize)draggableViewCell:(RMDraggableViewCell *)cell cornerBtnSizeWithIndexPath:(RMIndexPath *)indexPath;
- (void)draggableViewCell:(RMDraggableViewCell *)cell tappedWithIndexPath:(RMIndexPath *)indexPath;
- (void)draggableViewCell:(RMDraggableViewCell *)cell longPressedBeginWithIndexPath:(RMIndexPath *)indexPath;
- (void)draggableViewCell:(RMDraggableViewCell *)cell longPressedDidMoveWithIndexPath:(RMIndexPath *)indexPath;
- (void)draggableViewCell:(RMDraggableViewCell *)cell longPressedEndWithIndexPath:(RMIndexPath *)indexPath;

@end




@interface RMDraggableViewCell : UIView

@property (nonatomic, assign) id<RMDraggableViewCellDelegate> delegate;
@property (nonatomic) RMDraggableViewCellCornerBtnStyle cornerBtnStyle;
@property (nonatomic, retain) UIView * contentView;

//Controls in content view
@property (nonatomic, retain, readonly) UIImageView * imageView;
@property (nonatomic, retain, readonly) UILabel * textLabel;
@property (nonatomic, retain, readonly) UIButton * cornerBtn;

/**
 *  IndexPath in draggable view.
 */
@property (nonatomic, retain) RMIndexPath * indexPath;

//Flag to control logic
@property (nonatomic) BOOL isEditing;
@property (nonatomic) BOOL isShaking;

- (instancetype)initWithStyle:(RMDraggableViewCellType)cellType cornerBtnStyleWhenShaking:(RMDraggableViewCellCornerBtnStyle)cornerBtnStyle;

- (void)startShaking;
- (void)endShaking;

@end
