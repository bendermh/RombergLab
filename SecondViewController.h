//
//  SecondViewController.h
//  RombergLab
//
//  Created by Jorge on 3/12/15.
//  Copyright © 2015 ARK. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CorePlot/CorePlot.h>

@interface SecondViewController : NSViewController <CPTPlotDataSource>

@property (weak) IBOutlet NSView *AreaGrafico;
@property (weak) IBOutlet NSTextField *area;
@property (weak) IBOutlet NSView *areafoto;

@property NSMutableArray *datos;
@property NSMutableArray *datosGrafico1;
@property NSMutableArray *datosTime;
@property NSMutableArray *datosForce;
@property NSMutableArray *datosX;
@property NSMutableArray *datosY;

- (IBAction)guardarPNG:(id)sender;

@end
