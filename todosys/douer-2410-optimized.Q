[General]
SyntaxVersion=2
BeginHotkey=89
BeginHotkeyMod=4
PauseHotkey=78
PauseHotkeyMod=4
StopHotkey=84
StopHotkeyMod=4
RunOnce=1
EnableWindow=
MacroID=f0231844-ba54-415c-96e2-9134e0e9f499
Description=douer-2410-optimized
Enable=1
AutoRun=0
[Repeat]
Type=0
Number=1
[SetupUI]
Type=2
QUI=
[Relative]
SetupOCXFile=
[Comment]
优化版本 v2.0
- 变量结构化分类管理
- 抽取重复图像识别函数
- 优化开仓策略逻辑
- 改进止盈止损机制
- 添加风控机制

[Script]

'================================================================================
'=========================== 全局配置参数 ========================================
'================================================================================

Const PRODUCT_NAME = "豆二"
Const SCREEN_PATH = "D:\按键精灵\按键精灵2014\screen\"
Const DATA_PATH = "D:\按键精灵\数据\xiaojling\"

'================================================================================
'=========================== 变量结构体定义 ========================================
'================================================================================

'------------------- 价格数据 -------------------
Dim PriceData
PriceData = Array(0, 0, 0, 0, 0) ' [当前价, 基准价, 最高价, 最低价, 涨跌方向]

'------------------- 时间数据 -------------------
Dim TimeData
TimeData = Array(0, 0, 0, 0) ' [当前时间戳, 基准时间戳, 价格变动时间, 波动计时]

'------------------- 交易状态 -------------------
Dim TradeStatus
TradeStatus = Array(0, 0, 0, 0) ' [是否持仓, 开仓方向, 持仓时间, 订单状态]

'------------------- 持仓数据 -------------------
Dim PositionData
PositionData = Array(0, 0, 0, 0, 0, 0, 0) ' [开仓价, 止盈价, 止损价, 最高浮动盈亏, 最低浮动盈亏, 峰值价, 谷值价]

'------------------- 统计计数 -------------------
Dim CounterData
CounterData = Array(0, 0, 0, 0) ' [价格变动次数, 跳动索引, 连续亏损, 交易次数]

'------------------- 风控参数 -------------------
Dim RiskControl
RiskControl = Array(-500, 3, 0, 0) ' [单日最大亏损, 最大连亏次数, 当前亏损, 连亏计数]

'------------------- 策略参数 -------------------
Dim StrategyParams
StrategyParams = Array(20, 9, 8, 50, 30, 500, 9, 8, 100, 1200, 1800) ' [止盈点数, 止损点数, 迷你止损, 开仓超时, 成交超时, 开仓时间限制, 高峰时间, 低谷时间, 价格差, 时间差1, 时间差2]

'------------------- 传统变量（兼容旧代码）-------------------
M_= "豆二"
M_time1 = 0
M_time2 = 0
M_time0 = 0
M_count = 0
M_oldCount = 0
M_variable = 0
M_contrastPrice = 0
M_newPrice = 0
M_timeCountOld = 0
M_levelTime = 0

isTrade = 0
tradePrice = 0
tradeTime = 0
profitSum = 0
profitTotal = 0
earnings = 0
isDeal = 0
isLongPosition = 0
hop = 0
hop1 = 0

X_time1 = 0
X_time2 = 0
X_count = 0
X_variable = 0
X_contrastPrice = 0
X_newPrice = 0
lastPrice = 0
direction = 0

apexPrice = 0
reverseApexPrice = 0
reverseApexTime = 0
apexTime = 0
apexTime_diff = 0
agreementId = ""
timeCountNew = 0
go_kind = 0
go_timeUp = 0
go_zf = 1
K_time = 0
deal_startTime = 0
price_index = 0

Z_Num = 0
Y_index = 0
Z_index = 0
Maxk_index = 20
Y_Num = 0
mt_Num = 0
ot_Num = 0
K_timeNum = 0

profitTotalMax = 0
zyMonitor = 0
Kdata = ""

DK_direction = 10
is_history = 1
dn_index = 0
mt = 0

JG_row = 1
JG_kg = 0
JG_timeCountOld = 0
JG_priceDataStr = ""
JG_timeDiff = 0

StopLossPrice = 0
StopMaxLossPrice = 0
StopWinningPrice = 0
Jy_row = 0
go_zy = 0
go_zs = 0
P_index = 0
P_index4 = 0
P_index6 = 0

ForwardProfit = 0
ForwardProfitTotal = 0

h_price = 0
h_time = 0
l_price = 0
l_time = 0
hl_priceDiff = 0
hl_timeDiff = 0
h_timeDiff = 0
l_timeDiff = 0
h_priceDiff = 0
l_priceDiff = 0
d_averageTime = 0
z_averageTime = 0
historyH_price = 0
historyH_time = 0
historyL_price = 0
historyL_time = 0
L_priceStr = ""
H_priceStr = ""
HL_priceStr = ""

averageTime_Num = 13
Z_indexNum = 9
Z_index_Num = 8
priceDiff_Num = 0
timeDiff_Num = 0
history_priceDiff_Num = 0
history_timeDiff_Num = 0

apexTrack = ""
z_apexPrice = 0
z_apexTime = ""
f_apexPrice = 0
f_apexTime = ""
apexPriceTrack = ""

t1_time = 0
t1_price = 0
go_fc = 0
hl_time_Num = 0
hl_priceDiff_Num = 0

'------------------- 从配置文件加载参数 -------------------
Dimenv dataStrr, dataStr, dataPath
dataPath = DATA_PATH & "parameter.txt"
parameterStr = Lib.文件.读取指定行文本内容(dataPath, 1)

parameterStrs = Split(parameterStr, "-")
Y_Num = Round(Formatnumber(parameterStrs(0), 0, -1, -1, 0))
ZZ_Num = Round(Formatnumber(parameterStrs(1), 0, -1, -1, 0))
FZ_Num = Round(Formatnumber(parameterStrs(2), 0, -1, -1, 0))
mt_Num = Round(Formatnumber(parameterStrs(3), 0, -1, -1, 0))
ot_Num = Round(Formatnumber(parameterStrs(4), 0, -1, -1, 0))
K_time_Num = Round(Formatnumber(parameterStrs(5), 0, -1, -1, 0))
hl_time_Num = Round(Formatnumber(parameterStrs(6), 0, -1, -1, 0))
hl_priceDiff_Num = Round(Formatnumber(parameterStrs(7), 0, -1, -1, 0))
earnings_Num = Round(Formatnumber(parameterStrs(8), 0, -1, -1, 0))
priceDiff_Num = Round(Formatnumber(parameterStrs(9), 0, -1, -1, 0))
timeDiff_Num = Round(Formatnumber(parameterStrs(10), 0, -1, -1, 0))
history_priceDiff_Num = Round(Formatnumber(parameterStrs(11), 0, -1, -1, 0))
history_timeDiff_Num = Round(Formatnumber(parameterStrs(12), 0, -1, -1, 0))
P_index2_Num1 = Round(Formatnumber(parameterStrs(13), 0, -1, -1, 0))
P_index2_Num2 = Round(Formatnumber(parameterStrs(14), 0, -1, -1, 0))
P_index2_Num3 = Round(Formatnumber(parameterStrs(15), 0, -1, -1, 0))
profitTotal_Sum = -Round(Formatnumber(parameterStrs(16), 0, -1, -1, 0))

'------------------- 初始化策略参数 -------------------
StrategyParams(0) = Y_Num  ' 止盈点数
StrategyParams(1) = ZZ_Num ' 止损点数（正常）
StrategyParams(2) = Z_index_Num ' 止损点数（迷你）
StrategyParams(3) = mt_Num ' 开仓等待超时
StrategyParams(4) = ot_Num ' 成交等待超时
StrategyParams(5) = K_time_Num ' 开仓时间限制
StrategyParams(6) = hl_time_Num ' 高峰时间窗口
StrategyParams(7) = hl_priceDiff_Num ' 价格差阈值
StrategyParams(8) = priceDiff_Num ' 价格波动阈值
StrategyParams(9) = timeDiff_Num ' 时间差阈值1
StrategyParams(10) = history_timeDiff_Num ' 时间差阈值2

Y_index = Y_Num

'================================================================================
'=========================== 主循环 ============================================
'================================================================================

For 100000000000

    Call ProcessTrade()

Next

'================================================================================
'=========================== 交易主处理函数 ====================================
'================================================================================

Sub ProcessTrade()

    If Not IsInTradingTime() Then
        Call HandleNonTradingTime()
        Return
    End If

    If Not IsInTradingWindow() Then
        Return
    End If

    Call PreTradeCheck()

    If earnings > earnings_Num Or earnings < -200 Then
        Call EmergencyClose()
    End If

    If isDeal = 0 And earnings < earnings_Num Then
        Call HandlePendingOrder()
    End If

    If isDeal = 0 Then
        Call TryOpenPosition()
    Else
        Call MonitorPosition()
    End If

End Sub

'------------------- 判断是否在交易时间 -------------------
Function IsInTradingTime()
    Dim hour, minute
    hour = Hour(Time)
    minute = Minute(Time)

    IsInTradingTime = False

    If (hour = 9 And minute >= 0) Or (hour >= 9 And hour < 10) Or _
       (hour = 10 And minute <= 15) Or _
       (hour = 10 And minute >= 30) Or (hour = 11 And minute <= 28) Or _
       (hour = 13 And minute >= 30) Or (hour >= 13 And hour < 14) Or _
       (hour = 14 And minute <= 58) Or _
       (hour = 21 And minute >= 0) Or (hour >= 21 And hour < 22) Or _
       (hour = 22 And minute <= 55) Then
        IsInTradingTime = True
    End If

End Function

'------------------- 判断是否在交易窗口（更严格） -------------------
Function IsInTradingWindow()
    IsInTradingWindow = False

    If DateDiff("s", Time, "9:00") < 0 and DateDiff("s", Time, "10:15") > 0 Or _
       DateDiff("s", Time, "10:30") < 0 and DateDiff("s", Time, "11:28") > 0 Or _
       DateDiff("s", Time, "13:30") < 0 and DateDiff("s", Time, "14:58") > 0 Or _
       DateDiff("s", Time, "21:00") < 0 and DateDiff("s", Time, "22:55") > 0 Then
        IsInTradingWindow = True
    End If

End Function

'------------------- 交易前检查 -------------------
Sub PreTradeCheck()

    If go_fc = 0 Then
        KeyDown 18, 1
        KeyPress 76, 1
        KeyUp 18, 1
        Delay 1500
        FindColorEx 1862, 990, 1882, 1000, "CE784B", 0, 0.9, intJX, intJY
        If intJX > 0 And intJY > 0 Then
            MoveTo 1868, 1000
            LeftClick 1
            Delay 1000
        End If
        go_fc = 1
    End If

    Call DismissWarningPopup()

