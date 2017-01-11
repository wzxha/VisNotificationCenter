//
//  NSNotificationCenter+visNotificationCenter.m
//  visNotification
//
//  Created by WzxJiang on 16/10/27.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import "NSNotificationCenter+VisNotificationCenter.h"

@implementation NSNotificationCenter (visNotificationCenter)

+ (VisNotificationCenter *)defaultCenter {
    return [VisNotificationCenter vis_defaultCenter];
}

- (NSDictionary <NSString *, NSArray *> *)vis_allObservers {
    return [[[self class] defaultCenter] vis_allObservers];
}

- (NSArray <NSDictionary *> *)vis_mapsWithObject:(id)obj {
    return [[[self class] defaultCenter] vis_mapsWithObject: obj];
}

@end
