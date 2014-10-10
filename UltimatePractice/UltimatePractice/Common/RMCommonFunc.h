//
//  CommonFunc.h
//  UltimatePractice
//
//  Created by Jerry Ray on 10/8/14.
//  Copyright (c) 2014 RayManning. All rights reserved.
//

#define kLongTouchMoveOrRemoveClass @"LongTouchMoveOrRemoveClass"

#import <Foundation/Foundation.h>
#import "RMDynamicClassMod.h"

@interface RMCommonFunc : NSObject

+ (RMCommonFunc *)SharedInstance;

/**
 *  get all dynamic class models
 *
 *  @return NSArray Object
 */
- (NSArray *)allDynamicClasses;

@end
