//
//  RMDraggableViewCell.m
//  UltimatePractice
//
//  Created by Jerry Ray on 10/9/14.
//  Copyright (c) 2014 RayManning. All rights reserved.
//

#import "RMDraggableViewCell.h"

@interface RMDraggableViewCell ()

@property (nonatomic) RMDraggableViewCellCornerBtnStyle cornerBtnStyle;

@end

@implementation RMDraggableViewCell

- (instancetype)initWithStyle:(RMDraggableViewCellType)cellType {
    self = [super init];
    if (self) {
        //cell content view
        self.contentView = [[UIView alloc] init];
        self.contentView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1.0];
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
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
    CGRect imageViewRect = rect;
    imageViewRect.origin.x = 4.0;
    imageViewRect.origin.y = 4.0;
    imageViewRect.size.height -= 8.0;
    imageViewRect.size.width  -= 8.0;
    self.imageView.frame = imageViewRect;
    
    CGRect labelRect = imageViewRect;
    labelRect.origin.y = imageViewRect.origin.y + imageViewRect.size.height;
    labelRect.size.height = 18.0;
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

@end
