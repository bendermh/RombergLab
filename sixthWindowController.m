//
//  sixthWindowController.m
//  RombergLab
//
//  Created by Jorge on 31/05/2019.
//  Copyright © 2019 ARK. All rights reserved.
//

#import "sixthWindowController.h"

@interface sixthWindowController ()

@end

@implementation sixthWindowController
@synthesize sextaVentana;

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    NSString *userLocale = [[NSLocale currentLocale] localeIdentifier];
    NSString *userLanguage = [userLocale substringToIndex:2];
    if([userLanguage isEqualToString:@"es"]){
        [sextaVentana setTitle:@"Anlálisis externo"];
    }
    else {
        [sextaVentana setTitle:@"External analysis"];
    }
}

@end
