//
//  FivethViewController.m
//  RombergLab
//
//  Created by Jorge Rey Martinez on 4/9/17.
//  Copyright © 2017 ARK. All rights reserved.
//

#import "FivethViewController.h"

@interface FivethViewController ()
@property (weak) IBOutlet NSTextField *labelDate;
@property (weak) IBOutlet NSDateFormatter *formatterDate;
@property (weak) IBOutlet NSButton *buttonCondition1;
@property (weak) IBOutlet NSButton *buttonCondition2;
@property (weak) IBOutlet NSButton *buttonCondition3;
@property (weak) IBOutlet NSButton *buttonCondition4;
@property (weak) IBOutlet NSDatePicker *fieldBirthday;
@property (weak) IBOutlet NSTextField *fieldHeight;
@property (weak) IBOutlet NSLevelIndicator *barGlobal;
@property (weak) IBOutlet NSLevelIndicator *barVestibular;
@property (weak) IBOutlet NSLevelIndicator *barVisual;
@property (weak) IBOutlet NSLevelIndicator *barSomatic;
@property (weak) IBOutlet NSLevelIndicator *barConsistency;
@property (weak) IBOutlet NSView *areaReport;

@end

@implementation FivethViewController

@synthesize datos;
@synthesize datosCondicion1;
@synthesize datosCondicion2;
@synthesize datosCondicion3;
@synthesize datosCondicion4;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(analiza:)
                                                 name:@"InformePosturografia"
                                               object:nil];
    
//Date set
    NSDate *today = [NSDate date];
    self.labelDate.stringValue = [self.formatterDate stringFromDate:today];
}
- (IBAction)buttonCalculate:(id)sender {
    if ([self Validate]) {
        [self creaInforme];
    }
    else {
        NSAlert *alert = [[NSAlert alloc] init];
        NSString *userLocale = [[NSLocale currentLocale] localeIdentifier];
        NSString *userLanguage = [userLocale substringToIndex:2];
        if([userLanguage isEqualToString:@"es"]){
            [alert setMessageText:@"Campos introducidos incorrectos"];
            [alert setInformativeText:@"Los campos de edad o altura (en centímetros) están incompletos o no son válidos. Estos campos no pueden estar vacíos"];
        }
        else{
            [alert setMessageText:@"Not valid data"];
            [alert setInformativeText:@"Age or height (in centimeters) are incorrect or empty. These fields can not be empty."];
        }
        [alert addButtonWithTitle:@"OK"];
        [alert runModal];
    }
}
- (IBAction)buttonSavePNG:(id)sender {
    //De elemnto a imagen
    NSSize imgSize = self.areaReport.bounds.size;
    NSBitmapImageRep * rep = [self.areaReport bitmapImageRepForCachingDisplayInRect:[self.areaReport bounds]];
    [rep setSize:imgSize];
    [self.areaReport cacheDisplayInRect:[self.areaReport bounds] toBitmapImageRep:rep];
    NSData* data = [rep representationUsingType:NSPNGFileType properties:@{}];
    //Guardar imagen
    NSSavePanel * savePanel = [NSSavePanel savePanel];
    [savePanel setAllowedFileTypes:@[@"png"]];
    [savePanel setDirectoryURL:[NSURL fileURLWithPath:NSHomeDirectory()]];
    [savePanel beginSheetModalForWindow:[[self view] window] completionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            [savePanel orderOut:self]; //Cerrar el panel
            [data writeToURL:savePanel.URL atomically:YES];
        }
    }];
}

-(bool)Validate{
    //get age and height
    int height = [self.fieldHeight.stringValue intValue];
    NSDate *today = [NSDate date];
    NSDate *birth = self.fieldBirthday.dateValue;
    NSTimeInterval rawAge = [today timeIntervalSinceDate:birth];
    int Age = (rawAge/(365*24*60*60));
    //validation
    if (height > 60 && Age > 3) {
        if (height < 250 && Age < 150) {
            return true;
        }
        else{
            return false;
        }
    }
    return false;
}

//metod to compute scores
-(void)creaInforme{
    // ACORDARSE DE LAS CAIDAS
    
    //get age and height
    int height = [self.fieldHeight.stringValue intValue];
    NSDate *today = [NSDate date];
    NSDate *birth = self.fieldBirthday.dateValue;
    NSTimeInterval rawAge = [today timeIntervalSinceDate:birth];
    int Age = (rawAge/(365*24*60*60));
    
    NSLog(@"Under construction age: %i height:%i",height,Age);
}

