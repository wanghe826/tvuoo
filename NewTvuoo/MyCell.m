//
//  MyCell.m
//  NewTvuoo
//
//  Created by xubo on 10/20 Monday.
//  Copyright (c) 2014 wap3. All rights reserved.
//

#import "MyCell.h"
#import "EGOImageView.h"


@implementation MyCell
@synthesize typeLabel;
@synthesize capaLabel;
@synthesize imageView;
@synthesize nameLabel = _nameLabel;
@synthesize typeName = _typeName;


- (id) initWithStyle:(UITableViewCellStyle)style
     reuseIdentifier:(NSString *)reuseIdentifier
{
    if((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        hjObj = [[HJObjManager alloc] initWithLoadingBufferSize:100 memCacheSize:100];
//        NSString* cacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/Table"] ;
//        HJMOFileCache* fileCache = [[[HJMOFileCache alloc] initWithRootPath:cacheDirectory] autorelease];
//        hjObj.fileCache = fileCache;
//        
//        // Have the file cache trim itself down to a size & age limit, so it doesn't grow forever
//        fileCache.fileCountLimit = 100;
//        fileCache.fileAgeLimit = 60*60*24*7; //1 week
//        [fileCache trimCacheUsingBackgroundThread];
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        imageView = [[UIImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"logo.png"]];
        imageView = [[HJManagedImageV alloc] initWithFrame:CGRectMake(20, 10, 60, 60)];
        imageView.image = [UIImage imageNamed:@"tb_morenren2.png"];
        [self addSubview:imageView];
//        [imageView release];
        
        UILabel* namelabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 150, 30)];
        self.nameLabel = namelabel;
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
//        _nameLabel.text = _nameLabelText;
        [self.nameLabel setFont:[UIFont fontWithName:@"Courier New" size:18]];
        [self.contentView addSubview:self.nameLabel];
        [namelabel release];
        
        UILabel* typelabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 33, 40, 25)];
        self.typeLabel = typelabel;
        self.typeLabel.text = @"类型";
        [self.typeLabel setFont:[UIFont fontWithName:@"Courier New" size:15]];
        self.typeLabel.textColor = [UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1];
        [self.contentView addSubview:self.typeLabel];
        [typelabel release];
        
        UILabel* typenamee = [[UILabel alloc] initWithFrame:CGRectMake(140, 33, 100, 25)];
        self.typeName = typenamee;
        [self.typeName setFont:[UIFont fontWithName:@"Courier New" size:15]];
//        _typeName.text = _typeNameText;
        self.typeName.textColor = [UIColor colorWithRed:116.0/255.0 green:177.0/255.0 blue:79.0/255.0 alpha:1];
        [self.contentView addSubview:self.typeName];
        [typenamee release];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 40, 25)];
//        self.capaLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 40, 25)];
        self.capaLabel = label;
        self.capaLabel.text = @"大小";
        [self.capaLabel setFont:[UIFont fontWithName:@"Courier New" size:15]];
        self.capaLabel.textColor = [UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1];
        [self.contentView addSubview:self.capaLabel];
//        [self.capaLabel release];
        [label release];
        
        _capa = [[UILabel alloc] initWithFrame:CGRectMake(140,50,100,25)];
        _capa.tag = 14;
        [_capa setFont:[UIFont fontWithName:@"Courier New" size:15]];
        _capa.textColor = [UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1];
//        capa.text = [NSString stringWithFormat:@"%ldMb",(_gameInfo.androidPkgSize)/1024/1024];
//        _capa.text = _capaText;
        [self.contentView addSubview:_capa];
        [_capa release];
        
    }
    return self;
}

- (void)setImage:(NSString *)image
{
//    imageView.imageURL = [NSURL URLWithString:image];
    imageView.url = [NSURL URLWithString:image];
    [hjObj manage:imageView];
}



- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if(!newSuperview) {
//        [imageView cancelImageLoad];
    }
}

- (void)clear
{
    [imageView clear];
}

- (void)dealloc {
    [imageView clear];
    [imageView release];
    [hjObj release];
//    [_gameInfo release];
//    [_nameLabel release];
    self.nameLabel = nil;
    self.typeName = nil;
    self.capa = nil;
//    [_typeName release];
//    [_capa release];
    [super dealloc];
}

@end
