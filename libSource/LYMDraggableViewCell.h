//
//  LYMDraggableViewCell.h
//  UltimatePractice
//
//  Created by Jerry Ray on 10/9/14.
//  Copyright (c) 2014 雷一鸣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYMIndexPath.h"

#define DegreesToRadians(degrees) (degrees * M_PI / 180)
#define RadiansToDegrees(radians) (radians * 180 / M_PI)

@class LYMDraggableViewCell;
@class LYMIndexPath;

typedef enum {
    /**
     *  Show both image and label text.
     */
    LYMDraggableViewCellTypeDefault = 0,
    /**
     *  Show image without label text.
     */
    LYMDraggableViewCellTypeOnlyIcon = 1,
} LYMDraggableViewCellType;

typedef enum {
    LYMDraggableViewCellCornerBtnStyleTopLeft = 0,
    LYMDraggableViewCellCornerBtnStyleTopRight = 1,
} LYMDraggableViewCellCornerBtnStyle;


@protocol LYMDraggableViewCellDelegate <NSObject>

@optional

//appearance call back
- (CGFloat)draggableViewCell:(LYMDraggableViewCell *)cell cellEditingScaleUpFactorWithIndexPath:(LYMIndexPath *)indexPath;
- (CGFloat)draggableViewCell:(LYMDraggableViewCell *)cell cellImageCornerRadiusAtIndexPath:(LYMIndexPath *)indexPath;

- (void)draggableViewCell:(LYMDraggableViewCell *)cell cornerBtnPressedWithIndexPath:(LYMIndexPath *)indexPath;
- (CGSize)draggableViewCell:(LYMDraggableViewCell *)cell cornerBtnSizeWithIndexPath:(LYMIndexPath *)indexPath;


//operation callback
- (void)draggableViewCell:(LYMDraggableViewCell *)cell tappedWithIndexPath:(LYMIndexPath *)indexPath;
- (void)draggableViewCell:(LYMDraggableViewCell *)cell longPressedBeginWithIndexPath:(LYMIndexPath *)indexPath;
- (void)draggableViewCell:(LYMDraggableViewCell *)cell longPressedDidMoveWithIndexPath:(LYMIndexPath *)indexPath;
- (void)draggableViewCell:(LYMDraggableViewCell *)cell longPressedEndWithIndexPath:(LYMIndexPath *)indexPath;

@end




@interface LYMDraggableViewCell : UIView

@property (nonatomic, weak) id<LYMDraggableViewCellDelegate> delegate;
@property (nonatomic) LYMDraggableViewCellCornerBtnStyle cornerBtnStyle;

//Controls in content view
@property (nonatomic, retain, readonly) UIView      * contentView;
@property (nonatomic, retain, readonly) UIImageView * imageView;
@property (nonatomic, retain, readonly) UILabel     * textLabel;
@property (nonatomic, retain, readonly) UIButton    * cornerBtn;

/**
 *  IndexPath in draggable view.
 */
@property (nonatomic, retain) LYMIndexPath * indexPath;

//Flag to control logic
@property (nonatomic) BOOL isEditing;
@property (nonatomic) BOOL isShaking;
@property (nonatomic) BOOL canMove;
@property (nonatomic) BOOL canShake;
@property (nonatomic) BOOL canEdit;

- (instancetype)initWithSize:(CGSize)size style:(LYMDraggableViewCellType)cellType cornerBtnStyleWhenShaking:(LYMDraggableViewCellCornerBtnStyle)cornerBtnStyle;

- (void)startShaking;
- (void)endShaking;

@end
