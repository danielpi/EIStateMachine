//
//  TurnstileStateMachine.m
//  EIStateMachineExample
//
//  Created by Daniel Pink on 30/10/2013.
//  Copyright (c) 2013 Electronic Innovations. All rights reserved.
//

#import "TurnstileStateMachine.h"


@implementation TurnstileStateMachine

- (id)init
{
    self = [super init];
    if (self) {
        _delegate = nil;
        
        _lockedState = [[Locked alloc] initWithStateMachine:self];
        _unlockedState = [[Unlocked alloc] initWithStateMachine:self];
        
         self.nextState = _lockedState;
    }
    
    return self;
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
    
    self.machine.timer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                 target:self.machine
                                               selector:@selector(timeIsUp:)
                                               userInfo:nil
                                                repeats:NO];
}

- (void) pushTurnstile
{
    if ([((TurnstileStateMachine*)self.machine).delegate respondsToSelector:@selector(didReceiveEvent)])
    {
        [((TurnstileStateMachine*)self.machine).delegate didReceiveEvent];
    }
    
    
}

-(void)timeIsUp:(id)userInfo
{
    NSLog(@"Time is up");
    
    [self.machine setNextState:((TurnstileStateMachine*)self.machine).lockedState];
    [self.machine changeState];
}

@end