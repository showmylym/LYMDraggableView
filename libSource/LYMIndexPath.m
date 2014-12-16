//
//  RMIndexPath.m
//  UltimatePractice
//
//  Created by Lei Yiming on 10/13/14.
//  Copyright (c) 2014 雷一鸣. All rights reserved.
//

#import "LYMIndexPath.h"


@implementation LYMIndexPath


+ (instancetype)IndexPathWithRow:(NSUInteger)row column:(NSUInteger)column {
    LYMIndexPath * indexPath = [[LYMIndexPath alloc] init];
    indexPath.row = row;
    indexPath.column = column;
    return indexPath;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"row (%ld), column (%ld).", (long)self.row, (long)self.column];
}

- (id)copyWithZone:(NSZone *)zone {
    LYMIndexPath * copy = [[self class] IndexPathWithRow:self.row column:self.column];
    return copy;
}

- (BOOL)isEqual:(LYMIndexPath *)object {
    BOOL isEqual = NO;
    if (self.row == object.row && self.column == object.column) {
        isEqual = YES;
    }
    return isEqual;
}

@end
