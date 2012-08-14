//
//  BasicPlanViewController.h
//  HLA
//
//  Created by shawal sapuan on 8/1/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface BasicPlanViewController : UIViewController {
    NSString *databasePath;
    sqlite3 *contactDB;
    BOOL showHL;
}
@property (retain, nonatomic) IBOutlet UIButton *basicPlanBtn;

@property (nonatomic, assign,readwrite) int indexNo;
@property (nonatomic,strong) id agenID;
@property (nonatomic, assign,readwrite) int ageClient;
@property (nonatomic,strong) id requestSINo;

//screen field
@property (retain, nonatomic) IBOutlet UITextField *planField;
@property (retain, nonatomic) IBOutlet UITextField *termField;
@property (retain, nonatomic) IBOutlet UITextField *yearlyIncomeField;
@property (retain, nonatomic) IBOutlet UISegmentedControl *premiumTermSegment;
@property (retain, nonatomic) IBOutlet UISegmentedControl *yearlyIncomeSegment;
@property (retain, nonatomic) IBOutlet UISegmentedControl *advanceIncomeSegment;
@property (retain, nonatomic) IBOutlet UILabel *minSALabel;
@property (retain, nonatomic) IBOutlet UILabel *maxSALabel;

@property (retain, nonatomic) IBOutlet UIButton *btnHealthLoading;
@property (retain, nonatomic) IBOutlet UIView *healthLoadingView;

- (IBAction)goHomePressed:(id)sender;
- (IBAction)btnShowHealthLoadingPressed:(id)sender;

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

@end
