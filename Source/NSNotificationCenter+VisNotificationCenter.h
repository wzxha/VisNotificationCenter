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

+ (VisNotificationCenter *)vis_defaultCenter;

@end
