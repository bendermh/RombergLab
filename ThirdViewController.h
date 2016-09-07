//
//  ThirdViewController.h
//  RombergLab
//
//  Created by Jorge on 3/12/15.
//  Copyright © 2015 ARK. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CorePlot/CorePlot.h>

@interface ThirdViewController : NSViewController <CPTPlotDataSource>
{
    float A1,A2,A3,A4;
}
- (IBAction)guardarfoto:(id)sender;
@property (weak) IBOutlet NSView *areafoto;
@property (weak) IBOutlet NSView *AreaGrafico;
@property (weak) IBOutlet NSView *AreaGrafico2;
@property (weak) IBOutlet NSView *AreaGrafico3;
@property (weak) IBOutlet NSView *AreaGrafico4;

@property NSMutableArray *datos;
@property NSMutableArray *datosGrafico1;
@property NSMutableArray *datosGrafico2;
@property NSMutableArray *datosGrafico3;
@property NSMutableArray *datosGrafico4;

@property (weak) IBOutlet NSTextField *area;
@property (weak) IBOutlet NSTextField *area2;
@property (weak) IBOutlet NSTextField *area3;
@property (weak) IBOutlet NSTextField *area4;
@property (weak) IBOutlet NSTextField *AreaCocientes;

@end
