//
//  FourthViewController.m
//  RombergLab
//
//  Created by Jorge on 3/12/15.
//  Copyright © 2015 ARK. All rights reserved.
//

//Escala x 0.45

#import "FourthViewController.h"

@interface FourthViewController ()

@end

@implementation FourthViewController
@synthesize datos;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(analiza:)
                                                 name:@"ResultadosLOS"
                                               object:nil];
    NSString *userLocale = [[NSLocale currentLocale] localeIdentifier];
    NSString *userLanguage = [userLocale substringToIndex:2];
    if([userLanguage isEqualToString:@"es"]){
        [self.titulo setStringValue:@"Gráfico de límites de estabilidad"];
        [self.leyenda setStringValue:@"Valores LOS"];
        [self.izqueirdatexto setStringValue:@"Izquierda"];
        [self.derechatexto setStringValue:@"Derecha"];
    }


}

-(void)analiza:(NSNotification*)notificacion{
    
    datos = (NSMutableArray *)notificacion.object;

    
    NSMutableArray *DatosX = [NSMutableArray array];
    NSMutableArray *DatosY = [NSMutableArray array];
    
    for (int i = 0;i < [datos count];i++){
        [DatosX addObject:datos[i][3]];
        [DatosY addObject:datos[i][4]];
    }
    [self.ant setStringValue:[NSString stringWithFormat:@"%i",[[DatosY valueForKeyPath:@"@max.intValue"] intValue]]];
    [self.pos setStringValue:[NSString stringWithFormat:@"%i",[[DatosY valueForKeyPath:@"@min.intValue"] intValue]]];
    [self.lef setStringValue:[NSString stringWithFormat:@"%i",[[DatosX valueForKeyPath:@"@min.intValue"] intValue]]];
    [self.rig setStringValue:[NSString stringWithFormat:@"%i",[[DatosX valueForKeyPath:@"@max.intValue"] intValue]]];
    int ant = (([[DatosY valueForKeyPath:@"@max.intValue"] intValue]*0.45));
    int pos = (([[DatosY valueForKeyPath:@"@min.intValue"] intValue]*0.45));
    int lef = (([[DatosX valueForKeyPath:@"@min.intValue"] intValue]*0.45));
    int rig = (([[DatosX valueForKeyPath:@"@max.intValue"] intValue]*0.45));
    
    [self.cuadroAnt setFrame:CGRectMake((((0)+(332/2))-10), (((ant)+(190/2))-10), 20, 20)];
    [self.cuadroPos setFrame:CGRectMake((((0)+(332/2))-10), (((pos)+(190/2))-10), 20, 20)];
    [self.cuadroLef setFrame:CGRectMake((((lef)+(332/2))-10), ((0+(190/2))-10), 20, 20)];
    [self.cuadroRig setFrame:CGRectMake((((rig)+(332/2))-10), ((0+(190/2))-10), 20, 20)];
}

@end
