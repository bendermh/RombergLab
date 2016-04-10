//
//  FourthViewController.h
//  RombergLab
//
//  Created by Jorge on 3/12/15.
//  Copyright © 2015 ARK. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CorePlot/CorePlot.h>

@interface FourthViewController : NSViewController

@property NSMutableArray *datos;
@property NSMutableArray *datosGrafico1;

@property (weak) IBOutlet NSTextField *titulo;
@property (weak) IBOutlet NSTextField *ant;
@property (weak) IBOutlet NSTextField *lef;
@property (weak) IBOutlet NSTextField *rig;
@property (weak) IBOutlet NSTextField *pos;
@property (weak) IBOutlet NSTextField *leyenda;
@property (weak) IBOutlet NSTextField *izqueirdatexto;
@property (weak) IBOutlet NSTextField *derechatexto;
@property (weak) IBOutlet NSTextField *cuadroAnt;
@property (weak) IBOutlet NSTextField *cuadroPos;
@property (weak) IBOutlet NSTextField *cuadroLef;
@property (weak) IBOutlet NSTextField *cuadroRig;

@end
