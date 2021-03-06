//+------------------------------------------------------------------+
//|                                                      MA Cross.mq4 |
//|                                                          Mr Gao  |
//|                                                 364429340@qq.com |
//+------------------------------------------------------------------+
#property copyright "Mr Gao"
#property link      "364429340@qq.com"
#property version   "1.00"
#property strict
extern double  手数=0.1;
extern double  止损=100;
extern double  止盈=300;
extern bool    移动止损=false;
extern int     多单提损=400;
extern int     空单提损=400;
extern int     提损递增幅度=200;//比如多单提损设置40点，那么价格超过开仓价40点则止损上移20点。
extern int     滑点=30;
extern double  倍投系数=1.5;
extern int     手数精度=1;//平台支持0.01的可以设置为2，这个会影响加倍后的手数大小。
extern double  最大倍投手数=20;//根据倍投次数来设置以便控制好风险
extern int     EMA1=15;//入场信号的快线
extern int     SMA2=50;//入场信号的慢线
extern int     EMA3=144;//判断方向的快线
extern int     EMA4=169;//判断方向的慢线
int buyfuwei=多单提损;
int sellfuwei=空单提损;

int start()
  {
//定义均线值-------------------------------------------------------------------
   double ema15=iMA(Symbol(),0,EMA1,0,MODE_EMA,PRICE_CLOSE,0);
   double ema50=iMA(Symbol(),0,SMA2,0,MODE_SMA,PRICE_CLOSE,0);
   double ema144=iMA(Symbol(),0,EMA3,0,MODE_EMA,PRICE_CLOSE,0);
   double ema169=iMA(Symbol(),0,EMA4,0,MODE_EMA,PRICE_CLOSE,0);
 
//buy条件：没到止盈出现反向信号平仓-------------------------------------------------------------------  
   if((ema144>ema169)&&(ema15>ema50))
     {         
       /* for(int i=0;i<OrdersTotal();i++) //扫描订单总数
            {
                if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) //选定当前持单
                  {
                     if((OrderComment()==(Symbol()+"sell"))) //如果持有空单注释一样   
                       {
                           OrderClose(OrderTicket(),OrderLots(),Ask,滑点); //空仓平仓            
                       } 
                  }
            }  */  //这段代码是持仓单没止盈的情况下出现反向信号平仓
         if((buy(getlots(),止损,止盈,Symbol()+"buy",0)>0)&&(移动止损==true)) //下多单
           {
              多单提损=buyfuwei;
           }
      }
      
//sell条件：没到止盈出现反向信号平仓-------------------------------------------------------------------
   if((ema144<ema169)&&(ema15<ema50))
     {
       /* for(int i1=0;i1<OrdersTotal();i1++)
            {
                if(OrderSelect(i1,SELECT_BY_POS,MODE_TRADES))
                  {
                     if((OrderComment()==(Symbol()+"buy")))    
                       {
                          OrderClose(OrderTicket(),OrderLots(),Bid,滑点);             
                       } 
                  }
            } */
         if((sell(getlots(),止损,止盈,Symbol()+"sell",0)>0)&&(移动止损==true))
           {
              空单提损=sellfuwei;
           }
      }
  
//追踪止损设置------------------------------------------------------------------- 
  if(移动止损==true)
      { 
          for(int i=0;i<OrdersTotal();i++) //扫描订单总数
               {
                   if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) //选定当前持单
                     {
                       if((OrderComment()==(Symbol()+"buy"))) //如果持单编号一致
                         {
                              if(((Bid-OrderOpenPrice())/Point)>=多单提损) //如果买价-开仓价/点数>=移动止损
                                {
                                   double buysl=OrderStopLoss(); //获取订单止损价格
                                   if(OrderModify(OrderTicket(),OrderOpenPrice(),buysl+提损递增幅度*Point,OrderTakeProfit(),0)==true) 
                                   //修改止损:止损价+提损递增幅度 
                                     {
                                        多单提损=多单提损+提损递增幅度; //从新赋值移动止损
                                     }
                                }                 
                         } 
                       if((OrderComment()==(Symbol()+"sell")))    
                         {
                              if(((OrderOpenPrice()-Ask)/Point)>=空单提损)
                                {
                                   double sellsl=OrderStopLoss();
                                   if(OrderModify(OrderTicket(),OrderOpenPrice(),sellsl-提损递增幅度*Point,OrderTakeProfit(),0)==true)
                                     {
                                        空单提损=空单提损+提损递增幅度;
                                     }
                                }                 
                         }
                      }
                 }
           return(0);
      }
   return(0);
   }
 
