//
//  BasicPlanViewController.h
//  HLA
//
//  Created by shawal sapuan on 8/1/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface BasicPlanViewController : UIViewController <UITextFieldDelegate>{
    NSString *databasePath;
    sqlite3 *contactDB;
    BOOL showHL;
    UITextField *activeField;
}
@property (retain, nonatomic) IBOutlet UIButton *basicPlanBtn;

@property (nonatomic, assign,readwrite) int indexNo;
@property (nonatomic,strong) id agenID;
@property (nonatomic, assign,readwrite) int ageClient;
@property (nonatomic,strong) id requestSINo;


@property (nonatomic, assign,readwrite) int termCover;
@property (nonatomic, assign,readwrite) int minSA;
@property (nonatomic, assign,readwrite) int maxSA;
@property (nonatomic,strong) NSString *planChoose;

//screen field
@property (retain, nonatomic) IBOutlet UITextField *planField;
@property (retain, nonatomic) IBOutlet UITextField *termField;
@property (retain, nonatomic) IBOutlet UITextField *yearlyIncomeField;
@property (retain, nonatomic) IBOutlet UILabel *minSALabel;
@property (retain, nonatomic) IBOutlet UILabel *maxSALabel;
@property (retain, nonatomic) IBOutlet UIButton *btnHealthLoading;
@property (retain, nonatomic) IBOutlet UIView *healthLoadingView;
@property (retain, nonatomic) IBOutlet UISegmentedControl *MOPSegment;
@property (retain, nonatomic) IBOutlet UISegmentedControl *incomeSegment;
@property (retain, nonatomic) IBOutlet UISegmentedControl *advanceIncomeSegment;
@property (retain, nonatomic) IBOutlet UITextField *HLField;

//use to calculate
@property (nonatomic, assign,readwrite) int MOP;
@property (nonatomic, copy) NSString *yearlyIncome;
@property (nonatomic, assign,readwrite) int advanceYearlyIncome;
@property (nonatomic, assign,readwrite) int basicRate;
@property (nonatomic, assign,readwrite) int LSDRate;

- (IBAction)goHomePressed:(id)sender;
- (IBAction)btnShowHealthLoadingPressed:(id)sender;
- (IBAction)calculatePressed:(id)sender;
- (IBAction)MOPSegmentPressed:(id)sender;
- (IBAction)incomeSegmentPressed:(id)sender;
- (IBAction)advanceIncomeSegmentPressed:(id)sender;

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

@end
