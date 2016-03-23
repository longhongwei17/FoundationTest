//
//  Person.m
//  FoundationTest
//
//  Created by appleDeveloper on 16/3/23.
//  Copyright © 2016年 appleDeveloper. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>

@implementation Person

// runtime 实现 coding
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        unsigned count = 0;
        Ivar *ivars = class_copyIvarList([self class], &count);
        
        
        for (int index = 0; index < count; index ++) {
            Ivar ivar = ivars[index];
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            
     
            id vaule = [aDecoder decodeObjectForKey:key];
            [self setValue:vaule forKey:key];
        }
        free(ivars);
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    for (int idx = 0; idx < count; idx ++)
    {
        Ivar ivar = ivars[idx];
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
        free(ivars);
    }
}



@end
