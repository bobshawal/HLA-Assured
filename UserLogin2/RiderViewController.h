//
//  RiderViewController.h
//  HLA
//
//  Created by shawal sapuan on 8/1/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "RiderPTypeTbViewController.h"
#import "RiderListTbViewController.h"
#import "RiderFormTbViewController.h"

@interface RiderViewController : UIViewController <RiderPTypeTbViewControllerDelegate,RiderListTbViewControllerDelegate,RiderFormTbViewControllerDelegate,UITextFieldDelegate>
{
    NSString *databasePath;
    sqlite3 *contactDB;
    UIPopoverController *popOverConroller;
    BOOL term;
    BOOL sumA;
    BOOL plan;
    BOOL unit;
    BOOL deduc;
    BOOL hload;
    BOOL hloadterm;
    BOOL pressedPlan;
    BOOL pressedDeduc;
}

@property (nonatomic,strong) UIPopoverController *popOverConroller;
@property (retain, nonatomic) IBOutlet UIButton *riderBtn;
@property (retain, nonatomic) IBOutlet UIButton *btnPType;
@property (retain, nonatomic) IBOutlet UIButton *btnAddRider;

@property (retain, nonatomic) IBOutlet UILabel *termLabel;
@property (retain, nonatomic) IBOutlet UILabel *sumLabel;
@property (retain, nonatomic) IBOutlet UILabel *planLabel;
@property (retain, nonatomic) IBOutlet UILabel *cpaLabel;
@property (retain, nonatomic) IBOutlet UILabel *unitLabel;
@property (retain, nonatomic) IBOutlet UILabel *occpLabel;
@property (retain, nonatomic) IBOutlet UILabel *HLLabel;
@property (retain, nonatomic) IBOutlet UILabel *HLTLabel;
@property (retain, nonatomic) IBOutlet UITextField *termField;
@property (retain, nonatomic) IBOutlet UITextField *sumField;
@property (retain, nonatomic) IBOutlet UITextField *cpaField;
@property (retain, nonatomic) IBOutlet UITextField *unitField;
@property (retain, nonatomic) IBOutlet UITextField *occpField;
@property (retain, nonatomic) IBOutlet UITextField *HLField;
@property (retain, nonatomic) IBOutlet UITextField *HLTField;
@property (retain, nonatomic) IBOutlet UIButton *planBtn;
@property (retain, nonatomic) IBOutlet UIButton *deducBtn;
@property (retain, nonatomic) IBOutlet UILabel *minDisplayLabel;
@property (retain, nonatomic) IBOutlet UILabel *maxDisplayLabel;

//request from previous
@property (nonatomic, assign,readwrite) int indexNo;
@property (nonatomic,strong) id agenID;
@property (nonatomic, assign,readwrite) int requestAge;
@property (nonatomic,strong) id requestSINo;
@property (nonatomic, assign,readwrite) int requestCoverTerm;
@property (nonatomic,strong) id requestPlanCode;

//get from popover
@property (nonatomic,copy) NSString *pTypeCode;
@property (nonatomic, assign,readwrite) int PTypeSeq;
@property (nonatomic,copy) NSString *pTypeDesc;
@property (nonatomic,copy) NSString *riderCode;
@property (nonatomic,copy) NSString *riderDesc;

//setup form field
@property(nonatomic , retain) NSMutableArray *FLabelCode;
@property(nonatomic , retain) NSMutableArray *FLabelDesc;
@property(nonatomic , retain) NSMutableArray *FRidName;
@property(nonatomic , retain) NSMutableArray *FInputCode;
@property(nonatomic , retain) NSMutableArray *FTbName;
@property(nonatomic , retain) NSMutableArray *FFieldName;
@property(nonatomic , retain) NSMutableArray *FCondition;

@property (nonatomic,strong) NSString *SINoPlan;
@property (nonatomic,strong) NSString *planCode;
@property (nonatomic, assign,readwrite) int expAge;
@property (nonatomic, assign,readwrite) int minSATerm;
@property (nonatomic, assign,readwrite) int maxSATerm;
@property (nonatomic, assign,readwrite) int minTerm;
@property (nonatomic, assign,readwrite) int maxTerm;
@property (nonatomic, assign,readwrite) double maxRiderTerm;
@property (nonatomic,strong) NSString *planOption;
@property (nonatomic,strong) NSString *deductible;
@property (nonatomic,strong) NSString *inputHL1KSA;
@property (nonatomic,assign,readwrite) int inputHL1KSATerm;
@property (nonatomic,strong) NSString *inputHL100SA;
@property (nonatomic,assign,readwrite) int inputHL100SATerm;
@property (nonatomic,strong) NSString *inputHLPercentage;
@property (nonatomic,assign,readwrite) int inputHLPercentageTerm;

- (IBAction)homePressed:(id)sender;
- (IBAction)btnPTypePressed:(id)sender;
- (IBAction)btnAddRiderPressed:(id)sender;
- (IBAction)planBtnPressed:(id)sender;
- (IBAction)deducBtnPressed:(id)sender;
- (IBAction)doSaveRider:(id)sender;

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
-(void)keyboardDidHide:(NSNotificationCenter *)notification;

@end