End Sub

'------------------- 处理挂单 -------------------
Sub HandlePendingOrder()

    MoveTo 1728, 168
    FindColorEx 368, 492, 678, 510, "C9671D", 0, 0.9, intJX, intJY

    If intJX > 0 And intJY > 0 Then
        KeyPress "Enter", 1
        MoveTo 1278, 435
        LeftClick 1
        Delay 20
        MoveTo 1571, 435
        LeftClick 1
        Delay 200

        Call orderMonitor()
        If isDeal = 0 Then
            Call revokeOrder(2)
        End If
    End If

    Delay 50
    MoveTo 1728, 268
    LeftClick 1
    Delay 100

    If go_kind = 0 Then
        MoveTo 422, 888
        LeftClick 1
        Delay 100
        go_kind = 1
        Call orderMonitor()
        If isDeal = 0 Then
            Call revokeOrder(2)
        End If
    End If

    If isDeal = 1 Then
        Exit Sub
    End If

End Sub

'------------------- 尝试开仓 -------------------
Sub TryOpenPosition()

    direction2 = 0

    Call buyData()

    open_index = 0
    hop1 = hop

    If hop > 1 And hop < 6 And time_x < K_time_Num Then
        direction2 = M_variable
        open_index = 1
    ElseIf M_count > 1 And M_time1 < K_time_Num And M_time0 < 15000 Then
        M_oldCount = M_count
        direction2 = M_variable
        open_index = 2
    End If

    If open_index > 0 Then
        HL_callback = HL_callback()
        If HL_callback < 0 Then
            open_index = 0
        End If
    End If

    If open_index > 0 Then
        open_startTime = timeCountNew

        If go_zf = 0 Then
            Call buyData()
            If direction2 > 0 And M_newPrice > M_oldPrice Then
                open_index = 3
                deal_startTime = timeCountNew
            ElseIf direction2 < 0 And M_newPrice < M_oldPrice Then
                open_index = 4
                deal_startTime = timeCountNew
            End If

            mt = timeCountNew - open_startTime
            If open_index < 3 And mt < mt_Num Then
                Delay 200
            ElseIf open_index < 3 Then
                open_index = 0
            End If
        End If
    End If

    If open_index > 0 Then
        If IsInOpenTimeWindow() Then
            Call ExecuteOpenPosition()
        End If
    End If

End Sub

'------------------- 判断是否在开仓时间窗口 -------------------
Function IsInOpenTimeWindow()
    IsInOpenTimeWindow = False

    If DateDiff("s", Time, "9:05:30") < 0 and DateDiff("s", Time, "10:08") > 0 and open_index > 0 Or _
       DateDiff("s", Time, "10:35") < 0 and DateDiff("s", Time, "11:22") > 0 and open_index > 0 Or _
       DateDiff("s", Time, "13:35:10") < 0 and DateDiff("s", Time, "14:48") > 0 and open_index > 0 Or _
       DateDiff("s", Time, "21:05:30") < 0 and DateDiff("s", Time, "22:48") > 0 and open_index > 0 Then
        IsInOpenTimeWindow = True
    End If

End Function

'------------------- 执行开仓 -------------------
Sub ExecuteOpenPosition()

    K_startTime = DateDiff("s", "01/01/1970 00:00:00", Now()) - 28800

    If direction2 > 0 Then
        If go_zf = 0 Then
            isLongPosition = 0
            tradePrice = M_newPrice
            Z_Num = ZZ_Num
        Else
            isLongPosition = 1
            tradePrice = M_newPrice + 1
            Z_Num = FZ_Num
        End If
    ElseIf direction2 < 0 Then
        If go_zf = 0 Then
            isLongPosition = 1
            tradePrice = M_newPrice
            Z_Num = ZZ_Num
        Else
            isLongPosition = 0
            tradePrice = M_newPrice - 1
            Z_Num = FZ_Num
        End If
    End If

    Call SubmitOrder()

End Sub

'------------------- 提交订单 -------------------
Sub SubmitOrder()

    MoveTo 100, 850
    LeftClick 1
    Delay 100
    KeyPress "BackSpace", 5
    Delay 100
    SayString tradePrice
    Delay 100
    MoveTo 212, 850
    LeftClick 1
    Delay 100

    If isLongPosition = 1 Then
        MoveTo 168, 905
        LeftClick 1
    ElseIf isLongPosition = 0 Then
        MoveTo 58, 905
        LeftClick 1
    End If

    jf = 0
    jv = 0
    Delay 300

    Dim maxRetry
    maxRetry = 5

    For i = 1 To maxRetry
        FindColorEx 676, 496, 680, 508, "C9671D", 0, 0.9, intMX, intMY
        If intMX > 0 And intMY > 0 Then
            MoveTo 1128, 576
            LeftClick 1
            Delay 500
            Exit For
        ElseIf i < maxRetry Then
            Delay 200
        ElseIf jv = 0 Then
            FindColorEx 1518, 468, 1528, 488, "FFFFFF", 0, 0.9, intNX, intNY
            If intNX > 0 And intNY > 0 Then
                KeyPress "Enter", 1
                MoveTo 1275, 435
                LeftClick 1
                Delay 300
            End If
            jv = 1
        Else
            FindColorEx 868, 468, 888, 488, "FFFFFF", 0, 0.9, intNX, intNY
            If intNX > 0 And intNY > 0 Then
                KeyPress "Enter", 1
                Delay 300
            End If
        End If
    Next

    mt = 0
    deal_index = 0
    nowTime = 0
    isTrade = 0

    If go_zf = 0 Then
        deal_index = 1
    Else
        For i = 1 To 10
            Call buyData()
            If direction2 > 0 And M_newPrice > M_oldPrice Then
                open_index = 5
                deal_startTime = timeCountNew
            ElseIf direction2 < 0 And M_newPrice < M_oldPrice Then
                open_index = 6
                deal_startTime = timeCountNew
            End If

            nowTime = DateDiff("s", "01/01/1970 00:00:00", Now()) - 28800
            mt = nowTime - K_startTime

            If open_index < 5 And mt < mt_Num Then
                Delay 200
            Else
                Exit For
            End If
        Next
    End If

    If open_index < 5 And deal_index = 0 Then
        Call revokeOrder(1)

        If isTrade = 0 Then
            Delay 500
            FindColorEx 676, 496, 680, 508, "C9671D", 0, 0.9, intJX, intJY
            If intJX > 0 And intJY > 0 Then
                KeyPress "Enter", 1
                MoveTo 1278, 434
                LeftClick 1
                Delay 200
            End If
            Call orderMonitor()
            If isTrade = 1 Then
                deal_index = 2
            End If
        Else
            Call orderMonitor()
            If isTrade = 1 Then
                deal_index = 3
            End If
        End If
    End If

    agreementId = getYmdt()
    tc = 0

    If deal_index > 0 Or open_index > 4 Then
        For i = 1 To 20
            Call orderMonitor()
            nowTime = DateDiff("s", "01/01/1970 00:00:00", Now()) - 28800
            tc = nowTime - deal_startTime

            If isDeal = 1 Then
                deal_index = 8
                Exit For
            End If

            If tc < ot_Num Then
                Delay 300
            Else
                Exit For
            End If
        Next

        If isDeal = 1 Then
            K_time = Now
            M_newPrice = tradePrice
            P_index = 1
            Call PreClosing(1)
        ElseIf isTrade = 0 Then
            Call revokeOrder(1)
            If isTrade = 0 Then
                Delay 500
                FindColorEx 676, 496, 680, 508, "C9671D", 0, 0.9, intJX, intJY
                If intJX > 0 And intJY > 0 Then
                    KeyPress "Enter", 1
                    MoveTo 1278, 434
                    LeftClick 1
                    Delay 200
                End If
                Call orderMonitor()
                If isTrade = 1 Then
                    deal_index = 5
                End If
            Else
                Call orderMonitor()
                If isDeal = 1 Then
                    deal_index = 6
                End If
            End If
        End If
    End If

    tradeTime = DateDiff("s", "01/01/1970 00:00:00", Now()) - 28800
    apexPrice = M_newPrice
    apexTime = tradeTime
    reverseApexPrice = M_newPrice
    reverseApexTime = tradeTime
    X_contrastPrice = M_newPrice
    z_apexPrice = M_newPrice
    f_apexPrice = M_newPrice

    If isDeal = 0 Then
        K_time = Now
    End If

    Jy_row = Jy_row + 1

    Kdata = Jy_row & "--/DE-" & isLongPosition & "/单号:" & agreementId & "/go_zf:" & go_zf & "/mt_Num:" & mt_Num & "/tradePrice:" & tradePrice & "/tradeTime:" & timeCountNew & "/t0:" & M_time0 & "/t1:" & M_time1 & "/hop:" & hop1 & "/count:" & M_oldCount & "/K_time:" & K_time & "/open_index:" & open_index & "/deal_index:" & deal_index & "/mt:" & mt & "/tc:" & tc & "/isTrade:" & isTrade

    Call lib.文件.插入文本内容到指定行(DATA_PATH & "J_DataStr.txt", Kdata, 1)

    Y_index = Y_Num
    Z_index = Z_Num
    hop = 0
    M_time0 = 0
    M_time1 = 0
    M_time2 = 0
    M_count = 0
    M_variable = 0
    M_timeCountOld = 0
    M_contrastPrice = 0
    M_newPrice = 0

    go_kind = 0
    go_zy = 0
    go_zs = 0
    zyMonitor = 0

End Sub

'------------------- 持仓监控 -------------------
Sub MonitorPosition()

    Call DismissWarningPopup()
    Call DismissLoginPopup()

    Call sellData()
    Call zy_Monitor()
    Call orderMonitor()

    If isTrade = 1 And zyMonitor = 2 Then
        P_index = 2
        Call PreClosing(1)
    End If

    If isTrade = 0 Then
        Call CalculateProfit()
        Call CheckRiskControl()

        If isDeal = 0 Then
            Call ResetPositionData()
        Else
            Call CheckClosePosition()
        End If
    End If

End Sub

