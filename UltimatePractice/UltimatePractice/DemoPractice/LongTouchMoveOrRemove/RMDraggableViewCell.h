//
//  RMDraggableViewCell.h
//  UltimatePractice
//
//  Created by Jerry Ray on 10/9/14.
//  Copyright (c) 2014 RayManning. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    RMDraggableViewCellTypeDefault = 0,
} RMDraggableViewCellType;

typedef enum {
    RMDraggableViewCellCornerBtnStyleLeftTop = 0,
    RMDraggableViewCellCornerBtnStyleRightTop = 1,
} RMDraggableViewCellCornerBtnStyle;

@interface RMDraggableViewCell : UIView

@property (nonatomic, retain) UIView * contentView;

@property (nonatomic, retain) UIImageView * imageView;
@property (nonatomic, retain) UILabel * textLabel;
@property (nonatomic, retain) UIButton * cornerBtn;

@property (nonatomic) BOOL isEditing;

- (instancetype)initWithStyle:(RMDraggableViewCellType)cellType;

- (void)startEditingWithCornerBtnStyle:(RMDraggableViewCellCornerBtnStyle)btnStyle;
- (void)endEditing;

@end
