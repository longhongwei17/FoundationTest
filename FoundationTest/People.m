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

#pragma mark - 转Model

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        for (NSString *key in dict.allKeys) {
            id value = dict[key];
            SEL setter = [self propertySetterByKey:key];
            if (setter) {
                ((void(*)(id,SEL,id))objc_msgSend)(self,setter,value);
            }
        }
    }
    return self;
}

- (NSDictionary *)toDictionary
{
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    if (count != 0) {
        NSMutableDictionary *resultDict = @{}.mutableCopy;
        
        for (NSInteger index = 0; index < count; index ++) {
            const char *properName = property_getName(properties[index]);
            NSString *name = [NSString stringWithUTF8String:properName];
            
            SEL getter = [self propertyGetterByKey:name];
            if (getter) {
                id value = ((id (*)(id,SEL))objc_msgSend)(self,getter);
                if (value) {
                    resultDict[name] = value;
                }
            }
        }
        free(properties);
        return resultDict;
    }
    return nil;
}

- (SEL)propertySetterByKey:(NSString *)key
{
    NSString *propertySetterName = [NSString stringWithFormat:@"set%@:", key.capitalizedString];
    SEL setter = NSSelectorFromString(propertySetterName);
    if ([self respondsToSelector:setter]) {
        return setter;
    }
    return nil;
}

- (SEL)propertyGetterByKey:(NSString *)key
{
    SEL getter = NSSelectorFromString(key);
    if ([self respondsToSelector:getter]) {
        return getter;
    }
    return nil;
}



#pragma mark - 实现nscoding 协议  归档
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        
        unsigned count = 0;
        Ivar *ivars = class_copyIvarList([self class], &count);
        for (NSInteger index = 0; index < count; index ++) {
            Ivar ivar = ivars[index];
            const char *name = ivar_getName(ivar);
            NSString *key = [NSString stringWithUTF8String:name];
            id value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
        
    }
    return self;
}

// nscoding
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    
    for (NSInteger index = 0; index < count; index ++) {
        Ivar ivar = ivars[index];
        
        const char *name = ivar_getName(ivar);
        
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }
    free(ivars);
}


#pragma mark- 拿取属性
// 所有属性
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

#pragma mark - 所有是咧变量
// 所有变量
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
#pragma mark- 所有方法
// 所有方法
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

#pragma mark - 消息转发

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    // 拦截sing 方法
    if ([NSStringFromSelector(sel) isEqualToString:@"sing"]) {
        class_addMethod(self, sel, (IMP)otherSing, "v:@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

void otherSing(id self, SEL cmd)
{
    NSLog(@"%@ 唱歌 拉！",((People *)self).name);
}

@end


