//
//  ThirdWindowController.m
//  RombergLab
//
//  Created by Jorge on 3/12/15.
//  Copyright © 2015 ARK. All rights reserved.
//

#import "ThirdWindowController.h"

@interface ThirdWindowController ()

@end

@implementation ThirdWindowController

@synthesize terceraVentana;

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    NSString *userLocale = [[NSLocale currentLocale] localeIdentifier];
    NSString *userLanguage = [userLocale substringToIndex:2];
    if([userLanguage isEqualToString:@"es"]){
        [terceraVentana setTitle:@"Resultados Evaluación de Equilibrio"];
    }
    else {
        [terceraVentana setTitle:@"Sensibilized Balance Assessment"];
    }

}

@end
