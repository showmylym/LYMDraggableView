//
//  RMDraggableViewCell.m
//  UltimatePractice
//
//  Created by Jerry Ray on 10/9/14.
//  Copyright (c) 2014 RayManning. All rights reserved.
//

#import "RMDraggableViewCell.h"
#import "RMDraggableView.h"
#import "RMCommonFunc.h"



@interface RMDraggableViewCell ()


//Gesture
@property (nonatomic, retain) UITapGestureRecognizer * tapGesture;
@property (nonatomic, retain) UILongPressGestureRecognizer * longPressGesture;

//Controls in content view
@property (nonatomic, retain, readwrite) UIView * contentView;
@property (nonatomic, retain, readwrite) UIImageView * imageView;
@property (nonatomic, retain, readwrite) UILabel * textLabel;
@property (nonatomic, retain, readwrite) UIButton * cornerBtn;

//Store data
@property (nonatomic, assign) CGFloat screenZoomingFactor;
@property (nonatomic, assign) CGPoint beginningPoint;
@property (nonatomic, assign) CGPoint beginningCenter;

@end

@implementation RMDraggableViewCell

- (instancetype)initWithStyle:(RMDraggableViewCellType)cellType cornerBtnStyleWhenShaking:(RMDraggableViewCellCornerBtnStyle)cornerBtnStyle {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.canEdit = YES;
        self.canShake = YES;
        self.canMove = YES;
        self.isEditing = NO;
        self.isShaking = NO;
        
        self.frame = CGRectMake(0.0, 0.0, 50.0, 80.0);
        
        //cell content view
        self.contentView = [[UIView alloc] initWithFrame:self.frame];
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.contentView];
        
        //control in content view
        self.imageView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
        [self.contentView addSubview:self.imageView];
        
        self.textLabel = [[UILabel alloc] initWithFrame:self.contentView.frame];
        self.textLabel.font = [UIFont systemFontOfSize:12.0];
        self.textLabel.textColor = [UIColor colorWithRed:166.0/255.0 green:166.0/255.0 blue:166.0/255.0 alpha:1.0];
        if ([[RMCommonFunc SharedInstance] systemVersionValue] < 6.0) {
            self.textLabel.textAlignment = UITextAlignmentCenter;
            self.textLabel.lineBreakMode = UILineBreakModeClip;
        } else {
            self.textLabel.textAlignment = NSTextAlignmentCenter;
            self.textLabel.lineBreakMode = NSLineBreakByClipping;
        }
        [self.contentView addSubview:self.textLabel];
        
        self.cornerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cornerBtn addTarget:self action:@selector(cornerBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.cornerBtn setBackgroundImage:[UIImage imageNamed:@"dragviewcellcornerdel@3x"] forState:UIControlStateNormal];
        self.cornerBtn.hidden = YES;
        [self.contentView addSubview:self.cornerBtn];
        
        self.cornerBtnStyle = cornerBtnStyle;
        
        //Gesture
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureTriggered:)];
        [self addGestureRecognizer:self.tapGesture];
        
        self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureTriggered:)];
        self.longPressGesture.minimumPressDuration = 0.5;
        [self addGestureRecognizer:self.longPressGesture];
        
        //data
        //cal scaled space, to adapt screen after iPhone 6
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        self.screenZoomingFactor = screenSize.width / 320.0;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self changeControlsFrameWithNewCellFrame:self.frame];
}


#pragma mark - public methods
- (void)startShaking {
    if (self.canEdit) {
        self.cornerBtn.hidden = NO;
    }
    if (self.canShake) {
        [self.layer removeAllAnimations];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CAKeyframeAnimation * shakingAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            NSValue * value1 = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, DegreesToRadians(3.0), 0.0, 0.0, 1.0)];
            NSValue * value2 = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, - DegreesToRadians(3.0), 0.0, 0.0, 1.0)];
            NSValue * value3 = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, DegreesToRadians(3.0), 0.0, 0.0, 1.0)];
            shakingAnimation.values = @[value1, value2, value3];
            shakingAnimation.duration = 0.2;
            shakingAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            shakingAnimation.repeatCount = INFINITY;
            [self.layer addAnimation:shakingAnimation forKey:@"shaking"];
            self.isShaking = YES;
        });
    }
    
    
}

