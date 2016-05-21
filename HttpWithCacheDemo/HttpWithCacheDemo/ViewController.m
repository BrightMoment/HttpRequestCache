//
//  ViewController.m
//  HttpWithCacheDemo
//
//  Created by 大有 on 16/5/17.
//  Copyright © 2016年 大有. All rights reserved.
//

#import "ViewController.h"
#import "Api.h"
#import "UIImageView+WebCache.h"

#define Start_X 0.0f             // 第一个按钮的X坐标
#define Start_Y 540.0f           // 第一个按钮的Y坐标
#define Width_Space 1.0f         // 2个按钮之间的横间距
#define Height_Space 1.0f        // 竖间距
#define Button_Height 150.0f     // 高
#define Button_Width self.view.frame.size.width/3  //宽
#define Button_Width1 (self.view.frame.size.width-100)/4  //宽
#define Button_Height1 100.0f     // 高


#define MENU_HEIGHT 25
#define MENU_BUTTON_WIDTH  60

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface ViewController ()
{
    UIScrollView * scr;
    UIView * menuView;  //8个button view
    NSMutableArray * buttonArray;
    UILabel *labSize;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    buttonArray=[NSMutableArray array];
    scr=[self add_scollview:CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT-64) Tag:1 View:self.view co:CGSizeMake(0,SCREEN_HEIGHT)];
    scr.backgroundColor=[UIColor greenColor];

    Api *api=[[Api alloc]init:self tag:@"listShopMainTypes"];
    [api listShopMainTypes];
//    [api getViewSpotTypeListWithShopType:1];
    
    float size=[self folderSizeAtPath:@"HttpRequestCache"];
    labSize=[self labelName:[NSString stringWithFormat:@"%f",size] fontSize:14.0 rect:CGRectMake(0, 400, SCREEN_WIDTH, 50) View:scr Alignment:1 Color:[UIColor redColor] Tag:0];
}

-(long long)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size;
    }
    return 0;
}
-(float)folderSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSString *cachePath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    cachePath=[cachePath stringByAppendingPathComponent:path];
    long long folderSize=0;
    if ([fileManager fileExistsAtPath:cachePath])
    {
        NSArray *childerFiles=[fileManager subpathsAtPath:cachePath];
        for (NSString *fileName in childerFiles)
        {
            NSString *fileAbsolutePath=[cachePath stringByAppendingPathComponent:fileName];
            long long size=[self fileSizeAtPath:fileAbsolutePath];
            folderSize += size;
            NSLog(@"fileAbsolutePath=%@",fileAbsolutePath);
            
        }
        //SDWebImage框架自身计算缓存的实现
        folderSize+=[[SDImageCache sharedImageCache] getSize];
        return folderSize/1024.0/1024.0;
    }
    return 0;
}
- (float )FolderSizeAtPath:(NSString*) path{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    NSString *cachePath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    cachePath=[cachePath stringByAppendingPathComponent:path];
    
    if (![manager fileExistsAtPath:cachePath]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:cachePath] objectEnumerator];
    
    NSString* fileName;
    
    long long  folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        
        NSString* fileAbsolutePath = [cachePath stringByAppendingPathComponent:fileName];
        long long size=[self fileSizeAtPath:fileAbsolutePath];
        folderSize += size;
        NSLog(@"fileAbsolutePath=%@",fileAbsolutePath);
    }
    
    return folderSize/(1024.0*1024.0);
    
}
-(void)httpSuccess:(NSDictionary *)response tag:(NSString *)tag
{
    if([tag isEqualToString:@"listShopMainTypes"])
    {
        
        [buttonArray removeAllObjects];
        buttonArray=[response objectForKey:@"items"];
        
        [self allocMenuClassView:buttonArray];
        
    }

}

-(void)httpError:(NSString *)message tag:(NSString *)tag
{
    
}
-(void)MenuAction:(UIButton *)btn
{
    NSInteger index=btn.tag;
    if (index==0) {
        [self clearCache:@"HttpRequestCache"];
    }
    float size=[self folderSizeAtPath:@"HttpRequestCache"];
    labSize.text=[NSString stringWithFormat:@"%f",size];
}

