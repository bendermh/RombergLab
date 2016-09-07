//
//  ThirdViewController.m
//  RombergLab
//
//  Created by Jorge on 3/12/15.
//  Copyright © 2015 ARK. All rights reserved.
//

#import "ThirdViewController.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController
@synthesize datos;
@synthesize datosGrafico1;
@synthesize datosGrafico2;
@synthesize datosGrafico3;
@synthesize datosGrafico4;
@synthesize areafoto;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(analiza:)
                                                 name:@"ResultadosPosturografia"
                                               object:nil];
    
}

-(void)analiza:(NSNotification*)notificacion{
    
    datos = (NSMutableArray *)notificacion.object;
    
    //Metodo para cargar los datos en esta clase
    datos = (NSMutableArray *)notificacion.object;
    datosGrafico1 = [NSMutableArray array];
    datosGrafico2 = [NSMutableArray array];
    datosGrafico3 = [NSMutableArray array];
    datosGrafico4 = [NSMutableArray array];

    
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
            [datosGrafico1 addObject:[NSValue valueWithPoint:NSMakePoint(valorX, valorY)]];
        }
        if(Prueba == 3.2f){
            float valorX = [[DatosX objectAtIndex:i] doubleValue];
            float valorY = [[DatosY objectAtIndex:i] doubleValue];
            [datosGrafico2 addObject:[NSValue valueWithPoint:NSMakePoint(valorX, valorY)]];
        }
        if(Prueba == 3.3f){
            float valorX = [[DatosX objectAtIndex:i] doubleValue];
            float valorY = [[DatosY objectAtIndex:i] doubleValue];
            [datosGrafico3 addObject:[NSValue valueWithPoint:NSMakePoint(valorX, valorY)]];
        }
        if(Prueba == 3.4f){
            float valorX = [[DatosX objectAtIndex:i] doubleValue];
            float valorY = [[DatosY objectAtIndex:i] doubleValue];
            [datosGrafico4 addObject:[NSValue valueWithPoint:NSMakePoint(valorX, valorY)]];
        }
    }
    
    A1 = 0.0f;
    A2 = 0.0f;
    A3 = 0.0f;
    A4 = 0.0f;
    
    if ([datosGrafico1 count]){
        [self GraficarUno];
        [self AreaUno];
    }
    if ([datosGrafico2 count]){
        [self GraficarDos];
        [self AreaDos];
    }
    if ([datosGrafico3 count]){
        [self GraficarTres];
        [self AreaTres];
    }
    if ([datosGrafico4 count]){
        [self GraficarCuatro];
        [self AreaCuatro];
    }
    if(A1+A2+A3+A4>0){
        [self.AreaCocientes setStringValue:[NSString stringWithFormat:@"VIS (Romberg coef.):%0.3f    VES (C1/C2): %0.3f",((A1+A3)/(A2+A4))*100,(A1/A2)*100]];
    }
}

