//
//  ViewController.m
//  FoundationTest
//
//  Created by appleDeveloper on 16/3/23.
//  Copyright © 2016年 appleDeveloper. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self kvcTest];
    
    [self loadImageTest];
}

- (void)kvcTest
{
    Person *p1 = [[Person alloc] init];
    p1.name = @"long";
    p1.age = @"26";
    
    Person *p2 = [[Person alloc] init];
    p2.age = @"27";
    p2.name = @"hong";
    
    Person *p3 = [[Person alloc] init];
    p3.age = @"28";
    p3.name = @"wei";
    
    NSArray <Person *>*list = @[p1,p2,p3];
    
    NSLog(@"max ===%@",[list valueForKeyPath:@"@max.age"]);
    
    NSLog(@"index ===%d",[[list valueForKeyPath:@"name"] indexOfObject:@"wei"]);
    
}

- (void)loadImageTest
{
 
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
