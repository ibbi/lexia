//
//  CoachMark.swift
//  dyslexia
//
//  Created by ibbi on 7/15/23.
//

import SwiftUI
import UIKit
import KeyboardKit

struct Arrow: Shape {
    var position: CGFloat

    var animatableData: CGFloat {
        get { position }
        set { position = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: position, y: 15))
        path.addLine(to: CGPoint(x: position - 15, y: 0))
        path.addLine(to: CGPoint(x: position + 15, y: 0))
        path.closeSubpath()
        return path
    }
}

struct CoachMark: View {
    let coachID: Coachy
    let onNext: (() -> Void)?
    let onPrev: (() -> Void)?
    let onSkip: (() -> Void)?
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        let isSelectLexi = coachID == .selectLexi
        
        ZStack {
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(
                            stops: [
                                .init(color: Color.black.opacity(0.7), location: 0.0),
                                .init(color: Color.black.opacity(isSelectLexi ? 0.7 : 0), location: 0.35),
                                .init(color: Color.black.opacity(isSelectLexi ? 0.7 : 0), location: 1.0)
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
            
            VStack(alignment: (coachID == .dictate ? .leading : .trailing), spacing: 0) {
                Spacer()
                    VStack(alignment: .leading) {
                        coachID.mainText
                            .font(.body)
                            .padding(.bottom, isSelectLexi ? 0 : 6)
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
                                            Text(coachID != .confirm ? "\(Image(systemName: "chevron.right"))" : "Finish")
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
                if !isSelectLexi {
                    VStack {
                        Arrow(position: coachID.arrowPosition)
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
