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

@class EIBaseStateMachine;


@protocol EIBaseStateProtocol <NSObject>

@property (nonatomic, weak) EIBaseStateMachine * machine;

- (id) initWithStateMachine:(EIBaseStateMachine *)machine;
- (void) performSelector:(SEL)aSelector withObject:(id)anArgument afterDelay:(NSTimeInterval)delay;
@optional
- (void) runOnEntry;
- (void) timeOut;

@end


@interface EIBaseState : NSObject <EIBaseStateProtocol>

@property (nonatomic, weak) EIBaseStateMachine * machine;

- (id) initWithStateMachine:(EIBaseStateMachine *)machine;

@end



@interface EIBaseStateMachine : NSObject

@property (nonatomic, retain, readonly) id <EIBaseStateProtocol> state;
@property (nonatomic, retain, readwrite) id <EIBaseStateProtocol> nextState;
@property (atomic, retain, readwrite) NSTimer *timer;

- (void) changeState;
- (void) setTimeOutWithTimeInterval:(NSTimeInterval)timeInterval;
- (void) unhandledMethodSignature;

@end


