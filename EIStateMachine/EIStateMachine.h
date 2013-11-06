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

@class EIStateMachine;


@protocol EIStateProtocol <NSObject>

@property (nonatomic, weak) EIStateMachine * machine;

- (id) initWithStateMachine:(EIStateMachine *)machine;
- (void) performSelector:(SEL)aSelector withObject:(id)anArgument afterDelay:(NSTimeInterval)delay;
@optional
- (void) runOnEntry;
- (void) timeOut;

@end


@interface EIState : NSObject <EIStateProtocol>

@property (nonatomic, weak) EIStateMachine * machine;

- (id) initWithStateMachine:(EIStateMachine *)machine;

@end



@interface EIStateMachine : NSObject

@property (nonatomic, retain, readonly) id <EIStateProtocol> state;
@property (nonatomic, retain, readwrite) id <EIStateProtocol> nextState;
@property (atomic, retain, readwrite) NSTimer *timer;

- (void) changeState;
- (void) setTimeOutWithTimeInterval:(NSTimeInterval)timeInterval;
- (void) unhandledMethodSignature;

@end


