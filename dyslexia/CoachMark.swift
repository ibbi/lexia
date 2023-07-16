//
//  CoachMark.swift
//  dyslexia
//
//  Created by ibbi on 7/15/23.
//

import SwiftUI

struct CoachMark: View {
    let coachID: Coachy
    let onNext: (() -> Void)?
    let onSkip: (() -> Void)?
    
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .fill(Color.black.opacity(0.7))
                .ignoresSafeArea()
            
            if onSkip != nil {
                VStack {
                    
                    HStack {
                        Spacer()
                        Button(action: onSkip!) {
                            Text("Skip")
                                .font(.title3)
                        }
                        .buttonStyle(.borderless)
                        .tint(.red)
                        .padding()
                    }
                    Spacer()
                }
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                VStack {
                    VStack(alignment: .leading) {
                        coachID.mainText
                            .font(.body)
                            .padding(.bottom, coachID == .selectLexy ? 0 : 6)
                                if !(coachID.lowerText["subText"]?.isEmpty ?? true) {
                                    Text(coachID.lowerText["subText"]!)
                                        .font(.caption)
                                }
                                if !(coachID.lowerText["tipText"]?.isEmpty ?? true) {
                                    Text(coachID.lowerText["tipText"]!)
                                        .font(.caption2)
                                        .opacity(0.8)
                                }
                                if onNext != nil {
                                    Button(action: onNext!) {
                                        Text(coachID != .undo ? "Next" : "Finish")
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .tint(Color.primary)
                                    .foregroundColor(Color.accentColor)
                                }
                    }

                }
                .padding()
                .background(Color.accentColor)
                .cornerRadius(15)
                if coachID != .selectLexy {
                    VStack {
                        Path { path in
                            let position = coachID.arrowPosition
                            path.move(to: CGPoint(x: position, y: 10))
                            path.addLine(to: CGPoint(x: position - 10, y: 0))
                            path.addLine(to: CGPoint(x: position + 10, y: 0))
                            path.closeSubpath()
                        }
                        .fill(Color.accentColor)
                        .frame(height: 13)
                    }
                }
                else {
                 Spacer()
                }
            }
        }
    }
}

struct CoachMark_Previews: PreviewProvider {
    static var previews: some View {
        CoachMark(coachID: .dictate, onNext: {print("Ola")}, onSkip: {print("Fin")})
    }
}
