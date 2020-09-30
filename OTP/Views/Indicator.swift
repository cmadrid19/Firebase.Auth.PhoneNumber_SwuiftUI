//
//  Indicator.swift
//  OTP
//
//  Created by Maxim Macari on 30/09/2020.
//

import SwiftUI

struct Indicator: UIViewRepresentable{
    
    
    func makeUIView(context: UIViewRepresentableContext<Indicator>) -> UIActivityIndicatorView {
        
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        return indicator
        
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Indicator>) {
        
        
    }
    
}
