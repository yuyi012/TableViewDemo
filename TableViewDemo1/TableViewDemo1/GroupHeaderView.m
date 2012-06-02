//
//  GroupHeaderView.m
//  TableViewDemo1
//
//  Created by 俞亿 on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GroupHeaderView.h"

@implementation GroupHeaderView
@synthesize open = _open;
@synthesize groupName = _groupName;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor lightGrayColor];
        stateView = [[UIImageView alloc]initWithFrame:CGRectMake(6, 6, 17, 17)];
        stateView.image = [UIImage imageNamed:@"close.png"];
        [self addSubview:stateView];
        
        groupNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 5, 150, 20)];
        groupNameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:groupNameLabel];
    }
    return self;
}

- (void)dealloc
{
    [stateView release];
    [groupNameLabel release];
    [_groupName release];
    [super dealloc];
}

-(void)setGroupName:(NSString *)theName{
    [_groupName release];
    _groupName = [theName retain];
    groupNameLabel.text = _groupName;
}

-(void)setOpen:(BOOL)theOpen{
    _open = theOpen;
    if (_open) {
        stateView.image = [UIImage imageNamed:@"open.png"];
    }else {
        stateView.image = [UIImage imageNamed:@"close.png"];
    }
}
@end
