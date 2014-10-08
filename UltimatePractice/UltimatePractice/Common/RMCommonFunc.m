//
//  CommonFunc.m
//  UltimatePractice
//
//  Created by Jerry on 10/8/14.
//  Copyright (c) 2014 RayManning. All rights reserved.
//

#import "RMCommonFunc.h"

@implementation RMCommonFunc

+ (RMCommonFunc *)SharedInstance {
    static dispatch_once_t onceToken;
    static RMCommonFunc * obj = nil;
    dispatch_once(&onceToken, ^{
        obj = [RMCommonFunc new];
    });
    return obj;
}

- (NSArray *)allDynamicClasses {
    NSMutableArray * muarray = [NSMutableArray array];
    
    RMDynamicClassMod * touchMoveOrRemoveClassMod = [RMDynamicClassMod new];
    touchMoveOrRemoveClassMod.classKey = kLongTouchMoveOrRemoveClass;
    [muarray addObject:touchMoveOrRemoveClassMod];
    
    return [[NSArray alloc] initWithArray:muarray copyItems:YES];
}

@end
