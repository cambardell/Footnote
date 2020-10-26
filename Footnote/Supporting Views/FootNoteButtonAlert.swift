//
//  FootNoteButtonAlert.swift
//  CustomAlerts
//
//  Created by Jeffrey Lai on 10/8/20.
//

import SwiftUI

enum ActiveAlert {
    case first, second
}

struct FootNoteButtonAlert: View {

    @Environment(\.presentationMode) var presentationMode
    
    var singleButton: Bool = false
    var buttonTitle: String
    var title: String
    var message: String
    var primaryButton: Alert.Button?
    var secondaryButton: Alert.Button?
    
    var additionalActions: () -> Void

    @State private var showAlert = false
    @State private var activeAlert: ActiveAlert = .first

    private var alertTwoButtons: Alert {
        let primaryButton = Alert.Button.default(Text("Add Another Quote"))
        let secondaryButton = Alert.Button.default(Text("No More Quotes "), action: {
            self.presentationMode.wrappedValue.dismiss()
        })
        
        return Alert(title: Text(title), message: Text(message), primaryButton: primaryButton, secondaryButton: secondaryButton)
    }
    
    private var alertOneButton: Alert {
        let primaryButton = Alert.Button.cancel()
        
        return Alert(title: Text(title), message: Text(message), dismissButton: primaryButton)
    }
    
    
    var body: some View {

        Button(action: {
            if singleButton {
                self.activeAlert = .first
            } else {
                self.activeAlert = .second
            }
            
            self.showAlert.toggle()
            self.additionalActions()
        }, label: {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.white)
                .frame(height: 40)
                .padding(.horizontal)
                .overlay (
                    Text(buttonTitle)
                        .foregroundColor(.black)
            )
        })
        .alert(isPresented: $showAlert, content: {
            switch activeAlert {
            case .first:
                return alertOneButton
            case .second:
                return alertTwoButtons
            }
        })
    }

}
