//
//  TurnstileStateMachine.h
//  EIStateMachineExample
//
//  Created by Daniel Pink on 30/10/2013.
//  Copyright (c) 2013 Electronic Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseStateMachine.h"


@protocol TurnstileStateMachineDelegate
@optional
- (void) didChangeState;
- (void) didReceiveEvent;
@end


@class Locked;
@class Unlocked;
@class Broken;
@class OutOfOrder;



@interface TurnstileStateMachine : BaseStateMachine

@property (readwrite, weak) id delegate;

@property (nonatomic, readonly) Locked *lockedState;
@property (nonatomic, readonly) Unlocked *unlockedState;
@property (nonatomic, readonly) Broken *brokenState;
@property (nonatomic, readonly) OutOfOrder *outOfOrderState;

- (void) sendRepairman;

@end


@interface Locked : BaseState
- (void) insertCoin;
@end


@interface Unlocked : BaseState
- (void) pushTurnstile;
@end


@interface Broken : BaseState

@end


@interface OutOfOrder : BaseState
@end