//
//  BaseStateMachine.m
//  Statey
//
//  Created by Matt Connolly on 8/10/12.
//  Copyright (c) 2012 Matt Connolly. All rights reserved.
//

#import "EIBaseStateMachine.h"

NSString* StateMachineWillExitStateNotification = @"state-machine.exit";
NSString* StateMachineWillChangeStateNotification = @"state-machine.change";
NSString* StateMachineDidEnterStateNotification = @"state-machine.enter";


@implementation EIBaseState

- (id)initWithStateMachine:(EIBaseStateMachine*)machine
{
    self = [super init];
    if (self) {
        self.machine = machine;
    }
    return self;
}
@end


@implementation EIBaseStateMachine

- (id)init
{
    self = [super init];
    if (self) {
        _state = nil;
        _timer = nil;
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
        NSLog(@"Unrecognised Selector");
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
    
    NSLog(@"%@ -> %@", _state, self.nextState);
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