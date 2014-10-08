//
//  DynamicClassMod.h
//  UltimatePractice
//
//  Created by Jerry on 10/8/14.
//  Copyright (c) 2014 RayManning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMDynamicClassMod : NSObject
<NSCopying>

@property (nonatomic, retain) NSString * className;
@property (nonatomic, retain) NSString * classKey;
@property (nonatomic, retain) NSString * keyWords4Search;

@end
