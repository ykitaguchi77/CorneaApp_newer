
//
//  Informations.swift
//  CorneaApp
//
//  Created by Yoshiyuki Kitaguchi on 2021/04/18.
//
import SwiftUI

//変数を定義
struct Informations: View {
    @ObservedObject var user: User
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext
    @State var isSaved = false
    @State private var goTakePhoto: Bool = false  //撮影ボタン    
    
    var body: some View {
        NavigationView{
                Form{
                    HStack{
                        Text("入力日時")
                        Text(self.user.date, style: .date)
                    }
                    
                    //DatePicker("入力日時", selection: $user.date)
                    
                    HStack{
                        Text(" I D ")
                        TextField("idを入力してください", text: $user.id)
                        }.onChange(of: user.id) { _ in
                            self.user.isSendData = false
                            }
                        
                        Picker(selection: $user.selected_hospital,
                                   label: Text("施設")) {
                            ForEach(0..<user.hospitals.count) {
                                Text(self.user.hospitals[$0])
                                     }
                            }
                           .onChange(of: user.selected_hospital) {_ in
                               self.user.isSendData = false
                               UserDefaults.standard.set(user.selected_hospital, forKey:"hospitaldefault")
                           }
                    
                        Picker(selection: $user.selected_side,
                                   label: Text("右or左")) {
                            ForEach(0..<user.side.count) {
                                Text(self.user.side[$0])
                                    }
                            }
                            .onChange(of: user.selected_side) {_ in
                                self.user.isSendData = false
                                }
                        
                        Picker(selection: $user.selected_disease,
                                   label: Text("疾患")) {
                            ForEach(0..<user.disease.count) {
                                Text(self.user.disease[$0])
                                    }
                            }
                           .onChange(of: user.selected_disease) { _ in
                               self.user.isSendData = false
                               }
                        
                        HStack{
                            Text("自由記載欄")
                            TextField("", text: $user.free_disease)
                                .keyboardType(.default)
                        }.layoutPriority(1)
                        .onChange(of: user.free_disease) { _ in
                        self.user.isSendData = false
                    }
                }.navigationTitle("患者情報入力")
                .onAppear(){
                 }
            }
                
            
            Spacer()
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
               }
                
            ) {
                Text("保存")
                    .foregroundColor(Color.white)
                    .font(Font.largeTitle)
            }
                .frame(minWidth:0, maxWidth:CGFloat.infinity, minHeight: 75)
                .background(Color.black)
                .padding()
                .sheet(isPresented: self.$goTakePhoto) {
                     CameraPage(user: user)
                }
    }
}
