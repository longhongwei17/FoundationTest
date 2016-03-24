//
//  ViewController.m
//  FoundationTest
//
//  Created by appleDeveloper on 16/3/23.
//  Copyright © 2016年 appleDeveloper. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "People.h"
#import <objc/runtime.h>
#import <objc/message.h>

void sayFunction(id self ,SEL _cmd ,id some)
{
    NSLog(@"%@ 岁的%@ 说%@",object_getIvar(self, class_getInstanceVariable([self class], "_age")),[self valueForKey:@"name"],some);
}

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self kvcTest];
    
    [self dynamicClassTest];
    
    [self calculatePropertyAndIvar];

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

/**
 *  @brief 动态生成类 测试   ps 动态生成类 不能和 已经生成的 类冲突
 */
- (void)dynamicClassTest
{
    // 生成动态累类
    Class Teacher = objc_allocateClassPair([NSObject class], "Teacher", 0);
    
    // 增加属性
    class_addIvar(Teacher, "_name", sizeof(NSString *), log2(sizeof(NSString *)), @encode(NSString *));
    // 增加属性
    class_addIvar(Teacher, "_age", sizeof(int), log2(sizeof(int)), @encode(int));
    
    // 注册方法
    SEL s = sel_registerName("say:");
    // 为该类增加名为say的方法
    class_addMethod(Teacher, s, (IMP)sayFunction, "v@:@");
    
    // 注册该类
    objc_registerClassPair(Teacher);
    
    // 创建实例
    id personInstance = [[Teacher alloc] init];
    
    // 动态修改属性值
    Ivar nameIvae = class_getInstanceVariable(Teacher, "_name");
    object_setIvar(personInstance, nameIvae, @"long");
    
    // 动态修改属性值
    Ivar ageIvar = class_getInstanceVariable(Teacher, "_age");
    object_setIvar(personInstance, ageIvar, @10);
    
    // 强转函数指针 调方法
    ((void(*)(id,SEL,id))objc_msgSend)(personInstance,s ,@"大家好");
    
    //调下面方法 记得修改
    //Build Setting–> Apple LLVM 7.0 – Preprocessing–> Enable Strict Checking of objc_msgSend Calls 改为 NO
    //    objc_msgSend(personInstance, s, @"呀没得");
    
    personInstance = nil;
    objc_disposeClassPair(Teacher);
}

/**
 *  @brief 动态计算 属性 变量 方法列表
 */
- (void)calculatePropertyAndIvar
{
    People *cangTeacher = [[People alloc] init];
    cangTeacher.name = @"苍井空";
    cangTeacher.age = 18;
    [cangTeacher setValue:@"老师" forKey:@"occupation"];
    
    NSDictionary *propertyResultDic = [cangTeacher allProperties];
    for (NSString *propertyName in propertyResultDic.allKeys) {
        NSLog(@"propertyName:%@, propertyValue:%@",propertyName, propertyResultDic[propertyName]);
    }
    
    NSDictionary *ivarResultDic = [cangTeacher allIvars];
    for (NSString *ivarName in ivarResultDic.allKeys) {
        NSLog(@"ivarName:%@, ivarValue:%@",ivarName, ivarResultDic[ivarName]);
    }
    
    NSDictionary *methodResultDic = [cangTeacher allMethods];
    for (NSString *methodName in methodResultDic.allKeys) {
        NSLog(@"methodName:%@, argumentsCount:%@", methodName, methodResultDic[methodName]);
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
