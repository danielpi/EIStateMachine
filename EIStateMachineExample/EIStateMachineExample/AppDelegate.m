//
//  AppDelegate.m
//  EIStateMachineExample
//
//  Created by Daniel Pink on 30/10/2013.
//  Copyright (c) 2013 Electronic Innovations. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    _turnstile = [[TurnstileStateMachine alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangeState)
                                                 name:StateMachineDidEnterStateNotification
                                               object:nil];
    [_turnstile changeState];
}

- (IBAction)pushTurnstile:(id)sender
{
    [(Unlocked *)self.turnstile pushTurnstile];
}

- (IBAction)insertCoin:(id)sender
{
    [(Locked *)self.turnstile insertCoin];
}

- (IBAction)sendRepairMan:(id)sender
{
    [self.turnstile sendRepairman];
}


#pragma mark TurnstileStateMachineDelegateMethods
- (void) didChangeState
{
    if ([_turnstile.state isKindOfClass:[Unlocked class]]) {
        [self.stateLabel setStringValue:@"Unlocked"];
    } else if ([_turnstile.state isKindOfClass:[Locked class]]){
        [self.stateLabel setStringValue:@"Locked"];
    } else if ([_turnstile.state isKindOfClass:[Broken class]]){
        [self.stateLabel setStringValue:@"Broken"];
    } else if ([_turnstile.state isKindOfClass:[OutOfOrder class]]){
        [self.stateLabel setStringValue:@"Out of Order"];
    }
}

@end
