//
//  SecondViewController.m
//  RombergLab
//
//  Created by Jorge on 3/12/15.
//  Copyright © 2015 ARK. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController
@synthesize datos;
@synthesize datosGrafico1;
@synthesize datosTime;
@synthesize datosForce;
@synthesize datosX;
@synthesize datosY;
@synthesize areafoto;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(analiza:)
                                                 name:@"ResultadosLibres"
                                               object:nil];
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
        title = @"Gráfico de dispersión de posición";
    }
    else{
        title = @"Position Scatter Plot";
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
    
    [self.area setStringValue:[NSString stringWithFormat:@"Area: %0.2f",area]];
    
}

-(void)analiza:(NSNotification*)notificacion{
    //Metodo para cargar los datos en esta clase
    datos = (NSMutableArray *)notificacion.object;
    datosGrafico1 = [NSMutableArray array];
    datosTime  = [NSMutableArray array];
    datosForce = [NSMutableArray array];
    datosX  = [NSMutableArray array];
    datosY = [NSMutableArray array];
    
    NSMutableArray *DatosX = [NSMutableArray array];
    NSMutableArray *DatosY = [NSMutableArray array];
    
    for (int i = 0;i < [datos count];i++){
        [DatosX addObject:datos[i][3]];
        [DatosY addObject:datos[i][4]];
        [datosTime  addObject:datos[i][1]];
        [datosForce addObject:datos[i][2]];
        [datosX addObject:datos[i][3]];
        [datosY addObject:datos[i][4]];
        
    }
    
    for (int i = 0;i < [datos count];i++){
        float valorX = [[DatosX objectAtIndex:i] doubleValue];
        float valorY = [[DatosY objectAtIndex:i] doubleValue];
        [datosGrafico1 addObject:[NSValue valueWithPoint:NSMakePoint(valorX, valorY)]];
    }
    
    if ([datosGrafico1 count]){
        [self GraficarUno];
        [self AreaUno];
    }
}


//METODOS DELEGATE PARA PASAR DATOS A LOS GRAFICOS


// This method is here because this class also functions as datasource for our graph
// Therefore this class implements the CPTPlotDataSource protocol
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plotnumberOfRecords {
    
    if ([plotnumberOfRecords.identifier isEqual:@"Scatter1"])
    {
        return [datosGrafico1 count];
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
    //Añadir mas graficos
    return [NSNumber numberWithFloat:0];
}
- (IBAction)guardarCSV:(id)sender {
    
    //CSV formating
    // Structure in Data [Program Mode, Time Stamp, Calibrated Total Weight, Center of Gravity x, Center of Gravity y]
    NSMutableString *csvString = [NSMutableString stringWithString:@"Time,Force,PositionX,PositionY\n"];
    
    float valorTime  = 0.0;
    float valorForce = 0.0;
    float valorX  = 0.0;
    float valorY = 0.0;
    
    for (int i = 0;i < [datosForce count];i++){
        valorTime  = [[datosTime  objectAtIndex:i] doubleValue];
        valorForce = [[datosForce objectAtIndex:i] doubleValue];
        valorX  = [[datosX  objectAtIndex:i] doubleValue];
        valorY = [[datosY objectAtIndex:i] doubleValue];
        [csvString appendFormat:@"%0.3f, %0.2f, %0.2f, %0.2f\n", valorTime, valorForce, valorX, valorY];
    }
    //GUI SAVING
    
    // create the save panel
    NSSavePanel *panel = [NSSavePanel savePanel];
    
    // set panel parameters
    [panel setNameFieldStringValue:@"freeModeData.csv"];
    [panel setTitle:@"Export data to CSV file"];
    
    // display the panel
    [panel beginWithCompletionHandler:^(NSInteger result) {
        
        if (result == NSFileHandlingPanelOKButton) {
            
            // create a file namaner and grab the save panel's returned URL
            NSFileManager *manager = [NSFileManager defaultManager];
            NSURL *saveURL = [panel URL];
            
            [manager createFileAtPath:saveURL.relativePath contents:[csvString dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        }
    }];
    
}

- (IBAction)guardarPNG:(id)sender {
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


