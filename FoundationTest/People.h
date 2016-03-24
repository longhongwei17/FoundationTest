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


@interface People : NSObject<NSCoding>
{
//    NSString *_occupation;
//    NSString *_nationality;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong)NSNumber *age;

@property (nonatomic, copy) NSString *occupation;
@property (nonatomic, copy) NSString *nationality;

- (NSDictionary *)allProperties;

- (NSDictionary *)allIvars;

- (NSDictionary *)allMethods;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

- (NSDictionary *)toDictionary;

- (void)sing;
@end