-(void)analiza:(NSNotification*)notificacion{
    
    //Metodo para cargar los datos en esta clase
    datos = (NSMutableArray *)notificacion.object;
    datosCondicion1 = [NSMutableArray array];
    datosCondicion2 = [NSMutableArray array];
    datosCondicion3 = [NSMutableArray array];
    datosCondicion4 = [NSMutableArray array];
    
    
    NSMutableArray *DatosX = [NSMutableArray array];
    NSMutableArray *DatosY = [NSMutableArray array];
    NSMutableArray *Modo = [NSMutableArray array];
    float Prueba;
    
    for (int i = 0;i < [datos count];i++){
        [DatosX addObject:datos[i][3]];
        [DatosY addObject:datos[i][4]];
        [Modo addObject:datos[i][0]];
    }
    
    for (int i = 0;i < [datos count];i++){
        
        Prueba = [[Modo objectAtIndex:i] floatValue];
        if(Prueba == 3.1f){
            float valorX = [[DatosX objectAtIndex:i] doubleValue];
            float valorY = [[DatosY objectAtIndex:i] doubleValue];
            [datosCondicion1 addObject:[NSValue valueWithPoint:NSMakePoint(valorX, valorY)]];
        }
        if(Prueba == 3.2f){
            float valorX = [[DatosX objectAtIndex:i] doubleValue];
            float valorY = [[DatosY objectAtIndex:i] doubleValue];
            [datosCondicion2 addObject:[NSValue valueWithPoint:NSMakePoint(valorX, valorY)]];
        }
        if(Prueba == 3.3f){
            float valorX = [[DatosX objectAtIndex:i] doubleValue];
            float valorY = [[DatosY objectAtIndex:i] doubleValue];
            [datosCondicion3 addObject:[NSValue valueWithPoint:NSMakePoint(valorX, valorY)]];
        }
        if(Prueba == 3.4f){
            float valorX = [[DatosX objectAtIndex:i] doubleValue];
            float valorY = [[DatosY objectAtIndex:i] doubleValue];
            [datosCondicion4 addObject:[NSValue valueWithPoint:NSMakePoint(valorX, valorY)]];
        }
    }
    
    A1 = 0.0f;
    A2 = 0.0f;
    A3 = 0.0f;
    A4 = 0.0f;
    
    if ([datosCondicion1 count]){
        [self AreaUno];
    }
    if ([datosCondicion2 count]){
        [self AreaDos];
    }
    if ([datosCondicion3 count]){
        [self AreaTres];
    }
    if ([datosCondicion4 count]){
        [self AreaCuatro];
    }
    if(A1+A2+A3+A4>0){
        NSLog(@"Areas: %0.2f %0.2f %0.2f %0.2f", A1, A2, A3, A4);
    }
    else{
        NSLog(@"NO AREAS");
    }
}

//AREAS CALCULATION THE SAME AS THIRD VIEW CONTROLLER