//菜单8个button
-(void)allocMenuClassView:(NSMutableArray *)menuList
{
    [menuView removeFromSuperview];
    
    menuView=[[UIView alloc] initWithFrame:CGRectMake(0, 150, SCREEN_WIDTH, 160)];
    menuView.backgroundColor=[UIColor whiteColor];
    [scr addSubview:menuView];
    
    for(int i=0;i<menuList.count;i++)
    {
        
        NSDictionary * dic =[menuList objectAtIndex:i];
        
        NSInteger index = i%4;
        NSInteger page = i/4;
        
        UIImageView * img=  [self addSubviewImage:nil rect:CGRectMake(index * (Button_Width1 + Width_Space+25)+(SCREEN_WIDTH/4-50)/2, page  * (80 + Height_Space)+5, 50, 50) View:menuView Tag:i];
//        [img sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"pic"]] placeholderImage:nil options:SDWebImageRefreshCached];
        
        [img sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:[dic objectForKey:@"pic"]] andPlaceholderImage:nil options:1 progress:nil completed:nil];
        
        [self labelName:[dic objectForKey:@"name"] fontSize:12.0f rect:CGRectMake(index * (Button_Width1 + Width_Space+25), page  * (80 + Height_Space)+60, SCREEN_WIDTH/4, 20) View:menuView Alignment:1 Color:[UIColor blackColor] Tag:i];
        
        
        [self buttonPhotoAlignment:nil hilPhoto:nil rect:CGRectMake(index * (SCREEN_WIDTH/4 + Width_Space),page  * (80 + Height_Space),SCREEN_WIDTH/4,80) title:nil select:@selector(MenuAction:) Tag:i View:menuView textColor:nil Size:nil background:[UIColor clearColor]];
        
    }
    
}
//UIButton
-(UIButton*)buttonPhotoAlignment:(NSString*)photo hilPhoto:(NSString*)Hphoto rect:(CGRect)rect  title:(NSString*)title  select:(SEL)sel Tag:(NSInteger)tag View:(UIView*)ViewA textColor:(UIColor*)textcolor Size:(UIFont*)size background:(UIColor *)background {
    UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    [button setBackgroundImage:[UIImage imageNamed:photo] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:Hphoto] forState:UIControlStateHighlighted];
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    button.tag=tag;
    [button setTitleColor:textcolor forState:UIControlStateNormal];
    button.titleLabel.font=size;
    button.backgroundColor=background;
    
    [ViewA addSubview:button];
    return button;
}
//UILabel
-(UILabel*)labelName:(NSString*)text   fontSize:(CGFloat)font  rect:(CGRect)rect View:(UIView*)viewA Alignment:(NSTextAlignment)alignment Color:(UIColor*)color Tag:(NSInteger)tag{
    UILabel*label=[[UILabel alloc]initWithFrame:rect];
    label.text=text;
    label.backgroundColor=[UIColor clearColor];
    label.textAlignment=alignment;
    label.textColor=color;
    label.numberOfLines=0;
    label.lineBreakMode=NSLineBreakByCharWrapping;
    label.font = [UIFont systemFontOfSize:font];
    label.tag=tag;
    [viewA addSubview:label];
    
    return label;
}

//UIimageView
-(UIImageView*)addSubviewImage:(NSString*)imageName  rect:(CGRect)rect View:(UIView*)viewA Tag:(NSInteger)tag{
    UIImageView*view=[[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    view.frame=rect;
    view.userInteractionEnabled=YES;
    view.tag=tag;
    [viewA addSubview:view];
    return view;
}

//UIScrollView
-(UIScrollView *)add_scollview:(CGRect)rect Tag:(NSInteger) tag View:(UIView *)ViewA co:(CGSize)co
{
    UIScrollView * scrll=[[UIScrollView alloc] initWithFrame:rect];
    scrll.tag=tag;
    scrll.scrollEnabled=YES;
    scrll.contentSize=co;
    scrll.showsVerticalScrollIndicator = NO;
    scrll.showsHorizontalScrollIndicator = NO;
    [ViewA addSubview:scrll];
    
    return scrll;
}


//同样也是利用NSFileManager API进行文件操作，SDWebImage框架自己实现了清理缓存操作，我们可以直接调用。
-(void)clearCache:(NSString *)path{
    NSString *cachePath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    cachePath=[cachePath stringByAppendingPathComponent:path];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:cachePath]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:cachePath];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *fileAbsolutePath=[cachePath stringByAppendingPathComponent:fileName];
            NSLog(@"fileAbsolutePath=%@",fileAbsolutePath);
            [fileManager removeItemAtPath:fileAbsolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
}

@end
