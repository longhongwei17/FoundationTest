//
//  People.h
//  RunTimeTest
//
//  Created by appleDeveloper on 16/3/24.
//  Copyright © 2016年 appleDeveloper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>


@interface People : NSObject
{
    NSString *_occupation;
    NSString *_nationality;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign)NSUInteger age;

- (NSDictionary *)allProperties;

- (NSDictionary *)allIvars;

- (NSDictionary *)allMethods;


@end
