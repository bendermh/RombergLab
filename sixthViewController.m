//
//  sixthViewController.m
//  RombergLab
//
//  Created by Jorge on 31/05/2019.
//  Copyright © 2019 ARK. All rights reserved.
//

#import "sixthViewController.h"

@interface sixthViewController ()
@property (weak) IBOutlet NSTextField *area1Field;
@property (weak) IBOutlet NSTextField *area2Field;
@property (weak) IBOutlet NSTextField *area3Field;
@property (weak) IBOutlet NSTextField *area4Field;
@property (weak) IBOutlet NSTextField *textoSuperior;
@property (weak) IBOutlet NSButton *botonAnalisis;

@end

@implementation sixthViewController
@synthesize myWindowController6;
@synthesize areas;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    NSString *userLocale = [[NSLocale currentLocale] localeIdentifier];
    NSString *userLanguage = [userLocale substringToIndex:2];
    if([userLanguage isEqualToString:@"es"]){
        self.textoSuperior.stringValue = @"INTRODUCA DATOS GUARDADOS";
        self.botonAnalisis.title = @"Importar datos...";
    }
    else {
        self.textoSuperior.stringValue = @"INPUT RECORDED DATA";
        self.botonAnalisis.title = @"Import data...";
    }
}
- (IBAction)analizeData:(id)sender {
    
    //get data
    float area1 = [self.area1Field.stringValue floatValue];
    float area2 = [self.area2Field.stringValue floatValue];
    float area3 = [self.area3Field.stringValue floatValue];
    float area4 = [self.area4Field.stringValue floatValue];
    
    //validation
    if (area1 > 0 && area2 > 0 && area3 > 0 && area4 > 0) {
        if (area1 < 1500 && area2 < 1500 && area3 < 1500 && area4 < 1500) {
            areas = [NSArray arrayWithObjects:[NSNumber numberWithFloat:area1],[NSNumber numberWithFloat:area2],[NSNumber numberWithFloat:area3],[NSNumber numberWithFloat:area4], nil];
            NSStoryboard *storyBoard = [NSStoryboard storyboardWithName:@"Main" bundle:nil]; // get a reference to the storyboard
            myWindowController6 = [storyBoard instantiateControllerWithIdentifier:@"QuintaVentana"]; // instantiate your window controller
            [myWindowController6 showWindow:self];
            NSDictionary *isRealPosturography = @{@"isReal":@"false"};
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"InformePosturografia"
             object:areas
             userInfo:isRealPosturography];
        }
        else {
            [self inputWarning];
        }
    }
    else {
        [self inputWarning];
    }
}
-(void)inputWarning {
    NSAlert *alert = [[NSAlert alloc] init];
    NSString *userLocale = [[NSLocale currentLocale] localeIdentifier];
    NSString *userLanguage = [userLocale substringToIndex:2];
    if([userLanguage isEqualToString:@"es"]){
        [alert setMessageText:@"Campos introducidos incorrectos"];
        [alert setInformativeText:@"Todas las áreas deben ser numéricas y estar en un rango entre 0 y 1500. El separador decimal es el punto (.), revise los datos"];
    }
    else{
        [alert setMessageText:@"Not valid data"];
        [alert setInformativeText:@"All inputs must be numeric in a range from 0 to 1500"];
    }
    [alert addButtonWithTitle:@"OK"];
    [alert runModal];}

@end
