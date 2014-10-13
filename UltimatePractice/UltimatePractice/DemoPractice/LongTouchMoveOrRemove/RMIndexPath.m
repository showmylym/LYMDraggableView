//
//  RMIndexPath.m
//  UltimatePractice
//
//  Created by Jerry Ray on 10/13/14.
//  Copyright (c) 2014 RayManning. All rights reserved.
//

#import "RMIndexPath.h"


@implementation RMIndexPath


+ (instancetype)IndexPathWithRow:(NSUInteger)row column:(NSUInteger)column {
    RMIndexPath * indexPath = [[RMIndexPath alloc] init];
    indexPath.row = row;
    indexPath.column = column;
    return indexPath;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"row (%ld), column (%ld).", (long)self.row, (long)self.column];
}

- (id)copyWithZone:(NSZone *)zone {
    RMIndexPath * copy = [[self class] IndexPathWithRow:self.row column:self.column];
    return copy;
}

- (BOOL)isEqual:(RMIndexPath *)object {
    BOOL isEqual = NO;
    if (self.row == object.row && self.column == object.column) {
        isEqual = YES;
    }
    return isEqual;
}

@end
