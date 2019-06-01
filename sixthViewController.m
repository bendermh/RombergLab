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

@end

@implementation sixthViewController
@synthesize myWindowController6;
@synthesize areas;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
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
    }
    
}

@end
