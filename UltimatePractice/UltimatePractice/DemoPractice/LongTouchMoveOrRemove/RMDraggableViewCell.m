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

- (instancetype)initWithStyle:(RMDraggableViewCellType)cellType cornerBtnStyleWhenShaking:(RMDraggableViewCellCornerBtnStyle)cornerBtnStyle {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        //cell content view
        self.contentView = [[UIView alloc] init];
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
        
        self.cornerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cornerBtn addTarget:self action:@selector(cornerBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.cornerBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
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
    imageViewRect.size.height = imageViewRect.size.width;
    self.imageView.frame = imageViewRect;
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2.0;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.shouldRasterize = YES;
    self.imageView.layer.rasterizationScale = [[UIScreen mainScreen] scale];

    
    CGRect labelRect = imageViewRect;
    labelRect.origin.y = imageViewRect.origin.y + imageViewRect.size.height + vSpace;
    labelRect.size.height = textLabelHeight;
    self.textLabel.frame = labelRect;
    
    
    CGRect cornerBtnFrame;
    if (self.delegate && [self.delegate respondsToSelector:@selector(draggableViewCell:cornerBtnSizeWithIndexPath:)]) {
        cornerBtnFrame.size = [self.delegate draggableViewCell:self cornerBtnSizeWithIndexPath:self.indexPath];
    }
    cornerBtnFrame.origin.x = rect.size.width - cornerBtnFrame.size.width;
    cornerBtnFrame.origin.y = 0.0;
    self.cornerBtn.frame = cornerBtnFrame;
}


#pragma mark - public methods
- (void)startShaking {
    self.cornerBtn.hidden = NO;
    self.isShaking = YES;
    
    CAKeyframeAnimation * shakingAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    NSValue * value1 = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, DegreesToRadians(3.0), 0.0, 0.0, 1.0)];
    NSValue * value2 = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, - DegreesToRadians(3.0), 0.0, 0.0, 1.0)];
    NSValue * value3 = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, DegreesToRadians(3.0), 0.0, 0.0, 1.0)];
    shakingAnimation.values = @[value1, value2, value3];
    shakingAnimation.duration = 0.2;
    shakingAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    shakingAnimation.repeatCount = INFINITY;

    
    [self.layer addAnimation:shakingAnimation forKey:@"shaking"];
    
}

- (void)endShaking {
    self.isShaking = NO;
    self.cornerBtn.hidden = YES;
    [self.layer removeAllAnimations];

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
            
            self.imageView.layer.cornerRadius = 0.0;
            self.imageView.layer.masksToBounds = YES;
            self.imageView.layer.shouldRasterize = YES;
            self.imageView.layer.rasterizationScale = [[UIScreen mainScreen] scale];

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
            scaleDownRect.size.width /= self.editingZoomFactor;
            scaleDownRect.size.height /= self.editingZoomFactor;
            self.frame = scaleDownRect;
            self.center = endPoint;
            
            self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2.0;
            self.imageView.layer.masksToBounds = YES;
            self.imageView.layer.shouldRasterize = YES;
            self.imageView.layer.rasterizationScale = [[UIScreen mainScreen] scale];

            
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