-(void) AreaUno{
    
    NSMutableArray *DatosX = [NSMutableArray array];
    NSMutableArray *DatosY = [NSMutableArray array];
    
    for (int i = 0;i < [datosGrafico1 count];i++){
        NSValue *nx = [datosGrafico1 objectAtIndex:i];
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
    
    [self.area setStringValue:[NSString stringWithFormat:@"Area 1: %0.2f",area]];
    
}
-(void) AreaDos{
    
    NSMutableArray *DatosX = [NSMutableArray array];
    NSMutableArray *DatosY = [NSMutableArray array];
    
    for (int i = 0;i < [datosGrafico2 count];i++){
        NSValue *nx = [datosGrafico2 objectAtIndex:i];
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
    
    [self.area2 setStringValue:[NSString stringWithFormat:@"Area 2: %0.2f",area]];
    
}
-(void) AreaTres{
    
    NSMutableArray *DatosX = [NSMutableArray array];
    NSMutableArray *DatosY = [NSMutableArray array];
    
    for (int i = 0;i < [datosGrafico3 count];i++){
        NSValue *nx = [datosGrafico3 objectAtIndex:i];
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
    
    [self.area3 setStringValue:[NSString stringWithFormat:@"Area 3: %0.2f",area]];
    
}

-(void) AreaCuatro{
    
    NSMutableArray *DatosX = [NSMutableArray array];
    NSMutableArray *DatosY = [NSMutableArray array];
    
    for (int i = 0;i < [datosGrafico4 count];i++){
        NSValue *nx = [datosGrafico4 objectAtIndex:i];
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
    
    [self.area4 setStringValue:[NSString stringWithFormat:@"Area 4: %0.2f",area]];
    
}


-(void) GraficarUno{
    
    // We need a hostview, you can create one in IB (and create an outlet) or just do this:
    CGRect frame = [self.AreaGrafico bounds];
    CPTGraphHostingView* hostView = [[CPTGraphHostingView alloc] initWithFrame:frame];
    [self.AreaGrafico addSubview: hostView];
    
    // Create a CPTGraph object and add to hostView
    CPTGraph* graph = [[CPTXYGraph alloc] initWithFrame:hostView.bounds];
    hostView.hostedGraph = graph;
    
    // Set graph title
    NSString *userLocale = [[NSLocale currentLocale] localeIdentifier];
    NSString *userLanguage = [userLocale substringToIndex:2];
    NSString *title = @" ";
    if([userLanguage isEqualToString:@"es"]){
        title = @"1. Ojos abiertos, superficie dura";
    }
    else{
        title = @"1. Eyes open, no foam";
    }
    graph.title = title;
    // 3 - Create and set text style
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor blackColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 16.0f;
    graph.titleTextStyle = titleStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, 22.0f);
    
    
    // Get the (default) plotspace from the graph so we can set its x/y ranges
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    
    //Sangrias del grafico
    graph.plotAreaFrame.paddingTop = 5.0f;
    graph.plotAreaFrame.paddingRight = 2.0f;
    graph.plotAreaFrame.paddingBottom = 5.0f;
    graph.plotAreaFrame.paddingLeft = 2.0f;
    
    //COLOR DE FONDO
    //Color de fondo
    graph.plotAreaFrame.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:0 green:0 blue:0 alpha:0]];
    
    //Definir estilos de lineas (grafico y ejes)
    
    // Create a line style that we will apply to the axis and data line (no).
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineColor = [CPTColor blackColor];
    lineStyle.lineWidth = 1.0f;
    
    //Para la linea del grafico
    CPTMutableLineStyle *lineStyle2 = [CPTMutableLineStyle lineStyle];
    lineStyle2.lineColor = [CPTColor purpleColor];
    lineStyle2.lineWidth = 1.75f;
    
    //REJILLA
    CPTMutableLineStyle *lineStyle3 = [CPTMutableLineStyle lineStyle];
    lineStyle3.lineColor = [CPTColor grayColor];
    lineStyle3.lineWidth = 0.25f;
    
    // Create a text style that we will use for the axis labels.
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.fontName = @"Helvetica";
    textStyle.fontSize = 10;
    textStyle.color = [CPTColor blackColor];
    
    // Create the plot symbol we're going to use.
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol diamondPlotSymbol];
    plotSymbol.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    plotSymbol.lineStyle = lineStyle2;
    plotSymbol.size = CGSizeMake(9.0, 9.0);
    
    //Limites del gráfico
    
    float xAxisMin = -310;
    float xAxisMax = 310;
    float yAxisMin = -200;
    float yAxisMax = 200;
    
    // Note that these CPTPlotRange are defined by START and LENGTH (not START and END) !!
    // We modify the graph's plot space to setup the axis' min / max values.
    
    [plotSpace setXRange: [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:(xAxisMin)] length:[NSNumber numberWithFloat:(xAxisMax-xAxisMin)]]];
    
    [plotSpace setYRange: [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:(yAxisMin)] length:[NSNumber numberWithFloat:(yAxisMax-yAxisMin)]]];
    plotSpace.allowsUserInteraction = YES;
    
    //EJES
    
    // Modify the graph's axis with a label, line style, etc.
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) graph.axisSet;
    //axisSet.xAxis.title = @"Position";
    axisSet.xAxis.titleTextStyle = textStyle;
    axisSet.xAxis.titleOffset = -20.0f;
    axisSet.xAxis.titleLocation = [NSDecimalNumber decimalNumberWithString:(@"200.0")];
    //axisSet.xAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    axisSet.xAxis.labelingPolicy = CPTAxisLabelingPolicyFixedInterval;
    axisSet.xAxis.axisLineStyle = lineStyle;
    axisSet.xAxis.majorTickLineStyle = lineStyle;
    axisSet.xAxis.minorTickLineStyle = lineStyle;
    axisSet.xAxis.labelTextStyle = textStyle;
    axisSet.xAxis.labelOffset = 1.0f;
    axisSet.xAxis.majorIntervalLength = [NSNumber numberWithFloat:(100.0f)];
    axisSet.xAxis.minorTicksPerInterval = 1;
    axisSet.xAxis.minorTickLength = 5.0f;
    axisSet.xAxis.majorTickLength = 7.0f;
    axisSet.xAxis.majorGridLineStyle = lineStyle3;
    axisSet.xAxis.minorGridLineStyle = lineStyle3;
    axisSet.xAxis.tickDirection= CPTSignPositive;
    //Formatear los números de los ejes (quitar decimales)
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setGeneratesDecimalNumbers:NO];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    axisSet.xAxis.labelFormatter = formatter;
    
    //axisSet.yAxis.title = @"Position";
    axisSet.yAxis.titleTextStyle = textStyle;
    axisSet.yAxis.titleOffset = -20.0f;
    axisSet.yAxis.titleLocation = [NSDecimalNumber decimalNumberWithString:(@"152.0")];
    axisSet.yAxis.axisLineStyle = lineStyle;
    axisSet.yAxis.majorTickLineStyle = lineStyle;
    axisSet.yAxis.minorTickLineStyle = lineStyle;
    axisSet.yAxis.labelTextStyle = textStyle;
    axisSet.yAxis.labelOffset = 1.0f;
    axisSet.yAxis.majorIntervalLength = [NSNumber numberWithFloat:(100.0f)];
    axisSet.yAxis.minorTicksPerInterval = 1;
    axisSet.yAxis.minorTickLength = 5.0f;
    axisSet.yAxis.majorTickLength = 7.0f;
    axisSet.yAxis.majorGridLineStyle = lineStyle3;
    axisSet.yAxis.minorGridLineStyle = lineStyle3;
    axisSet.xAxis.tickDirection= CPTSignPositive;
    NSNumberFormatter *formattery = [[NSNumberFormatter alloc] init];
    [formattery setGeneratesDecimalNumbers:NO];
    [formattery setNumberStyle:NSNumberFormatterDecimalStyle];
    axisSet.yAxis.labelFormatter = formattery;
    
    // Create the plot (we do not define actual x/y values yet, these will be supplied by the datasource...)
    CPTScatterPlot* plot = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
    
    // Let's keep it simple and let this class act as datasource (therefore we implemtn <CPTPlotDataSource>)
    plot.dataSource = self;
    plot.identifier = @"Scatter1";
    plot.dataLineStyle = lineStyle2;
    plot.plotSymbol = plotSymbol;
    
    // Finally, add the created plot to the default plot space of the CPTGraph object we created before
    [graph addPlot:plot toPlotSpace:graph.defaultPlotSpace];
}


