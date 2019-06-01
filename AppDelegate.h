//
//  AppDelegate.h
//  RombergLab
//
//  Created by Jorge Rey Martínez on 29/11/15.
//  Copyright © 2015 Jorge Rey Martínez. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WiiRemote.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

{
BOOL reconectarOn;
}

@property (weak) IBOutlet NSMenuItem *MenuReconectar;
@property (weak) IBOutlet NSMenuItem *MenuModo;

- (IBAction)menuconexion:(id)sender;
- (IBAction)itemweb:(id)sender;
- (IBAction)itemnormal:(id)sender;
- (IBAction)itemposturografia:(id)sender;
- (IBAction)lostest:(id)sender;
- (IBAction)losduro:(id)sender;
- (IBAction)losmedio:(id)sender;
- (IBAction)losflojo:(id)sender;
- (IBAction)itemexit:(id)sender;
- (IBAction)externalData:(id)sender;

@property NSWindowController *myWindowControllerA;


@end

