//
//  CoachMark.swift
//  dyslexia
//
//  Created by ibbi on 7/15/23.
//

import SwiftUI
import UIKit
import KeyboardKit

struct CoachMark: View {
    let coachID: Coachy
    let onNext: (() -> Void)?
    let onPrev: (() -> Void)?
    let onSkip: (() -> Void)?
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        let isSelectLexy = coachID == .selectLexy
        
        ZStack {
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(
                            stops: [
                                .init(color: Color.black.opacity(0.7), location: 0.0),
                                .init(color: Color.black.opacity(isSelectLexy ? 0.7 : 0), location: 0.35),
                                .init(color: Color.black.opacity(isSelectLexy ? 0.7 : 0), location: 1.0)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                )
                .ignoresSafeArea()
            
            if onSkip != nil {
                VStack {
                    
                    HStack {
                        Spacer()
                               if colorScheme == .dark {
                                   Button(action: onSkip!) {
                                       Text("Skip")
                                           .font(.title3)
                                   }
                                   .buttonStyle(.borderless)
                                   .padding()
                                   .tint(.red)
                               } else {
                                   Button(action: onSkip!) {
                                       Text("Skip")
                                           .font(.title3)
                                   }
                                   .buttonStyle(.borderedProminent)
                                   .padding()
                                   .tint(.red)
                               }
                    }
                    Spacer()
                }
            }
            
            VStack(alignment: (coachID == .undo ? .trailing : .leading), spacing: 0) {
                Spacer()
                    VStack(alignment: .leading) {
                        coachID.mainText
                            .font(.body)
                            .padding(.bottom, isSelectLexy ? 0 : 6)
                            .foregroundColor(.white)
                                if !(coachID.lowerText["subText"]?.isEmpty ?? true) {
                                    Text(coachID.lowerText["subText"]!)
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
                                if !(coachID.lowerText["tipText"]?.isEmpty ?? true) {
                                    Text(coachID.lowerText["tipText"]!)
                                        .font(.caption2)
                                        .foregroundColor(.white)
                                        .opacity(0.8)
                                }
                        
                                if onNext != nil {
                                    HStack() {
                                        Spacer()
                                        if (onPrev != nil) {
                                            Button(action: onPrev!) {
                                                Text( "\(Image(systemName: "chevron.left"))")
                                            }
                                            .buttonStyle(.borderedProminent)
                                            .tint(Color.white)
                                            .foregroundColor(Color.accentColor)
                                        }
                                        Button(action: onNext!) {
                                            Text(coachID != .undo ? "\(Image(systemName: "chevron.right"))" : "Finish")
                                        }
                                        .buttonStyle(.borderedProminent)
                                        .tint(Color.white)
                                        .foregroundColor(Color.accentColor)
                                }
                        }

                }
                .padding()
                .background(Color.accentColor)
                .cornerRadius(15)
                .fixedSize()
                if !isSelectLexy {
                    VStack {
                        Path { path in
                            let position = coachID.arrowPosition
                            path.move(to: CGPoint(x: position, y: 15))
                            path.addLine(to: CGPoint(x: position - 15, y: 0))
                            path.addLine(to: CGPoint(x: position + 15, y: 0))
                            path.closeSubpath()
                        }
                        .fill(Color.accentColor)
                        .frame(height: 15)
                        .padding(.top, -7)
                    }
                }
                else {
                 Spacer()
                }
            }
            .padding(.horizontal, 14)
        }
    }
}

struct CoachMark_Previews: PreviewProvider {
    static var previews: some View {
        CoachMark(coachID: .dictate, onNext: {print("Ola")}, onPrev: {print("pr")}, onSkip: {print("Fin")})
    }
}
