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

@interface RiderViewController : UIViewController<RiderPTypeTbViewControllerDelegate,RiderListTbViewControllerDelegate> {
    NSString *databasePath;
    sqlite3 *contactDB;
    UIPopoverController *popOverConroller;
}

@property (retain, nonatomic) IBOutlet UIButton *riderBtn;

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

@property (retain, nonatomic) IBOutlet UIButton *btnPType;
@property (retain, nonatomic) IBOutlet UIButton *btnAddRider;
@property (nonatomic,strong) UIPopoverController *popOverConroller;

- (IBAction)homePressed:(id)sender;
- (IBAction)btnPTypePressed:(id)sender;
- (IBAction)btnAddRiderPressed:(id)sender;

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

@end
