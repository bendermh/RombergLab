//
//  ViewController.m
//  RombergLab
//
//  Created by Jorge Rey Martínez on 29/11/15.
//  Copyright © 2015 Jorge Rey Martínez. All rights reserved.
//

// Estructura: Primero los juegos y acciones y luego la conexion con la wii el concepto calibracion es solo para el peso

#import "ViewController.h"

@implementation ViewController
@synthesize datoslibres;
@synthesize datos;
@synthesize myWindowController;
@synthesize myWindowController2;
@synthesize myWindowController3;

WiiRemoteDiscovery* discovery;
WiiRemote* wii;
NSDate *Tiempo;


- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    datoslibres = [[NSMutableArray alloc] init];
    datos = [[NSMutableArray alloc] init];
    [self.grabarLibre setHidden:YES];
    Tiempo = [NSDate date];
    COGX = 0;
    COGY = 0;
    Tstamp = 0;
    problema = NO;
    acumulo = 0;
    
    
    if(!discovery) {
        [self performSelector:@selector(conecta:) withObject:self afterDelay:1.0f];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(expansionPortChanged:)
                                                 name:@"WiiRemoteExpansionPortChangedNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowWillClose:) name:NSWindowWillCloseNotification object:self.view.window];
    
    //NOTIFICACION del menuConexion y otros menus
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reconecta:)
                                     name:@"MenuConexión"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(modoNormal:)
                                                 name:@"ItemNormal"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(modoPosturografia:)
                                                 name:@"ItemPosturografia"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(modoLOSTest:)
                                                 name:@"ItemLosTest"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(modoLOSDuro:)
                                                 name:@"ItemLosDuro"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(modoLOSMedio:)
                                                 name:@"ItemLosMedio"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(modoLOSFlojo:)
                                                 name:@"ItemLosFlojo"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cerrarApp:)
                                                 name:@"Terminando"
                                               object:nil];
    
}
// PRIMERO LOS INICIADORES DE LAS PRUEBAS (normal no, es solo poner hacer limpieza, no hay acción la accion esta en el boton)

-(void)modoNormal:(id)sender{
    enprueba = NO;
    [self.contador setHidden:YES];
    [self.target setHidden:YES];
    [self.grabarLibre setHidden:NO];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"MenuModoActivo"
     object:nil];

    NSString *userLocale = [[NSLocale currentLocale] localeIdentifier];
    NSString *userLanguage = [userLocale substringToIndex:2];
    if([userLanguage isEqualToString:@"es"]){
        [self.Titulo setStringValue:@"Registro en modo libre: Cambie de modo en el menú"];
        [self.instrucciones setStringValue:@" "];
    }
    else {
        [self.instrucciones setStringValue:@" "];
        [self.Titulo setStringValue:@"Free Mode ON: Set new mode on menu bar"];
    }
}

-(void)modoLOSTest:(id)sender{
    enprueba = YES;
    [self.contador setHidden:YES];
    [self.target setHidden:YES];
    [self.grabarLibre setHidden:YES];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"MenuModoInactivo"
     object:nil];
    NSString *userLocale = [[NSLocale currentLocale] localeIdentifier];
    NSString *userLanguage = [userLocale substringToIndex:2];
    if([userLanguage isEqualToString:@"es"]){
        [self.Titulo setStringValue:@"Prueba LOS: Inclínese para alcanzar el objetivo"];
        [self.instrucciones setStringValue:@" "];
    }
    else {
        [self.instrucciones setStringValue:@" "];
        [self.Titulo setStringValue:@"LOS test: Tilt your body to reach the target"];
    }
    [self modoLOSTest];
}

-(void)modoPosturografia:(id)sender{
    enprueba = YES;
    [self.contador setHidden:NO];
    [self.target setHidden:YES];
    [self.grabarLibre setHidden:YES];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"MenuModoInactivo"
     object:nil];
    NSString *userLocale = [[NSLocale currentLocale] localeIdentifier];
    NSString *userLanguage = [userLocale substringToIndex:2];
    if([userLanguage isEqualToString:@"es"]){
        [self.Titulo setStringValue:@"Modo de evaluación del equlibrio"];
        [self.instrucciones setStringValue:@" "];
    }
    else {
        [self.instrucciones setStringValue:@" "];
        [self.Titulo setStringValue:@"Balance Assessment Mode"];
    }
        [self modoPosturografia];
}

-(void)modoLOSDuro:(id)sender{
    enprueba = YES;
    [self.contador setHidden:NO];
    [self.target setHidden:YES];
    [self.grabarLibre setHidden:YES];
    [self.pararLOS setHidden:NO];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"MenuModoInactivo"
     object:nil];
    NSString *userLocale = [[NSLocale currentLocale] localeIdentifier];
    NSString *userLanguage = [userLocale substringToIndex:2];
    if([userLanguage isEqualToString:@"es"]){
        [self.Titulo setStringValue:@"Modo ejercicio LOS (Niv.3): Aclance el objetivo"];
        [self.instrucciones setStringValue:@" "];
    }
    else {
        [self.instrucciones setStringValue:@" "];
        [self.Titulo setStringValue:@"LOS training Mode (Lev. 3): Reach the target"];
    }
        [self modoLOS3];
}

