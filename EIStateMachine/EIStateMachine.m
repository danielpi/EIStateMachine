//
//  BaseStateMachine.m
//  Statey
//
//  Created by Matt Connolly on 8/10/12.
//  Copyright (c) 2012 Matt Connolly. All rights reserved.
//

#import "EIStateMachine.h"

NSString* StateMachineWillExitStateNotification = @"state-machine.exit";
NSString* StateMachineWillChangeStateNotification = @"state-machine.change";
NSString* StateMachineDidEnterStateNotification = @"state-machine.enter";


@implementation EIState

- (id)initWithStateMachine:(EIStateMachine*)machine
{
    self = [super init];
    if (self) {
        _machine = machine;
    }
    return self;
}
@end


@implementation EIStateMachine

- (id)init
{
    self = [super init];
    if (self) {
        _state = nil;
        _timer = nil;
        _mute = NO;
    }
    return self;
}

#pragma mark - Objective C forwarding to state instances

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([super respondsToSelector:aSelector]) return YES;
    
    if (([self.state respondsToSelector:aSelector])) return YES;
    
    return NO;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if ([self.state respondsToSelector:aSelector]) {
        return [(NSObject*)self.state methodSignatureForSelector:aSelector];
    } else if ([super respondsToSelector:aSelector]) {
        return [super methodSignatureForSelector:aSelector];
    } else {
        return [super methodSignatureForSelector:@selector(unhandledMethodSignature)];
    }
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL aSelector = [anInvocation selector];
    
    if ([self.state respondsToSelector:aSelector]) {
        [anInvocation invokeWithTarget:self.state];
    } else {
        // silently ignore.
        if (!self.mute) {
            NSLog(@"Unrecognised Selector");
        }
    }
}

#pragma mark - Property accessors


- (void) changeState
{
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    
    if (self.state) {
        [nc postNotificationName:StateMachineWillExitStateNotification
                          object:self
                        userInfo:@{@"state":self.state}];
    }
    
    if (self.state && self.nextState) {
        [nc postNotificationName:StateMachineWillChangeStateNotification
                          object:self
                        userInfo:@{@"fromState":self.state, @"toState":self.nextState}];
    }
    
    [self.timer invalidate];
    
    if (!self.mute) {
        NSLog(@"%@ (Previous:%@)", self.nextState, _state);
    }
    
    _state = self.nextState;
    if ([_state respondsToSelector:@selector(runOnEntry)]) {
        [_state performSelector:@selector(runOnEntry) withObject:nil afterDelay:0];
    }
    
    //[_state runOnEntry];
    
    if (self.state) {
        [nc postNotificationName:StateMachineDidEnterStateNotification
                          object:self
                        userInfo:@{@"state":self.state}];
    }

}

- (void) setTimeOutWithTimeInterval:(NSTimeInterval)timeInterval
{
    [self.timer invalidate];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                  target:self
                                                selector:@selector(timeOut)
                                                userInfo:nil
                                                 repeats:NO];
}

- (void) unhandledMethodSignature
{
    return;
}

@end