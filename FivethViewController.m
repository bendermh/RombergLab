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
@property (weak) IBOutlet NSTextField *globalScoreValue;
@property (weak) IBOutlet NSTextField *betaInfo;
@property (weak) IBOutlet NSTextField *externalData;

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
    
    if (@available(macOS 10.13, *)) {[self.barGlobal setFillColor:[NSColor greenColor]];}
    if (@available(macOS 10.13, *)) {[self.barVestibular setFillColor:[NSColor greenColor]];}
    if (@available(macOS 10.13, *)) {[self.barVisual setFillColor:[NSColor greenColor]];}
    if (@available(macOS 10.13, *)) {[self.barSomatic setFillColor:[NSColor greenColor]];}
    if (@available(macOS 10.13, *)) {[self.barConsistency setFillColor:[NSColor greenColor]];}
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
    //get age and height
    int height = [self.fieldHeight.stringValue intValue];
    NSDate *today = [NSDate date];
    NSDate *birth = self.fieldBirthday.dateValue;
    NSTimeInterval rawAge = [today timeIntervalSinceDate:birth];
    int age = (rawAge/(365*24*60*60));
    NSLog(@"Under construction age: %i height:%i",age,height);
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
//  Put results in view
    int sc = round(scGlob*100);
//    Check for NaN values
    if (limGlob != limGlob){limGlob = 0;}
    if (limVest != limVest){limVest = 0;}
    if (limVis != limVis){limVis = 0;}
    if (limSomat != limSomat){limSomat = 0;}
