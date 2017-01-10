//
//  NSNotificationCenter+visNotificationCenter.m
//  visNotification
//
//  Created by WzxJiang on 16/10/27.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import "NSNotificationCenter+VisNotificationCenter.h"
#import <objc/runtime.h>

@interface NSNotificationCenter()

@property(nonatomic, copy)NSDictionary * vis_mappingTable;

@end

@implementation NSNotificationCenter (visNotificationCenter)

static NSString * VIS_MAPS_KEY      = @"VIS_MAPS_KEY";

const NSString * VIS_NOTI_OBSERVER = @"Observer";
const NSString * VIS_NOTI_NAME     = @"Name";
const NSString * VIS_NOTI_OBJECT   = @"Object";
const NSString * VIS_NOTI_SEL      = @"SEL";

- (void)setVis_mappingTable:(NSDictionary *)vis_mappingTable {
    objc_setAssociatedObject(self, &VIS_MAPS_KEY, vis_mappingTable, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSArray *)vis_mappingTable {
    return objc_getAssociatedObject(self, &VIS_MAPS_KEY);
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self vis_exchangeSEL:@selector(addObserverForName:object:queue:usingBlock:) swizzledSEL:@selector(vis_addObserverForName:object:queue:usingBlock:)];
        [self vis_exchangeSEL:@selector(addObserver:selector:name:object:) swizzledSEL:@selector(vis_addObserver:selector:name:object:)];
        [self vis_exchangeSEL:@selector(removeObserver:name:object:) swizzledSEL:@selector(vis_removeObserver:name:object:)];
    });
}

+ (void)vis_exchangeSEL:(SEL)originalSEL swizzledSEL:(SEL)swizzledSEL {
    Method original_method = class_getInstanceMethod(self, originalSEL);
    Method swizzled_method = class_getInstanceMethod(self, swizzledSEL);
    
    BOOL isAdd =
    class_addMethod(self, originalSEL, method_getImplementation(swizzled_method), method_getTypeEncoding(swizzled_method));
    
    if (isAdd) {
        class_replaceMethod(self, swizzledSEL, method_getImplementation(original_method), method_getTypeEncoding(original_method));
    } else {
        method_exchangeImplementations(original_method, swizzled_method);
    }
}

- (void)vis_addObserver:(id)observer selector:(SEL)aSelector name:(NSNotificationName)aName object:(id)anObject {
    NSString * observerPath = [NSString stringWithFormat:@"%p", observer];
    
    NSDictionary * currentNotifucationDictionary = [self vis_notificationDictionaryWithObserver:observer selector:NSStringFromSelector(aSelector) name:aName object:anObject];
    
    NSMutableArray * maps = [NSMutableArray arrayWithArray:self.vis_mappingTable[observerPath]];
    
    if (![maps containsObject:currentNotifucationDictionary]) {
        [self vis_addObserver:observer selector:aSelector name:aName object:anObject];
        [maps addObject:currentNotifucationDictionary];
        
        NSMutableDictionary * newMappingTable = [NSMutableDictionary dictionaryWithDictionary:self.vis_mappingTable];
        [newMappingTable setObject:maps forKey:observerPath];
        
        self.vis_mappingTable = [newMappingTable copy];
    }
}

- (id<NSObject>)vis_addObserverForName:(NSNotificationName)name object:(id)obj queue:(NSOperationQueue *)queue usingBlock:(void (^)(NSNotification * _Nonnull))block {
    id observer = [self vis_addObserverForName:name object:obj queue:queue usingBlock:block];
    
    NSString * observerPath = [NSString stringWithFormat:@"%p", observer];
    
    NSDictionary * currentNotifucationDictionary = [self vis_notificationDictionaryWithObserver:observer selector:block name:name object:obj];
    
    NSMutableArray * maps = [NSMutableArray arrayWithArray:self.vis_mappingTable[observerPath]];
    
    if (![maps containsObject:currentNotifucationDictionary]) {
        [maps addObject:currentNotifucationDictionary];
        
        NSMutableDictionary * newMappingTable = [NSMutableDictionary dictionaryWithDictionary:self.vis_mappingTable];
        [newMappingTable setObject:maps forKey:observerPath];
        
        self.vis_mappingTable = [newMappingTable copy];
    } else {
        [self removeObserver:observer name:name object:obj];
        [self vis_addObserverForName:name object:obj queue:queue usingBlock:block];
    }
    return observer;
}

- (void)vis_removeObserver:(id)observer name:(NSNotificationName)aName object:(id)anObject {
    [self vis_removeObserver:observer name:aName object:anObject];
    [self vis_removeMapsWithObserver:observer name:aName object:anObject];
}

- (NSDictionary *)vis_notificationDictionaryWithObserver:(id)observer selector:(id)aSelector name:(NSNotificationName)aName object:(id)anObject {
    NSMutableDictionary * notificationDictionary = [NSMutableDictionary dictionary];
    [notificationDictionary setValue:observer? observer: @""   forKey:(NSString *)VIS_NOTI_OBSERVER];
    [notificationDictionary setValue:aSelector? aSelector: @"" forKey:(NSString *)VIS_NOTI_SEL];
    [notificationDictionary setValue:aName? aName: @""         forKey:(NSString *)VIS_NOTI_NAME];
    [notificationDictionary setValue:anObject? anObject: @""   forKey:(NSString *)VIS_NOTI_OBJECT];
    return notificationDictionary;
}

- (void)vis_removeMapsWithObserver:(id)observer name:(NSNotificationName)aName object:(id)anObject {
    if (!observer) {
        return;
    }
    
    NSString * observerPath = [NSString stringWithFormat:@"%p", observer];
    
    if (![self.vis_mappingTable.allKeys containsObject:observerPath]) {
        return;
    }
    
    NSMutableArray * maps = [NSMutableArray arrayWithArray:self.vis_mappingTable[observerPath]];

    NSDictionary * currentNotifucationDictionary =
    [self vis_notificationDictionaryWithObserver:observer selector:@"" name:aName object:anObject];
    
    NSMutableArray * removeMaps = [NSMutableArray array];
    
    for (NSDictionary * map in maps) {
        if ([map isEqual:currentNotifucationDictionary]) {
            [removeMaps addObject:map];
        }
    }
    
    [maps removeObjectsInArray:removeMaps];
    
    NSMutableDictionary * newMappingTable =
    [NSMutableDictionary dictionaryWithDictionary:self.vis_mappingTable];
    [newMappingTable setObject:maps forKey:observerPath];
    
    self.vis_mappingTable = [newMappingTable copy];
}

- (NSDictionary <NSString *, NSArray *> *)vis_allObservers {
    return self.vis_mappingTable;
}

- (NSArray <NSDictionary *> *)vis_mapsWithObj:(id)obj {
    return self.vis_mappingTable[[NSString stringWithFormat:@"%p", obj]];
}

@end
