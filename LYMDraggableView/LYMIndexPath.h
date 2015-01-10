//
//  RMIndexPath.h
//  UltimatePractice
//
//  Created by Jerry Ray on 10/13/14.
//  Copyright (c) 2014 雷一鸣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYMIndexPath : NSObject <NSCopying>

@property (nonatomic, assign) NSUInteger row;
@property (nonatomic, assign) NSUInteger column;

+ (instancetype)IndexPathWithRow:(NSUInteger)row column:(NSUInteger)column;
- (BOOL)isEqual:(LYMIndexPath *)object;

@end
