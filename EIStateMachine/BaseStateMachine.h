//
//  BaseStateMachine.h
//  Statey
//
//  Created by Matt Connolly on 8/10/12.
//  Copyright (c) 2012 Matt Connolly. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* StateMachineWillExitStateNotification;
extern NSString* StateMachineWillChangeStateNotification;
extern NSString* StateMachineDidEnterStateNotification;

@class BaseState;

@interface BaseStateMachine : NSObject

@property (nonatomic, retain, readonly) BaseState *state;
@property (nonatomic, retain, readwrite) BaseState *nextState;
@property (atomic, retain, readwrite) NSTimer *timer;

- (void) changeState;
- (void) setTimeOutWithTimeInterval:(NSTimeInterval)timeInterval;
- (void) restartTimeOutWithTimeInterval:(NSTimeInterval)timeInterval;
- (void) unhandledMethodSignature;

@end


@interface BaseState : NSObject
@property (nonatomic, weak) BaseStateMachine * machine;
- (id) initWithStateMachine:(BaseStateMachine *)machine;
- (void) runOnEntry;
- (void) timeOut;
@end