-(void)modoLOSMedio:(id)sender{
    enprueba = YES;
    [self.contador setHidden:NO];
    [self.target setHidden:YES];
    [self.grabarLibre setHidden:YES];
    [self.pararLOS setHidden:NO];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"MenuModoInactivo"
     object:nil];
    NSString *userLocale = [[NSLocale currentLocale] localeIdentifier];
    NSString *userLanguage = [userLocale substringToIndex:2];
    if([userLanguage isEqualToString:@"es"]){
        [self.Titulo setStringValue:@"Modo ejercicio LOS (Niv.2): Aclance el objetivo"];
        [self.instrucciones setStringValue:@" "];
    }
    else {
        [self.instrucciones setStringValue:@" "];
        [self.Titulo setStringValue:@"LOS training Mode (Lev. 2): Reach the target"];
    }
    [self modoLOS2];
}

-(void)modoLOSFlojo:(id)sender{
    enprueba = YES;
    [self.contador setHidden:NO];
    [self.target setHidden:YES];
    [self.grabarLibre setHidden:YES];
    [self.pararLOS setHidden:NO];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"MenuModoInactivo"
     object:nil];
    NSString *userLocale = [[NSLocale currentLocale] localeIdentifier];
    NSString *userLanguage = [userLocale substringToIndex:2];
    if([userLanguage isEqualToString:@"es"]){
        [self.Titulo setStringValue:@"Modo ejercicio LOS (Niv.1): Aclance el objetivo"];
        [self.instrucciones setStringValue:@" "];
    }
    else {
        [self.instrucciones setStringValue:@" "];
        [self.Titulo setStringValue:@"LOS training Mode (Lev. 1): Reach the target"];
    }
    [self modoLOS1];
}

//Ahora las acciones de juego Nota: al final activar el menú otra vez

-(void)modoLOSTest {
    paso = 0;
    [datos removeAllObjects];
    terminaGrabar = NO;
    [self.target setHidden:NO];
    NSTimer *grabar;
    grabar = [NSTimer scheduledTimerWithTimeInterval: 0.05
                                                   target: self
                                                 selector: @selector(grabandoLOS:)
                                                 userInfo: nil
                                                  repeats: YES];
    NSTimer *accion;
    accion = [NSTimer scheduledTimerWithTimeInterval: 20
                                              target: self
                                            selector: @selector(accionLOS:)
                                            userInfo: nil
                                             repeats: YES];
    NSTimer *terminar;
    terminar = [NSTimer scheduledTimerWithTimeInterval: 81
                                              target: self
                                            selector: @selector(terminarLOS:)
                                            userInfo: nil
                                             repeats: NO];
    paso ++;
    if (paso == 1){
        float Px,Py;
        Px = (742/2)-(30/2); //742 ancho del view 30 ancho del cuadrado.
        Py = (421)-(44);
        [self.target setFrame:CGRectMake(Px, Py, 30, 30)];
    }

}

-(void)grabandoLOS:(NSTimer *)grabandoLOS{
    if (!terminaGrabar){
        // Estructura en Datos [Modo de prograna, Estampa de tiempo, Peso total calibrado, Centro de gravedad x, centro de gravedad y]
        
        [datos addObject:[NSArray arrayWithObjects:[NSNumber numberWithFloat:2.0],[NSNumber numberWithFloat:Tstamp],[NSNumber numberWithFloat:(lastWeight+tare)],[NSNumber numberWithFloat:COGX],[NSNumber numberWithFloat:COGY],nil]];
    }
    else {
        [grabandoLOS invalidate];
    }
}

-(void)accionLOS:(NSTimer *)accionLOS{
    if (!terminaGrabar){
        paso ++;
        if (paso == 2){
            float Px,Py;
            Px = (690)-(30); //742 ancho del view 30 ancho del cuadrado.
            Py = (421/2)-(30/2);
            [self.target setFrame:CGRectMake(Px, Py, 30, 30)];
            
        }
        if (paso == 3){
            float Px,Py;
            Px = (742/2)-(30/2); //742 ancho del view 30 ancho del cuadrado.
            Py = (5)+(30/2);
            [self.target setFrame:CGRectMake(Px, Py, 30, 30)];
        }
        if (paso == 4){
            float Px,Py;
            Px = (25)+(30); //742 ancho del view 30 ancho del cuadrado.
            Py = (421/2)-(30/2);
            [self.target setFrame:CGRectMake(Px, Py, 30, 30)];
        }
    }
    else {
        [accionLOS invalidate];
    }
}

-(void)terminarLOS:(NSTimer *)terminarLOS{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"MenuModoActivo"
     object:nil];
    
    terminaGrabar = YES;
    [self.target setHidden:YES];
    [self.pararLOS setHidden:YES];
    [self modoNormal:self];
    NSStoryboard *storyBoard = [NSStoryboard storyboardWithName:@"Main" bundle:nil]; // get a reference to the storyboard
    myWindowController2 = [storyBoard instantiateControllerWithIdentifier:@"CuartaVentana"]; // instantiate your window controller
    [myWindowController2 showWindow:self];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"PruebaTerminada"
     object:nil];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ResultadosLOS"
     object:datos];
}