//亏损加仓设置---------------------------------------------------------------------------  
   double getlots()
     {
        double lotsok=手数;
        if(OrdersHistoryTotal()>0)
           {
              for(int i=OrdersHistoryTotal()-1;i>0;i--)
                {
                   if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
                     {
                         if(OrderSymbol()==Symbol())
                           {
                              if(OrderMagicNumber()==0) 
                                {
                                   if(OrderProfit()>0)
                                     {
                                        lotsok=手数;
                                     }
                                   else
                                     {
                                       lotsok=DoubleToStr(NormalizeDouble(OrderLots()*倍投系数,手数精度),手数精度);
                                       Print("lotsok: "+lotsok);
                                       if(lotsok>最大倍投手数)
                                          {
                                             lotsok=最大倍投手数;
                                          }
                                        break;
                                     }
                                   break;
                                }
                          }
                    }
               }
           }
    else
      {
        return(手数);
      }
    return(lotsok);
      }
  
  
//buy函数----------------------------------------------------------------
int buy(double Lots,double sun,double ying,string comment,int magic)
    {
          int kaiguan=0; //初始化开关为打开
            for(int i=0;i<OrdersTotal();i++) //扫描订单总数
               {
                   if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) //选定当前持单
                     {
                       if((OrderComment()==comment)&&(OrderMagicNumber()==magic)) //如果当前持单注释和编号和设定的一致，则开关关闭不下单。    
                         {
                           kaiguan=1;                     
                         } 
                      }
               }
            if(kaiguan==0) //如果开关打开
              {
                   int ticket=OrderSend(Symbol( ) ,OP_BUY,Lots,Ask,滑点,0,0,comment,magic,0,White); //开仓买入多单，不设止盈止损（下单成功返回编号，失败返回-1）
                   if(ticket>0) //下单成功
                   {
                    if(OrderSelect(ticket, SELECT_BY_TICKET)==true) //选定订单如果编号一致
                      {
                       if((sun!=0)&&(ying!=0)) //不设止损止盈的情况
                        {
                          OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-sun*MarketInfo(Symbol(),MODE_POINT),OrderOpenPrice()+ying*MarketInfo(Symbol(),MODE_POINT),0,Red); 
                          //修改止盈止损
                        }
                       if((sun==0)&&(ying!=0)) //不设止损，设置止盈的情况
                        {
                          OrderModify(OrderTicket(),OrderOpenPrice(),0,OrderOpenPrice()+ying*MarketInfo(Symbol(),MODE_POINT),0,Red); 
                          //修改止盈
                        }
                       if((sun!=0)&&(ying==0)) //设置止损，不设止盈的情况
                        {
                          OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-sun*MarketInfo(Symbol(),MODE_POINT),0,0,Red); 
                          //修改止损
                        }
                      }
                   }
              return(ticket);
              }
             else
              {
               return(0);
              }
     }
  
//sell函数----------------------------------------------------------------
int sell(double Lots,double sun,double ying,string comment,int magic)
    {
               int kaiguan=0;
                 for(int i=0;i<OrdersTotal();i++)
                    {
                        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
                          {
                            if((OrderComment()==comment)&&(OrderMagicNumber()==magic))   
                              {
                                kaiguan=1;                     
                              } 
                           }
                    }
                 if(kaiguan==0)
                   {
                        int ticket=OrderSend(Symbol( ) ,OP_SELL,Lots,Bid,滑点,0,0,comment,magic,0,Red);
                        if(ticket>0)
                        {
                          if(OrderSelect(ticket, SELECT_BY_TICKET)==true)
                           {
                             if((sun!=0)&&(ying!=0))
                              {
                               OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+sun*MarketInfo(Symbol(),MODE_POINT),OrderOpenPrice()-ying*MarketInfo(Symbol(),MODE_POINT),0,Red);
                              } 
                             if((sun==0)&&(ying!=0))
                              {
                               OrderModify(OrderTicket(),OrderOpenPrice(),0,OrderOpenPrice()-ying*MarketInfo(Symbol(),MODE_POINT),0,Red);
                              } 
                             if((sun!=0)&&(ying==0))
                              {
                               OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+sun*MarketInfo(Symbol(),MODE_POINT),0,0,Red);
                              } 
                           }
                        }
                        return(ticket);
                   }
                  else
                   {
                    return(0);
                   } 
    }

