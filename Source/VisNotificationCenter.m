//
//  VisNotificationCenter.m
//  Example
//
//  Created by WzxJiang on 17/1/11.
//  Copyright © 2017年 wzxjiang. All rights reserved.
//

#import "VisNotificationCenter.h"

@interface VisNotificationCenter()

@property(nonatomic, strong)NSMutableDictionary * vis_mappingTable;

@end

@implementation VisNotificationCenter

const NSString * VIS_NOTI_OBSERVER = @"Observer";
const NSString * VIS_NOTI_NAME     = @"Name";
const NSString * VIS_NOTI_OBJECT   = @"Object";
const NSString * VIS_NOTI_SEL      = @"SEL";

+ (NSNotificationCenter *)vis_defaultCenter {
    static VisNotificationCenter * vis_defaultCenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        vis_defaultCenter = [VisNotificationCenter new];
    });
    return vis_defaultCenter;
}

- (instancetype)init {
    if (self = [super init]) {
        _vis_mappingTable = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)addObserver:(id)observer selector:(SEL)aSelector name:(NSNotificationName)aName object:(id)anObject {
    NSString * observerPath = [NSString stringWithFormat:@"%p", observer];
    
    NSDictionary * currentNotifucationDictionary =
    [self vis_notificationDictionaryWithObserver:observer
                                        selector:NSStringFromSelector(aSelector)
                                            name:aName
                                          object:anObject];
    
    NSMutableArray * maps = [NSMutableArray arrayWithArray:_vis_mappingTable[observerPath]];
    
    if (![maps containsObject:currentNotifucationDictionary]) {
        [maps addObject:currentNotifucationDictionary];
        
        [_vis_mappingTable setObject:maps forKey:observerPath];
        
        [super addObserver:observer selector:aSelector name:aName object:anObject];
    }
}

- (void)removeObserver:(id)observer name:(NSNotificationName)aName object:(id)anObject {
    NSString * observerPath = [NSString stringWithFormat:@"%p", observer];
    
    NSMutableArray * maps = [NSMutableArray arrayWithArray:_vis_mappingTable[observerPath]];
    if (maps.count == 0) {
        return;
    }
    
    if (!aName) {
        [_vis_mappingTable removeObjectForKey:observerPath];
    } else {
        NSMutableArray * removeMaps = [NSMutableArray array];
        for (NSDictionary * map in maps) {
            if (![map[VIS_NOTI_NAME] isEqualToString:aName]) {
                continue;
            }
            
            if ([map[VIS_NOTI_OBJECT] isEqual:(anObject? anObject: @"")]) {
                [removeMaps addObject:map];
            }
        }
        [maps removeObjectsInArray:removeMaps];
        if (maps.count > 0) {
            [_vis_mappingTable setObject:maps forKey:observerPath];
        } else {
            [_vis_mappingTable removeObjectForKey:observerPath];
        }
    }
    
    [super removeObserver:observer name:aName object:anObject];
}

- (NSDictionary *)vis_notificationDictionaryWithObserver:(id)observer selector:(id)aSelector name:(NSNotificationName)aName object:(id)anObject {
    NSMutableDictionary * notificationDictionary = [NSMutableDictionary dictionary];
    [notificationDictionary setValue:observer forKey:(NSString *)VIS_NOTI_OBSERVER];
    [notificationDictionary setValue:aSelector forKey:(NSString *)VIS_NOTI_SEL];
    [notificationDictionary setValue:aName forKey:(NSString *)VIS_NOTI_NAME];
    [notificationDictionary setValue:anObject? anObject: @"" forKey:(NSString *)VIS_NOTI_OBJECT];
    return notificationDictionary;
}

- (NSDictionary <NSString *, NSArray *> *)vis_allObservers {
    return _vis_mappingTable;
}

- (NSArray <NSDictionary *> *)vis_mapsWithObject:(id)obj {
    return _vis_mappingTable[[NSString stringWithFormat:@"%p", obj]];
}

@end