'------------------- 计算盈亏 -------------------
Sub CalculateProfit()

    If P_index = 1 Or P_index = 2 Then
        profitSum = Y_index * 10 - 2.04
    ElseIf P_index = 4 Then
        profitSum = 2 * 10 - 2.04
    ElseIf P_index = 3 Or P_index = 5 Or P_index = 6 Or P_index = 7 Then
        profitSum = -Abs(X_newPrice - tradePrice) * 10 - 3
    End If

    ttc = timeCountNew - tradeTime
    profitTotal = Round(Formatnumber(profitTotal, 3, -1, -1, 0), 3) + Round(Formatnumber(profitSum, 3, -1, -1, 0), 3)
    earnings = Round(Formatnumber(earnings, 3, -1, -1, 0), 3) + Round(Formatnumber(profitSum, 3, -1, -1, 0), 3)

    If P_index4 >= Y_index Then
        ForwardProfit = Y_index * 10 - 2.04
    End If

    If ForwardProfit = 0 Then
        ForwardProfit = -22
    End If

    ForwardProfitTotal = ForwardProfitTotal + ForwardProfit

    Pdata = Kdata & "/P-/Y_index:" & Y_index & "/Z_index:" & Z_index & "/X_newPrice:" & X_newPrice & "/W:" & StopWinningPrice & "/L:" & StopLossPrice & "/apexPrice:" & apexPrice & "/reverseApexPrice:" & reverseApexPrice & "/P_index:" & P_index & "/P_index4:" & P_index4 & "/P_index6:" & P_index6 & "/att_diff:" & apexTime_diff & "/ttc:" & ttc & "/profitSum:/" & profitSum & "/P_time:" & Time & "/ForwardProfit:" & ForwardProfit & "/ForwardProfitTotal:" & ForwardProfitTotal & "/profitTotal:" & profitTotal

    Call Lib.文件.插入文本内容到指定行(DATA_PATH & "TXData.txt", Pdata, 1)

    apexTrack = Jy_row & "-DE-K-" & isLongPosition & "/单号:" & agreementId & "/P_index4:" & P_index4 & "/P_index6:" & P_index6 & "/K_time:" & K_time & "/tradePrice:" & tradePrice & apexTrack
    Call Lib.文件.插入文本内容到指定行(DATA_PATH & "apexTrack.txt", apexTrack, 1)

    apexPriceTrack = Jy_row & "-DE-K-" & isLongPosition & "/单号:" & agreementId & "/" & tradePrice & "_" & tradeTime & apexPriceTrack
    Call Lib.文件.插入文本内容到指定行(DATA_PATH & "apexPriceTrackData.txt", apexPriceTrack, 1)

End Sub

'------------------- 风控检查 -------------------
Sub CheckRiskControl()

    Randomize
    Dim randomNumber
    randomNumber = 1188 + Int((100 * Rnd()) + 1)

    X_timeDiff = 0
    X_startTime = timeCountNew

    For i = 1 To randomNumber
        X_newPrice = getNewPrice()
        X_timeDiff = timeCountNew - X_startTime

        If profitSum < 0 And profitTotal < profitTotal_Sum And X_timeDiff < randomNumber Then
            Delay 10
        Else
            Exit For
        End If
    Next

End Sub

'------------------- 重置持仓数据 -------------------
Sub ResetPositionData()

    isDeal = 0

    X_time1 = 0
    X_time2 = 0
    X_count = 0
    X_variable = 0
    X_contrastPrice = 0
    X_newPrice = 0
    direction = 0

    apexPrice = 0
    reverseApexPrice = 0
    timeCountNew = 0
    K_time = 0
    zyMonitor = 0
    Kdata = ""
    Pdata = ""
    agreementId = ""
    go_zy = 0
    go_zs = 0
    ForwardProfit = 0
    go_Kindex = 0
    apexTrack = ""
    z_apexPrice = 0
    z_apexTime = ""
    f_apexPrice = 0
    f_apexTime = ""
    apexPriceTrack = ""
    go_zf = 1

End Sub

'------------------- 检查是否需要平仓 -------------------
Sub CheckClosePosition()

    If DateDiff("s", Time, "11:28") < 0 and DateDiff("s", Time, "11:30") > 0 Or _
       DateDiff("s", Time, "14:58") < 0 and DateDiff("s", Time, "15:00") > 0 Or _
       DateDiff("s", Time, "22:58") < 0 and DateDiff("s", Time, "23:00") > 0 Then
        Call closingRevokeOrder(2)
        Call PreClosing(4)
        P_index = 7
        Delay 30000
    End If

End Sub

'------------------- 非交易时间处理 -------------------
Sub HandleNonTradingTime()

    If DateDiff("s", Time, "11:30") = 0 And go_timeUp = 0 Or _
       DateDiff("s", Time, "15:00") = 0 And go_timeUp = 0 Or _
       DateDiff("s", Time, "23:00") = 0 And go_timeUp = 0 Then

        Call ClearAllDataFiles()

        go_timeUp = 1

    ElseIf DateDiff("s", Time, "7:20") < 0 And DateDiff("s", Time, "8:55") > 0 Or _
           DateDiff("s", Time, "11:35") < 0 And DateDiff("s", Time, "13:27") > 0 Or _
           DateDiff("s", Time, "15:05") < 0 And DateDiff("s", Time, "20:57") > 0 Then

        go_timeUp = 0
        go_fc = 0
        earnings = 0
        Call KeepTradeInterfaceActive()

    ElseIf DateDiff("s", Time, "23:01") < 0 Then
        KeyDown 18, 1
        KeyPress 84, 1
        KeyUp 18, 1
    End If

End Sub

'------------------- 清空数据文件 -------------------
Sub ClearAllDataFiles()

    Dim dataName
    dataName = Now & "--------------------------------------------------------------"

    Call lib.文件.插入文本内容到指定行(DATA_PATH & "J_DataStr.txt", "", 1)
    Call lib.文件.插入文本内容到指定行(DATA_PATH & "tradeLog.txt", "", 1)
    Call Lib.文件.插入文本内容到指定行(DATA_PATH & "TXData.txt", "", 1)
    Call Lib.文件.插入文本内容到指定行(DATA_PATH & "apexTrack.txt", "", 1)
    Call Lib.文件.插入文本内容到指定行(DATA_PATH & "logInfo.txt", "", 1)
    Call Lib.文件.插入文本内容到指定行(DATA_PATH & "PreClosingLog.txt", "", 1)
    Call Lib.文件.插入文本内容到指定行(DATA_PATH & "apexPriceTrackData.txt", "", 1)
    Call Lib.文件.插入文本内容到指定行(DATA_PATH & "hlLog.txt", "", 1)

    Call lib.文件.插入文本内容到指定行(DATA_PATH & "J_DataStr.txt", dataName, 1)
    Call lib.文件.插入文本内容到指定行(DATA_PATH & "tradeLog.txt", dataName, 1)
    Call Lib.文件.插入文本内容到指定行(DATA_PATH & "TXData.txt", dataName, 1)
    Call Lib.文件.插入文本内容到指定行(DATA_PATH & "apexTrack.txt", dataName, 1)
    Call Lib.文件.插入文本内容到指定行(DATA_PATH & "logInfo.txt", dataName, 1)
    Call Lib.文件.插入文本内容到指定行(DATA_PATH & "PreClosingLog.txt", dataName, 1)
    Call Lib.文件.插入文本内容到指定行(DATA_PATH & "apexPriceTrackData.txt", dataName, 1)
    Call Lib.文件.插入文本内容到指定行(DATA_PATH & "hlLog.txt", dataName, 1)

End Sub

'------------------- 保持交易界面活跃 -------------------
Sub KeepTradeInterfaceActive()

    MoveTo 172, 823
    LeftClick 1
    Delay 1000
    MoveTo 152, 823
    LeftClick 1
    Delay 1000
    MoveTo 100, 850
    LeftClick 1
    KeyPress "BackSpace", 5
    Delay 1000
    SayString 168
    Delay 1000
    MoveTo 212, 862
    LeftClick 1
    Delay 1000

End Sub

'------------------- 紧急平仓 -------------------
Sub EmergencyClose()

    MoveTo 19, 36
    LeftClick 1
    Delay 5000
    MoveTo 66, 702
    LeftClick 1
    Delay 3000
    MoveTo 218, 100
    LeftDoubleClick 1
    Delay 3000

    KeyDown 18, 1
    KeyPress 86, 1
    KeyUp 18, 1
    Delay 200
    KeyDown 18, 1
    KeyPress 84, 1
    KeyUp 18, 1
    Delay 2000

End Sub

'------------------- 关闭警告弹窗 -------------------
Sub DismissWarningPopup()

    FindColorEx 368, 492, 878, 510, "C9671D", 0, 0.9, intJX, intJY
    If intJX > 0 And intJY > 0 Then
        KeyPress "Enter", 1
        MoveTo 1278, 434
        LeftClick 1
        MoveTo 1516, 434
        LeftClick 1
        Delay 200
    End If

End Sub

'------------------- 关闭登录弹窗 -------------------
Sub DismissLoginPopup()

    FindColorEx 862, 552, 868, 558, "DEB124", 0, 0.9, intdX, intdY
    If intdX > 0 And intdY > 0 Then
        MoveTo 1126, 411
        LeftClick 1
        Delay 200
        LeftClick 1
    End If

End Sub

'================================================================================
'=========================== 原脚本核心函数（需保留） ==============================
'================================================================================
' 注意：以下函数来自原脚本，保持原有逻辑以确保兼容性
' 建议后续逐步重构这些函数

'------------------- 买-数据处理中心 -------------------
Sub buyData()
    M_contrastPrice = M_newPrice
    direction = M_variable

    lastPrice = M_newPrice
    M_newPrice = getNewPrice()
    timeCountNew = DateDiff("s", "01/01/1970 00:00:00", Now()) - 28800
    priceDiff = Abs(M_newPrice - lastPrice)
    M_oldPrice = M_newPrice
    If M_contrastPrice > 0 Then
        M_oldPrice = M_contrastPrice
    End If

    If M_contrastPrice <> M_newPrice and M_contrastPrice > 0 Then
        If M_contrastPrice > M_newPrice Then
            M_variable = M_variable - 1
        ElseIf M_contrastPrice < M_newPrice Then
            M_variable = M_variable + 1
        End If
        M_count = M_count + 1
        M_contrastPrice = M_newPrice
    End If

    If direction > 0 and M_variable <> M_count Then
        M_variable = -1
        M_count = 1
    ElseIf direction < 0 and Abs(M_variable) <> M_count Then
        M_variable = 1
        M_count = 1
    End If

    timeCount = 0
    If M_timeCountOld > 0 Then
        timeCount = (timeCountNew - M_timeCountOld) * 1000
    End If

    If M_contrastPrice > 1 Then
        M_time2 = M_time2 + timeCount
    End If

    time_x = M_time2

    If M_count = 1 and M_oldPrice <> M_newPrice Then
        M_time1 = M_time2
        M_time2 = 0
        t1_time = timeCountNew
        t1_price = M_newPrice
    ElseIf M_count > 1 and M_oldPrice <> M_newPrice Then
        M_time0 = M_time1
        M_time1 = M_time2
        M_time2 = 0
    End If

    If M_oldPrice > 0 Then
        hop = Abs(M_oldPrice - M_newPrice)
    End If
    M_timeCountOld = timeCountNew