-(void)modoPosturografia {
    paso = 0;
    paso2 = 0;
    paso3 = 0;
    paso4 = 0;
    cronom = 40;
    [datos removeAllObjects];
    terminaGrabar = NO;
    NSAlert *alert = [[NSAlert alloc] init];
    NSString *userLocale = [[NSLocale currentLocale] localeIdentifier];
    NSString *userLanguage = [userLocale substringToIndex:2];
    if([userLanguage isEqualToString:@"es"]){
        [alert setMessageText:@"Condición 1: Ojos abiertos"];
        [alert setInformativeText:@"Centrado en la plataforma. Sin moverse."];
    }
    else{
        [alert setMessageText:@"Condition1: Open Eyes"];
        [alert setInformativeText:@"Stay centered. No movement."];
    }
    [alert addButtonWithTitle:@"Start"];
    if ([alert runModal] == NSAlertFirstButtonReturn){
        NSTimer *grabarPOS1;
        grabarPOS1 = [NSTimer scheduledTimerWithTimeInterval: 0.05
                                                  target: self
                                                selector: @selector(grabandoPOS1:)
                                                userInfo: nil
                                                 repeats: YES];
        NSTimer *cronometro;
        cronometro = [NSTimer scheduledTimerWithTimeInterval: 1
                                                      target: self
                                                    selector: @selector(cronometro:)
                                                    userInfo: nil
                                                     repeats: YES];

        
        
    }
}
    
-(void)cronometro:(NSTimer *)cronometro{
    if (paso <=(40/0.05)){[self.contador setStringValue:[NSString stringWithFormat:@"%i",(cronom-1)]];}
    else {
        terminaGrabar = NO;
        NSAlert *alert = [[NSAlert alloc] init];
        NSString *userLocale = [[NSLocale currentLocale] localeIdentifier];
        NSString *userLanguage = [userLocale substringToIndex:2];
        if([userLanguage isEqualToString:@"es"]){
            [alert setMessageText:@"Condición 2: Ojos cerrados"];
            [alert setInformativeText:@"Centrado en la plataforma. Sin moverse."];
        }
        else{
            [alert setMessageText:@"Condition2: Closed Eyes"];
            [alert setInformativeText:@"Stay centered. No movement."];
        }
        [alert addButtonWithTitle:@"Start"];
        if ([alert runModal] == NSAlertFirstButtonReturn){
            NSTimer *grabarPOS2;
            grabarPOS2 = [NSTimer scheduledTimerWithTimeInterval: 0.05
                                                          target: self
                                                        selector: @selector(grabandoPOS2:)
                                                        userInfo: nil
                                                         repeats: YES];
            NSTimer *cronometro2;
            cronometro2 = [NSTimer scheduledTimerWithTimeInterval: 1
                                                          target: self
                                                        selector: @selector(cronometro2:)
                                                        userInfo: nil
                                                         repeats: YES];
        [cronometro invalidate];
        cronom = 40;
    }
}
    cronom --;
}

-(void)cronometro2:(NSTimer *)cronometro2{
    if (paso2 <=(40/0.05)){[self.contador setStringValue:[NSString stringWithFormat:@"%i",(cronom)]];}
    else {
        terminaGrabar = NO;
        NSAlert *alert = [[NSAlert alloc] init];
        NSString *userLocale = [[NSLocale currentLocale] localeIdentifier];
        NSString *userLanguage = [userLocale substringToIndex:2];
        if([userLanguage isEqualToString:@"es"]){
            [alert setMessageText:@"Condición 3: Ojos abiertos. Sobre espuma o cojin pequeño"];
            [alert setInformativeText:@"Poner espuma encima de la plataforma y luego subirse centrado en la plataforma. Sin moverse."];
        }
        else{
            [alert setMessageText:@"Condition3: Open Eyes. Stand on foam"];
            [alert setInformativeText:@"Put foam over the balance board. Stand over board again. Stay centered. No movement."];
        }
        [alert addButtonWithTitle:@"Start"];
        if ([alert runModal] == NSAlertFirstButtonReturn){
            NSTimer *grabarPOS3;
            grabarPOS3 = [NSTimer scheduledTimerWithTimeInterval: 0.05
                                                          target: self
                                                        selector: @selector(grabandoPOS3:)
                                                        userInfo: nil
                                                         repeats: YES];
            NSTimer *cronometro3;
            cronometro3 = [NSTimer scheduledTimerWithTimeInterval: 1
                                                           target: self
                                                         selector: @selector(cronometro3:)
                                                         userInfo: nil
                                                          repeats: YES];
            [cronometro2 invalidate];
        }
    cronom = 40;
    }
    cronom--;
}

-(void)cronometro3:(NSTimer *)cronometro3{
    if (paso3 <=(40/0.05)){[self.contador setStringValue:[NSString stringWithFormat:@"%i",(cronom)]];}
    else {
        terminaGrabar = NO;
        NSAlert *alert = [[NSAlert alloc] init];
        NSString *userLocale = [[NSLocale currentLocale] localeIdentifier];
        NSString *userLanguage = [userLocale substringToIndex:2];
        if([userLanguage isEqualToString:@"es"]){
            [alert setMessageText:@"Condición 4: Ojos cerrados. Sobre espuma o cojin pequeño"];
            [alert setInformativeText:@"Centrado en la plataforma. Sin moverse."];
        }
        else{
            [alert setMessageText:@"Condition4: Close Eyes. Stand on foam"];
            [alert setInformativeText:@"Put foam over the balance board. Stand over board again. Stay centered. No movement."];
        }
        [alert addButtonWithTitle:@"Start"];
        if ([alert runModal] == NSAlertFirstButtonReturn){
            NSTimer *grabarPOS4;
            grabarPOS4 = [NSTimer scheduledTimerWithTimeInterval: 0.05
                                                          target: self
                                                        selector: @selector(grabandoPOS4:)
                                                        userInfo: nil
                                                         repeats: YES];
            NSTimer *cronometro4;
            cronometro4 = [NSTimer scheduledTimerWithTimeInterval: 1
                                                           target: self
                                                         selector: @selector(cronometro4:)
                                                         userInfo: nil
                                                          repeats: YES];
            [cronometro3 invalidate];
        }
    cronom = 40;
    }
    cronom --;
}

