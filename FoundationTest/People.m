//
//  People.m
//  RunTimeTest
//
//  Created by appleDeveloper on 16/3/24.
//  Copyright © 2016年 appleDeveloper. All rights reserved.
//

#import "People.h"

@interface People ()

@end

@implementation People

- (NSDictionary *)allProperties
{
    unsigned count = 0;
    
    objc_property_t *property = class_copyPropertyList([self class], &count);
    NSMutableDictionary *map =@{}.mutableCopy;
    
    for (NSInteger index = 0; index < count; index ++) {
        
         const char *  properName = property_getName(property[index]);
        NSString *name = [NSString stringWithUTF8String:properName];
        
        id value = [self valueForKey:name];
        
        if (value) {
            map[name] = value;
        }
    }
    free(property);
    return map;
}

- (NSDictionary *)allIvars
{
    unsigned count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    NSMutableDictionary *map = @{}.mutableCopy;
    
    for (NSInteger index = 0; index < count; index ++) {
        const char *ivarName = ivar_getName(ivars[index]);
        NSString *key = [NSString stringWithUTF8String:ivarName];
        
        id value = [self valueForKey:key];
        if (value) {
            map[key] = value;
        }
    }
    free(ivars);
    return map;
}

- (NSDictionary *)allMethods
{
  
    unsigned count = 0;
    
    NSMutableDictionary *map = @{}.mutableCopy;
    
    Method *methods = class_copyMethodList([self class], &count);
    
    for (NSInteger index = 0; index < count ; index ++) {
        SEL methodSEL = method_getName(methods[index]);
        const char *methodName = sel_getName(methodSEL);
        NSString *key = [NSString stringWithUTF8String:methodName];
        
        NSInteger arguments = method_getNumberOfArguments(methods[index]);
        
        map[key] = @(arguments - 2);
    }
    free(methods);
    
    return map;
}

@end