//    output results
    self.globalScoreValue.stringValue = [NSString stringWithFormat:@"%i/100",sc];
    self.barGlobal.floatValue = scGlob;
    if (scGlob-limGlob > 0){
        [self.barVestibular setHidden:TRUE];
        [self.barVisual setHidden:TRUE];
        [self.barSomatic setHidden:TRUE];
        [self.barConsistency setHidden:TRUE];
        if (@available(macOS 10.13, *)) {[self.barGlobal setFillColor:[NSColor greenColor]];}
        if (@available(macOS 10.13, *)) {[self.barVestibular setFillColor:[NSColor greenColor]];}
        if (@available(macOS 10.13, *)) {[self.barVisual setFillColor:[NSColor greenColor]];}
        if (@available(macOS 10.13, *)) {[self.barSomatic setFillColor:[NSColor greenColor]];}
        if (@available(macOS 10.13, *)) {[self.barConsistency setFillColor:[NSColor greenColor]];}
    }
    else {
        [self.barVestibular setHidden:FALSE];
        [self.barVisual setHidden:FALSE];
        [self.barSomatic setHidden:FALSE];
        [self.barConsistency setHidden:FALSE];
        if (@available(macOS 10.13, *)) {[self.barGlobal setFillColor:[NSColor redColor]];}
        if (@available(macOS 10.13, *)) {[self.barVestibular setFillColor:[NSColor greenColor]];}
        if (@available(macOS 10.13, *)) {[self.barVisual setFillColor:[NSColor greenColor]];}
        if (@available(macOS 10.13, *)) {[self.barSomatic setFillColor:[NSColor greenColor]];}
        if (@available(macOS 10.13, *)) {[self.barConsistency setFillColor:[NSColor greenColor]];}
        self.barVestibular.floatValue = scVest;
        self.barVisual.floatValue = scVis;
        self.barSomatic.floatValue = scSomat;
        self.barConsistency.floatValue = scInt;
        if(scVest-limVest < 0){
            if (@available(macOS 10.13, *)) {[self.barVestibular setFillColor:[NSColor redColor]];}
        }
        if(scVis-limVis < 0) {
            if (@available(macOS 10.13, *)) {[self.barVisual setFillColor:[NSColor redColor]];}
        }
        if(scSomat-limSomat < 0){
            if (@available(macOS 10.13, *)) {[self.barSomatic setFillColor:[NSColor redColor]];}
        }
        if(scInt < 0.2){
            if (@available(macOS 10.13, *)) {[self.barConsistency setFillColor:[NSColor redColor]];}
        }
    }
    self.betaInfo.stringValue = [NSString stringWithFormat:@"Global: %f/%f Vestibular:%f/%f Visual:%f/%f Somat:%f/%f",scGlob,limGlob,scVest,limVest,scVis,limVis,scSomat,limSomat];
}
//Scores calculation method
-(NSArray *)getScores:(float)area1 :(float)area2 :(float)area3 :(float)area4{
    //Conditions Normalization
    float scoreUno = (((35.87)-(area1-3.95))/(35.87));
    float scoreDos = ((40.03-(area2-3.74))/(40.03));
    float scoreTres = ((179.33-(area3-19.18))/(179.33));
    float scoreCuatro = ((743.22-(area4-39.11))/(743.22));
    //Falls & Negative Counting
    if (_buttonCondition1.state == TRUE) {scoreUno = -4;}
    if (_buttonCondition2.state == TRUE) {scoreDos = -4;}
    if (_buttonCondition3.state == TRUE) {scoreTres = -4;}
    if (_buttonCondition4.state == TRUE) {scoreCuatro = -4;}
    //Global score
    float ScoreGlobal = ((scoreUno+scoreDos+scoreTres+scoreCuatro)/4);
    float ScoreVestibular = scoreCuatro;
    float ScoreVisual = scoreTres;
    float ScoreSomatosensorial = scoreDos;
    //Integrity
    float ScoreIntegrity = 0;
    if (scoreCuatro != 0){
        ScoreIntegrity = (scoreUno/scoreCuatro);
        
    }
    else {
        ScoreIntegrity = (scoreUno/0.1f);
    }
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
    //Modifications: If mean <0.5 is corrected to = 0.5
    //Modifications: If SD > 0.2 is corrected to 0.2
    float globalMeanMatrix[4][4];
    globalMeanMatrix[0][0] = 0.503f;
    globalMeanMatrix[0][1] = 0.500f;
    globalMeanMatrix[0][2] = 0.616f;
    globalMeanMatrix[0][3] = 0.789f;
    globalMeanMatrix[1][0] = 0.691f;
    globalMeanMatrix[1][1] = 0.712f;
    globalMeanMatrix[1][2] = 0.732f;
    globalMeanMatrix[1][3] = 0.808f;
    globalMeanMatrix[2][0] = 0.500f;
    globalMeanMatrix[2][1] = 0.500f;
    globalMeanMatrix[2][2] = 0.592f;
    globalMeanMatrix[2][3] = 0.678f;
    globalMeanMatrix[3][0] = 0.703f;
    globalMeanMatrix[3][1] = 0.596f;
    globalMeanMatrix[3][2] = 0.801f;
    globalMeanMatrix[3][3] = 0.830f;
    float globalSdMatrix[4][4];
    globalSdMatrix[0][0] = 0.200f;
    globalSdMatrix[0][1] = 0.200f;
    globalSdMatrix[0][2] = 0.200f;
    globalSdMatrix[0][3] = 0.134f;
    globalSdMatrix[1][0] = 0.165f;
    globalSdMatrix[1][1] = 0.096f;
    globalSdMatrix[1][2] = 0.200f;
    globalSdMatrix[1][3] = 0.164f;
    globalSdMatrix[2][0] = 0.200f;
    globalSdMatrix[2][1] = 0.200f;
    globalSdMatrix[2][2] = 0.220f;
    globalSdMatrix[2][3] = 0.176f;
    globalSdMatrix[3][0] = 0.138f;
    globalSdMatrix[3][1] = 0.183f;
    globalSdMatrix[3][2] = 0.153f;
    globalSdMatrix[3][3] = 0.154f;
    //Limit Calculation
    limite = (globalMeanMatrix[agePos][heightPos]-(globalSdMatrix[agePos][heightPos]));
    return limite;
}
-(float)limiteVestibular:(int)ageGroup :(int)heightGroup{
    float limite = 0.0f;
    int agePos = ageGroup-1;
    int heightPos = heightGroup-1;
    //Limit Calculation
    //Matrix definition from statistical clinical trial
    float vestibularMeanMatrix[4][4];
    vestibularMeanMatrix[0][0] = 1.000f;
    vestibularMeanMatrix[0][1] = 0.720f;
    vestibularMeanMatrix[0][2] = 1.000f;
    vestibularMeanMatrix[0][3] = 1.000f;
    vestibularMeanMatrix[1][0] = 1.000f;
    vestibularMeanMatrix[1][1] = 0.720f;
    vestibularMeanMatrix[1][2] = 1.000f;
    vestibularMeanMatrix[1][3] = 1.000f;
    vestibularMeanMatrix[2][0] = 1.000f;
    vestibularMeanMatrix[2][1] = 0.720f;
    vestibularMeanMatrix[2][2] = 1.000f;
    vestibularMeanMatrix[2][3] = 1.000f;
    vestibularMeanMatrix[3][0] = 1.000f;
    vestibularMeanMatrix[3][1] = 0.720f;
    vestibularMeanMatrix[3][2] = 1.000f;
    vestibularMeanMatrix[3][3] = 1.000f;
    float vestibularSdMatrix[4][4];
    vestibularSdMatrix[0][0] = 0.300f;
    vestibularSdMatrix[0][1] = 0.300f;
    vestibularSdMatrix[0][2] = 0.300f;
    vestibularSdMatrix[0][3] = 0.300f;
    vestibularSdMatrix[1][0] = 0.300f;
    vestibularSdMatrix[1][1] = 0.300f;
    vestibularSdMatrix[1][2] = 0.300f;
    vestibularSdMatrix[1][3] = 0.300f;
    vestibularSdMatrix[2][0] = 0.300f;
    vestibularSdMatrix[2][1] = 0.300f;
    vestibularSdMatrix[2][2] = 0.300f;
    vestibularSdMatrix[2][3] = 0.300f;
    vestibularSdMatrix[3][0] = 0.300f;
    vestibularSdMatrix[3][1] = 0.300f;
    vestibularSdMatrix[3][2] = 0.300f;
    vestibularSdMatrix[3][3] = 0.300f;
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
    visualMeanMatrix[0][0] = 0.950f;
    visualMeanMatrix[0][1] = 0.750f;
    visualMeanMatrix[0][2] = 0.950f;
    visualMeanMatrix[0][3] = 1.010f;
    visualMeanMatrix[1][0] = 0.950f;
    visualMeanMatrix[1][1] = 0.750f;
    visualMeanMatrix[1][2] = 0.950f;
    visualMeanMatrix[1][3] = 1.010f;
    visualMeanMatrix[2][0] = 0.950f;
    visualMeanMatrix[2][1] = 0.750f;
    visualMeanMatrix[2][2] = 0.950f;
    visualMeanMatrix[2][3] = 1.010f;
    visualMeanMatrix[3][0] = 0.950f;
    visualMeanMatrix[3][1] = 0.750f;
    visualMeanMatrix[3][2] = 0.950f;
    visualMeanMatrix[3][3] = 1.010f;
    float visualSdMatrix[4][4];
    visualSdMatrix[0][0] = 0.300f;
    visualSdMatrix[0][1] = 0.300f;
    visualSdMatrix[0][2] = 0.300f;
    visualSdMatrix[0][3] = 0.300f;
    visualSdMatrix[1][0] = 0.300f;
    visualSdMatrix[1][1] = 0.300f;
    visualSdMatrix[1][2] = 0.300f;
    visualSdMatrix[1][3] = 0.300f;
    visualSdMatrix[2][0] = 0.300f;
    visualSdMatrix[2][1] = 0.300f;
    visualSdMatrix[2][2] = 0.300f;
    visualSdMatrix[2][3] = 0.300f;
    visualSdMatrix[3][0] = 0.300f;
    visualSdMatrix[3][1] = 0.300f;
    visualSdMatrix[3][2] = 0.300f;
    visualSdMatrix[3][3] = 0.300f;
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
    somatosensorialMeanMatrix[0][0] = 1.009f;
    somatosensorialMeanMatrix[0][1] = 1.009f;
    somatosensorialMeanMatrix[0][2] = 1.009f;
    somatosensorialMeanMatrix[0][3] = 1.009f;
    somatosensorialMeanMatrix[1][0] = 1.009f;
    somatosensorialMeanMatrix[1][1] = 1.009f;
    somatosensorialMeanMatrix[1][2] = 1.009f;
    somatosensorialMeanMatrix[1][3] = 1.009f;
    somatosensorialMeanMatrix[2][0] = 1.009f;
    somatosensorialMeanMatrix[2][1] = 1.009f;
    somatosensorialMeanMatrix[2][2] = 1.009f;
    somatosensorialMeanMatrix[2][3] = 1.009f;
    somatosensorialMeanMatrix[3][0] = 1.009f;
    somatosensorialMeanMatrix[3][1] = 1.009f;
    somatosensorialMeanMatrix[3][2] = 1.009f;
    somatosensorialMeanMatrix[3][3] = 1.009f;

    float somatosensorialSdMatrix[4][4];
    //adjusted if > 0.2 = 0.2 and if < 0.05 = 0.05
    somatosensorialSdMatrix[0][0] = 0.300f;
    somatosensorialSdMatrix[0][1] = 0.300f;
    somatosensorialSdMatrix[0][2] = 0.300f;
    somatosensorialSdMatrix[0][3] = 0.300f;
    somatosensorialSdMatrix[1][0] = 0.300f;
    somatosensorialSdMatrix[1][1] = 0.300f;
    somatosensorialSdMatrix[1][2] = 0.300f;
    somatosensorialSdMatrix[1][3] = 0.300f;
    somatosensorialSdMatrix[2][0] = 0.300f;
    somatosensorialSdMatrix[2][1] = 0.300f;
    somatosensorialSdMatrix[2][2] = 0.300f;
    somatosensorialSdMatrix[2][3] = 0.300f;
    somatosensorialSdMatrix[3][0] = 0.300f;
    somatosensorialSdMatrix[3][1] = 0.300f;
    somatosensorialSdMatrix[3][2] = 0.300f;
    somatosensorialSdMatrix[3][3] = 0.300f;
    //Limit Calculation
    limite = (somatosensorialMeanMatrix[agePos][heightPos]-2*(somatosensorialSdMatrix[agePos][heightPos]));
    return limite;
}

-(void)analiza:(NSNotification*)notificacion{
    NSString *isReal = [notificacion.userInfo objectForKey:@"isReal"];
    if ([isReal  isEqual: @"true"]){
    // se ejecuta si viene de posturografía
    isRealPostur = true;
        [self.externalData setHidden:true];
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
    }
    else {
        isRealPostur = false;
        [self.externalData setHidden:false];
        NSArray *importedAreas = (NSArray *)notificacion.object;
        A1 = [[importedAreas objectAtIndex:0]floatValue];
        A2 = [[importedAreas objectAtIndex:1]floatValue];
        A3 = [[importedAreas objectAtIndex:2]floatValue];
        A4 = [[importedAreas objectAtIndex:3]floatValue];
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
