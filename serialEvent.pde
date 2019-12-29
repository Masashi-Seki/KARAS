//PIC基板からのシリアル通信データを受信する関数

void serialEvent(Serial p) {
  //データ受信
  getData = p.read();

  //ゲーム中のモードなら
  if (state==0x05 || state==0x06) {
    new_tilt=getData;

    //傾いている方向を判別
    if (abs(new_tilt-old_tilt)>150) {
      if (new_tilt > old_tilt) {
        state_til=1;
      } else if (new_tilt < old_tilt) {
        state_til=0;
      }
    }

    //角度情報を整理
    if (state_til==1) {
      tilt = -1 * (255-new_tilt);
    } else if (state_til==0) {
      tilt = new_tilt;
    }

    //データ更新
    old_tilt=new_tilt;
  }
}