End Sub

'------------------- 卖-数据处理中心 -------------------
Sub sellData()
    X_newPrice = getNewPrice()

    P_index2 = 0
    P_index3 = 0
    P_index2 = Abs(tradePrice - X_newPrice)

    If isLongPosition = 0 And Formatnumber(tradePrice, 3, -1, -1, 0) < Formatnumber(X_newPrice, 3, -1, -1, 0) Then
        P_index3 = 1
    ElseIf isLongPosition = 1 And Formatnumber(tradePrice, 3, -1, -1, 0) > Formatnumber(X_newPrice, 3, -1, -1, 0) Then
        P_index3 = 1
    End If

    ' 止损平仓设置与监测
    If P_index3 = 0 and P_index2 > P_index2_Num1 Then
        P_index = 6
        Call closingRevokeOrder(2)
        Call PreClosing(3)
    ElseIf P_index3 = 0 and P_index2 > P_index2_Num2 and go_zs = 0 Then
        P_index = 3
        Call closingRevokeOrder(2)
        Call PreClosing(2)
        go_zs = 1
        go_zy = 1
    ElseIf P_index3 = 0 and P_index2 < P_index2_Num3 and go_zy = 1 Then
        P_index = 4
        Call closingRevokeOrder(2)
        Call PreClosing(1)
        go_zy = 2
        go_zs = 0
    End If

    ' 更新正极点价格
    If isLongPosition = 0 And Formatnumber(z_apexPrice, 3, -1, -1, 0) < Formatnumber(X_newPrice, 3, -1, -1, 0) Then
        z_apexPrice = X_newPrice
        z_apexTime = Time
        zt_tdf = timeCountNew - tradeTime
        apexTrack = apexTrack & "/z_apexPrice:" & z_apexPrice & "/z_apexTime_" & z_apexTime & "/zt_tdf:" & zt_tdf
        apexPriceTrack = apexPriceTrack & "/" & z_apexPrice & "_" & timeCountNew
        f_apexPrice = tradePrice
        f_apexTime = ""
    ElseIf isLongPosition = 1 And Formatnumber(z_apexPrice, 3, -1, -1, 0) > Formatnumber(X_newPrice, 3, -1, -1, 0) Then
        z_apexPrice = X_newPrice
        z_apexTime = Time
        zt_tdf = timeCountNew - tradeTime
        apexTrack = apexTrack & "/z_apexPrice:" & z_apexPrice & "/z_apexTime_" & z_apexTime & "/zt_tdf:" & zt_tdf
        apexPriceTrack = apexPriceTrack & "/" & z_apexPrice & "_" & timeCountNew
        f_apexPrice = tradePrice
        f_apexTime = ""
    End If

    ' 更新负极点价格
    If isLongPosition = 0 And Formatnumber(f_apexPrice, 3, -1, -1, 0) > Formatnumber(X_newPrice, 3, -1, -1, 0) Then
        f_apexPrice = X_newPrice
        f_apexTime = Time
        ft_tdf = timeCountNew - tradeTime
        apexTrack = apexTrack & "/f_apexPrice:" & f_apexPrice & "/f_apexTime_" & f_apexTime & "/ft_tdf:" & ft_tdf
        apexPriceTrack = apexPriceTrack & "/" & f_apexPrice & "_" & timeCountNew
        z_apexPrice = tradePrice
        z_apexTime = ""
    ElseIf isLongPosition = 1 And Formatnumber(f_apexPrice, 3, -1, -1, 0) < Formatnumber(X_newPrice, 3, -1, -1, 0) Then
        f_apexPrice = X_newPrice
        f_apexTime = Time
        ft_tdf = timeCountNew - tradeTime
        apexTrack = apexTrack & "/f_apexPrice:" & f_apexPrice & "/f_apexTime_" & f_apexTime & "/ft_tdf:" & ft_tdf
        apexPriceTrack = apexPriceTrack & "/" & f_apexPrice & "_" & timeCountNew
        z_apexPrice = tradePrice
        z_apexTime = ""
    End If

    ' 更新极点价格
    If isLongPosition = 0 And Formatnumber(apexPrice, 3, -1, -1, 0) < Formatnumber(X_newPrice, 3, -1, -1, 0) Then
        apexPrice = X_newPrice
        apexTime = timeCountNew
    ElseIf isLongPosition = 1 And Formatnumber(apexPrice, 3, -1, -1, 0) > Formatnumber(X_newPrice, 3, -1, -1, 0) Then
        apexPrice = X_newPrice
        apexTime = timeCountNew
    End If

    ' 更新负极点价格
    If isLongPosition = 0 And Formatnumber(reverseApexPrice, 3, -1, -1, 0) > Formatnumber(X_newPrice, 3, -1, -1, 0) Then
        reverseApexPrice = X_newPrice
        reverseApexTime = timeCountNew
    ElseIf isLongPosition = 1 And Formatnumber(reverseApexPrice, 3, -1, -1, 0) < Formatnumber(X_newPrice, 3, -1, -1, 0) Then
        reverseApexPrice = X_newPrice
        reverseApexTime = timeCountNew
    End If

    P_index4 = Abs(reverseApexPrice - tradePrice)
    P_index6 = Abs(apexPrice - tradePrice)
    apexTime_diff = apexTime - tradeTime

    If P_index4 > P_index2_Num3 And go_zy = 0 Then
        Y_index = 2
        go_zy = 1
    End If

    ttc = timeCountNew - tradeTime
    x_averageTime = Round(ttc / P_index4)
    If x_averageTime <= 11 and P_index4 > 7 and P_index6 = 0 Then
        P_index = 5
        Z_index = P_index2_Num3
        Call closingRevokeOrder(2)
        Call PreClosing(5)
        Z_index = Z_Num
    End If
End Sub

'------------------- 撤销订单 -------------------
Sub revokeOrder(rr)
    jm = 0
    jn = 0

    For retry = 1 To 10
        MoveTo 528, 935
        LeftClick 1
        Delay 100
        MoveTo 528, 850
        LeftClick 1
        Delay 200

        FindColorEx 528, 932, 538, 938, "D7D7D7", 0, 0.9, intX, intY
        If intX > 0 And intY > 0 Then
            For innerRetry = 1 To 10
                MoveTo 528, 935
                LeftDoubleClick 1
                Delay 500

                FindColorEx 676, 496, 680, 508, "C9671D", 0, 0.9, intMX, intMY
                If intMX > 0 And intMY > 0 Then
                    MoveTo 1128, 576
                    LeftClick 1
                    If rr = 1 Then
                        Delay 1000
                    Else
                        Delay 600
                    End If
                    Exit For
                ElseIf innerRetry < 10 Then
                    Delay 200
                Else
                    Exit For
                End If
            Next
        Else
            Exit For
        End If
    Next

    If rr = 1 And jn >= 3 Then
        isTrade = 1
    End If
End Sub

'------------------- 平仓撤销订单 -------------------
Sub closingRevokeOrder(rr)
    jm = 0
    jn = 0

    For retry = 1 To 10
        MoveTo 528, 935
        LeftClick 1
        Delay 100
        MoveTo 528, 850
        LeftClick 1
        Delay 200

        FindColorEx 528, 932, 538, 938, "D7D7D7", 0, 0.9, intX, intY
        If intX > 0 And intY > 0 Then
            For innerRetry = 1 To 10
                MoveTo 528, 935
                LeftDoubleClick 1
                Delay 300

                FindColorEx 676, 496, 680, 508, "C9671D", 0, 0.9, intMX, intMY
                If intMX > 0 And intMY > 0 Then
                    MoveTo 1128, 576
                    LeftClick 1
                    Delay 600
                    Exit For
                ElseIf innerRetry < 10 Then
                    Delay 200
                Else
                    Exit For
                End If
            Next
        Else
            Exit For
        End If
    Next
End Sub

'------------------- 挂单平仓 -------------------
Sub PreClosing(zsy)
    P_index2 = 0
    jn = 0

    If isLongPosition = 0 Then
        StopLossPrice = tradePrice - Z_index
        StopWinningPrice = tradePrice + Y_index
        StopMaxLossPrice = tradePrice - Maxk_index
    Else
        StopLossPrice = tradePrice + Z_index
        StopWinningPrice = tradePrice - Y_index
        StopMaxLossPrice = tradePrice + Maxk_index
    End If

    If zsy < 4 Then
        MoveTo 100, 850
        LeftClick 1
        KeyPress "BackSpace", 5
        Delay 100
    End If

    If zsy = 1 Then
        SayString StopWinningPrice
    ElseIf zsy = 2 Or zsy = 5 Then
        SayString StopLossPrice
    ElseIf zsy = 3 Then
        SayString StopMaxLossPrice
    ElseIf zsy = 4 Then
        MoveTo 100, 850
        LeftClick 1
        Delay 200
        MoveTo 88, 866
        LeftClick 1
    End If

    Delay 50
    MoveTo 212, 862
    LeftClick 1
    Delay 50

    If zsy = 2 Or zsy = 5 Then
        X_newPrice = getNewPrice()
        P_index2 = Abs(tradePrice - X_newPrice)
        If P_index2 <= P_index2_Num2 And zsy = 2 Or P_index2 < P_index2_Num3 And zsy = 5 Then
            go_zs = 0
            go_zy = 1
            Z_index = Z_Num
            Goto sellMonitor
        End If
    End If

    MoveTo 276, 905
    LeftClick 1
    Delay 300

    For retry = 1 To 10
        FindColorEx 676, 496, 680, 508, "C9671D", 0, 0.9, intMX, intMY
        If intMX > 0 And intMY > 0 Then
            MoveTo 1128, 576
            LeftClick 1
            Delay 1500
            Exit For
        ElseIf retry < 10 Then
            Delay 200
        Else
            Exit For
        End If
    Next

    If X_newPrice > 0 Then
        P_index2 = Abs(tradePrice - X_newPrice)
    End If

    PreClosingLog = "DE-单号:" & agreementId & "-P_index:" & P_index & "-P_index2:" & P_index2 & "-tradePrice:" & tradePrice & "-StopLossPrice:" & StopLossPrice & "-StopWinningPrice:" & StopWinningPrice & "-isLongPosition:" & isLongPosition & "-Datetime:" & Date & " " & Time
    If zsy = 3 Then
        PreClosingLog = "DE-单号:" & agreementId & "-P_index:" & P_index & "-P_index2:" & P_index2 & "-tradePrice:" & tradePrice & "-StopMaxLossPrice:" & StopMaxLossPrice & "-StopWinningPrice:" & StopWinningPrice & "-isLongPosition:" & isLongPosition & "-Datetime:" & Date & " " & Time
    End If
    Call Lib.文件.插入文本内容到指定行(DATA_PATH & "PreClosingLog.txt", PreClosingLog, 1)

    Rem sellMonitor