-(void)cronometro4:(NSTimer *)cronometro4{
    if (paso4 <=(40/0.05)){[self.contador setStringValue:[NSString stringWithFormat:@"%i",(cronom)]];}
    else {
        terminaGrabar = NO;
        NSAlert *alert = [[NSAlert alloc] init];
        NSString *userLocale = [[NSLocale currentLocale] localeIdentifier];
        NSString *userLanguage = [userLocale substringToIndex:2];
        if([userLanguage isEqualToString:@"es"]){
            [alert setMessageText:@"Prueba terminada"];
            [alert setInformativeText:@"Se vuelve al modo libre"];
        }
        else{
            [alert setMessageText:@"Test finished"];
            [alert setInformativeText:@"Go back to free mode"];
        }
        [alert addButtonWithTitle:@"OK"];
        if ([alert runModal] == NSAlertFirstButtonReturn){
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"MenuModoActivo"
             object:nil];
            
            terminaGrabar = YES;
            [self.target setHidden:YES];
            [self.contador setHidden:YES];
            [self modoNormal:self];
            NSStoryboard *storyBoard = [NSStoryboard storyboardWithName:@"Main" bundle:nil]; // get a reference to the storyboard
            myWindowController3 = [storyBoard instantiateControllerWithIdentifier:@"TerceraVentana"]; // instantiate your window controller
            [myWindowController3 showWindow:self];
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"PruebaTerminada"
             object:nil];
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"ResultadosPosturografia"
             object:datos];
        }

        [cronometro4 invalidate];
        }
    cronom --;
}



-(void)grabandoPOS1:(NSTimer *)grabandoPOS1{
        paso ++;
        if (paso <= (40/0.05)){
            // Estructura en Datos [Modo de prograna, Estampa de tiempo, Peso total calibrado, Centro de gravedad x, centro de gravedad y]
            
            [datos addObject:[NSArray arrayWithObjects:[NSNumber numberWithFloat:3.1],[NSNumber numberWithFloat:Tstamp],[NSNumber numberWithFloat:(lastWeight+tare)],[NSNumber numberWithFloat:COGX],[NSNumber numberWithFloat:COGY],nil]];
        }
        else {
            [grabandoPOS1 invalidate];
        }
}
-(void)grabandoPOS2:(NSTimer *)grabandoPOS2{
        paso2 ++;
        if (paso2 <= (40/0.05)){
            // Estructura en Datos [Modo de prograna, Estampa de tiempo, Peso total calibrado, Centro de gravedad x, centro de gravedad y]
            
            [datos addObject:[NSArray arrayWithObjects:[NSNumber numberWithFloat:3.2],[NSNumber numberWithFloat:Tstamp],[NSNumber numberWithFloat:(lastWeight+tare)],[NSNumber numberWithFloat:COGX],[NSNumber numberWithFloat:COGY],nil]];
        }
        else {
            [grabandoPOS2 invalidate];
        }
}
-(void)grabandoPOS3:(NSTimer *)grabandoPOS3{
        paso3 ++;
        if (paso3 <= (40/0.05)){
            // Estructura en Datos [Modo de prograna, Estampa de tiempo, Peso total calibrado, Centro de gravedad x, centro de gravedad y]
            
            [datos addObject:[NSArray arrayWithObjects:[NSNumber numberWithFloat:3.3],[NSNumber numberWithFloat:Tstamp],[NSNumber numberWithFloat:(lastWeight+tare)],[NSNumber numberWithFloat:COGX],[NSNumber numberWithFloat:COGY],nil]];
        }
        else {
            [grabandoPOS3 invalidate];
        }
}

-(void)grabandoPOS4:(NSTimer *)grabandoPOS4{
    paso4 ++;
    if (paso4 <= (40/0.05)){
        // Estructura en Datos [Modo de prograna, Estampa de tiempo, Peso total calibrado, Centro de gravedad x, centro de gravedad y]
        
        [datos addObject:[NSArray arrayWithObjects:[NSNumber numberWithFloat:3.4],[NSNumber numberWithFloat:Tstamp],[NSNumber numberWithFloat:(lastWeight+tare)],[NSNumber numberWithFloat:COGX],[NSNumber numberWithFloat:COGY],nil]];
    }
    else {
        [grabandoPOS4 invalidate];
    }
}



