void game() {

  //背景の色
  background(#00bfff);

  //時間取得
  if (state==0x05) {
    getTime();

    //タイムリミットの計算
    timeLimit=one_limit*(state_num+1);
    //BGM再生
    song.play();

    //2人以上のプレイなら
    if (state_num>0) {
      //カラスの出没するタイミングと場所を選択
      app_time=(int)random(10, timeLimit-10);
      fall_posi=(int)random(0, 3);
      if (fall_posi==1)
        fall_posi=0;
    }
  }

  //カウントダウンの開始
  if (start==0) {
    if (((el_time-cl_time)/1000)>1) {
      countdown.play();
      start++;
    }
  }

  //カウントダウンの数値表示
  if (start==1) {
    count=5-((el_time-cl_time)/1000);
    if (count>0) {
      fill(#ffffff);
      textSize(200);
      textAlign(CENTER);
      text((int)count, width/2, height/2-200);
    } else if (count==0) {
      start++;
    }
  }

  //「スタート」の表示
  if (start==2) {
    fill(#ffffff);
    textSize(200);
    textAlign(CENTER);
    text("START!", width/2, height/2-200);

    //カウントダウン開始から6秒後まで表示する
    if (((el_time-cl_time)/1000)>6) {
      start++;
    }
  }

  //残り時間の計算
  leave_tim=timeLimit-((el_time-cl_time)/1000)+5;

  //--- 背景・文字表示 ---
  fill(#ffffff); //背景の色
  textSize(200); //文字の大きさ
  textAlign(CENTER);

  //カウントダウンの数値表示
  if (start==2 || start==3) {
    text((int)leave_tim, width/2-350, 900);
  } else {
    text((int)timeLimit, width/2-350, 900);
  }
  textSize(150);
  text("sec. left", width/2+150, 900);

  //--- 終了プロセス ---
  if (leave_tim<=0) { //game clear
    state++;
    countdown.rewind();
    result=1;
  }
  if (X>500||X<-500) { //game over
    state++;
    countdown.rewind();
    result=2;
  }

  //255~0の値を0~90度に変換
  tilt_deg=0.35*tilt;

  //角度に制限をかける
  if (tilt_deg>30)
    tilt_deg=30;
  if (tilt_deg<-30)
    tilt_deg=-30;

  //平滑化処理（単純移動平均）
  for (int i=0; i<19; i++) {
    data[19-i]=data[19-i-1];
  }
  data[0]=tilt_deg;

  //配列更新
  for (int i=0; i<20; i++)
    tilt_ave+=data[i];
  tilt_ave/=20;

  //カラスがシーソーに止まったら，角度を傾ける
  if (karas_state==3) {
    if (fall_posi==0) error++;
    else if (fall_posi==1) error--;

    //15度まで傾ける
    if (error>15)
      karas_state=4;
  }

  //角度にエラー項を足す
  tilt_ave+=error;

  //シーソーの絵画
  strokeWeight(40);
  stroke(255, 0, 0);
  translate(width/2, height/2);
  line(0, 0, L*cos((PI/180)*(tilt_ave)), L*sin((PI/180)*(tilt_ave)));
  line(0, 0, -L*cos((PI/180)*(tilt_ave)), -L*sin((PI/180)*(tilt_ave)));

  //微小時刻の取得
  new_time = millis();
  time = new_time-old_time;
  old_time = new_time;

  //難易度の設定（摩擦係数を変える）
  if (state_lev==0x00)
    friction=0.01;
  else if (state_lev==0x01)
    friction=0.03;
  else if (state_lev==0x02)
    friction=0.05;

  //斜面方向の加速度計算
  a = g*sin((PI/180)*(tilt_ave))*friction;
  //斜面方向の増分
  x = 0.5*a*time*time;

  //位置を更新する
  if (start==2 ||start==3) {
    X+=x;
  }

  //位置に制限を描ける
  if (X>600)
    X=600;
  else if (X<-600)
    X=-600;
  else
    ;

  //シーソーの支点の絵画
  fill(#000000);
  noStroke();
  ellipse(0, 0, 40, 40);

  //ボールの絵画
  fill(#9400d3);
  noStroke();
  ellipse(X, sin((PI/180)*(tilt_ave))/cos((PI/180)*(tilt_ave))*X, 200, 200);

  //カラスを出没させる
  if ((leave_tim<app_time+2)&&(leave_tim>app_time-2)&&(state_num>0)) {
    karas_state=1;
    crow.play();
  }

  //カラスを移動させる処理
  if (karas_state==0) {
  } else if (karas_state==1) {
    image(karas, posi_x, posi_y, 236, 195);
    posi_x-=5;
    if (fall_posi==0 && posi_x<300) {
      karas_state=2;
    } else if (fall_posi==1 && posi_x<-600) {
      karas_state=2;
    }
  } else if (karas_state==2) {
    image(karas, posi_x, posi_y, 236, 195);
    posi_y+=5;
    if (posi_y>L*sin((PI/180)*(tilt_ave))-220) karas_state=3;
  } else if (karas_state==3 || karas_state==4) {
    if (fall_posi==0) {
      image(karas, posi_x, L*sin((PI/180)*(tilt_ave))-180, 236, 195);
    } else if (fall_posi==1) {
      image(karas, posi_x, -L*sin((PI/180)*(tilt_ave))-180, 236, 195);
    }
  }
}
