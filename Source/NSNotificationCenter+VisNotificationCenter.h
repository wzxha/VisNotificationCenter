//
//  NSNotificationCenter+_visDelegateNotificationCenter.h
//  _visDelegateNotification
//
//  Created by WzxJiang on 16/10/27.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (VisNotificationCenter)

FOUNDATION_EXTERN NSString * VIS_NOTI_OBSERVER;
FOUNDATION_EXTERN NSString * VIS_NOTI_NAME;
FOUNDATION_EXTERN NSString * VIS_NOTI_OBJECT;
FOUNDATION_EXTERN NSString * VIS_NOTI_SEL;

- (NSDictionary <NSString *, NSArray *> *)vis_allObservers;
- (NSArray <NSDictionary *> *)vis_mapsWithObj:(id)obj;

@end
