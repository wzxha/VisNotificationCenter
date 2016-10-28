//
//  ViewController.m
//  Example
//
//  Created by WzxJiang on 16/10/28.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import "ViewController.h"
#import "NSNotificationCenter+WDNotificationCenter.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(test) name:nil object:@"1"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(test) name:@"2" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(test) name:@"2" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(test) name:@"2" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(test) name:@"2" object:nil];
    NSLog(@"%@", [NSNotificationCenter defaultCenter].allObservers);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
