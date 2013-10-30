//
//  BaseStateMachine.m
//  Statey
//
//  Created by Matt Connolly on 8/10/12.
//  Copyright (c) 2012 Matt Connolly. All rights reserved.
//

#import "BaseStateMachine.h"

NSString* StateMachineWillExitStateNotification = @"state-machine.exit";
NSString* StateMachineWillChangeStateNotification = @"state-machine.change";
NSString* StateMachineDidEnterStateNotification = @"state-machine.enter";

@implementation BaseStateMachine

@synthesize timer;

- (id)init
{
    self = [super init];
    if (self) {
        _state = nil;
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
    } else {
        return [super methodSignatureForSelector:aSelector];
    }
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL aSelector = [anInvocation selector];
    
    if ([self.state respondsToSelector:aSelector]) {
        [anInvocation invokeWithTarget:self.state];
    } else {
        // silently ignore.
        // TODO: debug print this
        printf("Unrecognised selector");
        // Why doesn't this stop the unrecognized selector excepion from being thrown?
    }
}

#pragma mark - Property accessors


-(void) changeState
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
    
    NSLog(@"%@ -> %@", _state, self.nextState);
    _state = self.nextState;
    [_state runOnEntry];
    
    if (self.state) {
        [nc postNotificationName:StateMachineDidEnterStateNotification
                          object:self
                        userInfo:@{@"state":self.state}];
    }

}


@end


@implementation BaseState

- (id)initWithStateMachine:(BaseStateMachine*)machine
{
    self = [super init];
    if (self) {
        self.machine = machine;
    }
    return self;
}

- (void)runOnEntry
{
    // Debug message to say we have entered a state
}

@end