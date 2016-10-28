//
//  NSNotificationCenter+WDNotificationCenter.m
//  WDNotification
//
//  Created by WzxJiang on 16/10/27.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import "NSNotificationCenter+WDNotificationCenter.h"
#import <objc/runtime.h>

@interface NSNotificationCenter()

@property(nonatomic, copy)NSArray * wd_maps;

@end

@implementation NSNotificationCenter (WDNotificationCenter)

static NSString * wd_maps_key      = @"wd_maps_key";

const NSString * WD_NOTI_OBSERVER = @"Observer";
const NSString * WD_NOTI_NAME     = @"Name";
const NSString * WD_NOTI_OBJECT   = @"Object";
const NSString * WD_NOTI_SEL      = @"SEL";

- (void)setWd_maps:(NSMutableArray *)wd_maps {
    objc_setAssociatedObject(self, &wd_maps_key, wd_maps, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSMutableArray *)wd_maps {
    return objc_getAssociatedObject(self, &wd_maps_key);;
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self wd_exchangeSEL:@selector(addObserverForName:object:queue:usingBlock:) swizzledSEL:@selector(wd_addObserverForName:object:queue:usingBlock:)];
        [self wd_exchangeSEL:@selector(addObserver:selector:name:object:) swizzledSEL:@selector(wd_addObserver:selector:name:object:)];
        [self wd_exchangeSEL:@selector(removeObserver:name:object:) swizzledSEL:@selector(wd_removeObserver:name:object:)];
    });
}

+ (void)wd_exchangeSEL:(SEL)originalSEL swizzledSEL:(SEL)swizzledSEL {
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

- (void)wd_addObserver:(id)observer selector:(SEL)aSelector name:(NSNotificationName)aName object:(id)anObject {
    NSDictionary * currentNotiDic = [self wd_mapsWithObserver:observer selector:NSStringFromSelector(aSelector) name:aName object:anObject];
    if (![self.wd_maps containsObject:currentNotiDic]) {
        // 未存在该通知则添加
        [self wd_addObserver:observer selector:aSelector name:aName object:anObject];
        NSMutableArray * maps = [NSMutableArray arrayWithArray:self.wd_maps];
        [maps addObject:currentNotiDic];
        self.wd_maps = [maps copy];
    }
}

- (id<NSObject>)wd_addObserverForName:(NSNotificationName)name object:(id)obj queue:(NSOperationQueue *)queue usingBlock:(void (^)(NSNotification * _Nonnull))block {
    id observer = [self wd_addObserverForName:name object:obj queue:queue usingBlock:block];
    NSDictionary * currentNotiDic = [self wd_mapsWithObserver:observer selector:block name:name object:obj];
    if (![self.wd_maps containsObject:currentNotiDic]) {
        NSMutableArray * maps = [NSMutableArray arrayWithArray:self.wd_maps];
        [maps addObject:currentNotiDic];
        self.wd_maps = [maps copy];
    } else {
        [self removeObserver:observer name:name object:obj];
        [self wd_addObserverForName:name object:obj queue:queue usingBlock:block];
    }
    return observer;
}

- (void)wd_removeObserver:(id)observer name:(NSNotificationName)aName object:(id)anObject {
    [self wd_removeObserver:observer name:aName object:anObject];
    [self wd_removeMapsWithObserver:observer name:aName object:anObject];
}

- (NSDictionary *)wd_mapsWithObserver:(id)observer selector:(id)aSelector name:(NSNotificationName)aName object:(id)anObject {
    NSMutableDictionary * notiDic = [NSMutableDictionary dictionary];
    [notiDic setValue:observer forKey:(NSString *)WD_NOTI_OBSERVER];
    [notiDic setValue:aSelector forKey:(NSString *)WD_NOTI_SEL];
    [notiDic setValue:aName forKey:(NSString *)WD_NOTI_NAME];
    [notiDic setValue:anObject forKey:(NSString *)WD_NOTI_OBJECT];
    return notiDic;
}

- (void)wd_removeMapsWithObserver:(id)observer name:(NSNotificationName)aName object:(id)anObject {
    NSMutableArray * dics = [NSMutableArray array];
    
    if (aName) {
        [dics addObject:@{@"key": WD_NOTI_NAME,
                          @"value": aName}];
    }
    
    if (anObject) {
        [dics addObject:@{@"key": WD_NOTI_OBJECT,
                          @"value": anObject}];
    }
    
    NSMutableArray * maps = [NSMutableArray arrayWithArray:self.wd_maps];
    NSMutableArray * removeMaps = [NSMutableArray array];
    for (NSDictionary * map in maps) {
        if (![observer isEqual: map[WD_NOTI_OBSERVER]]) {
            continue;
        }
        
        BOOL isMatch = YES;
        for (NSDictionary * dic in dics) {
            if (![map[dic[@"key"]] isEqual:dic[@"value"]]) {
                isMatch = NO;
                continue;
            }
        }
        
        if (isMatch) {
            [removeMaps addObject:map];
        }
    }
    [maps removeObjectsInArray:removeMaps];
    self.wd_maps = [maps copy];
}

- (NSArray *)allObservers {
    return self.wd_maps;
}
@end
