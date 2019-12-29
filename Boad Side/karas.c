/*
 * Author: Masashi Seki
 * Created on 2019/02/01, 1:13
 */

#include <xc.h>
#include <pic16f877a.h>

//クロック設定
//#use delay(clock = 20000000)の代わり
#define _XTAL_FREQ 20000000

//コンフィギュレーションビット
//#fuses HS,PUT,NOWDT,BROWNOUT,NOPROTECT,NOLVPの代わり
#pragma config FOSC = HS //クロック発振モード：4MHz以上の外部振動子
#pragma config WDTE = OFF //ウォッチドッグタイマ：ウォッチドッグタイマを使用しない
#pragma config PWRTE = ON //パワーアップタイマ：パワーアップタイマを使用する
#pragma config BOREN = ON //ブラウンアウトリセット：ブラウンアウトリセットをする
#pragma config LVP = OFF //低電圧プログラム：低電圧プログラムをしない
#pragma config CPD = OFF //EEPROMデータプロテクト：EEPROMデータプロテクトをしない
#pragma config WRT = OFF //メモリライト：プログラムメモリ書き込み禁止
#pragma config CP = OFF //コードプロテクト：コードをプロテクトしない

void setup(){
    for(int i = 0 ; i < 1 ; i++){
        PORTB=0xFF;
        __delay_ms(200);
        PORTB=0x00;
        __delay_ms(200);
    }
}

int main() {
    //変数宣言
    long new_getData;
    long old_getData;
    long state;

    long new_push;
    long old_push;
    long push;

    //変数初期化
    new_getData = 0x00;
    old_getData = 0x00;
    state=0x00;

    new_push=0x00;
    old_push=0x00;
    push=0x00;

    //ポート設定
    TRISA = 0b00000111; //RA0~RA2を入力モードに
    TRISB = 0x00; //LEDを出力モードに
    TRISE = 0b00000111; //DIP SWを入力モードに

    //ポートの初期化
    PORTA = 0b00000000;
    PORTB = 0x00;

    //シリアル通信設定
    TXSTA  = 0b00100100;
    RCSTA  = 0b10010000;
    //高速通信モード, 20MHz, 9600bps
    SPBRG  = 129;

    //アナログポート設定
    ADCON1 = 0b10000010;

    //LED点滅（初期化完了の合図）
    setup();

    //無限ループ
    while(1){

        //データ受信
        new_getData = RCREG;

        //違うデータが送られてきたら反映する
        if(new_getData != old_getData){
            state = new_getData;
        }

        switch(state){

            //モード選択 スイッチの情報を送る
            case 0x04:

                //SW1==ON, SW2==OFF, SW3==OFF
                if (PORTE == 0b00000011) {
                    new_push=0x03;
                    //PORTB=0x03;
                    //PORTB = state;
                }
                //SW1==OFF, SW2==ON, SW3==OFF
                else if (PORTE == 0x05) {
                    new_push=0x05;
                    //PORTB=0x05;
                }
                //SW1==OFF, SW2==OFF, SW3==ON
                else if (PORTE == 0x06) {
                    new_push=0x06;
                    //PORTB=0x06;
                }
                //SW1==OFF, SW2==OFF, SW3==OFF
                else if (PORTE == 0x07) {
                    new_push=0x07;
                    //PORTB=0x07;
                }

                //スイッチの状態が変わったらシリアル通信で送る
                if(new_push!=old_push){
                    push = new_push;
                    TXREG = push;
                    PORTB=0xAA;
                    __delay_ms(300);
                    PORTB=0x00;
                }
                old_push=new_push;
                break;

            //ゲーム中 加速度センサの情報を送る
            case 0x06:
                ADCON0 = 0b00001101;

                __delay_ms(10);
                PORTB = ((ADRESH<<8) + ADRESL); //ポート出力
                TXREG = ((ADRESH<<8) + ADRESL); //シリアル通信で送信
                __delay_ms(10);
                break;

            case 0x0A:
                //SW1==ON, SW2==OFF, SW3==OFF
                if (PORTE == 0b00000011) {
                    new_push=0x03;
                }
                //SW1==OFF, SW2==ON, SW3==OFF
                else if (PORTE == 0x05) {
                    new_push=0x05;
               }
                //SW1==OFF, SW2==OFF, SW3==ON
                else if (PORTE == 0x06) {
                    new_push=0x06;
                }
                //SW1==OFF, SW2==OFF, SW3==OFF
                else if (PORTE == 0x07) {
                    new_push=0x07;
                }

                //スイッチの状態が変わったらシリアル通信で送る
                if(new_push!=old_push){
                    push = new_push;
                    TXREG = push;
                    PORTB=0xAA;
                    __delay_ms(300);
                    PORTB=0x00;
                }
                old_push=new_push;

                break;
            //変数初期化
            case 0xFF:
                setup();
                new_getData = 0x00;
                old_getData = 0x00;
                state=0x00;
                new_push=0x00;
                old_push=0x00;
                push=0x00;
               break;

            //上記以外なら
            default:
                PORTB=0x00;
                break;
        }

        //データを更新する
        old_getData = new_getData;
        __delay_ms(10);
    }
    return 0;
}
