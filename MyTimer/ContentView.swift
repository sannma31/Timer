//
//  ContentView.swift
//  MyTimer
//
//  Created by 笠井翔雲 on 2024/04/18.
//

import SwiftUI

struct ContentView: View {
    //タイマーの変数を作成
    @State var timerHandler: Timer?
    //カウント(経過時間)の変数を作成
    @State var count = 0
    //永続化する秒数設定(初期値は10)
    @AppStorage("timer_value") var timerValue = 10
    //アラート表示有無
    @State var showAlert = false
    var body: some View {
        NavigationStack{
            ZStack{
                Image(.backgroundTimer)
                //リサイズする
                    .resizable()
                //セーフエリアを超えて画面全体に配置する
                    .ignoresSafeArea()
                    .scaledToFill()
                VStack(spacing:30.0){
                    Text("残り\(timerValue - count)秒")
                        .font(.largeTitle)
                    HStack{
                        Button{
                            startTimer()
                        }label: {
                            Text("スタート")
                                .font(.title)
                                .foregroundStyle(Color.white)
                                .frame(width:140,height: 140)
                                .background(Color.start)
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        }
                        Button{
                            //ボタンをタップした時timerHandlerをアンラップ
                            if let timerHandler{
                                //もしタイマーが、実行中だったら停止
                                if timerHandler.isValid == true{
                                    //タイマー停止
                                    timerHandler.invalidate()
                                }
                            }
                        }label: {
                            Text("ストップ")
                                .font(.title)
                                .foregroundStyle(Color.white)
                                .frame(width:140,height: 140)
                                .background(Color.stop)
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        }
                    }
                }
                .onAppear{
                    count = 0
                }
                .toolbar{
                    //ナビゲーションバーの右にボタンを追加
                    ToolbarItem(placement: .topBarTrailing){
                        NavigationLink{
                            SettingView()
                        }label: {
                            Text("秒数設定")
                        }
                    }
                }
                .alert("終了",isPresented: $showAlert){
                    Button("OK"){
                        print("OKタップされました")
                    }
                }message: {
                    Text("タイマー終了時間だよ")
                }
            }
        }
    }
    func countDownTimer(){
        count += 1
        if timerValue - count <= 0{
            timerHandler?.invalidate()
            
            showAlert = true
        }
    }
    func startTimer(){
        if let timerHandler{
            if timerHandler.isValid == true{
                return
            }
        }
        if timerValue - count <= 0{
            count = 0
        }
        timerHandler = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){
            _ in
            countDownTimer()
        }
    }
}

#Preview {
    ContentView()
}
