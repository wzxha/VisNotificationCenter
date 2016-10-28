//
//  NSNotificationCenter+WDNotificationCenter.h
//  WDNotification
//
//  Created by WzxJiang on 16/10/27.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (WDNotificationCenter)

FOUNDATION_EXTERN NSString * WD_NOTI_OBSERVER;
FOUNDATION_EXTERN NSString * WD_NOTI_NAME;
FOUNDATION_EXTERN NSString * WD_NOTI_OBJECT;
FOUNDATION_EXTERN NSString * WD_NOTI_SEL;

- (NSArray *)allObservers;

@end
