//
//  PremiumViewController.h
//  HLA
//
//  Created by shawal sapuan on 9/11/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface PremiumViewController : UIViewController {
    NSString *databasePath;
    sqlite3 *contactDB;
}

@property (retain, nonatomic) IBOutlet UIWebView *WebView;

@property (nonatomic, assign,readwrite) int requestMOP;
@property (nonatomic, assign,readwrite) int requestTerm;
@property (nonatomic, assign,readwrite) int requestAge;
@property (nonatomic,strong) id requestBasicSA;
@property (nonatomic,strong) id requestBasicHL;
@property (nonatomic,strong) id requestSINo;
@property (nonatomic,strong) id requestPlanCode;

@property (nonatomic, assign,readwrite) int basicRate;
@property (nonatomic, assign,readwrite) int basicLSDRate;
@property(nonatomic , retain) NSMutableArray *riderCode;
@property(nonatomic , retain) NSMutableArray *riderDesc;
@property(nonatomic , retain) NSMutableArray *riderTerm;
@property(nonatomic , retain) NSMutableArray *riderSA;
@property(nonatomic , retain) NSMutableArray *riderHL1K;
@property(nonatomic , retain) NSMutableArray *riderHL100;
@property(nonatomic , retain) NSMutableArray *riderHLP;
@property(nonatomic , retain) NSMutableArray *riderPlanOpt;
@property(nonatomic , retain) NSMutableArray *riderUnit;
@property(nonatomic , retain) NSMutableArray *riderDeduct;
@property(nonatomic , retain) NSMutableArray *riderCustCode;
@property(nonatomic , retain) NSMutableArray *riderSmoker;
@property(nonatomic , retain) NSMutableArray *riderAge;
@property (nonatomic, assign,readwrite) int riderRate;
@property (nonatomic, assign,readwrite) int riderLSDRate;
@property (nonatomic,strong) NSString *planCodeRider;
@property (nonatomic,strong) NSString *pentaSQL;
@property (nonatomic,strong) NSString *plnOptC;
@property (nonatomic,strong) NSString *planOptHMM;
@property (nonatomic,strong) NSString *deducHMM;
@property (nonatomic,strong) NSString *planHSPII;
@property (nonatomic,strong) NSString *planMGII;
@property (nonatomic,strong) NSString *planMGIV;

//display in table prem
@property (nonatomic,strong) NSString *annualRiderTot;
@property (nonatomic,strong) NSString *quarterRiderTot;
@property (nonatomic,strong) NSString *halfRiderTot;
@property (nonatomic,strong) NSString *monthRiderTot;

- (IBAction)doClose:(id)sender;

@end
