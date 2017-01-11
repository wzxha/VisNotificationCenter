//
//  NSNotificationCenter+_visDelegateNotificationCenter.h
//  _visDelegateNotification
//
//  Created by WzxJiang on 16/10/27.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VisNotificationCenter.h"

@interface NSNotificationCenter (VisNotificationCenter)

- (NSDictionary <NSString *, NSArray *> *)vis_allObservers;
- (NSArray <NSDictionary *> *)vis_mapsWithObject:(id)obj;

@end
