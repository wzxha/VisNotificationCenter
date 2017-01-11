//
//  ViewController.m
//  Example
//
//  Created by WzxJiang on 17/1/11.
//  Copyright © 2017年 wzxjiang. All rights reserved.
//

#import "ViewController.h"
#import "NSNotificationCenter+VisNotificationCenter.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat time = CACurrentMediaTime();
    for (int i = 0; i < 10000; i++) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(test) name:@"test" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"test" object:nil];
        NSLog(@"%@", [[NSNotificationCenter defaultCenter] vis_mapsWithObject:self]);
    }
    NSLog(@"%f", CACurrentMediaTime() - time);
}

- (void)test {
    //
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
