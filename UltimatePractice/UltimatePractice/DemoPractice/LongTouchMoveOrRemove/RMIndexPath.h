//
//  RMIndexPath.h
//  UltimatePractice
//
//  Created by Jerry Ray on 10/13/14.
//  Copyright (c) 2014 RayManning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMIndexPath : NSObject <NSCopying>

@property (nonatomic, assign) NSUInteger row;
@property (nonatomic, assign) NSUInteger column;

+ (instancetype)IndexPathWithRow:(NSUInteger)row column:(NSUInteger)column;
- (BOOL)isEqual:(RMIndexPath *)object;

@end