- (void)endShaking {
    self.isShaking = NO;
    self.cornerBtn.hidden = YES;
    [self.layer removeAllAnimations];
    
}

#pragma mark - Private methods
- (void)changeControlsFrameWithNewCellFrame:(CGRect)rect {
    CGFloat margin = 0.0;
    CGFloat vSpace = 4.0;
    
    CGRect imageViewRect = rect;
    imageViewRect.origin.x = margin;
    imageViewRect.origin.y = margin;
    imageViewRect.size.width  -= margin * 2;
    imageViewRect.size.height = imageViewRect.size.width;
    self.imageView.frame = imageViewRect;
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2.0;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.shouldRasterize = YES;
    self.imageView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    CGRect labelFrame = imageViewRect;
    labelFrame.origin.y += imageViewRect.origin.y + imageViewRect.size.height + vSpace;
    labelFrame.size.height = 18.0;
    self.textLabel.frame = labelFrame;
    
    CGRect cornerBtnFrame;
    if (self.delegate && [self.delegate respondsToSelector:@selector(draggableViewCell:cornerBtnSizeWithIndexPath:)]) {
        cornerBtnFrame.size = [self.delegate draggableViewCell:self cornerBtnSizeWithIndexPath:self.indexPath];
    }
    cornerBtnFrame.origin.x = rect.size.width - cornerBtnFrame.size.width * 2.0 / 3.0;
    cornerBtnFrame.origin.y = 0.0;
    self.cornerBtn.frame = cornerBtnFrame;
    
}

- (void)tapGestureTriggered:(UITapGestureRecognizer *)gesture {
    if (self.delegate && [self.delegate respondsToSelector:@selector(draggableViewCell:tappedWithIndexPath:)]) {
        [self.delegate draggableViewCell:self tappedWithIndexPath:self.indexPath];
    }
}

- (void)longPressGestureTriggered:(UILongPressGestureRecognizer *)gesture {
    if (self.canMove == NO || self.canEdit == NO) {
        return ;
    }
    CGFloat cellEditingScaleFactor = 1.0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(draggableViewCell:cellEditingScaleFactor:)]) {
        cellEditingScaleFactor = [self.delegate draggableViewCell:self cellEditingScaleFactor:self.indexPath];
    }
    
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
            scaleUpRect.size.width *= cellEditingScaleFactor * self.screenZoomingFactor;
            scaleUpRect.size.height *= cellEditingScaleFactor * self.screenZoomingFactor;
            self.frame = scaleUpRect;
            self.center = center;
            [self changeControlsFrameWithNewCellFrame:self.frame];
            
        } break;
        case UIGestureRecognizerStateChanged: {
            CGPoint currentPoint = [gesture locationInView:self.superview];
            CGFloat xMove = currentPoint.x - self.beginningPoint.x;
            CGFloat yMove = currentPoint.y - self.beginningPoint.y;
            self.center = CGPointMake(self.beginningCenter.x + xMove, self.beginningCenter.y + yMove);
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(draggableViewCell:longPressedDidMoveWithIndexPath:)]) {
                [self.delegate draggableViewCell:self longPressedDidMoveWithIndexPath:self.indexPath];
            }
            
        } break;
        case UIGestureRecognizerStateEnded: {
            CGPoint endPoint = self.center;
            CGRect scaleDownRect = self.frame;
            scaleDownRect.size.width /= cellEditingScaleFactor * self.screenZoomingFactor;
            scaleDownRect.size.height /= cellEditingScaleFactor * self.screenZoomingFactor;
            self.frame = scaleDownRect;
            self.center = endPoint;
            [self changeControlsFrameWithNewCellFrame:self.frame];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(draggableViewCell:longPressedEndWithIndexPath:)]) {
                [self.delegate draggableViewCell:self longPressedEndWithIndexPath:self.indexPath];
            }
            
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