-(void)modoLOS3 {
    paso = 0;
    cronom = 120;
    finJuego = NO;
    dificultad = 3;
    puntuacion = 0;
    posibletotal = 1;
    NSTimer *cronometro;
    cronometro = [NSTimer scheduledTimerWithTimeInterval: 1
                                              target: self
                                            selector: @selector(cronometroLOStrain:)
                                            userInfo: nil
                                             repeats: YES];
    NSTimer *mueve;
    mueve = [NSTimer scheduledTimerWithTimeInterval: 5
                                                  target: self
                                                selector: @selector(mueveLOStrain:)
                                                userInfo: nil
                                                 repeats: YES];
    NSTimer *detecta;
    detecta = [NSTimer scheduledTimerWithTimeInterval: 0.01
                                             target: self
                                           selector: @selector(colision:)
                                           userInfo: nil
                                            repeats: YES];
    int x = 0;
    int y = 0;
        if (dificultad == 3){
        int limAbajo = (0+200);
        int limArriba = (741-200);
        x = limAbajo + arc4random() % (limArriba - limAbajo);
        limAbajo = (0+100);
        limArriba = (421-100);
        y = limAbajo + arc4random() % (limArriba - limAbajo);
    }
    [self.target setFrame:CGRectMake(x, y, 30, 30)];
    [self.target setHidden:NO];

}



-(void)modoLOS2 {
    paso = 0;
    cronom = 90;
    finJuego = NO;
    dificultad = 2;
    puntuacion = 0;
    posibletotal = 1;
    NSTimer *cronometro;
    cronometro = [NSTimer scheduledTimerWithTimeInterval: 1
                                                  target: self
                                                selector: @selector(cronometroLOStrain:)
                                                userInfo: nil
                                                 repeats: YES];
    NSTimer *mueve;
    mueve = [NSTimer scheduledTimerWithTimeInterval: 10
                                             target: self
                                           selector: @selector(mueveLOStrain:)
                                           userInfo: nil
                                            repeats: YES];
    NSTimer *detecta;
    detecta = [NSTimer scheduledTimerWithTimeInterval: 0.01
                                               target: self
                                             selector: @selector(colision:)
                                             userInfo: nil
                                              repeats: YES];
    int x = 0;
    int y = 0;
       if (dificultad == 2){
        int limAbajo = (0+200);
        int limArriba = (741-200);
        x = limAbajo + arc4random() % (limArriba - limAbajo);
        limAbajo = (0+100);
        limArriba = (421-100);
        y = limAbajo + arc4random() % (limArriba - limAbajo);
    }
    [self.target setFrame:CGRectMake(x, y, 30, 30)];
    [self.target setHidden:NO];

}

-(void)modoLOS1 {
    paso = 0;
    cronom = 90;
    finJuego = NO;
    dificultad = 1;
    posibletotal = 1;
    puntuacion = 0;
    NSTimer *cronometro;
    cronometro = [NSTimer scheduledTimerWithTimeInterval: 1
                                                  target: self
                                                selector: @selector(cronometroLOStrain:)
                                                userInfo: nil
                                                 repeats: YES];
    NSTimer *mueve;
    mueve = [NSTimer scheduledTimerWithTimeInterval: 15
                                             target: self
                                           selector: @selector(mueveLOStrain:)
                                           userInfo: nil
                                            repeats: YES];
    NSTimer *detecta;
    detecta = [NSTimer scheduledTimerWithTimeInterval: 0.01
                                               target: self
                                             selector: @selector(colision:)
                                             userInfo: nil
                                              repeats: YES];
    int x = 0;
    int y = 0;
    if (dificultad == 1){
        int limAbajo = (0+250);
        int limArriba = (741-250);
        x = limAbajo + arc4random() % (limArriba - limAbajo);
        limAbajo = (0+180);
        limArriba = (421-180);
        y = limAbajo + arc4random() % (limArriba - limAbajo);
    }
    [self.target setFrame:CGRectMake(x, y, 30, 30)];
    [self.target setHidden:NO];

}

-(void)cronometroLOStrain:(NSTimer *)cronometro{
    if (finJuego){
        [cronometro invalidate];
    }
    else{
       [self.contador setStringValue:[NSString stringWithFormat:@"%i",(cronom-1)]];
        if (cronom <= 0){finJuego = YES;}
    }
    cronom --;
}

-(void)mueveLOStrain:(NSTimer *)mueve{
    if (finJuego){
        [mueve invalidate];
    }
    else{
        if (self.target.hidden){[self.target setHidden:NO];}
        int x = 0;
        int y = 0;
        if (dificultad == 1){
            int limAbajo = (0+250);
            int limArriba = (741-250);
            x = limAbajo + arc4random() % (limArriba - limAbajo);
            limAbajo = (0+180);
            limArriba = (421-180);
            y = limAbajo + arc4random() % (limArriba - limAbajo);
        }
        if (dificultad == 2){
            int limAbajo = (0+200);
            int limArriba = (741-200);
            x = limAbajo + arc4random() % (limArriba - limAbajo);
            limAbajo = (0+100);
            limArriba = (421-100);
            y = limAbajo + arc4random() % (limArriba - limAbajo);
        }
        if (dificultad == 3){
            int limAbajo = (0+200);
            int limArriba = (741-200);
            x = limAbajo + arc4random() % (limArriba - limAbajo);
            limAbajo = (0+100);
            limArriba = (421-100);
            y = limAbajo + arc4random() % (limArriba - limAbajo);
        }
    [self.target setFrame:CGRectMake(x, y, 30, 30)];
    }
    posibletotal ++;
    impactoContado = NO;
}

