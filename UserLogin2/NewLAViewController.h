//
//  NewLAViewController.h
//  HLA
//
//  Created by shawal sapuan on 7/30/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "ListingTbViewController.h"

@interface NewLAViewController : UIViewController<UITextFieldDelegate,UIPopoverControllerDelegate>{
    NSString *databasePath;
    sqlite3 *contactDB;
    UITextField *activeField;
    UIPopoverController *popoverController;
    ListingTbViewController *listingPopVC;
}

@property (nonatomic, assign,readwrite) int indexNo;
@property (nonatomic,strong) id agenID;

//LA Field
@property (retain, nonatomic) IBOutlet UITextField *LANameField;
@property (retain, nonatomic) IBOutlet UISegmentedControl *sexSegment;
@property (retain, nonatomic) IBOutlet UISegmentedControl *smokerSegment;
@property (retain, nonatomic) IBOutlet UITextField *LAAgeField;
@property (retain, nonatomic) IBOutlet UITextField *LACommencementDateField;
@property (retain, nonatomic) IBOutlet UITextField *LAOccSearchField;
@property (retain, nonatomic) IBOutlet UITextField *LAOccLoadingField;
@property (retain, nonatomic) IBOutlet UITextField *LACPAField;
@property (retain, nonatomic) IBOutlet UITextField *LAPAField;
@property (retain, nonatomic) IBOutlet UIButton *btnDOB;
@property (retain, nonatomic) IBOutlet UIButton *btnOccp;

//declare for store in DB
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *smoker;
@property (nonatomic, copy) NSString *DOB;
@property (nonatomic, copy) NSString *jobDesc;
@property (nonatomic, copy) NSString *SINo;
@property (nonatomic, copy) NSString *SIDate;
@property (nonatomic, assign,readwrite) int SILastNo;
@property (nonatomic, copy) NSString *CustCode;
@property (nonatomic, copy) NSString *CustDate;
@property (nonatomic, assign,readwrite) int CustLastNo;
@property (nonatomic, assign,readwrite) int age;
@property (nonatomic, assign,readwrite) int ANB;

//for occupation
@property(nonatomic , retain) NSMutableArray *occDesc;
@property(nonatomic , retain) NSMutableArray *occCode;
@property(nonatomic , retain) NSString *occLoading;
@property(nonatomic , retain) NSString *occCPA;
@property(nonatomic , retain) NSString *occPA;

@property (retain, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (retain, nonatomic) IBOutlet UIPickerView *occPickerView;
@property (retain, nonatomic) IBOutlet UIDatePicker *datePickerView;
@property (retain, nonatomic) IBOutlet UIToolbar *pickerToolbar;

//menu btn
@property (retain, nonatomic) IBOutlet UIButton *lifeAssuredBtn;

@property (nonatomic, retain) UIPopoverController *popoverController;

- (IBAction)sexSegmentPressed:(id)sender;
- (IBAction)smokerSegmentPressed:(id)sender;
- (IBAction)goHome:(id)sender;
- (IBAction)payorBtnPressed:(id)sender;
- (IBAction)secondLAPressed:(id)sender;
- (IBAction)btnDOBPressed:(id)sender;
- (IBAction)btnOccPressed:(id)sender;
- (IBAction)btnOccDone:(id)sender;
- (IBAction)datePickerValueChanged:(id)sender;
- (IBAction)doSaveLA:(id)sender;
- (IBAction)selectProspect:(id)sender;

-(void)keyboardDidShow:(NSNotificationCenter *)notification;
-(void)keyboardDidHide:(NSNotificationCenter *)notification;
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

@end