-(void) GraficarDos{
    
    // We need a hostview, you can create one in IB (and create an outlet) or just do this:
    CGRect frame = [self.AreaGrafico2 bounds];
    CPTGraphHostingView* hostView = [[CPTGraphHostingView alloc] initWithFrame:frame];
    [self.AreaGrafico2 addSubview: hostView];
    
    // Create a CPTGraph object and add to hostView
    CPTGraph* graph = [[CPTXYGraph alloc] initWithFrame:hostView.bounds];
    hostView.hostedGraph = graph;
    
    // Set graph title
    NSString *userLocale = [[NSLocale currentLocale] localeIdentifier];
    NSString *userLanguage = [userLocale substringToIndex:2];
    NSString *title = @" ";
    if([userLanguage isEqualToString:@"es"]){
        title = @"2. Ojos cerrados, superfice dura";
    }
    else{
        title = @"2. Eyes closed, no foam";
    }
    graph.title = title;
    // 3 - Create and set text style
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor blackColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 16.0f;
    graph.titleTextStyle = titleStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, 22.0f);
    
    
    // Get the (default) plotspace from the graph so we can set its x/y ranges
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    
    //Sangrias del grafico
    graph.plotAreaFrame.paddingTop = 5.0f;
    graph.plotAreaFrame.paddingRight = 2.0f;
    graph.plotAreaFrame.paddingBottom = 5.0f;
    graph.plotAreaFrame.paddingLeft = 2.0f;
    
    //COLOR DE FONDO
    //Color de fondo
    graph.plotAreaFrame.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:0 green:0 blue:0 alpha:0]];
    
    //Definir estilos de lineas (grafico y ejes)
    
    // Create a line style that we will apply to the axis and data line (no).
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineColor = [CPTColor blackColor];
    lineStyle.lineWidth = 1.0f;
    
    //Para la linea del grafico
    CPTMutableLineStyle *lineStyle2 = [CPTMutableLineStyle lineStyle];
    lineStyle2.lineColor = [CPTColor purpleColor];
    lineStyle2.lineWidth = 1.75f;
    
    //REJILLA
    CPTMutableLineStyle *lineStyle3 = [CPTMutableLineStyle lineStyle];
    lineStyle3.lineColor = [CPTColor grayColor];
    lineStyle3.lineWidth = 0.25f;
    
    // Create a text style that we will use for the axis labels.
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.fontName = @"Helvetica";
    textStyle.fontSize = 10;
    textStyle.color = [CPTColor blackColor];
    
    // Create the plot symbol we're going to use.
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill = [CPTFill fillWithColor:[CPTColor blackColor]];
    plotSymbol.lineStyle = lineStyle2;
    plotSymbol.size = CGSizeMake(9.0, 9.0);
    
    //Limites del gráfico
    
    float xAxisMin = -310;
    float xAxisMax = 310;
    float yAxisMin = -200;
    float yAxisMax = 200;
    
    // Note that these CPTPlotRange are defined by START and LENGTH (not START and END) !!
    // We modify the graph's plot space to setup the axis' min / max values.
    
    [plotSpace setXRange: [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:(xAxisMin)] length:[NSNumber numberWithFloat:(xAxisMax-xAxisMin)]]];
    
    [plotSpace setYRange: [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:(yAxisMin)] length:[NSNumber numberWithFloat:(yAxisMax-yAxisMin)]]];
    plotSpace.allowsUserInteraction = YES;
    
    //EJES
    
    // Modify the graph's axis with a label, line style, etc.
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) graph.axisSet;
    //axisSet.xAxis.title = @"Position";
    axisSet.xAxis.titleTextStyle = textStyle;
    axisSet.xAxis.titleOffset = -20.0f;
    axisSet.xAxis.titleLocation = [NSDecimalNumber decimalNumberWithString:(@"200.0")];
    //axisSet.xAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    axisSet.xAxis.labelingPolicy = CPTAxisLabelingPolicyFixedInterval;
    axisSet.xAxis.axisLineStyle = lineStyle;
    axisSet.xAxis.majorTickLineStyle = lineStyle;
    axisSet.xAxis.minorTickLineStyle = lineStyle;
    axisSet.xAxis.labelTextStyle = textStyle;
    axisSet.xAxis.labelOffset = 1.0f;
    axisSet.xAxis.majorIntervalLength = [NSNumber numberWithFloat:(100.0f)];
    axisSet.xAxis.minorTicksPerInterval = 1;
    axisSet.xAxis.minorTickLength = 5.0f;
    axisSet.xAxis.majorTickLength = 7.0f;
    axisSet.xAxis.majorGridLineStyle = lineStyle3;
    axisSet.xAxis.minorGridLineStyle = lineStyle3;
    axisSet.xAxis.tickDirection= CPTSignPositive;
    //Formatear los números de los ejes (quitar decimales)
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setGeneratesDecimalNumbers:NO];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    axisSet.xAxis.labelFormatter = formatter;
    
    //axisSet.yAxis.title = @"Position";
    axisSet.yAxis.titleTextStyle = textStyle;
    axisSet.yAxis.titleOffset = -20.0f;
    axisSet.yAxis.titleLocation = [NSDecimalNumber decimalNumberWithString:(@"152.0")];
    axisSet.yAxis.axisLineStyle = lineStyle;
    axisSet.yAxis.majorTickLineStyle = lineStyle;
    axisSet.yAxis.minorTickLineStyle = lineStyle;
    axisSet.yAxis.labelTextStyle = textStyle;
    axisSet.yAxis.labelOffset = 1.0f;
    axisSet.yAxis.majorIntervalLength = [NSNumber numberWithFloat:(100.0f)];
    axisSet.yAxis.minorTicksPerInterval = 1;
    axisSet.yAxis.minorTickLength = 5.0f;
    axisSet.yAxis.majorTickLength = 7.0f;
    axisSet.yAxis.majorGridLineStyle = lineStyle3;
    axisSet.yAxis.minorGridLineStyle = lineStyle3;
    axisSet.xAxis.tickDirection= CPTSignPositive;
    NSNumberFormatter *formattery = [[NSNumberFormatter alloc] init];
    [formattery setGeneratesDecimalNumbers:NO];
    [formattery setNumberStyle:NSNumberFormatterDecimalStyle];
    axisSet.yAxis.labelFormatter = formattery;
    
    // Create the plot (we do not define actual x/y values yet, these will be supplied by the datasource...)
    CPTScatterPlot* plot = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
    
    // Let's keep it simple and let this class act as datasource (therefore we implemtn <CPTPlotDataSource>)
    plot.dataSource = self;
    plot.identifier = @"Scatter2";
    plot.dataLineStyle = lineStyle2;
    plot.plotSymbol = plotSymbol;
    
    // Finally, add the created plot to the default plot space of the CPTGraph object we created before
    [graph addPlot:plot toPlotSpace:graph.defaultPlotSpace];
}

