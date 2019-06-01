//
//  AppDelegate.m
//  RombergLab
//
//  Created by Jorge Rey Martínez on 29/11/15.
//  Copyright © 2015 Jorge Rey Martínez. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()


@end

@implementation AppDelegate

@synthesize myWindowControllerA;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
  
    [self.MenuModo setEnabled:NO];
    
    //ASUNTOS LEGALES Y SEGURIDAD
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if (! [defaults boolForKey:@"notFirstRun"]) {
        [defaults setBool:YES forKey:@"notFirstRun"];
        
        NSAlert *alert = [[NSAlert alloc] init];
        NSString *userLocale = [[NSLocale currentLocale] localeIdentifier];
        NSString *userLanguage = [userLocale substringToIndex:2];
        if([userLanguage isEqualToString:@"es"]){
            [alert setMessageText:@"Pulse OK si está de acuerdo con los términos de uso de este programa.\r\rSi continua ejecutando este progama acepta dichos términos.\r\rNo use este programa si no está de acuerdo con sus términos de uso"];
            [alert setInformativeText:@"Puede encontrar estos términos en el menú 'Acerca' de esta aplicacion"];
        }
        else{
            [alert setMessageText:@"Press OK if you are in agreement with the terms of use of this software.\r\rIf you continue using this software you accept this terms.\r\rDo not use this software if you are not in agreement with this terms"];
            [alert setInformativeText:@"You can find this terms written on the 'About' menu of this software"];
        }
        [alert addButtonWithTitle:@"OK"];
        [alert runModal];
    }
    else {
        // [defaults setBool:NO forKey:@"notFirstRun"]; //ACTIVAR SOLO EN PRUEBAS
    }
    // FIN LEGALES SEGUIR NORMAL
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reconectaActivo:)
                                                 name:@"ConexiónApagada"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menuModoActivo:)
                                                 name:@"MenuModoActivo"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menuModoInactivo:)
                                                 name:@"MenuModoInactivo"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(iniciarlibre:)
                                                 name:@"PruebaTerminada"
                                               object:nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    
    
}

- (IBAction)menuconexion:(id)sender{
    if (reconectarOn){
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"MenuConexión"
     object:nil];}
    
}

-(void)reconectaActivo:(id)sender{
    reconectarOn = YES;
}

-(void)iniciarlibre:(id)sender{
    [self performSelector: @selector(itemnormal:) withObject:self afterDelay: 0.0];
}

-(void)menuModoActivo:(id)sender{
[self.MenuModo setEnabled:YES];
}

-(void)menuModoInactivo:(id)sender{
    [self.MenuModo setEnabled:NO];
}

- (IBAction)itemweb:(id)sender{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://mlibra.com/"]];
}
- (IBAction)itemwebValidation:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://doi.org/10.1080/00016489.2016.1204665"]];
}
- (IBAction)itemwebNormalization:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://doi.org/10.1007/s00405-018-5170-6"]];
}


- (IBAction)itemnormal:(id)sender {
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ItemNormal"
     object:nil];
}
- (IBAction)itemposturografia:(id)sender {
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ItemPosturografia"
     object:nil];
}
- (IBAction)lostest:(id)sender {
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ItemLosTest"
     object:nil];
    
}
- (IBAction)losduro:(id)sender {
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ItemLosDuro"
     object:nil];
    
}
- (IBAction)losmedio:(id)sender {
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ItemLosMedio"
     object:nil];
    
}
- (IBAction)losflojo:(id)sender{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ItemLosFlojo"
     object:nil];
    
}
- (IBAction)itemexit:(id)sender{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"Terminando"
     object:nil];
}

- (IBAction)externalData:(id)sender {
    
    NSStoryboard *storyBoard = [NSStoryboard storyboardWithName:@"Main" bundle:nil]; // get a reference to the storyboard
    myWindowControllerA = [storyBoard instantiateControllerWithIdentifier:@"SextaVentana"]; // instantiate your window controller
    [myWindowControllerA showWindow:self];
}



@end
