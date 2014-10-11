//
//  RMDraggableViewCell.m
//  UltimatePractice
//
//  Created by Jerry Ray on 10/9/14.
//  Copyright (c) 2014 RayManning. All rights reserved.
//

#import "RMDraggableViewCell.h"
#import "RMDraggableView.h"


#define ZoomFactor_Based320Width      1.5



@interface RMDraggableViewCell ()

@property (nonatomic) RMDraggableViewCellCornerBtnStyle cornerBtnStyle;

//Gesture
@property (nonatomic, retain) UITapGestureRecognizer * tapGesture;
@property (nonatomic, retain) UILongPressGestureRecognizer * longPressGesture;

//Controls in content view
@property (nonatomic, retain, readwrite) UIImageView * imageView;
@property (nonatomic, retain, readwrite) UILabel * textLabel;
@property (nonatomic, retain, readwrite) UIButton * cornerBtn;

//Store data
@property (nonatomic, assign) CGFloat editingZoomFactor;
@property (nonatomic, assign) CGPoint beginningPoint;
@property (nonatomic, assign) CGPoint beginningCenter;

@end

@implementation RMDraggableViewCell

- (instancetype)initWithStyle:(RMDraggableViewCellType)cellType {
    self = [super init];
    if (self) {
        //cell content view
        self.contentView = [[UIView alloc] init];
        self.contentView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1.0];
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.contentView];
        
        //control in content view
        self.imageView = [[UIImageView alloc] init];
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:self.imageView];
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.text = @"test";
        self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:self.textLabel];
        
        self.cornerBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [self.cornerBtn addTarget:self action:@selector(cornerBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.cornerBtn.hidden = YES;
        [self.contentView addSubview:self.cornerBtn];
        
        //Gesture
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureTriggered:)];
        [self addGestureRecognizer:self.tapGesture];
        
        self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureTriggered:)];
        self.longPressGesture.minimumPressDuration = 0.5;
        [self addGestureRecognizer:self.longPressGesture];
        
        //data
        //cal scaled space, to adapt screen after iPhone 6
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat scaleFactor = screenSize.width / 320.0;
        self.editingZoomFactor = ZoomFactor_Based320Width * scaleFactor;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    NSLog(@"%@ drawRect, view frame:%@", NSStringFromClass([self class]), NSStringFromCGRect(self.frame));
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
    
    CGRect cornerBtnFrame;
    cornerBtnFrame.size.width = 10.0;
    cornerBtnFrame.size.height = 10.0;
    cornerBtnFrame.origin.x = rect.size.width - cornerBtnFrame.size.width;
    cornerBtnFrame.origin.y = 0.0;
    self.cornerBtn.frame = cornerBtnFrame;
    
}


#pragma mark - public methods
- (void)startShakingWithCornerBtnStyle:(RMDraggableViewCellCornerBtnStyle)btnStyle {
    self.cornerBtnStyle = btnStyle;
    self.cornerBtn.hidden = NO;
    self.isShaking = YES;
}

- (void)endShaking {
    self.isShaking = NO;
    self.cornerBtn.hidden = YES;
}

#pragma mark - Private methods
- (void)tapGestureTriggered:(UITapGestureRecognizer *)gesture {
    NSLog(@"tap row(%ld) column(%ld) cell once",  (long)self.indexPath.row, (long)self.indexPath.column);
    if (self.delegate && [self.delegate respondsToSelector:@selector(draggableViewCell:tappedWithIndexPath:)]) {
        [self.delegate draggableViewCell:self tappedWithIndexPath:self.indexPath];
    }
}

- (void)longPressGestureTriggered:(UILongPressGestureRecognizer *)gesture {
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            if (self.delegate && [self.delegate respondsToSelector:@selector(draggableViewCell:longPressedBeginWithIndexPath:)]) {
                [self.delegate draggableViewCell:self longPressedBeginWithIndexPath:self.indexPath];
            }
            [self.superview bringSubviewToFront:self];
            //store beginning location
            self.beginningPoint = [gesture locationInView:self.superview];
            self.beginningCenter = self.center;
            //scale up and reset center
            CGPoint center = self.center;
            CGRect scaleUpRect = self.frame;
            scaleUpRect.size.width *= self.editingZoomFactor;
            scaleUpRect.size.height *= self.editingZoomFactor;
            self.frame = scaleUpRect;
            self.center = center;
        } break;
        case UIGestureRecognizerStateChanged: {
            if (self.delegate && [self.delegate respondsToSelector:@selector(draggableViewCell:longPressedDidMoveWithIndexPath:)]) {
                [self.delegate draggableViewCell:self longPressedDidMoveWithIndexPath:self.indexPath];
            }
            CGPoint currentPoint = [gesture locationInView:self.superview];
            CGFloat xMove = currentPoint.x - self.beginningPoint.x;
            CGFloat yMove = currentPoint.y - self.beginningPoint.y;
            
            self.center = CGPointMake(self.beginningCenter.x + xMove, self.beginningCenter.y + yMove);
        } break;
        case UIGestureRecognizerStateEnded: {
            if (self.delegate && [self.delegate respondsToSelector:@selector(draggableViewCell:longPressedEndWithIndexPath:)]) {
                [self.delegate draggableViewCell:self longPressedEndWithIndexPath:self.indexPath];
            }
            
            CGPoint endPoint = self.center;
            CGRect scaleDownRect = self.frame;
            scaleDownRect.size.width /= self.editingZoomFactor;
            scaleDownRect.size.height /= self.editingZoomFactor;
            self.frame = scaleDownRect;
            self.center = endPoint;

        } break;
            
        default:
            break;
    }
}

- (void)cornerBtnPressed:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(draggableViewCell:cornerBtnPressedWithIndexPath:)]) {
        [self.delegate draggableViewCell:self cornerBtnPressedWithIndexPath:self.indexPath];
    }
}

@end