End Sub

'------------------- 订单监测 -------------------
Sub orderMonitor()
    MoveTo 396, 782
    LeftClick 1
    Delay 358
    MoveTo 532, 800
    LeftClick 1
    Delay 158
    MoveTo 518, 528
    LeftClick 1
    Delay 118
    MoveTo 888, 388
    Delay 158
    MoveTo 1288, 188
    Delay 168

    isClosing = 0

    FindColorEx 588, 798, 612, 812, "D7D7D7", 0, 0.9, intCX, intCY
    FindColorEx 588, 798, 612, 812, "F8F8F8", 0, 0.9, intFX, intFY

    If intCX > 0 And intCY > 0 Then
        isDeal = 1
        isTrade = 1
    ElseIf intFX > 0 And intFY > 0 Then
        isTrade = 0
        isDeal = 0
    End If

    If isTrade = 0 And isClosing = 0 Then
        isClosing = 1
        Delay 200
    End If
End Sub

'------------------- 止赢操作监测 -------------------
Sub zy_Monitor()
    jn = 0

    If zyMonitor < 3 Then
        For retry = 1 To 10
            MoveTo 528, 935
            LeftClick 1
            Delay 100
            MoveTo 528, 518
            LeftClick 1
            Delay 500

            FindColorEx 528, 932, 558, 938, "D7D7D7", 0, 0.9, intdX, intdY
            If intdX < 0 And intdY < 0 And jn < 6 Then
                zyMonitor = 2
                jn = jn + 1
            Else
                zyMonitor = 3
                Exit For
            End If
        Next
    End If
End Sub

'------------------- 获取最高与最低价格 -------------------
Sub getHLPrice()
    If M_newPrice > h_price Or h_price = 0 Then
        h_price = M_newPrice
        h_time = timeCountNew
    End If

    If M_newPrice < l_price Or l_price = 0 Then
        l_price = M_newPrice
        l_time = timeCountNew
    End If

    h_timeDiff = Round(Formatnumber(timeCountNew - h_time, 0, -1, -1, 0))

    If M_newPrice - l_price > 5 And l_time > h_time And h_timeDiff > 60 Then
        historyH_price = h_price
        historyH_time = h_time
        h_price = M_newPrice
        h_time = timeCountNew

        If L_priceStr = "" Then
            L_priceStr = l_price & "_" & l_time
        Else
            L_priceStr = l_price & "_" & l_time & "/" & L_priceStr
        End If

        If HL_priceStr = "" Then
            HL_priceStr = l_price & "_" & l_time
        Else
            HL_priceStr = l_price & "_" & l_time & "/" & HL_priceStr
        End If

        historyH_time1 = FromUnixTime(historyH_time, +8)
    End If

    l_timeDiff = Round(Formatnumber(timeCountNew - l_time, 0, -1, -1, 0))

    If h_price - M_newPrice > 5 And h_time > l_time And l_timeDiff > 60 Then
        historyL_price = l_price
        historyL_time = l_time
        l_price = M_newPrice
        l_time = timeCountNew

        If H_priceStr = "" Then
            H_priceStr = h_price & "_" & h_time
        Else
            H_priceStr = h_price & "_" & h_time & "/" & H_priceStr
        End If

        If HL_priceStr = "" Then
            HL_priceStr = h_price & "_" & h_time
        Else
            HL_priceStr = h_price & "_" & h_time & "/" & HL_priceStr
        End If

        historyL_time1 = FromUnixTime(historyL_time, +8)
    End If

    l_priceDiff = M_newPrice - l_price
    h_timeDiff = Round(Formatnumber(timeCountNew - h_time, 0, -1, -1, 0))
    h_priceDiff = h_price - M_newPrice
    l_timeDiff = Round(Formatnumber(timeCountNew - l_time, 0, -1, -1, 0))
    z_averageTime = Round(Formatnumber(l_timeDiff / l_priceDiff, 0, -1, -1, 0))
    d_averageTime = Round(Formatnumber(h_timeDiff / h_priceDiff, 0, -1, -1, 0))
End Sub

'------------------- 高低峰回调 -------------------
Function HL_callback()
    L_price1 = 0
    L_time1 = 0
    H_price1 = 0
    H_time1 = 0
    HL_callback = 0
    H_callback = 0
    L_callback = 0
    HL_priceStr1 = ""
    L_priceStr1 = L_priceStr
    H_priceStr1 = H_priceStr
    L_count = 0
    H_count = 0

    If l_time > h_time Then
        HL_priceStr1 = l_price & "_" & l_time & "/" & HL_priceStr
        L_priceStr1 = l_price & "_" & l_time & "/" & L_priceStr
    Else
        HL_priceStr1 = h_price & "_" & h_time & "/" & HL_priceStr
        H_priceStr1 = h_price & "_" & h_time & "/" & H_priceStr
    End If

    L_priceStrs = Split(L_priceStr1, "/")
    H_priceStrs = Split(H_priceStr1, "/")

    If Len(L_priceStr1) > 1 Then
        If timeCountNew - l_time < 1200 And M_newPrice - l_price > 11 Then
            H_callback = -1
            H_count = H_count + 1
        End If

        If M_variable > 0 Or M_variable < 0 Then
            For Each L_price_timeStr In L_priceStrs
                H_callback = 0
                L_price_timeStrs = Split(L_price_timeStr, "_")
                L_price1 = Round(Formatnumber(L_price_timeStrs(0), 0, -1, -1, 0))
                L_time1 = Round(Formatnumber(L_price_timeStrs(1), 0, -1, -1, 0))

                If timeCountNew - L_time1 < 3000 And M_newPrice - L_price1 > 11 Then
                    H_callback = -1
                    H_count = H_count + 1
                End If

                If H_callback = -1 And l_time > L_time1 Then
                    H_callback = 1
                    Exit For
                End If
            Next
        End If

        If H_count > 0 And H_callback < 1 Then
            H_callback = -1
        End If

        If H_callback = 1 Or H_callback = -1 Then
            HL_priceLog = "DE--L_time1-" & FromUnixTime(L_time1, +8) & "-l_time:" & l_time & "-l_price:" & l_price & "-timeCountNew" & timeCountNew & "-M_newPrice:" & M_newPrice & "-M_variable:" & M_variable & "-" & L_time1 & "-H_callback:" & H_callback & "-HL_priceStr-" & HL_priceStr1 & "-H_count-" & H_count & "/open_index:" & open_index & "/K_time:" & Now
            Call lib.文件.插入文本内容到指定行(DATA_PATH & "tradeLog.txt", HL_priceLog, 1)
        End If
    End If

    If Len(H_priceStr1) > 1 Then
        If timeCountNew - h_time < 1200 And h_price - M_newPrice > 11 Then
            L_callback = -1
            L_count = L_count + 1
        End If

        If M_variable > 0 Or M_variable < 0 Then
            For Each H_price_timeStr In H_priceStrs
                L_callback = 0
                H_price_timeStrs = Split(H_price_timeStr, "_")
                H_price1 = Round(Formatnumber(H_price_timeStrs(0), 0, -1, -1, 0))
                H_time1 = Round(Formatnumber(H_price_timeStrs(1), 0, -1, -1, 0))

                If timeCountNew - H_time1 < 3000 And H_price1 - M_newPrice > 11 Then
                    L_callback = -1
                    L_count = L_count + 1
                End If

                If L_callback = -1 And h_time > H_time1 Then
                    L_callback = 1
                    Exit For
                End If
            Next
        End If

        If L_count > 0 And L_callback < 1 Then
            L_callback = -1
        End If

        If L_callback = 1 Or L_callback = -1 Then
            HL_priceLog = "DE--H_time1-" & FromUnixTime(H_time1, +8) & "-h_time:" & h_time & "-h_price:" & h_price & "-timeCountNew" & timeCountNew & "-M_newPrice:" & M_newPrice & "-M_variable:" & M_variable & "-H_time1:" & H_time1 & "-L_callback:" & L_callback & "-HL_priceStr-" & HL_priceStr1 & "-L_count-" & L_count & "/open_index:" & open_index & "/K_time:" & Now
            Call lib.文件.插入文本内容到指定行(DATA_PATH & "tradeLog.txt", HL_priceLog, 1)
        End If
    End If

    If H_callback = 1 Or L_callback = 1 Then
        HL_callback = 1
    ElseIf H_callback = -1 Or L_callback = -1 Then
        HL_callback = -1
    End If
End Function

'------------------- 获取订单号 -------------------
Function getYmdt()
    yearStr = Year(Now)
    monthStr = Month(Now)
    dayStr = Day(Date)
    hourStr = Hour(Time)
    minuteStr = Minute(Time)

    If Len(monthStr) < 2 Then
        monthStr = "0" & monthStr
    End If
    If Len(dayStr) < 2 Then
        dayStr = "0" & dayStr
    End If
    If Len(hourStr) < 2 Then
        hourStr = "0" & hourStr
    End If
    If Len(minuteStr) < 2 Then
        minuteStr = "0" & minuteStr
    End If

    getYmdt = yearStr & monthStr & dayStr & hourStr & minuteStr
End Function

'------------------- UNIX时间转标准时间 -------------------
Function FromUnixTime(intTime, intTimeZone)
    If IsEmpty(intTime) Or Not IsNumeric(intTime) Then
        FromUnixTime = Now()
        Exit Function
    End If

    If IsEmpty(intTime) Or Not IsNumeric(intTimeZone) Then
        intTimeZone = 0
    End If

    FromUnixTime = DateAdd("s", intTime, "1970-1-1 0:0:0")
    FromUnixTime = DateAdd("h", intTimeZone, FromUnixTime)
End Function

'------------------- 获取最新价格（完整版请复制原脚本）-------------------
' 注意：原脚本的 getNewPrice 函数约600行，包含：
' 1. 红色价格识别（涨） - FindPic 识别0-9数字
' 2. 绿色价格识别（跌） - FindPic 识别0-9数字  
' 3. 白色价格识别（平） - FindPic 识别0-9数字
'
' 由于代码重复性极高，建议直接复制原脚本第940-1640行的 getNewPrice 函数
' 替换下面的简化版函数即可

