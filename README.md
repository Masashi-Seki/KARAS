# KARAS
バランスゲームKARASのソースコード．

# Description
## --- Connection ---
PC ---(USB)--- マイコン基板

## --- Code ---
### Main Side
Processingを使用．メインプロセス側のプログラム．グラフィックの絵画を行う．

### Bord Side
C言語．PICマイコンのソースコード．ジャイロセンサやスイッチの状態をシリアル通信でPCへ送信する．

# Reference
ADC Using PIC16F877A
https://exploreembedded.com/wiki/ADC_Using_PIC16F877A