-(void) AreaUno{
    
    NSMutableArray *DatosX = [NSMutableArray array];
    NSMutableArray *DatosY = [NSMutableArray array];
    
    for (int i = 0;i < [datosCondicion1 count];i++){
        NSValue *nx = [datosCondicion1 objectAtIndex:i];
        NSPoint cord = nx.pointValue;
        double x = cord.x;
        double y = cord.y;
        [DatosX addObject:[NSNumber numberWithDouble:x]];
        [DatosY addObject:[NSNumber numberWithDouble:y]];
    }
    
    double meanx = [[DatosX valueForKeyPath:@"@avg.self"]doubleValue];
    double meany = [[DatosY valueForKeyPath:@"@avg.self"]doubleValue];
    
    NSMutableArray *nfx = [NSMutableArray array];
    NSMutableArray *nfy = [NSMutableArray array];
    NSMutableArray *xy  = [NSMutableArray array];
    double sumaxy = 0.0f;
    
    //Obtener las normalizaciones
    for (int i = 0;i<[DatosX count];i++){
        double nx = [[DatosX objectAtIndex:i]doubleValue] - meanx;
        double ny = [[DatosY objectAtIndex:i]doubleValue] - meany;
        [nfx addObject:[NSNumber numberWithDouble:nx]];
        [nfy addObject:[NSNumber numberWithDouble:ny]];
    }
    
    //nuevo array con los elemntos de x e y multiplicados
    for (int i = 0;i<[nfx count];i++){
        double mxy = [[nfx objectAtIndex:i]doubleValue]*[[nfy objectAtIndex:i]doubleValue];
        [xy addObject:[NSNumber numberWithDouble:mxy]];
    }
    
    //suma de los elementos del array nuevo
    for (int i = 0;i<[xy count];i++){
        sumaxy = sumaxy + [[xy objectAtIndex:i] doubleValue];
    }
    
    //COVARIANZA
    float covxy = (sumaxy)/([nfx  count]-1);
    
    
    //Varianza de X y Varianza de Y
    
    NSMutableArray *varx = [NSMutableArray array];
    NSMutableArray *vary = [NSMutableArray array];
    
    for (int i = 0;i<[DatosX count];i++){
        double nx = [[DatosX objectAtIndex:i]doubleValue] - meanx;
        double ny = [[DatosY objectAtIndex:i]doubleValue] - meany;
        [varx addObject:[NSNumber numberWithDouble:(nx*nx)]];
        [vary addObject:[NSNumber numberWithDouble:(ny*ny)]];
    }
    
    double sumny = 0.0f;
    double sumnx = 0.0f;
    
    for (int i = 0;i<[varx count];i++){
        sumnx = sumnx + [[varx objectAtIndex:i] doubleValue];
        sumny = sumny + [[vary objectAtIndex:i] doubleValue];
    }
    
    double varX = sumnx/([varx count]-1);
    double varY = sumny/([vary count]-1);
    
    ///LA MATRIX DE COVARIANZA ES [(varX),(covxy):(covyx),(vary)]---[(1.1),(1.2):(2.1),(2.2)]
    //Ahora calculamos los valores propios o "eigenvaluen"
    
    double L1 = (((varX+varY)+(sqrt((4*(covxy*covxy))+(pow(varX-varY,2)))))/2);
    double L2 = (((varX+varY)-(sqrt((4*(covxy*covxy))+(pow(varX-varY,2)))))/2);
    
    
    //AND THE AREA !!! assuming a confidence of 0.9
    
    double chi = 0.2107f;//(inverse of the chi-square cumulative distribution function with 2 degrees of freedom at P . GET IN MATLAB = chi2inv((1-0.9),2))
    
    double area = M_PI*chi*(sqrt(L1)*sqrt(L2));
    
    A1 = area;
}
-(void) AreaDos{
    
    NSMutableArray *DatosX = [NSMutableArray array];
    NSMutableArray *DatosY = [NSMutableArray array];
    
    for (int i = 0;i < [datosCondicion2 count];i++){
        NSValue *nx = [datosCondicion2 objectAtIndex:i];
        NSPoint cord = nx.pointValue;
        double x = cord.x;
        double y = cord.y;
        [DatosX addObject:[NSNumber numberWithDouble:x]];
        [DatosY addObject:[NSNumber numberWithDouble:y]];
    }
    
    double meanx = [[DatosX valueForKeyPath:@"@avg.self"]doubleValue];
    double meany = [[DatosY valueForKeyPath:@"@avg.self"]doubleValue];
    
    NSMutableArray *nfx = [NSMutableArray array];
    NSMutableArray *nfy = [NSMutableArray array];
    NSMutableArray *xy  = [NSMutableArray array];
    double sumaxy = 0.0f;
    
    //Obtener las normalizaciones
    for (int i = 0;i<[DatosX count];i++){
        double nx = [[DatosX objectAtIndex:i]doubleValue] - meanx;
        double ny = [[DatosY objectAtIndex:i]doubleValue] - meany;
        [nfx addObject:[NSNumber numberWithDouble:nx]];
        [nfy addObject:[NSNumber numberWithDouble:ny]];
    }
    
    //nuevo array con los elemntos de x e y multiplicados
    for (int i = 0;i<[nfx count];i++){
        double mxy = [[nfx objectAtIndex:i]doubleValue]*[[nfy objectAtIndex:i]doubleValue];
        [xy addObject:[NSNumber numberWithDouble:mxy]];
    }
    
    //suma de los elementos del array nuevo
    for (int i = 0;i<[xy count];i++){
        sumaxy = sumaxy + [[xy objectAtIndex:i] doubleValue];
    }
    
    //COVARIANZA
    float covxy = (sumaxy)/([nfx  count]-1);
    
    
    //Varianza de X y Varianza de Y
    
    NSMutableArray *varx = [NSMutableArray array];
    NSMutableArray *vary = [NSMutableArray array];
    
    for (int i = 0;i<[DatosX count];i++){
        double nx = [[DatosX objectAtIndex:i]doubleValue] - meanx;
        double ny = [[DatosY objectAtIndex:i]doubleValue] - meany;
        [varx addObject:[NSNumber numberWithDouble:(nx*nx)]];
        [vary addObject:[NSNumber numberWithDouble:(ny*ny)]];
    }
    
    double sumny = 0.0f;
    double sumnx = 0.0f;
    
    for (int i = 0;i<[varx count];i++){
        sumnx = sumnx + [[varx objectAtIndex:i] doubleValue];
        sumny = sumny + [[vary objectAtIndex:i] doubleValue];
    }
    
    double varX = sumnx/([varx count]-1);
    double varY = sumny/([vary count]-1);
    
    ///LA MATRIX DE COVARIANZA ES [(varX),(covxy):(covyx),(vary)]---[(1.1),(1.2):(2.1),(2.2)]
    //Ahora calculamos los valores propios o "eigenvaluen"
    
    double L1 = (((varX+varY)+(sqrt((4*(covxy*covxy))+(pow(varX-varY,2)))))/2);
    double L2 = (((varX+varY)-(sqrt((4*(covxy*covxy))+(pow(varX-varY,2)))))/2);
    
    
    //AND THE AREA !!! assuming a confidence of 0.9
    
    double chi = 0.2107f;//(inverse of the chi-square cumulative distribution function with 2 degrees of freedom at P . GET IN MATLAB = chi2inv((1-0.9),2))
    
    double area = M_PI*chi*(sqrt(L1)*sqrt(L2));
    
    A2 = area;
}
-(void) AreaTres{
    
    NSMutableArray *DatosX = [NSMutableArray array];
    NSMutableArray *DatosY = [NSMutableArray array];
    
    for (int i = 0;i < [datosCondicion3 count];i++){
        NSValue *nx = [datosCondicion3 objectAtIndex:i];
        NSPoint cord = nx.pointValue;
        double x = cord.x;
        double y = cord.y;
        [DatosX addObject:[NSNumber numberWithDouble:x]];
        [DatosY addObject:[NSNumber numberWithDouble:y]];
    }
    
    double meanx = [[DatosX valueForKeyPath:@"@avg.self"]doubleValue];
    double meany = [[DatosY valueForKeyPath:@"@avg.self"]doubleValue];
    
    NSMutableArray *nfx = [NSMutableArray array];
    NSMutableArray *nfy = [NSMutableArray array];
    NSMutableArray *xy  = [NSMutableArray array];
    double sumaxy = 0.0f;
    
    //Obtener las normalizaciones
    for (int i = 0;i<[DatosX count];i++){
        double nx = [[DatosX objectAtIndex:i]doubleValue] - meanx;
        double ny = [[DatosY objectAtIndex:i]doubleValue] - meany;
        [nfx addObject:[NSNumber numberWithDouble:nx]];
        [nfy addObject:[NSNumber numberWithDouble:ny]];
    }
    
    //nuevo array con los elemntos de x e y multiplicados
    for (int i = 0;i<[nfx count];i++){
        double mxy = [[nfx objectAtIndex:i]doubleValue]*[[nfy objectAtIndex:i]doubleValue];
        [xy addObject:[NSNumber numberWithDouble:mxy]];
    }
    
    //suma de los elementos del array nuevo
    for (int i = 0;i<[xy count];i++){
        sumaxy = sumaxy + [[xy objectAtIndex:i] doubleValue];
    }
    
    //COVARIANZA
    float covxy = (sumaxy)/([nfx  count]-1);
    
    
    //Varianza de X y Varianza de Y
    
    NSMutableArray *varx = [NSMutableArray array];
    NSMutableArray *vary = [NSMutableArray array];
    
    for (int i = 0;i<[DatosX count];i++){
        double nx = [[DatosX objectAtIndex:i]doubleValue] - meanx;
        double ny = [[DatosY objectAtIndex:i]doubleValue] - meany;
        [varx addObject:[NSNumber numberWithDouble:(nx*nx)]];
        [vary addObject:[NSNumber numberWithDouble:(ny*ny)]];
    }
    
    double sumny = 0.0f;
    double sumnx = 0.0f;
    
    for (int i = 0;i<[varx count];i++){
        sumnx = sumnx + [[varx objectAtIndex:i] doubleValue];
        sumny = sumny + [[vary objectAtIndex:i] doubleValue];
    }
    
    double varX = sumnx/([varx count]-1);
    double varY = sumny/([vary count]-1);
    
    ///LA MATRIX DE COVARIANZA ES [(varX),(covxy):(covyx),(vary)]---[(1.1),(1.2):(2.1),(2.2)]
    //Ahora calculamos los valores propios o "eigenvaluen"
    
    double L1 = (((varX+varY)+(sqrt((4*(covxy*covxy))+(pow(varX-varY,2)))))/2);
    double L2 = (((varX+varY)-(sqrt((4*(covxy*covxy))+(pow(varX-varY,2)))))/2);
    
    
    //AND THE AREA !!! assuming a confidence of 0.9
    
    double chi = 0.2107f;//(inverse of the chi-square cumulative distribution function with 2 degrees of freedom at P . GET IN MATLAB = chi2inv((1-0.9),2))
    
    double area = M_PI*chi*(sqrt(L1)*sqrt(L2));
    
    A3 = area;
}