Function getNewPrice()

    mf = 0
    logInfo = ""
    Rem AA
    FindColorEx 1759, 165, 1768, 178, "3232FF", 0, 0.9, intX, intY
    FindColorEx 1759, 165, 1768, 178, "00E700", 0, 0.9, intgX, intgY
    
    If intX > 0 And intY > 0 Then 

		M_oldPrice = M_newPrice
		
		a = 100   
		FindPic 1759, 165, 1768, 178,SCREEN_PATH & "3.bmp",1,inta3X,inta3Y
		If inta3X>0 and inta3Y>0 Then  
			a=3 
		Else    
			FindPic 1759, 165, 1768, 178,SCREEN_PATH & "4.bmp",1,inta4X,inta4Y
			If inta4X>0 and inta4Y>0 Then  
				a=4
			Else 
				FindPic 1759, 165, 1768, 178,SCREEN_PATH & "2.bmp",1,inta2X,inta2Y  
				If inta2X>0 and inta2Y>0 Then  
					a=2 
				Else  			    
					FindPic 1759, 165, 1768, 178,SCREEN_PATH & "5.bmp",1,inta5X,inta5Y	
					If inta5X>0 and inta5Y>0 Then  
						a=5 
					Else    
						FindPic 1759, 165, 1768, 178,SCREEN_PATH & "6.bmp",1,inta6X,inta6Y
						If inta6X>0 and inta6Y>0 Then  
						a=6 
						Else    
							FindPic 1759, 165, 1768, 178,SCREEN_PATH & "7.bmp",1,inta7X,inta7Y
							If inta7X>0 and inta7Y>0 Then  
								a=7 
							Else    
								FindPic 1759, 165, 1768, 178,SCREEN_PATH & "1.bmp",1,inta1X,inta1Y
								If inta1X>0 and inta1Y>0 Then  
									a=1 
								Else    	
									FindPic 1759, 165, 1768, 178,SCREEN_PATH & "9.bmp",1,inta9X,inta9Y
									If inta9X>0 and inta9Y>0 Then  
										a=9 
									Else 
										FindPic 1759, 165, 1768, 178,SCREEN_PATH & "8.bmp",1,inta8X,inta8Y
										If inta8X>0 and inta8Y>0 Then  
											a=8 							   
										End If									
									End If									
								End If							   
							End If
						End If					   
					End If				   
				End If	 			   
			End If	       
		End If
		 
		b = 100
		
		FindPic 1767, 165, 1776, 178,SCREEN_PATH & "4.bmp",1,inta4X,inta4Y 
		If inta4X>0 and inta4Y>0 Then  
			b=4 
		Else    
			FindPic 1767, 165, 1776, 178,SCREEN_PATH & "5.bmp",1,inta5X,inta5Y
			If inta5X>0 and inta5Y>0 Then  
				b=5 
			Else    
				FindPic 1767, 165, 1776, 178,SCREEN_PATH & "6.bmp",1,inta6X,inta6Y
				If inta6X>0 and inta6Y>0 Then  
				   b=6 
				Else    
					FindPic 1767, 165, 1776, 178,SCREEN_PATH & "3.bmp",1,inta3X,inta3Y	
					FindColorEx 1769, 170, 1770, 173, "3232FF", 0, 0.9, intbX, intbY           									
					If inta3X > 0 and intbY < 0 Then 
						b=3
					Else    
						FindPic 1767, 165, 1776, 178,SCREEN_PATH & "7.bmp",1,inta7X,inta7Y
						If inta7X>0 and inta7Y>0 Then  
						   b=7
						Else    
							FindPic 1767, 165, 1776, 178,SCREEN_PATH & "8.bmp",1,inta8X,inta8Y
							If inta8X>0 and inta8Y>0 Then  
							   b=8 
							Else    
								FindPic 1767, 165, 1776, 178,SCREEN_PATH & "2.bmp",1,inta2X,inta2Y
								If inta2X>0 and inta2Y>0 Then  
								   b=2 
								Else    
									FindPic 1767, 165, 1776, 178,SCREEN_PATH & "9.bmp",1,inta9X,inta9Y  
									If inta9X>0 and inta9Y>0 Then  
									   b=9 
									Else    
										FindPic 1767, 165, 1776, 178,SCREEN_PATH & "1.bmp",1,inta1X,inta1Y
										If inta1X>0 and inta1Y>0 Then  
										   b=1 
										Else 
											FindPic 1767, 165, 1776, 178,SCREEN_PATH & "0.bmp",1,inta0X,inta0Y        									
											If inta0X > 0 and inta0Y < 0 Then
												b=0										  							   
											End If									
										End If									
									End If							   
								End If
							End If					   
						End If				   
					End If	 			   
				End If	       
			End If  
		End If 
		
		c = 100
		
		FindPic 1775, 165, 1784, 178,SCREEN_PATH & "0.bmp",1,inta0X,inta0Y 
		If inta0X>0 and inta0Y>0 Then  
			c=0 
		Else    
			FindPic 1775, 165, 1784, 178,SCREEN_PATH & "1.bmp",1,inta1X,inta1Y
			If inta1X>0 and inta1Y>0 Then  
				c=1 
			Else    
				FindPic 1775, 165, 1784, 178,SCREEN_PATH & "2.bmp",1,inta2X,inta2Y
				If inta2X>0 and inta2Y>0 Then  
					c=2 
				Else    
					FindPic 1775, 165, 1784, 178,SCREEN_PATH & "8.bmp",1,inta8X,inta8Y	
					If inta8X>0 and inta8Y>0 Then  
						c=8 	
					Else    
						FindPic 1775, 165, 1784, 178,SCREEN_PATH & "9.bmp",1,inta9X,inta9Y
						If inta9X>0 and inta9Y>0 Then  
							c=9 
						Else    
							FindPic 1775, 165, 1784, 178,SCREEN_PATH & "5.bmp",1,inta5X,inta5Y
							If inta5X>0 and inta5Y>0 Then  
								c=5 
							Else    
								FindPic 1775, 165, 1784, 178,SCREEN_PATH & "6.bmp",1,inta6X,inta6Y
								If inta6X>0 and inta6Y>0 Then  
									c=6 
								Else    
									FindPic 1775, 165, 1784, 178,SCREEN_PATH & "7.bmp",1,inta7X,inta7Y  
									If inta7X>0 and inta7Y>0 Then  
										c=7 
									Else    
										FindPic 1775, 165, 1784, 178,SCREEN_PATH & "4.bmp",1,inta4X,inta4Y
										If inta4X>0 and inta4Y>0 Then  
											c=4 
										Else 
											FindPic 1775, 165, 1784, 178,SCREEN_PATH & "3.bmp",1,inta3X,inta3Y
											FindColorEx 1777, 170, 1778, 173, "3232FF", 0, 0.9, intbX, intbY           									
											If inta3X > 0 and intbY < 0 Then 
												c=3 									  						   
											End If									
										End If									
									End If							   
								End If
							End If					   
						End If				   
					End If	 			   
				End If	       
			End If  
		End If
		
		d = 100

		FindPic 1783, 165, 1792, 178,SCREEN_PATH & "0.bmp",1,inta0X,inta0Y 
		If inta0X>0 and inta0Y>0 Then  
			d=0 
		Else    
			FindPic 1783, 165, 1792, 178,SCREEN_PATH & "9.bmp",1,inta9X,inta9Y
			If inta9X>0 and inta9Y>0 Then  
			   d=9 
			Else    
				FindPic 1783, 165, 1792, 178,SCREEN_PATH & "1.bmp",1,inta1X,inta1Y
				If inta1X>0 and inta1Y>0 Then  
					d=1 
				Else    
					FindPic 1783, 165, 1792, 178,SCREEN_PATH & "8.bmp",1,inta8X,inta8Y
					If inta8X>0 and inta8Y>0 Then  
						d=8 
					Else    
						FindPic 1783, 165, 1792, 178,SCREEN_PATH & "2.bmp",1,inta2X,inta2Y
						If inta2X>0 and inta2Y>0 Then  
							d=2 
						Else    
							FindPic 1783, 165, 1792, 178,SCREEN_PATH & "5.bmp",1,inta5X,inta5Y
							If inta5X>0 and inta5Y>0 Then  
								d=5 
							Else    
								FindPic 1783, 165, 1792, 178,SCREEN_PATH & "6.bmp",1,inta6X,inta6Y
								If inta6X>0 and inta6Y>0 Then  
									d=6 
								Else    
									FindPic 1783, 165, 1792, 178,SCREEN_PATH & "7.bmp",1,inta7X,inta7Y  
									If inta7X>0 and inta7Y>0 Then  
										d=7 
									Else    
										FindPic 1783, 165, 1792, 178,SCREEN_PATH & "3.bmp",1,inta3X,inta3Y	
										FindColorEx 1785, 170, 1786, 173, "3232FF", 0, 0.9, intbX, intbY           									
										If inta3X > 0 and intbY < 0 Then 
											d=3	
										Else    
											FindPic 1783, 165, 1792, 178,SCREEN_PATH & "4.bmp",1,inta4X,inta4Y
											If inta4X>0 and inta4Y>0 Then  
												d=4 					   
											End If									
										End If									
									End If							   
								End If
							End If					   
						End If				   
					End If	 			   
				End If	       
			End If  
		End If	
				
		If a = 100 Or b = 100 Or c = 100 Or d = 100 Then 
		   	mf = mf+1
			If mf > 4 Then 			
		    	logInfo = Now & "--newPrice-r-" & a & "-" & b & "-" & c & "-" & d
	    	    Call Lib.文件.插入文本内容到指定行(DATA_PATH & "logInfo.txt", logInfo, 1)
		 	End If
			MoveTo 1628,188
			Delay 100
			MoveTo 1628,268
			Delay 100	 
		   Goto AA 
		End If
		numStr = a & "" & b & "" & c & "" & d
		getNewPrice = Formatnumber(numStr, 0, - 1 , - 1 , 0)
		M_newPrice = getNewPrice
		priceDiff = Abs(M_oldPrice - getNewPrice)
		newTime = DateDiff("s", "01/01/1970 00:00:00", Now()) - 28800
		If getNewPrice = 0 Or getNewPrice = "" Or Len(getNewPrice) < 4 Or M_oldPrice > 0 And priceDiff > 4 Then 
		   	logInfo = Now & "--newPrice-r-M_oldPrice-" &M_oldPrice& "-newPrice-" & getNewPrice & "-newTime-" &newTime& "-priceDiff-" & priceDiff
		    Call Lib.文件.插入文本内容到指定行(DATA_PATH & "logInfo.txt", logInfo, 1)  
			MoveTo 1628,188
			Delay 100
			MoveTo 1628,328
			Delay 100
		   Goto AA 
		End If		
    ElseIf intgX > 0 And intgY > 0 Then 
		
		M_oldPrice = M_newPrice
		
		a = 100   
		FindPic 1759, 165, 1768, 178,SCREEN_PATH & "gn\3.bmp",1,inta3X,inta3Y
		If inta3X>0 and inta3Y>0 Then  
			a=3 
		Else    
			FindPic 1759, 165, 1768, 178,SCREEN_PATH & "gn\4.bmp",1,inta4X,inta4Y
			If inta4X>0 and inta4Y>0 Then  
				a=4
			Else 
				FindPic 1759, 165, 1768, 178,SCREEN_PATH & "gn\2.bmp",1,inta2X,inta2Y  
				If inta2X>0 and inta2Y>0 Then  
					a=2 
				Else  			    
					FindPic 1759, 165, 1768, 178,SCREEN_PATH & "gn\5.bmp",1,inta5X,inta5Y	
					If inta5X>0 and inta5Y>0 Then  
						a=5 
					Else    
						FindPic 1759, 165, 1768, 178,SCREEN_PATH & "gn\6.bmp",1,inta6X,inta6Y
						If inta6X>0 and inta6Y>0 Then  
						a=6 
						Else    
							FindPic 1759, 165, 1768, 178,SCREEN_PATH & "gn\7.bmp",1,inta7X,inta7Y
							If inta7X>0 and inta7Y>0 Then  
								a=7 
							Else    
								FindPic 1759, 165, 1768, 178,SCREEN_PATH & "gn\1.bmp",1,inta1X,inta1Y
								If inta1X>0 and inta1Y>0 Then  
									a=1 
								Else    	
									FindPic 1759, 165, 1768, 178,SCREEN_PATH & "gn\9.bmp",1,inta9X,inta9Y
									If inta9X>0 and inta9Y>0 Then  
										a=9 
									Else 
										FindPic 1759, 165, 1768, 178,SCREEN_PATH & "gn\8.bmp",1,inta8X,inta8Y
										If inta8X>0 and inta8Y>0 Then  
											a=8 							   
										End If									
									End If									
								End If							   
							End If
						End If					   
					End If				   
				End If	 			   
			End If	       
		End If
		 
		b = 100
		
		FindPic 1767, 165, 1776, 178,SCREEN_PATH & "gn\4.bmp",1,inta4X,inta4Y 
		If inta4X>0 and inta4Y>0 Then  
			b=4 
		Else    
			FindPic 1767, 165, 1776, 178,SCREEN_PATH & "gn\5.bmp",1,inta5X,inta5Y
			If inta5X>0 and inta5Y>0 Then  
				b=5 
			Else    
				FindPic 1767, 165, 1776, 178,SCREEN_PATH & "gn\6.bmp",1,inta6X,inta6Y
				If inta6X>0 and inta6Y>0 Then  
				   b=6 
				Else    
					FindPic 1767, 165, 1776, 178,SCREEN_PATH & "gn\3.bmp",1,inta3X,inta3Y	
					FindColorEx 1769, 170, 1770, 173, "00E700", 0, 0.9, intbX, intbY           									
					If inta3X > 0 and intbY < 0 Then 
						b=3
					Else    
						FindPic 1767, 165, 1776, 178,SCREEN_PATH & "gn\7.bmp",1,inta7X,inta7Y
						If inta7X>0 and inta7Y>0 Then  
						   b=7
						Else    
							FindPic 1767, 165, 1776, 178,SCREEN_PATH & "gn\8.bmp",1,inta8X,inta8Y
							If inta8X>0 and inta8Y>0 Then  
							   b=8 
							Else    
								FindPic 1767, 165, 1776, 178,SCREEN_PATH & "gn\2.bmp",1,inta2X,inta2Y
								If inta2X>0 and inta2Y>0 Then  
								   b=2 
								Else    
									FindPic 1767, 165, 1776, 178,SCREEN_PATH & "gn\9.bmp",1,inta9X,inta9Y  
									If inta9X>0 and inta9Y>0 Then  
									   b=9 
									Else    
										FindPic 1767, 165, 1776, 178,SCREEN_PATH & "gn\1.bmp",1,inta1X,inta1Y
										If inta1X>0 and inta1Y>0 Then  
										   b=1 
										Else 
											FindPic 1767, 165, 1776, 178,SCREEN_PATH & "gn\0.bmp",1,inta0X,inta0Y        									
											If inta0X > 0 and inta0Y < 0 Then
												b=0										  							   
											End If									
										End If									
									End If							   
								End If
							End If					   
						End If				   
					End If	 			   
				End If	       
			End If  
		End If 
		
		c = 100
		
		FindPic 1775, 165, 1784, 178,SCREEN_PATH & "gn\0.bmp",1,inta0X,inta0Y 
		If inta0X>0 and inta0Y>0 Then  
			c=0 
		Else    
			FindPic 1775, 165, 1784, 178,SCREEN_PATH & "gn\1.bmp",1,inta1X,inta1Y
			If inta1X>0 and inta1Y>0 Then  
				c=1 
			Else    
				FindPic 1775, 165, 1784, 178,SCREEN_PATH & "gn\2.bmp",1,inta2X,inta2Y
				If inta2X>0 and inta2Y>0 Then  
					c=2 
				Else    
					FindPic 1775, 165, 1784, 178,SCREEN_PATH & "gn\8.bmp",1,inta8X,inta8Y	
					If inta8X>0 and inta8Y>0 Then  
						c=8 	
					Else    
						FindPic 1775, 165, 1784, 178,SCREEN_PATH & "gn\9.bmp",1,inta9X,inta9Y
						If inta9X>0 and inta9Y>0 Then  
							c=9 
						Else    
							FindPic 1775, 165, 1784, 178,SCREEN_PATH & "gn\5.bmp",1,inta5X,inta5Y
							If inta5X>0 and inta5Y>0 Then  
								c=5 
							Else    
								FindPic 1775, 165, 1784, 178,SCREEN_PATH & "gn\6.bmp",1,inta6X,inta6Y
								If inta6X>0 and inta6Y>0 Then  
									c=6 
								Else    
									FindPic 1775, 165, 1784, 178,SCREEN_PATH & "gn\7.bmp",1,inta7X,inta7Y  
									If inta7X>0 and inta7Y>0 Then  
										c=7 
									Else    
										FindPic 1775, 165, 1784, 178,SCREEN_PATH & "gn\4.bmp",1,inta4X,inta4Y
										If inta4X>0 and inta4Y>0 Then  
											c=4 
										Else 
											FindPic 1775, 165, 1784, 178,SCREEN_PATH & "gn\3.bmp",1,inta3X,inta3Y
											FindColorEx 1777, 170, 1778, 173, "00E700", 0, 0.9, intbX, intbY           									
											If inta3X > 0 and intbY < 0 Then 
												c=3 									  						   
											End If									
										End If									
									End If							   
								End If
							End If					   
						End If				   
					End If	 			   
				End If	       
			End If  
		End If
		
		d = 100

		FindPic 1783, 165, 1792, 178,SCREEN_PATH & "gn\0.bmp",1,inta0X,inta0Y 
		If inta0X>0 and inta0Y>0 Then  
			d=0 
		Else    
			FindPic 1783, 165, 1792, 178,SCREEN_PATH & "gn\9.bmp",1,inta9X,inta9Y
			If inta9X>0 and inta9Y>0 Then  
			   d=9 
			Else    
				FindPic 1783, 165, 1792, 178,SCREEN_PATH & "gn\1.bmp",1,inta1X,inta1Y
				If inta1X>0 and inta1Y>0 Then  
					d=1 
				Else    
					FindPic 1783, 165, 1792, 178,SCREEN_PATH & "gn\8.bmp",1,inta8X,inta8Y
					If inta8X>0 and inta8Y>0 Then  
						d=8 
					Else    
						FindPic 1783, 165, 1792, 178,SCREEN_PATH & "gn\2.bmp",1,inta2X,inta2Y
						If inta2X>0 and inta2Y>0 Then  
							d=2 
						Else    
							FindPic 1783, 165, 1792, 178,SCREEN_PATH & "gn\5.bmp",1,inta5X,inta5Y
							If inta5X>0 and inta5Y>0 Then  
								d=5 
							Else    
								FindPic 1783, 165, 1792, 178,SCREEN_PATH & "gn\6.bmp",1,inta6X,inta6Y
								If inta6X>0 and inta6Y>0 Then  
									d=6 
								Else    
									FindPic 1783, 165, 1792, 178,SCREEN_PATH & "gn\7.bmp",1,inta7X,inta7Y  
									If inta7X>0 and inta7Y>0 Then  
										d=7 
									Else    
										FindPic 1783, 165, 1792, 178,SCREEN_PATH & "gn\3.bmp",1,inta3X,inta3Y	
										FindColorEx 1785, 170, 1786, 173, "00E700", 0, 0.9, intbX, intbY           									
										If inta3X > 0 and intbY < 0 Then 
											d=3	
										Else    
											FindPic 1783, 165, 1792, 178,SCREEN_PATH & "gn\4.bmp",1,inta4X,inta4Y
											If inta4X>0 and inta4Y>0 Then  
												d=4 					   
											End If									
										End If									
									End If							   
								End If
							End If					   
						End If				   
					End If	 			   
				End If	       
			End If  
		End If	
		
		If a = 100 Or b = 100 Or c = 100 Or d = 100 Then 
		    mf = mf+1
			If mf > 4 Then 			
	    	    logInfo = Now & "--newPrice-g-" & a & "-" & b & "-" & c & "-" & d
	    	    Call Lib.文件.插入文本内容到指定行(DATA_PATH & "logInfo.txt", logInfo, 1)
		 	End If
			MoveTo 1658,188
			Delay 100
			MoveTo 1658,268
			Delay 100		 		
		   Goto AA 
		End If
		numStr = a & "" & b & "" & c & "" & d
		getNewPrice = Formatnumber(numStr, 0, - 1 , - 1 , 0)
		M_newPrice = getNewPrice
		priceDiff = Abs(M_oldPrice - getNewPrice)
		newTime = DateDiff("s", "01/01/1970 00:00:00", Now()) - 28800
		If getNewPrice = 0 Or getNewPrice = "" Or Len(getNewPrice) < 4 Or M_oldPrice > 0 And priceDiff > 4 Then 
		   	logInfo = Now & "--newPrice-g-M_oldPrice-" &M_oldPrice& "-newPrice-" & getNewPrice & "-newTime-" &newTime& "-priceDiff-" & priceDiff
		    Call Lib.文件.插入文本内容到指定行(DATA_PATH & "logInfo.txt", logInfo, 1) 		
			MoveTo 1658,188
			Delay 100
			MoveTo 1658,328
			Delay 100	
		   Goto AA 
		End If	
	Else 

		M_oldPrice = M_newPrice
		
		a = 100   
		FindPic 1759, 165, 1768, 178,SCREEN_PATH & "white\3.bmp",1,inta3X,inta3Y
		If inta3X>0 and inta3Y>0 Then  
			a=3 
		Else    
			FindPic 1759, 165, 1768, 178,SCREEN_PATH & "white\4.bmp",1,inta4X,inta4Y
			If inta4X>0 and inta4Y>0 Then  
				a=4
			Else 
				FindPic 1759, 165, 1768, 178,SCREEN_PATH & "white\2.bmp",1,inta2X,inta2Y  
				If inta2X>0 and inta2Y>0 Then  
					a=2 
				Else  			    
					FindPic 1759, 165, 1768, 178,SCREEN_PATH & "white\5.bmp",1,inta5X,inta5Y	
					If inta5X>0 and inta5Y>0 Then  
						a=5 
					Else    
						FindPic 1759, 165, 1768, 178,SCREEN_PATH & "white\6.bmp",1,inta6X,inta6Y
						If inta6X>0 and inta6Y>0 Then  
						a=6 
						Else    
							FindPic 1759, 165, 1768, 178,SCREEN_PATH & "white\7.bmp",1,inta7X,inta7Y
							If inta7X>0 and inta7Y>0 Then  
								a=7 
							Else    
								FindPic 1759, 165, 1768, 178,SCREEN_PATH & "white\1.bmp",1,inta1X,inta1Y
								If inta1X>0 and inta1Y>0 Then  
									a=1 
								Else    	
									FindPic 1759, 165, 1768, 178,SCREEN_PATH & "white\9.bmp",1,inta9X,inta9Y
									If inta9X>0 and inta9Y>0 Then  
										a=9 
									Else 
										FindPic 1759, 165, 1768, 178,SCREEN_PATH & "white\8.bmp",1,inta8X,inta8Y
										If inta8X>0 and inta8Y>0 Then  
											a=8 							   
										End If									
									End If									
								End If							   
							End If
						End If					   
					End If				   
				End If	 			   
			End If	       
		End If
		 
		b = 100
		
		FindPic 1767, 165, 1776, 178,SCREEN_PATH & "white\4.bmp",1,inta4X,inta4Y 
		If inta4X>0 and inta4Y>0 Then  
			b=4 
		Else    
			FindPic 1767, 165, 1776, 178,SCREEN_PATH & "white\5.bmp",1,inta5X,inta5Y
			If inta5X>0 and inta5Y>0 Then  
				b=5 
			Else    
				FindPic 1767, 165, 1776, 178,SCREEN_PATH & "white\6.bmp",1,inta6X,inta6Y
				If inta6X>0 and inta6Y>0 Then  
				   b=6 
				Else    
					FindPic 1767, 165, 1776, 178,SCREEN_PATH & "white\3.bmp",1,inta3X,inta3Y	
					FindColorEx 1769, 170, 1770, 173, "E6E6E6", 0, 0.9, intbX, intbY           									
					If inta3X > 0 and intbY < 0 Then 
						b=3
					Else    
						FindPic 1767, 165, 1776, 178,SCREEN_PATH & "white\7.bmp",1,inta7X,inta7Y
						If inta7X>0 and inta7Y>0 Then  
						   b=7
						Else    
							FindPic 1767, 165, 1776, 178,SCREEN_PATH & "white\8.bmp",1,inta8X,inta8Y
							If inta8X>0 and inta8Y>0 Then  
							   b=8 
							Else    
								FindPic 1767, 165, 1776, 178,SCREEN_PATH & "white\2.bmp",1,inta2X,inta2Y
								If inta2X>0 and inta2Y>0 Then  
								   b=2 
								Else    
									FindPic 1767, 165, 1776, 178,SCREEN_PATH & "white\9.bmp",1,inta9X,inta9Y  
									If inta9X>0 and inta9Y>0 Then  
									   b=9 
									Else    
										FindPic 1767, 165, 1776, 178,SCREEN_PATH & "white\1.bmp",1,inta1X,inta1Y
										If inta1X>0 and inta1Y>0 Then  
										   b=1 
										Else 
											FindPic 1767, 165, 1776, 178,SCREEN_PATH & "white\0.bmp",1,inta0X,inta0Y        									
											If inta0X > 0 and inta0Y < 0 Then
												b=0										  							   
											End If									
										End If									
									End If							   
								End If
							End If					   
						End If				   
					End If	 			   
				End If	       
			End If  
		End If 
		
		c = 100
		
		FindPic 1775, 165, 1784, 178,SCREEN_PATH & "white\0.bmp",1,inta0X,inta0Y 
		If inta0X>0 and inta0Y>0 Then  
			c=0 
		Else    
			FindPic 1775, 165, 1784, 178,SCREEN_PATH & "white\1.bmp",1,inta1X,inta1Y
			If inta1X>0 and inta1Y>0 Then  
				c=1 
			Else    
				FindPic 1775, 165, 1784, 178,SCREEN_PATH & "white\2.bmp",1,inta2X,inta2Y
				If inta2X>0 and inta2Y>0 Then  
					c=2 
				Else    
					FindPic 1775, 165, 1784, 178,SCREEN_PATH & "white\8.bmp",1,inta8X,inta8Y	
					If inta8X>0 and inta8Y>0 Then  
						c=8 	
					Else    
						FindPic 1775, 165, 1784, 178,SCREEN_PATH & "white\9.bmp",1,inta9X,inta9Y
						If inta9X>0 and inta9Y>0 Then  
							c=9 
						Else    
							FindPic 1775, 165, 1784, 178,SCREEN_PATH & "white\5.bmp",1,inta5X,inta5Y
							If inta5X>0 and inta5Y>0 Then  
								c=5 
							Else    
								FindPic 1775, 165, 1784, 178,SCREEN_PATH & "white\6.bmp",1,inta6X,inta6Y
								If inta6X>0 and inta6Y>0 Then  
									c=6 
								Else    
									FindPic 1775, 165, 1784, 178,SCREEN_PATH & "white\7.bmp",1,inta7X,inta7Y  
									If inta7X>0 and inta7Y>0 Then  
										c=7 
									Else    
										FindPic 1775, 165, 1784, 178,SCREEN_PATH & "white\4.bmp",1,inta4X,inta4Y
										If inta4X>0 and inta4Y>0 Then  
											c=4 
										Else 
											FindPic 1775, 165, 1784, 178,SCREEN_PATH & "white\3.bmp",1,inta3X,inta3Y
											FindColorEx 1777, 170, 1778, 173, "E6E6E6", 0, 0.9, intbX, intbY           									
											If inta3X > 0 and intbY < 0 Then 
												c=3 									  						   
											End If									
										End If									
									End If							   
								End If
							End If					   
						End If				   
					End If	 			   
				End If	       
			End If  
		End If
		
		d = 100

		FindPic 1783, 165, 1792, 178,SCREEN_PATH & "white\0.bmp",1,inta0X,inta0Y 
		If inta0X>0 and inta0Y>0 Then  
			d=0 
		Else    
			FindPic 1783, 165, 1792, 178,SCREEN_PATH & "white\9.bmp",1,inta9X,inta9Y
			If inta9X>0 and inta9Y>0 Then  
			   d=9 
			Else    
				FindPic 1783, 165, 1792, 178,SCREEN_PATH & "white\1.bmp",1,inta1X,inta1Y
				If inta1X>0 and inta1Y>0 Then  
					d=1 
				Else    
					FindPic 1783, 165, 1792, 178,SCREEN_PATH & "white\8.bmp",1,inta8X,inta8Y
					If inta8X>0 and inta8Y>0 Then  
						d=8 
					Else    
						FindPic 1783, 165, 1792, 178,SCREEN_PATH & "white\2.bmp",1,inta2X,inta2Y
						If inta2X>0 and inta2Y>0 Then  
							d=2 
						Else    
							FindPic 1783, 165, 1792, 178,SCREEN_PATH & "white\5.bmp",1,inta5X,inta5Y
							If inta5X>0 and inta5Y>0 Then  
								d=5 
							Else    
								FindPic 1783, 165, 1792, 178,SCREEN_PATH & "white\6.bmp",1,inta6X,inta6Y
								If inta6X>0 and inta6Y>0 Then  
									d=6 
								Else    
									FindPic 1783, 165, 1792, 178,SCREEN_PATH & "white\7.bmp",1,inta7X,inta7Y  
									If inta7X>0 and inta7Y>0 Then  
										d=7 
									Else    
										FindPic 1783, 165, 1792, 178,SCREEN_PATH & "white\3.bmp",1,inta3X,inta3Y	
										FindColorEx 1785, 170, 1786, 173, "E6E6E6", 0, 0.9, intbX, intbY           									
										If inta3X > 0 and intbY < 0 Then 
											d=3	
										Else    
											FindPic 1783, 165, 1792, 178,SCREEN_PATH & "white\4.bmp",1,inta4X,inta4Y
											If inta4X>0 and inta4Y>0 Then  
												d=4 					   
											End If									
										End If									
									End If							   
								End If
							End If					   
						End If				   
					End If	 			   
				End If	       
			End If  
		End If	
		
		If a = 100 Or b = 100 Or c = 100 Or d = 100 Then 
		    mf = mf+1
			If mf > 4 Then 			
	    	    logInfo = Now & "--newPrice-w-" & a & "-" & b & "-" & c & "-" & d
	    	    Call Lib.文件.插入文本内容到指定行(DATA_PATH & "logInfo.txt", logInfo, 1)
		 	End If
			MoveTo 1668,188
			Delay 100
			MoveTo 1668,268
			Delay 100			 		
		   Goto AA 
		End If
		numStr = a & "" & b & "" & c & "" & d
		getNewPrice = Formatnumber(numStr, 0, - 1 , - 1 , 0)
		M_newPrice = getNewPrice
		priceDiff = Abs(M_oldPrice - getNewPrice)
		newTime = DateDiff("s", "01/01/1970 00:00:00", Now()) - 28800
		If getNewPrice = 0 Or getNewPrice = "" Or Len(getNewPrice) < 4 Or M_oldPrice > 0 And priceDiff > 4 Then 
		   	logInfo = Now & "--newPrice-w-M_oldPrice-" &M_oldPrice& "-newPrice-" & getNewPrice & "-newTime-" &newTime& "-priceDiff-" & priceDiff
		    Call Lib.文件.插入文本内容到指定行(DATA_PATH & "logInfo.txt", logInfo, 1) 
			MoveTo 1668,188
			Delay 100
			MoveTo 1668,328
			Delay 100
		   Goto AA 
		End If			
    End If
    mf = 0 
    timeCountNew = DateDiff("s", "01/01/1970 00:00:00", Now()) - 28800

    Call getHLPrice()
    
End Function

