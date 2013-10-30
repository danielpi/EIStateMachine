//
//  AppDelegate.h
//  EIStateMachineExample
//
//  Created by Daniel Pink on 30/10/2013.
//  Copyright (c) 2013 Electronic Innovations. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TurnstileStateMachine.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, TurnstileStateMachineDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readwrite, strong) TurnstileStateMachine *turnstile;

@property (weak) IBOutlet NSTextField *stateLabel;

- (IBAction)pushTurnstile:(id)sender;
- (IBAction)insertCoin:(id)sender;

@end