-(void)colision:(NSTimer *)detecta{
    if (finJuego){
        [detecta invalidate];
        [self.target setHidden:YES];
        [self.contador setHidden:YES];
        [self.pararLOS setHidden:YES];
        NSAlert *alert = [[NSAlert alloc] init];
        [self modoNormal:self];
        NSString *userLocale = [[NSLocale currentLocale] localeIdentifier];
        NSString *userLanguage = [userLocale substringToIndex:2];
        if([userLanguage isEqualToString:@"es"]){
            [alert setMessageText:@"Entrenamiento LOS Terminado"];
            [alert setInformativeText:[NSString stringWithFormat:@"Puntuación: %i sobre %i\rSe vuelve al modo libre",puntuacion,(posibletotal-1)]];
        }
        else{
            [alert setMessageText:@"LOS Training Finished"];
            [alert setInformativeText:[NSString stringWithFormat:@"Score: %i over %i\rGo back to free mode",puntuacion,posibletotal]];
        }
        [alert addButtonWithTitle:@"OK"];
        if ([alert runModal] == NSAlertFirstButtonReturn){
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"MenuModoActivo"
             object:nil];
        }
        
    }
    //Detección de colisiones
    else
    {
        if(CGRectIntersectsRect(self.target.frame, self.Posicion.frame)){
           // NSLog(@"Impacto: %i Puntos: %i",contacto, puntuacion);
            contacto ++;
            if (!impactoContado){
                if (contacto >(100)){
                    puntuacion ++;
                    impactoContado = YES;
                    [self.target setHidden:YES];
                    NSSound *contactosound = [NSSound soundNamed:@"contacto"];
                    [contactosound play];
                }
                }
            else {
                contacto = 0;
            }
        }

    }
}

//Otras acciones (de inicio fundamentalmente botones y del sistema)

- (IBAction)terminarLOSentreno:(id)sender{
    [self.pararLOS setHidden:YES];
    finJuego = YES;
}



-(void)reconecta:(id)sender{
    if(!enprueba){
        if(self.reconexion.hidden){
            [self.reconexion setHidden:NO];
        }
    }
    else{
        NSString *userLocale = [[NSLocale currentLocale] localeIdentifier];
        NSString *userLanguage = [userLocale substringToIndex:2];
        if([userLanguage isEqualToString:@"es"]){
            [self.Titulo setStringValue:@"ERROR EN PRUEBA: CONEXION PERDIDA"];
            [self.instrucciones setStringValue:@" "];
        }
        else {
            [self.instrucciones setStringValue:@" "];
            [self.Titulo setStringValue:@"ERROR DURING TEST: CONNECTION LOSS"];
        }
    }
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)windowWillClose:(NSNotification *)notification
{
    NSWindow *win = [notification object];
    if ([win.title isEqualToString:@"RombergLab"]){
    if (wii) {
        [wii closeConnection];
    }
    }
    
    
}

- (void)cerrarApp:(NSNotification *)notification{
    if (wii) {
        [wii closeConnection];
    }
    [[NSApplication sharedApplication] terminate:nil];
}


- (IBAction)conecta:(id)sender {
    NSString *userLocale = [[NSLocale currentLocale] localeIdentifier];
    NSString *userLanguage = [userLocale substringToIndex:2];
    
    if(!discovery) {
        discovery = [[WiiRemoteDiscovery alloc] init];
        [discovery setDelegate:self];
        [discovery start];
        
        
        if([userLanguage isEqualToString:@"es"]){
            [self.status setStringValue:@"Conectando..."];
            [self.instrucciones setStringValue:@"Pulse el boton rojo SYNC en la tabla. Desenlace la tabla del menú Bluetooth del sistema."];
            [self.reconexion setTitle:@"Dejar de buscar"];
            [self.Titulo setStringValue:@"Paso 1: Enlazar la tabla"];

        }
        else {
            [self.status setStringValue:@"Connecting..."];
            [self.Titulo setStringValue:@"Step 1: Link the board"];
            [self.instrucciones setStringValue:@"Press the SYNC red button in the board. Unlink the Board on the Bluetooth system menu."];
            [self.reconexion setTitle:@"Stop searching"];
        }
        [self.rueda startAnimation:self];
        
    }
    else {
        [discovery stop];
        discovery = nil;
        
        if(wii) {
            [wii closeConnection];
            wii = nil;
        }
        [self.rueda stopAnimation:self];
        [self.BT setImage:[NSImage imageNamed:@"BT_OF"]];
        if([userLanguage isEqualToString:@"es"]){
            [self.status setStringValue:@"Desconectado"];
            [self.instrucciones setStringValue:@""];
            [self.reconexion setTitle:@"Buscar tablas"];
        }
        else {
            [self.status setStringValue:@"Disconnected"];
            [self.instrucciones setStringValue:@""];
            [self.reconexion setTitle:@"Start search"];
        }
    }
}

- (IBAction)calibrar:(id)sender {
    tare = 0.0 - lastWeight;
    [self.ArrDer setHidden:NO];
    [self.ArrIzq setHidden:NO];
    [self.AbaDer setHidden:NO];
    [self.AbaIzq setHidden:NO];
    [self.Posicion setHidden:NO];
    [self.InfoY setHidden:YES];
    [self.InfoX setHidden:YES];
    [self.calibracion setHidden:YES];
    [self.grabarLibre setHidden:NO];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"MenuModoActivo"
     object:nil];
    NSString *userLocale = [[NSLocale currentLocale] localeIdentifier];
    NSString *userLanguage = [userLocale substringToIndex:2];
    if([userLanguage isEqualToString:@"es"]){
        [self.status setStringValue:@"Operativa"];
        [self.instrucciones setStringValue:@"Suba a la tabla"];
        [self.Titulo setStringValue:@"Registro en modo libre: Cambie de modo en el menú"];
    }
    else {
        [self.status setStringValue:@"Operative"];
        [self.instrucciones setStringValue:@"Step on board"];
        [self.Titulo setStringValue:@"Free Mode ON: Set new mode on menu bar"];
    }
}

