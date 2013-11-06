//
//  TurnstileStateMachine.h
//  EIStateMachineExample
//
//  Created by Daniel Pink on 30/10/2013.
//  Copyright (c) 2013 Electronic Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EIBaseStateMachine.h"


@class Locked;
@class Unlocked;
@class Broken;
@class OutOfOrder;


@interface TurnstileStateMachine : EIBaseStateMachine

@property (nonatomic, readonly) Locked *lockedState;
@property (nonatomic, readonly) Unlocked *unlockedState;
@property (nonatomic, readonly) Broken *brokenState;
@property (nonatomic, readonly) OutOfOrder *outOfOrderState;

- (void) sendRepairman;

@end


@interface Locked : EIBaseState <EIBaseStateProtocol>
- (void) insertCoin;
@end


@interface Unlocked : EIBaseState <EIBaseStateProtocol>
- (void) pushTurnstile;
@end


@interface Broken : EIBaseState <EIBaseStateProtocol>
@end


@interface OutOfOrder : EIBaseState <EIBaseStateProtocol>
@end