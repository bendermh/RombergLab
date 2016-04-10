//
//  FourthWindowController.m
//  RombergLab
//
//  Created by Jorge on 3/12/15.
//  Copyright © 2015 ARK. All rights reserved.
//

#import "FourthWindowController.h"

@interface FourthWindowController ()

@end

@implementation FourthWindowController
@synthesize cuartaVentana;

- (void)windowDidLoad {
    
    [super windowDidLoad];
    
    NSString *userLocale = [[NSLocale currentLocale] localeIdentifier];
    NSString *userLanguage = [userLocale substringToIndex:2];
    if([userLanguage isEqualToString:@"es"]){
        [cuartaVentana setTitle:@"Resultados Limites de Estabilidad"];
    }
    else {
        [cuartaVentana setTitle:@"Limits of Stability Results"];
    }
    

    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