-(void) GraficarTres{
    
    // We need a hostview, you can create one in IB (and create an outlet) or just do this:
    CGRect frame = [self.AreaGrafico3 bounds];
    CPTGraphHostingView* hostView = [[CPTGraphHostingView alloc] initWithFrame:frame];
    [self.AreaGrafico3 addSubview: hostView];
    
    // Create a CPTGraph object and add to hostView
    CPTGraph* graph = [[CPTXYGraph alloc] initWithFrame:hostView.bounds];
    hostView.hostedGraph = graph;
    
    // Set graph title
    NSString *userLocale = [[NSLocale currentLocale] localeIdentifier];
    NSString *userLanguage = [userLocale substringToIndex:2];
    NSString *title = @" ";
    if([userLanguage isEqualToString:@"es"]){
        title = @"3. Ojos abiertos, superficie blanda";
    }
    else{
        title = @"3. Eyes open, foam";
    }
    graph.title = title;
    // 3 - Create and set text style
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor blackColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 16.0f;
    graph.titleTextStyle = titleStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, 22.0f);
    
    
    // Get the (default) plotspace from the graph so we can set its x/y ranges
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    
    //Sangrias del grafico
    graph.plotAreaFrame.paddingTop = 5.0f;
    graph.plotAreaFrame.paddingRight = 2.0f;
    graph.plotAreaFrame.paddingBottom = 5.0f;
    graph.plotAreaFrame.paddingLeft = 2.0f;
    
    //COLOR DE FONDO
    //Color de fondo
    graph.plotAreaFrame.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:0 green:0 blue:0 alpha:0]];
    
    //Definir estilos de lineas (grafico y ejes)
    
    // Create a line style that we will apply to the axis and data line (no).
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineColor = [CPTColor blackColor];
    lineStyle.lineWidth = 1.0f;
    
    //Para la linea del grafico
    CPTMutableLineStyle *lineStyle2 = [CPTMutableLineStyle lineStyle];
    lineStyle2.lineColor = [CPTColor grayColor];
    lineStyle2.lineWidth = 1.75f;
    
    //REJILLA
    CPTMutableLineStyle *lineStyle3 = [CPTMutableLineStyle lineStyle];
    lineStyle3.lineColor = [CPTColor grayColor];
    lineStyle3.lineWidth = 0.25f;
    
    // Create a text style that we will use for the axis labels.
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.fontName = @"Helvetica";
    textStyle.fontSize = 10;
    textStyle.color = [CPTColor blackColor];
    
    // Create the plot symbol we're going to use.
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol diamondPlotSymbol];
    plotSymbol.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    plotSymbol.lineStyle = lineStyle2;
    plotSymbol.size = CGSizeMake(9.0, 9.0);
    
    //Limites del gráfico
    
    float xAxisMin = -310;
    float xAxisMax = 310;
    float yAxisMin = -200;
    float yAxisMax = 200;
    
    // Note that these CPTPlotRange are defined by START and LENGTH (not START and END) !!
    // We modify the graph's plot space to setup the axis' min / max values.
    
    [plotSpace setXRange: [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:(xAxisMin)] length:[NSNumber numberWithFloat:(xAxisMax-xAxisMin)]]];
    
    [plotSpace setYRange: [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:(yAxisMin)] length:[NSNumber numberWithFloat:(yAxisMax-yAxisMin)]]];
    plotSpace.allowsUserInteraction = YES;
    
    //EJES
    
    // Modify the graph's axis with a label, line style, etc.
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) graph.axisSet;
    //axisSet.xAxis.title = @"Position";
    axisSet.xAxis.titleTextStyle = textStyle;
    axisSet.xAxis.titleOffset = -20.0f;
    axisSet.xAxis.titleLocation = [NSDecimalNumber decimalNumberWithString:(@"200.0")];
    //axisSet.xAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    axisSet.xAxis.labelingPolicy = CPTAxisLabelingPolicyFixedInterval;
    axisSet.xAxis.axisLineStyle = lineStyle;
    axisSet.xAxis.majorTickLineStyle = lineStyle;
    axisSet.xAxis.minorTickLineStyle = lineStyle;
    axisSet.xAxis.labelTextStyle = textStyle;
    axisSet.xAxis.labelOffset = 1.0f;
    axisSet.xAxis.majorIntervalLength = [NSNumber numberWithFloat:(100.0f)];
    axisSet.xAxis.minorTicksPerInterval = 1;
    axisSet.xAxis.minorTickLength = 5.0f;
    axisSet.xAxis.majorTickLength = 7.0f;
    axisSet.xAxis.majorGridLineStyle = lineStyle3;
    axisSet.xAxis.minorGridLineStyle = lineStyle3;
    axisSet.xAxis.tickDirection= CPTSignPositive;
    //Formatear los números de los ejes (quitar decimales)
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setGeneratesDecimalNumbers:NO];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    axisSet.xAxis.labelFormatter = formatter;
    
    //axisSet.yAxis.title = @"Position";
    axisSet.yAxis.titleTextStyle = textStyle;
    axisSet.yAxis.titleOffset = -20.0f;
    axisSet.yAxis.titleLocation = [NSDecimalNumber decimalNumberWithString:(@"152.0")];
    axisSet.yAxis.axisLineStyle = lineStyle;
    axisSet.yAxis.majorTickLineStyle = lineStyle;
    axisSet.yAxis.minorTickLineStyle = lineStyle;
    axisSet.yAxis.labelTextStyle = textStyle;
    axisSet.yAxis.labelOffset = 1.0f;
    axisSet.yAxis.majorIntervalLength = [NSNumber numberWithFloat:(100.0f)];
    axisSet.yAxis.minorTicksPerInterval = 1;
    axisSet.yAxis.minorTickLength = 5.0f;
    axisSet.yAxis.majorTickLength = 7.0f;
    axisSet.yAxis.majorGridLineStyle = lineStyle3;
    axisSet.yAxis.minorGridLineStyle = lineStyle3;
    axisSet.xAxis.tickDirection= CPTSignPositive;
    NSNumberFormatter *formattery = [[NSNumberFormatter alloc] init];
    [formattery setGeneratesDecimalNumbers:NO];
    [formattery setNumberStyle:NSNumberFormatterDecimalStyle];
    axisSet.yAxis.labelFormatter = formattery;
    
    // Create the plot (we do not define actual x/y values yet, these will be supplied by the datasource...)
    CPTScatterPlot* plot = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
    
    // Let's keep it simple and let this class act as datasource (therefore we implemtn <CPTPlotDataSource>)
    plot.dataSource = self;
    plot.identifier = @"Scatter3";
    plot.dataLineStyle = lineStyle2;
    plot.plotSymbol = plotSymbol;
    
    // Finally, add the created plot to the default plot space of the CPTGraph object we created before
    [graph addPlot:plot toPlotSpace:graph.defaultPlotSpace];
}

