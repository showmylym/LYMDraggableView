//
//  RMDraggableViewCell.m
//  UltimatePractice
//
//  Created by Jerry Ray on 10/9/14.
//  Copyright (c) 2014 RayManning. All rights reserved.
//

#import "RMDraggableViewCell.h"
#import "RMDraggableView.h"

@interface RMDraggableViewCell ()

@property (nonatomic) RMDraggableViewCellCornerBtnStyle cornerBtnStyle;

@property (nonatomic, retain) UITapGestureRecognizer * tapGesture;
@end

@implementation RMDraggableViewCell

- (instancetype)initWithStyle:(RMDraggableViewCellType)cellType {
    self = [super init];
    if (self) {
        //cell content view
        self.contentView = [[UIView alloc] init];
        self.contentView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1.0];
        [self addSubview:self.contentView];
        
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureTriggered:)];
        [self.contentView addGestureRecognizer:self.tapGesture];
        
        //control in content view initialization
        self.imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageView];
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.text = @"test";
        [self.contentView addSubview:self.textLabel];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    NSLog(@"%@ drawRect:%@", NSStringFromClass([self class]), NSStringFromCGRect(rect));
    self.contentView.frame = rect;
    
    CGFloat textLabelHeight = 18.0;
    CGFloat margin = 4.0;
    CGFloat vSpace = 4.0;
    
    CGRect imageViewRect = rect;
    imageViewRect.origin.x = margin;
    imageViewRect.origin.y = margin;
    imageViewRect.size.width  -= margin * 2;
    imageViewRect.size.height -= textLabelHeight + margin * 2 - vSpace;
    self.imageView.frame = imageViewRect;
    
    CGRect labelRect = imageViewRect;
    labelRect.origin.y = imageViewRect.origin.y + imageViewRect.size.height;
    labelRect.size.height = textLabelHeight;
    self.textLabel.frame = labelRect;
    
}


#pragma mark - public methods
- (void)startEditingWithCornerBtnStyle:(RMDraggableViewCellCornerBtnStyle)btnStyle {
    self.cornerBtnStyle = btnStyle;
    self.isEditing = YES;
}

- (void)endEditing {
    self.isEditing = NO;
}

#pragma mark - Private methods
- (void)tapGestureTriggered:(UIGestureRecognizer *)gesture {
    NSLog(@"tap row(%ld) column(%ld) cell once",  (long)self.indexPath.row, (long)self.indexPath.column);
    if (self.delegate && [self.delegate respondsToSelector:@selector(draggableViewCell:tappedWithIndexPath:)]) {
        [self.delegate draggableViewCell:self tappedWithIndexPath:self.indexPath];
    }
    
}

@end
