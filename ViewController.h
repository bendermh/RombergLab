//
//  ViewController.h
//  RombergLab
//
//  Created by Jorge Rey Martínez on 29/11/15.
//  Copyright © 2015 Jorge Rey Martínez. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WiiRemote.h"
#import "WiiRemoteDiscovery.h"

@interface ViewController : NSViewController <WiiRemoteDelegate, WiiRemoteDiscoveryDelegate>

{
    float tare,lastWeight,arribaderecha,arribaizquierda,abajoderecha,abajoizquierda,COGX,COGY,Tstamp;
    BOOL problema,grabarLibreON,grabarLibre2,terminaGrabar,enprueba,finJuego,impactoContado;
    int paso,paso2,paso3,paso4,cronom,dificultad,puntuacion,posibletotal,acumulo,contacto;
}

@property (weak) IBOutlet NSProgressIndicator *rueda;
@property (weak) IBOutlet NSTextField *status;
@property (weak) IBOutlet NSTextField *instrucciones;
@property (weak) IBOutlet NSButton *reconexion;
@property (weak) IBOutlet NSButton *calibracion;
@property (weak) IBOutlet NSImageView *BT;
@property (weak) IBOutlet NSTextField *ArrDer;
@property (weak) IBOutlet NSTextField *ArrIzq;
@property (weak) IBOutlet NSTextField *AbaDer;
@property (weak) IBOutlet NSTextField *AbaIzq;
@property (weak) IBOutlet NSTextField *Posicion;
@property (weak) IBOutlet NSTextField *InfoX;
@property (weak) IBOutlet NSTextField *InfoY;
@property (weak) IBOutlet NSTextField *Titulo;
@property (weak) IBOutlet NSButton *grabarLibre;
@property (weak) IBOutlet NSTextField *target;
@property (weak) IBOutlet NSTextField *contador;
@property NSMutableArray *datoslibres;
@property NSMutableArray *datos;
@property NSWindowController *myWindowController;
@property NSWindowController *myWindowController2;
@property NSWindowController *myWindowController3;
@property (weak) IBOutlet NSButton *pararLOS;



- (IBAction)conecta:(id)sender;
- (IBAction)calibrar:(id)sender;
- (IBAction)accionGrabarLibre:(id)sender;
- (IBAction)terminarLOSentreno:(id)sender;

@end

