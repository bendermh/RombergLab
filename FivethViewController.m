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
    int age = (rawAge/(365*24*60*60));
    NSLog(@"Under construction age: %i height:%i",height,age);
    float areaUno = A1;
    float areaDos = A2;
    float areaTres = A3;
    float areaCuatro = A4;
    //Scores
    NSArray *TestScores = [self getScores:areaUno :areaDos :areaTres :areaCuatro];
    float scGlob = [TestScores[0] floatValue];
    float scVest = [TestScores[1] floatValue];
    float scVis = [TestScores[2] floatValue];
    float scSomat = [TestScores[3] floatValue];
    float scInt = [TestScores[4] floatValue];
    //Normalized limits
    //Fit in table range
    if (age < 18) {age = 18;}
    if (age > 68) {age = 68;}
    if (height < 150) {height = 150;}
    if (height > 193) {height = 193;}
    //
    NSArray *TestNormals = [self getNormalValues:age :height];
    float limGlob = [TestNormals[0] floatValue];
    float limVest = [TestNormals[1] floatValue];
    float limVis = [TestNormals[2] floatValue];
    float limSomat = [TestNormals[3] floatValue];
    //Check falls
    //****NOT implemented
    NSLog(@"Global: %f over %f Vestibular:%f over %f Visual:%f over %f Somat:%f over %f",scGlob,limGlob,scVest,limVest,scVis,limVis,scSomat,limSomat);
    NSLog(@"Inconsistent: %f",scInt);
}
//Scores calculation method
-(NSArray *)getScores:(float)area1 :(float)area2 :(float)area3 :(float)area4{
    //Conditions Normalization
    float scoreUno = ((35.87-(area1-3.95))/(35.87));
    float scoreDos = ((40.03-(area2-3.74))/(40.03));
    float scoreTres = ((179.33-(area3-19.18))/(179.33));
    float scoreCuatro = ((743.22-(area4-39.11))/(743.22));
    //Global score
    float ScoreGlobal = ((scoreUno+scoreDos+scoreTres+scoreCuatro)/4);
    //Pre systems scores
    float preScoreVestibular = (scoreCuatro/scoreUno);
    float preScoreVisual = ((scoreTres+scoreCuatro)/(scoreUno+scoreDos));
    float preScoreSomatosensorial = ((scoreDos+scoreCuatro)/(scoreUno+scoreTres));
    //Normalized system scores
    float ScoreVestibular = ((67.50-(preScoreVestibular-3.61))/(67.50-3.61));
    float ScoreVisual = ((33.71-(preScoreVisual-3.04))/(33.71-3.04));
    float ScoreSomatosensorial = ((8.34-(preScoreSomatosensorial-1.01))/(8.43-1.01));
    //By default integrity is allways ok, future implementation goes heare
    float ScoreIntegrity = 1.0f;
    NSArray *Scores = [NSArray arrayWithObjects:[NSNumber numberWithFloat:ScoreGlobal],[NSNumber numberWithFloat:ScoreVestibular],[NSNumber numberWithFloat:ScoreVisual],[NSNumber numberWithFloat:ScoreSomatosensorial],[NSNumber numberWithFloat:ScoreIntegrity],nil];
    return Scores;
}
-(NSArray *)getNormalValues:(int)age :(int)height{
    float limiteGlobal = 0.0f;
    float limiteVestibular = 0.0f;
    float limiteVisual = 0.0f;
    float limiteSomatosensorial = 0.0f;
    //TABULATION 18-68 150-193
    int ageGroup = 1;
    int heightGroup = 1;
    //Age Gropups
    if (age >17 && age <34){
        ageGroup = 4;
    }
    else if (age > 33 && age <46){
        ageGroup = 2;
        
    }
    else if (age > 45 && age <55) {
        ageGroup = 1;
    }
    else if ( age > 54 && age <69) {
        ageGroup = 3;
    }
    //Height groups
    if (height >149 && height <165){
        heightGroup = 4;
    }
    else if (height > 164 && height <176){
        heightGroup = 3;
        
    }
    else if (height > 175 && height <184) {
        heightGroup = 1;
    }
    else if ( height > 183 && height <194) {
        heightGroup = 2;
    }
    NSLog(@"AgeGroup: %i HeightGroup: %i",ageGroup,heightGroup);
    //Get limits from calculated groups
    limiteGlobal = [self limiteGlobal:ageGroup :heightGroup];
    limiteVestibular = [self limiteVestibular:ageGroup :heightGroup];
    limiteVisual = [self limiteVisual:ageGroup :heightGroup];
    limiteSomatosensorial = [self limiteSomatosensorial:ageGroup :heightGroup];
    //Send array of limits as method result
    NSArray *Limits = [NSArray arrayWithObjects:[NSNumber numberWithFloat:limiteGlobal],[NSNumber numberWithFloat:limiteVestibular],[NSNumber numberWithFloat:limiteVisual],[NSNumber numberWithFloat:limiteSomatosensorial], nil];
    return Limits;
}
-(float)limiteGlobal:(int)ageGroup :(int)heightGroup{
    float limite = 0.0f;
    int agePos = ageGroup-1;
    int heightPos = heightGroup-1;
    //Limit Calculation
    //Matrix definition from statistical clinical trial
    float globalMeanMatrix[4][4];
    globalMeanMatrix[0][0] = 0.503f;
    globalMeanMatrix[0][1] = 0.370f;
    globalMeanMatrix[0][2] = 0.616f;
    globalMeanMatrix[0][3] = 0.789f;
    globalMeanMatrix[1][0] = 0.691f;
    globalMeanMatrix[1][1] = 0.712f;
    globalMeanMatrix[1][2] = 0.732f;
    globalMeanMatrix[1][3] = 0.808f;
    globalMeanMatrix[2][0] = 0.495f;
    globalMeanMatrix[2][1] = 0.335f;
    globalMeanMatrix[2][2] = 0.592f;
    globalMeanMatrix[2][3] = 0.678f;
    globalMeanMatrix[3][0] = 0.703f;
    globalMeanMatrix[3][1] = 0.596f;
    globalMeanMatrix[3][2] = 0.801f;
    globalMeanMatrix[3][3] = 0.830f;
    float globalSdMatrix[4][4];
    globalSdMatrix[0][0] = 0.214f;
    globalSdMatrix[0][1] = 0.282f;
    globalSdMatrix[0][2] = 0.283f;
    globalSdMatrix[0][3] = 0.134f;
    globalSdMatrix[1][0] = 0.165f;
    globalSdMatrix[1][1] = 0.096f;
    globalSdMatrix[1][2] = 0.215f;
    globalSdMatrix[1][3] = 0.164f;
    globalSdMatrix[2][0] = 0.265f;
    globalSdMatrix[2][1] = 0.219f;
    globalSdMatrix[2][2] = 0.220f;
    globalSdMatrix[2][3] = 0.176f;
    globalSdMatrix[3][0] = 0.138f;
    globalSdMatrix[3][1] = 0.183f;
    globalSdMatrix[3][2] = 0.153f;
    globalSdMatrix[3][3] = 0.154f;
    //Limit Calculation
    limite = (globalMeanMatrix[agePos][heightPos]-2*(globalSdMatrix[agePos][heightPos]));
    return limite;
}
-(float)limiteVestibular:(int)ageGroup :(int)heightGroup{
    float limite = 0.0f;
    int agePos = ageGroup-1;
    int heightPos = heightGroup-1;
    //Limit Calculation
    //Matrix definition from statistical clinical trial
    float vestibularMeanMatrix[4][4];
    vestibularMeanMatrix[0][0] = 1.044f;
    vestibularMeanMatrix[0][1] = 1.085f;
    vestibularMeanMatrix[0][2] = 1.055f;
    vestibularMeanMatrix[0][3] = 1.056f;
    vestibularMeanMatrix[1][0] = 1.056f;
    vestibularMeanMatrix[1][1] = 1.016f;
    vestibularMeanMatrix[1][2] = 1.067f;
    vestibularMeanMatrix[1][3] = 1.071f;
    vestibularMeanMatrix[2][0] = 1.065f;
    vestibularMeanMatrix[2][1] = 1.025f;
    vestibularMeanMatrix[2][2] = 1.028f;
    vestibularMeanMatrix[2][3] = 1.051f;
    vestibularMeanMatrix[3][0] = 1.072f;
    vestibularMeanMatrix[3][1] = 1.042f;
    vestibularMeanMatrix[3][2] = 1.064f;
    vestibularMeanMatrix[3][3] = 1.074f;
    float vestibularSdMatrix[4][4];
    //Adjusted if < 0.05 then  = 0.05
    vestibularSdMatrix[0][0] = 0.050f;
    vestibularSdMatrix[0][1] = 0.050f;
    vestibularSdMatrix[0][2] = 0.067f;
    vestibularSdMatrix[0][3] = 0.050f;
    vestibularSdMatrix[1][0] = 0.050f;
    vestibularSdMatrix[1][1] = 0.050f;
    vestibularSdMatrix[1][2] = 0.050f;
    vestibularSdMatrix[1][3] = 0.050f;
    vestibularSdMatrix[2][0] = 0.050f;
    vestibularSdMatrix[2][1] = 0.063f;
    vestibularSdMatrix[2][2] = 0.066f;
    vestibularSdMatrix[2][3] = 0.058f;
    vestibularSdMatrix[3][0] = 0.050f;
    vestibularSdMatrix[3][1] = 0.074f;
    vestibularSdMatrix[3][2] = 0.050f;
    vestibularSdMatrix[3][3] = 0.050f;
    //Limit Calculation
    limite = (vestibularMeanMatrix[agePos][heightPos]-2*(vestibularSdMatrix[agePos][heightPos]));
    return limite;
}
-(float)limiteVisual:(int)ageGroup :(int)heightGroup{
    float limite = 0.0f;
    int agePos = ageGroup-1;
    int heightPos = heightGroup-1;
    //Limit Calculation
    //Matrix definition from statistical clinical trial
    float visualMeanMatrix[4][4];
    visualMeanMatrix[0][0] = 0.796f;
    visualMeanMatrix[0][1] = 0.990f;
    visualMeanMatrix[0][2] = 0.778f;
    visualMeanMatrix[0][3] = 0.700f;
    visualMeanMatrix[1][0] = 0.756f;
    visualMeanMatrix[1][1] = 0.787f;
    visualMeanMatrix[1][2] = 0.873f;
    visualMeanMatrix[1][3] = 0.812f;
    visualMeanMatrix[2][0] = 0.750f;
    visualMeanMatrix[2][1] = 0.735f;
    visualMeanMatrix[2][2] = 0.615f;
    visualMeanMatrix[2][3] = 0.756f;
    visualMeanMatrix[3][0] = 0.811f;
    visualMeanMatrix[3][1] = 0.463f;
    visualMeanMatrix[3][2] = 0.785f;
    visualMeanMatrix[3][3] = 0.874f;
    float visualSdMatrix[4][4];
    //adjusted id > 0.2 = 0.2
    visualSdMatrix[0][0] = 0.200f;
    visualSdMatrix[0][1] = 0.155f;
    visualSdMatrix[0][2] = 0.200f;
    visualSdMatrix[0][3] = 0.200f;
    visualSdMatrix[1][0] = 0.200f;
    visualSdMatrix[1][1] = 0.200f;
    visualSdMatrix[1][2] = 0.200f;
    visualSdMatrix[1][3] = 0.200f;
    visualSdMatrix[2][0] = 0.200f;
    visualSdMatrix[2][1] = 0.200f;
    visualSdMatrix[2][2] = 0.200f;
    visualSdMatrix[2][3] = 0.200f;
    visualSdMatrix[3][0] = 0.200f;
    visualSdMatrix[3][1] = 0.200f;
    visualSdMatrix[3][2] = 0.200f;
    visualSdMatrix[3][3] = 0.200f;
    //Limit Calculation
    limite = (visualMeanMatrix[agePos][heightPos]-2*(visualSdMatrix[agePos][heightPos]));
    return limite;
}
-(float)limiteSomatosensorial:(int)ageGroup :(int)heightGroup{
    float limite = 0.0f;
    int agePos = ageGroup-1;
    int heightPos = heightGroup-1;
    //Limit Calculation
    //Matrix definition from statistical clinical trial
    float somatosensorialMeanMatrix[4][4];
    somatosensorialMeanMatrix[0][0] = 0.668f;
    somatosensorialMeanMatrix[0][1] = 1.045f;
    somatosensorialMeanMatrix[0][2] = 0.778f;
    somatosensorialMeanMatrix[0][3] = 0.786f;
    somatosensorialMeanMatrix[1][0] = 0.777f;
    somatosensorialMeanMatrix[1][1] = 0.428f;
    somatosensorialMeanMatrix[1][2] = 0.868f;
    somatosensorialMeanMatrix[1][3] = 0.906f;
    somatosensorialMeanMatrix[2][0] = 0.868f;
    somatosensorialMeanMatrix[2][1] = 0.490f;
    somatosensorialMeanMatrix[2][2] = 0.535f;
    somatosensorialMeanMatrix[2][3] = 0.742f;
    somatosensorialMeanMatrix[3][0] = 0.918f;
    somatosensorialMeanMatrix[3][1] = 0.670f;
    somatosensorialMeanMatrix[3][2] = 0.852f;
    somatosensorialMeanMatrix[3][3] = 0.938f;
    float somatosensorialSdMatrix[4][4];
    //adjusted if > 0.2 = 0.2 and if < 0.05 = 0.05
    somatosensorialSdMatrix[0][0] = 0.200f;
    somatosensorialSdMatrix[0][1] = 0.050f;
    somatosensorialSdMatrix[0][2] = 0.200f;
    somatosensorialSdMatrix[0][3] = 0.200f;
    somatosensorialSdMatrix[1][0] = 0.200f;
    somatosensorialSdMatrix[1][1] = 0.200f;
    somatosensorialSdMatrix[1][2] = 0.200f;
    somatosensorialSdMatrix[1][3] = 0.200f;
    somatosensorialSdMatrix[2][0] = 0.187f;
    somatosensorialSdMatrix[2][1] = 0.200f;
    somatosensorialSdMatrix[2][2] = 0.200f;
    somatosensorialSdMatrix[2][3] = 0.200f;
    somatosensorialSdMatrix[3][0] = 0.156f;
    somatosensorialSdMatrix[3][1] = 0.200f;
    somatosensorialSdMatrix[3][2] = 0.200f;
    somatosensorialSdMatrix[3][3] = 0.193f;
    //Limit Calculation
    limite = (somatosensorialMeanMatrix[agePos][heightPos]-2*(somatosensorialSdMatrix[agePos][heightPos]));
    return limite;
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