- (IBAction)accionGrabarLibre:(id)sender {

    if(grabarLibreON){
        //Termina la grabacion
        enprueba = NO;
        NSStoryboard *storyBoard = [NSStoryboard storyboardWithName:@"Main" bundle:nil]; // get a reference to the storyboard
        myWindowController = [storyBoard instantiateControllerWithIdentifier:@"SegundaVentana"]; // instantiate your window controller
        [myWindowController showWindow:self];
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"ResultadosLibres"
         object:datoslibres];
        [datoslibres removeAllObjects];
        NSString *userLocale = [[NSLocale currentLocale] localeIdentifier];
        NSString *userLanguage = [userLocale substringToIndex:2];
        if([userLanguage isEqualToString:@"es"]){
            [self.grabarLibre setTitle:@"Iniciar registro"];
        }
        else {
            [self.grabarLibre setTitle:@"Start recording"];
        }
        grabarLibreON = NO;
    }
    else{
        //Inicia la grabacion
        enprueba = YES;
        grabarLibreON = YES;
        [datoslibres removeAllObjects];
        NSTimer *grabarlibre;
        grabarlibre = [NSTimer scheduledTimerWithTimeInterval: 0.025
                                               target: self
                                            selector: @selector(grabandoLibre:)
                                             userInfo: nil
                                              repeats: YES];
    
        
        NSString *userLocale = [[NSLocale currentLocale] localeIdentifier];
        NSString *userLanguage = [userLocale substringToIndex:2];
        if([userLanguage isEqualToString:@"es"]){
            [self.grabarLibre setTitle:@"Parar registro"];
        }
        else {
            [self.grabarLibre setTitle:@"Stop recording"];
        }
    }
    
}

-(void)grabandoLibre:(NSTimer *)grabarlibre{
    if (!grabarLibre2){
        // Estructura en Datos [Modo de prograna, Estampa de tiempo, Peso total calibrado, Centro de gravedad x, centro de gravedad y]
        
        [datoslibres addObject:[NSArray arrayWithObjects:[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:Tstamp],[NSNumber numberWithFloat:(lastWeight+tare)],[NSNumber numberWithFloat:COGX],[NSNumber numberWithFloat:COGY],nil]];
    }
    else {
        [grabarlibre invalidate];
        grabarLibre2 = YES;
    }
}


///CONEXION CON CLASES DE WII


#pragma mark WiiRemoteDelegate methods (optional)

// cooked values from the Balance Beam
- (void) balanceBeamKilogramsChangedTopRight:(float)topRight
                                 bottomRight:(float)bottomRight
                                     topLeft:(float)topLeft
                                  bottomLeft:(float)bottomLeft {
    
    lastWeight = topRight + bottomRight + topLeft + bottomLeft;
    
    float trueWeight = lastWeight + tare;
    //NSLog(@"Peso: %f",trueWeight);
    
    if(trueWeight > 0.1) {
        
        arribaderecha = topRight;
        arribaizquierda = topLeft;
        abajoizquierda = bottomLeft;
        abajoderecha = bottomRight;

        }
    else {
        arribaderecha = 0;
        arribaizquierda = 0;
        abajoizquierda = 0;
        abajoderecha = 0;
    }
    float arde,ariz,abde,abiz;
    
    if  (arribaizquierda > 25) ariz = 25;
    else ariz = arribaizquierda;
    if  (arribaderecha > 25) arde = 25;
    else arde = arribaderecha;
    if  (abajoizquierda > 25) abiz = 25;
    else abiz = abajoizquierda;
    if  (abajoderecha > 25) abde = 25;
    else abde = abajoderecha;
    
    ariz = 1.4*ariz;
    arde = 1.4*arde;
    abiz = 1.4*abiz;
    abde = 1.4*abde;
    
    
    [self.ArrIzq setFrame:CGRectMake(580, 39, ariz, ariz)];
    [self.ArrDer setFrame:CGRectMake(614, 39, arde, arde)];
    [self.AbaIzq setFrame:CGRectMake(580, 5, abiz, abiz)];
    [self.AbaDer setFrame:CGRectMake(614, 5, abde, abde)];
    
    //Calculo COG
    
    BOOL E = NO;
    float FuX,FuY,FuT,T1;
    if(trueWeight > 10){
        [self.instrucciones setStringValue:@""];
        FuX = 9.8 * ((arribaderecha+abajoderecha)-(arribaizquierda+abajoizquierda));
        FuY = 9.8 * ((arribaderecha+arribaizquierda)-(abajoderecha+abajoizquierda));
        FuT = 9.8 * (arribaderecha+abajoderecha+arribaizquierda+abajoizquierda);
        T1 = [Tiempo timeIntervalSinceNow]*-1;
        COGX =((FuX*(0.022022345)*(21.48547))/FuT);
        COGY =((FuY*(0.022022345)*(12.21421))/FuT);
    }
    else{
        E = YES;
        problema = YES;
        COGX = 0;
        COGY = 0;
        T1 = [Tiempo timeIntervalSinceNow]*-1;
    }
    Tstamp = T1;
    //DIBUJA LA POSICION (Ratio tamaño tabla 1,759 - Ratio tamaño ventana)
    
    if (!E) COGX = (COGX*820)+10;
    if (!E) COGY = (COGY*820)+15;
    float Px,Py;
    Px = ((741/2)-(30/2))+COGX ; //742 ancho del view 30 ancho del cuadrado.
    Py = ((421/2)-(30/2))+COGY ;
    [self.Posicion setFrame:CGRectMake(Px, Py, 30, 30)];
    [self.InfoX setStringValue:[NSString stringWithFormat:@"X: %.2f",COGX]];
    [self.InfoY setStringValue:[NSString stringWithFormat:@"Y: %.2f",COGY]];
    //NSLog(@"%f",[wii batteryLevel]); //Carga alta: 0.973958. Carga media: 0.979167. Carga Baja: 0.973958 SIN SENTIDO

}

