//
//  Message_View.swift
//  here
//
//  Created by Liyang Wang on 10/10/23.
//

import SwiftUI
import ARKit

struct NoteMessageView: View {
    @State private var noteMessage: String = "This is your message!"
    let senderName: String = "Username"

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ARBackgroundView()

                VStack(spacing: 10) {
                    Spacer()

                    HStack {
                        //
                    }
                    .padding(.leading, 20)

                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .shadow(radius: 5)

                        VStack {
                            TextEditor(text: $noteMessage)
                                .padding(.all, 30)

                            Spacer(minLength: 20)

                            HStack {
                                Button(action: {
                                    // Share Action
                                }, label: {
                                    Image(systemName: "square.and.arrow.up.fill")
                                        .resizable()
                                        .foregroundColor(.blue)
                                        .frame(width: 24, height: 24)
                                        .padding(.leading, 20)
                                })

                                Spacer()

                                Button(action: {
                                    // Send Action
                                }, label: {
                                    Image(systemName: "paperplane.fill")
                                        .resizable()
                                        .foregroundColor(.blue)
                                        .frame(width: 24, height: 24)
                                        .padding(.trailing, 20)
                                })
                            }
                            .padding(.bottom, 25)
                        }
                    }
                    .opacity(0.5)
                    .frame(width: geometry.size.width - 40, height: geometry.size.width - 40)
                    
                    Spacer()
                }
            }
        }
    }
}

struct ARBackgroundView: UIViewRepresentable {
    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView(frame: .zero)
        
        arView.session.delegate = context.coordinator
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic
        
        arView.session.run(configuration)
        
        return arView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {}

    // ARKit delegate methods
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, ARSessionDelegate {}
}

struct NoteMessageView_Previews: PreviewProvider {
    static var previews: some View {
        NoteMessageView()
    }
}
