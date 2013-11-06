//
//  TurnstileStateMachine.h
//  EIStateMachineExample
//
//  Created by Daniel Pink on 30/10/2013.
//  Copyright (c) 2013 Electronic Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EIStateMachine.h"


@class Locked;
@class Unlocked;
@class Broken;
@class OutOfOrder;


@interface TurnstileStateMachine : EIStateMachine

@property (nonatomic, readonly) Locked *lockedState;
@property (nonatomic, readonly) Unlocked *unlockedState;
@property (nonatomic, readonly) Broken *brokenState;
@property (nonatomic, readonly) OutOfOrder *outOfOrderState;

- (void) sendRepairman;

@end


@interface Locked : EIState <EIStateProtocol>
- (void) insertCoin;
@end


@interface Unlocked : EIState <EIStateProtocol>
- (void) pushTurnstile;
@end


@interface Broken : EIState <EIStateProtocol>
@end


@interface OutOfOrder : EIState <EIStateProtocol>
@end