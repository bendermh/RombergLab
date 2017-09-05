//
//  FivethWindowController.m
//  RombergLab
//
//  Created by Jorge Rey Martinez on 4/9/17.
//  Copyright © 2017 ARK. All rights reserved.
//

#import "FivethWindowController.h"

@interface FivethWindowController ()

@end

@implementation FivethWindowController

@synthesize quintaVentana;

- (void)windowDidLoad {
    [super windowDidLoad];
    
    NSString *userLocale = [[NSLocale currentLocale] localeIdentifier];
    NSString *userLanguage = [userLocale substringToIndex:2];
    if([userLanguage isEqualToString:@"es"]){
        [quintaVentana setTitle:@"Resultados Normalizados - RmobergLab - PROHIBIDO SU USO CLÍNCO/DIAGNÓSTICO"];
    }
    else {
        [quintaVentana setTitle:@"Normalized Results - RomberLab - NOT FOR CLINICAL USE"];
    }
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
