//
//  SecondWindowController.m
//  RombergLab
//
//  Created by Jorge on 3/12/15.
//  Copyright © 2015 ARK. All rights reserved.
//

#import "SecondWindowController.h"

@interface SecondWindowController ()

@end

@implementation SecondWindowController
@synthesize segundaVentana;

- (void)windowDidLoad {
    [super windowDidLoad];
    NSString *userLocale = [[NSLocale currentLocale] localeIdentifier];
    NSString *userLanguage = [userLocale substringToIndex:2];
    if([userLanguage isEqualToString:@"es"]){
        [segundaVentana setTitle:@"Resultados de modo libre"];
    }
    else {
        [segundaVentana setTitle:@"Free mode results"];
    }
    
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
