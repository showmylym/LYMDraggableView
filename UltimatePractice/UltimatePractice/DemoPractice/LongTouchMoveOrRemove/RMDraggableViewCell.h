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

@interface RMDraggableViewCell : UIView

@property (nonatomic, retain) UIImageView * imageView;
@property (nonatomic, retain) UILabel * textLabel;
@property (nonatomic, retain) UIButton * leftTopXBtn;

- (instancetype)initWithStyle:(RMDraggableViewCellType)cellType;

- (void)startEditing;
- (void)endEditing;

@end
