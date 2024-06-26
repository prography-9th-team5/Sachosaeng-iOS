//
//  SignSuccessView.swift
//  Sachosaeng
//
//  Created by LJh on 6/21/24.
//

import SwiftUI

struct SignSuccessView: View {
    @State private var isActive: Bool = false

    var body: some View {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    CommonTitle(top: "랜덤이름님!",
                                topFont: .bold,
                                middle: "사초생에 오신 걸 환영해요",
                                middleFont: .medium,
                                footer: "회원가입 완료",
                                footerFont: .medium, isSuccessView: true)
                }
                .frame(height: 100)
                .padding(.bottom, 45)
                TempImageView(isBorder: true,
                              width: PhoneSpace.screenWidth - 100,
                              height: PhoneSpace.screenWidth - 100)
                Spacer()
                
            }
            .padding(.top, 70)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    isActive = true
                }
            }
            .navigationDestination(isPresented: $isActive) {
                MainView()
            }
        }

}


struct SignSuccessView_Previews: PreviewProvider {
    static var previews: some View {
        SignSuccessView()
    }
}
