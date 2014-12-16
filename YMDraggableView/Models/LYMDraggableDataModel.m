//
//  LYMDraggableDataModel.m
//  YMDraggableView
//
//  Created by Lei Yiming on 12/9/14.
//  Copyright (c) 2014 雷一鸣. All rights reserved.
//

#import "LYMDraggableDataModel.h"

@implementation LYMDraggableDataModel

- (NSString *)description {
    return [NSString stringWithFormat:@"{title:%@, imageFilePath:%@}", self.title, self.imageFilePath];
}

@end
