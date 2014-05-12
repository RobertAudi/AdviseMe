//
//  AMAdviceViewController.m
//  AdviseMe
//
//  Created by Robert Audi on 07/05/14.
//  Copyright (c) 2014 Robert Audi. All rights reserved.
//

#import "AMAdviceViewController.h"
#import <AFHTTPRequestOperationManager.h>
#import <ObjectiveSugar/ObjectiveSugar.h>
#import <AVFoundation/AVSpeechSynthesis.h>

@interface AMAdviceViewController ()

@property (weak, nonatomic) IBOutlet UIButton *adviceButton;
@property (weak, nonatomic) IBOutlet UILabel  *adviceLabel;
@property (weak, nonatomic) IBOutlet UIButton *speakButton;
@property (weak, nonatomic) IBOutlet UIButton *goodButton;
@property (weak, nonatomic) IBOutlet UIButton *badButton;

@property (strong, nonatomic) NSString *goodCookie;
@property (strong, nonatomic) NSString *badCookie;

@property (strong, nonatomic, readonly) NSArray *badWords;

@end

@implementation AMAdviceViewController

@synthesize badWords = _badWords;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)adviceButtonTapped:(id)sender
{
    self.badCookie = nil;

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:@"http://api.adviceslip.com/advice" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
         [UIView animateWithDuration:0.3 animations:^{
              CGRect frame = self.adviceButton.frame;
              frame.origin.y = 62.0;
              self.adviceButton.frame = frame;
          }];

         self.goodCookie = responseObject[@"slip"][@"advice"];
         self.adviceLabel.text = self.goodCookie;

         self.speakButton.hidden = NO;
         self.speakButton.userInteractionEnabled = YES;

         self.badButton.hidden = NO;
         self.badButton.userInteractionEnabled = YES;
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
     }];
}

- (IBAction)speak:(id)sender
{
    AVSpeechUtterance   *utterance;
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc] init];

    if (self.badButton.isHidden) {
        utterance = [AVSpeechUtterance speechUtteranceWithString:self.badCookie];
    } else {
        utterance = [AVSpeechUtterance speechUtteranceWithString:self.goodCookie];
    }

    utterance.rate = AVSpeechUtteranceDefaultSpeechRate / 3.0;

    [synthesizer speakUtterance:utterance];
}

- (IBAction)activateGoodForm:(id)sender
{
    self.adviceLabel.text = self.goodCookie;

    self.goodButton.hidden                 = YES;
    self.goodButton.userInteractionEnabled = NO;

    self.badButton.hidden                 = NO;
    self.badButton.userInteractionEnabled = YES;
}

- (IBAction)activateBadForm:(id)sender
{
    self.adviceLabel.text = self.badCookie;

    self.badButton.hidden                 = YES;
    self.badButton.userInteractionEnabled = NO;

    self.goodButton.hidden                 = NO;
    self.goodButton.userInteractionEnabled = YES;
}

- (NSString *)badCookie
{
    if (_badCookie == nil) {
        _badCookie = [self vulgarizeCookie:self.goodCookie];
    }

    return _badCookie;
}

- (NSArray *)badWords
{
    if (_badWords == nil) {
        _badWords = @[@"cunt", @"fuck", @"bitch", @"whore", @"penis", @"dick", @"bellend", @"ass",
                      @"asshole", @"buttfuck", @"fucktard", @"jerk", @"chav", @"ballsack", @"prolapse",
                      @"motherfucker", @"skank", @"bastard", @"dickhead", @"dyke", @"faggot", @"homo",
                      @"scum", @"wank", @"wanker", @"twat", @"slag", @"dipshit", @"cock", @"fatass",
                      @"fuckface", @"jerkoff", @"jackoff", @"knobhead", @"prick", @"scumbag", @"shithead",
                      @"sucker", @"turd", @"tosser", @"asslicker", @"maggot", @"douche", @"douchebag",
                      @"assclown", @"shit", @"shitstick", @"crap", @"shithole", @"cocksucker", @"slut",
                      @"numbnut", @"dickhole", @"gonad", @"shlong", @"shitstain", @"cuntmuscle", @"cockgobbler",
                      @"jizz", @"butthole", @"anus", @"assface", @"bitchass", @"bonner", @"blowjob", @"bullshit",
                      @"buttplug", @"chesticle", @"clit", @"clitface", @"clusterfuck", @"clitfuck", @"cockass",
                      @"cockface", @"shitfuck", @"cum", @"cumblaster", @"cumdumpster", @"cumfuck", @"cumslut",
                      @"cuntass", @"cuntslut", @"dickface", @"dickwad", @"dumbfuck", @"dumbass", @"fuckhole",
                      @"fucker", @"fucknutt", @"fuckwad", @"gay", @"gayass", @"gayfuck", @"gaylord", @"gaywad",
                      @"jackass", @"jagoff", @"jerkass", @"kootch", @"lesbo", @"muff", @"muffdiver", @"nutsack",
                      @"pisshead", @"poonani", @"pussy", @"pussylicker", @"queer", @"shitbag", @"snatch", @"testicle",
                      @"titfuck", @"vajayjay"];
    }

    return _badWords;
}

- (NSString *)vulgarizeCookie:(NSString *)cookie
{
    NSArray        *wordsInGoodCookie = [self.goodCookie split:@" "];
    NSMutableArray *wordsInBadCookie  = [NSMutableArray arrayWithObject:wordsInGoodCookie[0]];

    for (int i = 1, max = (int)[wordsInGoodCookie count]; i < max; i++) {
        int numberOfBadWordsToInsert = arc4random() % 3;

        [@(numberOfBadWordsToInsert)times :^{
             [wordsInBadCookie addObject:self.badWords.sample];
         }];

        [wordsInBadCookie addObject:wordsInGoodCookie[i]];
    }

    return [wordsInBadCookie join:@" "];
}

@end