-(void) AreaCuatro{
    
    NSMutableArray *DatosX = [NSMutableArray array];
    NSMutableArray *DatosY = [NSMutableArray array];
    
    for (int i = 0;i < [datosCondicion4 count];i++){
        NSValue *nx = [datosCondicion4 objectAtIndex:i];
        NSPoint cord = nx.pointValue;
        double x = cord.x;
        double y = cord.y;
        [DatosX addObject:[NSNumber numberWithDouble:x]];
        [DatosY addObject:[NSNumber numberWithDouble:y]];
    }
    
    double meanx = [[DatosX valueForKeyPath:@"@avg.self"]doubleValue];
    double meany = [[DatosY valueForKeyPath:@"@avg.self"]doubleValue];
    
    NSMutableArray *nfx = [NSMutableArray array];
    NSMutableArray *nfy = [NSMutableArray array];
    NSMutableArray *xy  = [NSMutableArray array];
    double sumaxy = 0.0f;
    
    //Obtener las normalizaciones
    for (int i = 0;i<[DatosX count];i++){
        double nx = [[DatosX objectAtIndex:i]doubleValue] - meanx;
        double ny = [[DatosY objectAtIndex:i]doubleValue] - meany;
        [nfx addObject:[NSNumber numberWithDouble:nx]];
        [nfy addObject:[NSNumber numberWithDouble:ny]];
    }
    
    //nuevo array con los elemntos de x e y multiplicados
    for (int i = 0;i<[nfx count];i++){
        double mxy = [[nfx objectAtIndex:i]doubleValue]*[[nfy objectAtIndex:i]doubleValue];
        [xy addObject:[NSNumber numberWithDouble:mxy]];
    }
    
    //suma de los elementos del array nuevo
    for (int i = 0;i<[xy count];i++){
        sumaxy = sumaxy + [[xy objectAtIndex:i] doubleValue];
    }
    
    //COVARIANZA
    float covxy = (sumaxy)/([nfx  count]-1);
    
    
    //Varianza de X y Varianza de Y
    
    NSMutableArray *varx = [NSMutableArray array];
    NSMutableArray *vary = [NSMutableArray array];
    
    for (int i = 0;i<[DatosX count];i++){
        double nx = [[DatosX objectAtIndex:i]doubleValue] - meanx;
        double ny = [[DatosY objectAtIndex:i]doubleValue] - meany;
        [varx addObject:[NSNumber numberWithDouble:(nx*nx)]];
        [vary addObject:[NSNumber numberWithDouble:(ny*ny)]];
    }
    
    double sumny = 0.0f;
    double sumnx = 0.0f;
    
    for (int i = 0;i<[varx count];i++){
        sumnx = sumnx + [[varx objectAtIndex:i] doubleValue];
        sumny = sumny + [[vary objectAtIndex:i] doubleValue];
    }
    
    double varX = sumnx/([varx count]-1);
    double varY = sumny/([vary count]-1);
    
    ///LA MATRIX DE COVARIANZA ES [(varX),(covxy):(covyx),(vary)]---[(1.1),(1.2):(2.1),(2.2)]
    //Ahora calculamos los valores propios o "eigenvaluen"
    
    double L1 = (((varX+varY)+(sqrt((4*(covxy*covxy))+(pow(varX-varY,2)))))/2);
    double L2 = (((varX+varY)-(sqrt((4*(covxy*covxy))+(pow(varX-varY,2)))))/2);
    
    
    //AND THE AREA !!! assuming a confidence of 0.9
    
    double chi = 0.2107f;//(inverse of the chi-square cumulative distribution function with 2 degrees of freedom at P . GET IN MATLAB = chi2inv((1-0.9),2))
    
    double area = M_PI*chi*(sqrt(L1)*sqrt(L2));
    
    A4 = area;
}



@end