#pragma mark WiiRemoteDelegate methods

- (void) buttonChanged:(WiiButtonType) type isPressed:(BOOL) isPressed
{
//    [self doTare:self]; NO QUEREMOS BOTON DE CALIBRAR
}

- (void) wiiRemoteDisconnected:(IOBluetoothDevice*) device
{
    [device closeConnection];
    NSSound *conectado = [NSSound soundNamed:@"Disconnect"];
    [conectado play];
    [self.reconexion setHidden:NO];
    [self.calibracion setHidden:YES];
    NSString *userLocale = [[NSLocale currentLocale] localeIdentifier];
    NSString *userLanguage = [userLocale substringToIndex:2];
    if([userLanguage isEqualToString:@"es"]){
        [self.status setStringValue:@"Desconectado"];
        [self.instrucciones setStringValue:@""];
        [self.reconexion setTitle:@"REINICIAR"];
    }
    else {
        [self.status setStringValue:@"Disconnected"];
        [self.instrucciones setStringValue:@""];
        [self.reconexion setTitle:@"RESTART"];
        
    }
    [self.BT setImage:[NSImage imageNamed:@"BT_FF"]];
}

#pragma mark Magic?

- (void)expansionPortChanged:(NSNotification *)nc{
    
    WiiRemote* tmpWii = (WiiRemote*)[nc object];
    
    // Check that the Wiimote reporting is the one we're connected to.
    if (![[tmpWii address] isEqualToString:[wii address]]){
        return;
    }
    
    if ([wii isExpansionPortAttached]){
        [wii setExpansionPortEnabled:YES];
    }	
}

#pragma mark WiiRemoteDiscoveryDelegate methods

- (void) WiiRemoteDiscovered:(WiiRemote*)wiimote {
    
    NSString *userLocale = [[NSLocale currentLocale] localeIdentifier];
    NSString *userLanguage = [userLocale substringToIndex:2];
    wii = wiimote;
    [wii setDelegate:self];
    NSSound *conectado = [NSSound soundNamed:@"Success"];
    [conectado play];
    [self.rueda stopAnimation:self];
    [self.BT setImage:[NSImage imageNamed:@"BT_ON"]];
    [self.calibracion setHidden:NO];
    [self.reconexion setHidden:YES];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ConexiónApagada"
     object:nil];
    if([userLanguage isEqualToString:@"es"]){
        [self.status setStringValue:@"Conectado"];
        [self.instrucciones setStringValue:@"Listo para calibrar, deje la platafoma sobre el suelo, pulse calibrar, AUN NO SE SUBA"];
        [self.Titulo setStringValue:@"Paso 2: Calibrar"];
        [self.calibracion setTitle:@"Calibrar"];
    }
    else {
        [self.status setStringValue:@"Connected"];
        [self.instrucciones setStringValue:@"Ready to calibrate, put board on the floor, push calibrate, DO NOT STEP ON BOARD"];
        [self.Titulo setStringValue:@"Step 2: Calibrate"];
        [self.calibracion setTitle:@"Calibrate"];
    }
}

- (void) WiiRemoteDiscoveryError:(int)code {
    NSLog(@"Error: %u", code);
    int error = 3758097101;
    if (code == error){
        if (acumulo > 3){
            acumulo = -15;
        NSAlert *alert = [[NSAlert alloc] init];
        NSString *userLocale = [[NSLocale currentLocale] localeIdentifier];
        NSString *userLanguage = [userLocale substringToIndex:2];
        if([userLanguage isEqualToString:@"es"]){
            [alert setMessageText:@"Problema con la configuración Bluetooth."];
            [alert setInformativeText:@"Debería abrir la configuración bluetooth en las preferencias del sistema y eliminar la conexion con la Tabla de equilibrio de la lista de dispositivos enlazados (es aconsejable salir de este programa)"];
        }
        else{
            [alert setMessageText:@"Bluetooth configuration problem"];
            [alert setInformativeText:@"You should open the bluethoot configuration panel on system settings and erase the connection with the Balance board item contained on the linked devices list (probably you need to close this program)"];
        }
        [alert addButtonWithTitle:@"OK"];
        [alert runModal];
    }
        acumulo ++;
    }
    // Keep trying...
    [self.rueda stopAnimation:self];
    [discovery stop];
    sleep(1);
    [discovery start];
    [self.rueda startAnimation:self];
    
}

- (void) willStartWiimoteConnections {
    
}
@end
