//変数を初期化する関数
void reset() {

  //時間関係
  el_time=0x00;
  cl_time=0x00;
  getData=0x00;
  timer=0x00;

  //選択画面関係
  state_cho=0x00;
  state_lev=0x00;
  state_num=0x00;

  //角度関係
  state_til=0;
  tilt=0;
  new_tilt=0;
  old_tilt=0;
  tilt_ave=0;
  tilt_deg=0;

  //物理計算関係
  a=0;
  g=9.8;
  t=0;
  x=0;
  X=0;

  //タイマー関係
  new_time=0;
  old_time=0;
  time=0;

  //平滑化処理関係
  for (int i=0; i<20; i++)
    data[i]=0;

  //カウントダウン関係
  timeLimit=0;
  one_limit=10; //sec
  leave_tim=0;
  result=0;

  //摩擦係数
  friction=0;

  //カウンタ関係
  start=0;
  count=0;

  //音楽データ関係
  song.pause();
  song.rewind();
  //音量を-60から4まで1秒かけて変化させる
  song.shiftGain(-60, 4, 1000);

  //シーソー関係
  L=500;
  
  //カラス出没関係
  app_time=0;
  posi_x=1000;
  posi_y=-500;
  karas_state=0;
  fall_posi=0;
  error=0;
}
