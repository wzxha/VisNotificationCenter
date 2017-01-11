//
//  NSNotificationCenter+visNotificationCenter.m
//  visNotification
//
//  Created by WzxJiang on 16/10/27.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import "NSNotificationCenter+VisNotificationCenter.h"

@implementation NSNotificationCenter (visNotificationCenter)

+ (NSNotificationCenter *)vis_defaultCenter {
    return [VisNotificationCenter vis_defaultCenter];
}

@end
