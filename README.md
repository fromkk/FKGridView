FKGridView
==========

簡単なグリッドレイアウトをObjective-Cで表現します。

![ScreenShot](http://fromkk.me/wp-content/uploads/2014/03/2245debba0f64de3d1d5c2e4fc1714bf.png)

## Sample code
> //initialize  
> self.gridView = [FKGridView new];  
> //set view frame  
> self.gridView.frame = self.view.bounds;  
> //set col counts  
> self.gridView.cols = 3;  
> //auto resize items.  
> self.gridView.autoresizeWidth = YES; 
> //add subview  
> [self.view addSubview:self.gridView];  
> 
> for (int i = 0; i < 102; i++) {  
>     //create subview  
>     UIView *currentView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, (320.0f - 5.0f * 4.0f) / 3.0f, rand() % 10 * 10.0f)];  
>     //red background color  
>     currentView.backgroundColor = [UIColor redColor];  
>     //add item. if animated is NO then stop animation.  
>     [self.gridView addGridItemView:currentView animated:YES];  
> }  
