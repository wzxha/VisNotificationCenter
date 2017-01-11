//
//  VisNotificationCenter.h
//  Example
//
//  Created by WzxJiang on 17/1/11.
//  Copyright © 2017年 wzxjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * VIS_NOTI_OBSERVER;
extern NSString * VIS_NOTI_NAME;
extern NSString * VIS_NOTI_OBJECT;
extern NSString * VIS_NOTI_SEL;

@interface VisNotificationCenter : NSNotificationCenter

+ (NSNotificationCenter *)vis_defaultCenter;

- (NSDictionary <NSString *, NSArray *> *)vis_allObservers;
- (NSArray <NSDictionary *> *)vis_mapsWithObject:(id)obj;

@end
