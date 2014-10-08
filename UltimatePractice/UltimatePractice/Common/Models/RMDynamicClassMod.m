//
//  DynamicClassMod.m
//  UltimatePractice
//
//  Created by Jerry on 10/8/14.
//  Copyright (c) 2014 RayManning. All rights reserved.
//

#import "RMDynamicClassMod.h"

@implementation RMDynamicClassMod

- (id)copyWithZone:(NSZone *)zone {
    RMDynamicClassMod * copyObj = [[[self class] alloc] init];
    copyObj.className       = [self.className copy];
    copyObj.classKey        = [self.classKey copy];
    copyObj.keyWords4Search = [self.keyWords4Search copy];
    return copyObj;
}

@end