-(void) GraficarCuatro{
    
    // We need a hostview, you can create one in IB (and create an outlet) or just do this:
    CGRect frame = [self.AreaGrafico4 bounds];
    CPTGraphHostingView* hostView = [[CPTGraphHostingView alloc] initWithFrame:frame];
    [self.AreaGrafico4 addSubview: hostView];
    
    // Create a CPTGraph object and add to hostView
    CPTGraph* graph = [[CPTXYGraph alloc] initWithFrame:hostView.bounds];
    hostView.hostedGraph = graph;
    
    // Set graph title
    NSString *userLocale = [[NSLocale currentLocale] localeIdentifier];
    NSString *userLanguage = [userLocale substringToIndex:2];
    NSString *title = @" ";
    if([userLanguage isEqualToString:@"es"]){
        title = @"4. Ojos cerrados, superficie blanda";
    }
    else{
        title = @"4. Eyes closed, foam";
    }
    graph.title = title;
    // 3 - Create and set text style
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor blackColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 16.0f;
    graph.titleTextStyle = titleStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, 22.0f);
    
    
    // Get the (default) plotspace from the graph so we can set its x/y ranges
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    
    //Sangrias del grafico
    graph.plotAreaFrame.paddingTop = 5.0f;
    graph.plotAreaFrame.paddingRight = 2.0f;
    graph.plotAreaFrame.paddingBottom = 5.0f;
    graph.plotAreaFrame.paddingLeft = 2.0f;
    
    //COLOR DE FONDO
    //Color de fondo
    graph.plotAreaFrame.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:0 green:0 blue:0 alpha:0]];
    
    //Definir estilos de lineas (grafico y ejes)
    
    // Create a line style that we will apply to the axis and data line (no).
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineColor = [CPTColor blackColor];
    lineStyle.lineWidth = 1.0f;
    
    //Para la linea del grafico
    CPTMutableLineStyle *lineStyle2 = [CPTMutableLineStyle lineStyle];
    lineStyle2.lineColor = [CPTColor grayColor];
    lineStyle2.lineWidth = 1.75f;
    
    //REJILLA
    CPTMutableLineStyle *lineStyle3 = [CPTMutableLineStyle lineStyle];
    lineStyle3.lineColor = [CPTColor grayColor];
    lineStyle3.lineWidth = 0.25f;
    
    // Create a text style that we will use for the axis labels.
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.fontName = @"Helvetica";
    textStyle.fontSize = 10;
    textStyle.color = [CPTColor blackColor];
    
    // Create the plot symbol we're going to use.
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill = [CPTFill fillWithColor:[CPTColor blackColor]];
    plotSymbol.lineStyle = lineStyle2;
    plotSymbol.size = CGSizeMake(9.0, 9.0);
    
    //Limites del gráfico
    
    float xAxisMin = -310;
    float xAxisMax = 310;
    float yAxisMin = -200;
    float yAxisMax = 200;
    
    // Note that these CPTPlotRange are defined by START and LENGTH (not START and END) !!
    // We modify the graph's plot space to setup the axis' min / max values.
    
    [plotSpace setXRange: [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:(xAxisMin)] length:[NSNumber numberWithFloat:(xAxisMax-xAxisMin)]]];
    
    [plotSpace setYRange: [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:(yAxisMin)] length:[NSNumber numberWithFloat:(yAxisMax-yAxisMin)]]];
    plotSpace.allowsUserInteraction = YES;
    
    //EJES
    
    // Modify the graph's axis with a label, line style, etc.
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) graph.axisSet;
    //axisSet.xAxis.title = @"Position";
    axisSet.xAxis.titleTextStyle = textStyle;
    axisSet.xAxis.titleOffset = -20.0f;
    axisSet.xAxis.titleLocation = [NSDecimalNumber decimalNumberWithString:(@"200.0")];
    //axisSet.xAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    axisSet.xAxis.labelingPolicy = CPTAxisLabelingPolicyFixedInterval;
    axisSet.xAxis.axisLineStyle = lineStyle;
    axisSet.xAxis.majorTickLineStyle = lineStyle;
    axisSet.xAxis.minorTickLineStyle = lineStyle;
    axisSet.xAxis.labelTextStyle = textStyle;
    axisSet.xAxis.labelOffset = 1.0f;
    axisSet.xAxis.majorIntervalLength = [NSNumber numberWithFloat:(100.0f)];
    axisSet.xAxis.minorTicksPerInterval = 1;
    axisSet.xAxis.minorTickLength = 5.0f;
    axisSet.xAxis.majorTickLength = 7.0f;
    axisSet.xAxis.majorGridLineStyle = lineStyle3;
    axisSet.xAxis.minorGridLineStyle = lineStyle3;
    axisSet.xAxis.tickDirection= CPTSignPositive;
    //Formatear los números de los ejes (quitar decimales)
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setGeneratesDecimalNumbers:NO];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    axisSet.xAxis.labelFormatter = formatter;
    
    //axisSet.yAxis.title = @"Position";
    axisSet.yAxis.titleTextStyle = textStyle;
    axisSet.yAxis.titleOffset = -20.0f;
    axisSet.yAxis.titleLocation = [NSDecimalNumber decimalNumberWithString:(@"152.0")];
    axisSet.yAxis.axisLineStyle = lineStyle;
    axisSet.yAxis.majorTickLineStyle = lineStyle;
    axisSet.yAxis.minorTickLineStyle = lineStyle;
    axisSet.yAxis.labelTextStyle = textStyle;
    axisSet.yAxis.labelOffset = 1.0f;
    axisSet.yAxis.majorIntervalLength = [NSNumber numberWithFloat:(100.0f)];
    axisSet.yAxis.minorTicksPerInterval = 1;
    axisSet.yAxis.minorTickLength = 5.0f;
    axisSet.yAxis.majorTickLength = 7.0f;
    axisSet.yAxis.majorGridLineStyle = lineStyle3;
    axisSet.yAxis.minorGridLineStyle = lineStyle3;
    axisSet.xAxis.tickDirection= CPTSignPositive;
    NSNumberFormatter *formattery = [[NSNumberFormatter alloc] init];
    [formattery setGeneratesDecimalNumbers:NO];
    [formattery setNumberStyle:NSNumberFormatterDecimalStyle];
    axisSet.yAxis.labelFormatter = formattery;
    
    // Create the plot (we do not define actual x/y values yet, these will be supplied by the datasource...)
    CPTScatterPlot* plot = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
    
    // Let's keep it simple and let this class act as datasource (therefore we implemtn <CPTPlotDataSource>)
    plot.dataSource = self;
    plot.identifier = @"Scatter4";
    plot.dataLineStyle = lineStyle2;
    plot.plotSymbol = plotSymbol;
    
    // Finally, add the created plot to the default plot space of the CPTGraph object we created before
    [graph addPlot:plot toPlotSpace:graph.defaultPlotSpace];
}


