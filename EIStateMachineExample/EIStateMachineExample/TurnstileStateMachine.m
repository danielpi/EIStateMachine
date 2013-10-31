//
//  TurnstileStateMachine.m
//  EIStateMachineExample
//
//  Created by Daniel Pink on 30/10/2013.
//  Copyright (c) 2013 Electronic Innovations. All rights reserved.
//

#import "TurnstileStateMachine.h"
#include <time.h>
#include <stdlib.h>


@implementation TurnstileStateMachine

- (id)init
{
    self = [super init];
    if (self) {
        _delegate = nil;
        
        _lockedState = [[Locked alloc] initWithStateMachine:self];
        _unlockedState = [[Unlocked alloc] initWithStateMachine:self];
        _brokenState = [[Broken alloc] initWithStateMachine:self];
        _outOfOrderState = [[OutOfOrder alloc] initWithStateMachine:self];
        
         self.nextState = _lockedState;
        
         srand(time(NULL));
    }
    
    return self;
}

- (void) sendRepairman
{
    [self setNextState:((TurnstileStateMachine*)self).outOfOrderState];
    [self changeState];
}

@end


@implementation Locked

- (void) runOnEntry
{
    if ([((TurnstileStateMachine*)self.machine).delegate respondsToSelector:@selector(didChangeState)])
    {
        [((TurnstileStateMachine*)self.machine).delegate didChangeState];
    }
}

- (void) insertCoin
{
    if ([((TurnstileStateMachine*)self.machine).delegate respondsToSelector:@selector(didReceiveEvent)])
    {
        [((TurnstileStateMachine*)self.machine).delegate didReceiveEvent];
    }
    
    [self.machine setNextState:((TurnstileStateMachine*)self.machine).unlockedState];
    [self.machine changeState];
}

@end


@implementation Unlocked

- (void) runOnEntry
{
    if ([((TurnstileStateMachine*)self.machine).delegate respondsToSelector:@selector(didChangeState)])
    {
        [((TurnstileStateMachine*)self.machine).delegate didChangeState];
    }
    
    [self.machine setTimeOutWithTimeInterval:3.0];
}

- (void) pushTurnstile
{
    int r = rand() % 10;
    
    if (r < 3) {
        [self.machine setNextState:((TurnstileStateMachine*)self.machine).brokenState];
        [self.machine changeState];
    } else {
        [self.machine setNextState:((TurnstileStateMachine*)self.machine).lockedState];
        [self.machine changeState];
    }
    
    if ([((TurnstileStateMachine*)self.machine).delegate respondsToSelector:@selector(didReceiveEvent)])
    {
        [((TurnstileStateMachine*)self.machine).delegate didReceiveEvent];
    }
}

- (void) timeOut
{
    NSLog(@"Time is up");
    
    [self.machine setNextState:((TurnstileStateMachine*)self.machine).lockedState];
    [self.machine changeState];
}

@end


@implementation Broken

- (void) runOnEntry
{
    if ([((TurnstileStateMachine*)self.machine).delegate respondsToSelector:@selector(didChangeState)])
    {
        [((TurnstileStateMachine*)self.machine).delegate didChangeState];
    }
}

@end


@implementation OutOfOrder

- (void) runOnEntry
{
    if ([((TurnstileStateMachine*)self.machine).delegate respondsToSelector:@selector(didChangeState)])
    {
        [((TurnstileStateMachine*)self.machine).delegate didChangeState];
    }
    
    [self.machine setTimeOutWithTimeInterval:5.0];
}

- (void) timeOut
{
    NSLog(@"Repair Finished");
    
    [self.machine setNextState:((TurnstileStateMachine*)self.machine).lockedState];
    [self.machine changeState];
}

@end