//
//  Bird.m
//  FoundationTest
//
//  Created by appleDeveloper on 16/3/24.
//  Copyright © 2016年 appleDeveloper. All rights reserved.
//

#import "Bird.h"
#import "People.h"

@implementation Bird

#pragma mark - 消息转发步骤

// fist
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    return NO;
}

// second
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return nil;
}

// third
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if ([NSStringFromSelector(aSelector) isEqualToString:@"sing"]) {
        return [NSMethodSignature signatureWithObjCTypes:"@:"];
    }
    return [super methodSignatureForSelector: aSelector];
}

// four modify call object
- (void)forwardInvocation:(NSInvocation *)anInvocation
{

#if 0
    People *p = [People new];
    p.name = @"uu";
    [anInvocation invokeWithTarget:p];
    
#else
    
    [anInvocation setSelector:@selector(dance)];
    [anInvocation invokeWithTarget:self];
    
#endif
    
}

- (void)doesNotRecognizeSelector:(SEL)aSelector
{
    NSLog(@"消息无法处理 %@",NSStringFromSelector(aSelector));
}

- (void)dance
{
    NSLog(@"小鸟跳舞");
}

@end