//METODOS DELEGATE PARA PASAR DATOS A LOS GRAFICOS


// This method is here because this class also functions as datasource for our graph
// Therefore this class implements the CPTPlotDataSource protocol
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plotnumberOfRecords {
    
    if ([plotnumberOfRecords.identifier isEqual:@"Scatter1"])
    {
        return [datosGrafico1 count];
    }
    if ([plotnumberOfRecords.identifier isEqual:@"Scatter2"])
    {
        return [datosGrafico2 count];
    }
    if ([plotnumberOfRecords.identifier isEqual:@"Scatter3"])
    {
        return [datosGrafico3 count];
    }
    if ([plotnumberOfRecords.identifier isEqual:@"Scatter4"])
    {
        return [datosGrafico4 count];
    }
    //Añadir mas graficos
    return 0;
}

// This method is here because this class also functions as datasource for our graph
// Therefore this class implements the CPTPlotDataSource protocol
-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    if ([plot.identifier isEqual:@"Scatter1"])
    {
        NSValue *value = [datosGrafico1 objectAtIndex:index];
        NSPoint point = [value pointValue];
        
        // FieldEnum determines if we return an X or Y value.
        if ( fieldEnum == CPTScatterPlotFieldX )
        {
            //NSLog(@"X: %@",[NSNumber numberWithFloat:point.x]); //LUEGO ANULAR
            return [NSNumber numberWithFloat:point.x];
        }
        else    // Y-Axis
        {
            //NSLog(@"Y: %@",[NSNumber numberWithFloat:point.y]); //LUEGO ANULAR
            return [NSNumber numberWithFloat:point.y];
        }
    }
    if ([plot.identifier isEqual:@"Scatter2"])
    {
        NSValue *value = [datosGrafico2 objectAtIndex:index];
        NSPoint point = [value pointValue];
        
        // FieldEnum determines if we return an X or Y value.
        if ( fieldEnum == CPTScatterPlotFieldX )
        {
            //NSLog(@"X: %@",[NSNumber numberWithFloat:point.x]); //LUEGO ANULAR
            return [NSNumber numberWithFloat:point.x];
        }
        else    // Y-Axis
        {
            //NSLog(@"Y: %@",[NSNumber numberWithFloat:point.y]); //LUEGO ANULAR
            return [NSNumber numberWithFloat:point.y];
        }
    }
    if ([plot.identifier isEqual:@"Scatter3"])
    {
        NSValue *value = [datosGrafico3 objectAtIndex:index];
        NSPoint point = [value pointValue];
        
        // FieldEnum determines if we return an X or Y value.
        if ( fieldEnum == CPTScatterPlotFieldX )
        {
            //NSLog(@"X: %@",[NSNumber numberWithFloat:point.x]); //LUEGO ANULAR
            return [NSNumber numberWithFloat:point.x];
        }
        else    // Y-Axis
        {
            //NSLog(@"Y: %@",[NSNumber numberWithFloat:point.y]); //LUEGO ANULAR
            return [NSNumber numberWithFloat:point.y];
        }
    }
    if ([plot.identifier isEqual:@"Scatter4"])
    {
        NSValue *value = [datosGrafico4 objectAtIndex:index];
        NSPoint point = [value pointValue];
        
        // FieldEnum determines if we return an X or Y value.
        if ( fieldEnum == CPTScatterPlotFieldX )
        {
            //NSLog(@"X: %@",[NSNumber numberWithFloat:point.x]); //LUEGO ANULAR
            return [NSNumber numberWithFloat:point.x];
        }
        else    // Y-Axis
        {
            //NSLog(@"Y: %@",[NSNumber numberWithFloat:point.y]); //LUEGO ANULAR
            return [NSNumber numberWithFloat:point.y];
        }
    }
    
    //Añadir mas graficos
    return [NSNumber numberWithFloat:0];
}



- (IBAction)guardarfoto:(id)sender {
    //De elemnto a imagen
    NSSize imgSize = areafoto.bounds.size;
    NSBitmapImageRep * rep = [areafoto bitmapImageRepForCachingDisplayInRect:[areafoto bounds]];
    [rep setSize:imgSize];
    [areafoto cacheDisplayInRect:[areafoto bounds] toBitmapImageRep:rep];
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
@end
