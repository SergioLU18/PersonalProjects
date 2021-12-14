//
//  GameView.swift
//  App09-Game
//
//  Created by Alumno on 01/11/21.
//

import SwiftUI
import SpriteKit


struct PongGameView: View {
    
    @Environment(\.presentationMode) var presentationMode

    @State var scene: SKScene = PongGameScene()
    @State var score: Int = 0
    @State var isLoading: Bool = false
    
    var width = CGFloat()
    var height = CGFloat()

    
    var body: some View {
        ZStack {
                    VStack {
                       
                    }
            .edgesIgnoringSafeArea(.all)
            .onDisappear {
                
                scene.removeAllActions()
                scene.removeAllChildren()
               
            }
            CustomController()
            if isLoading{
                LoadingView()
            }
        }.onAppear{
            load()
        }
        
        
    }
    func load(){
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            isLoading = false
        }
        
        
    }
    
    
}


struct PongGameView_Previews: PreviewProvider {
    static var previews: some View {
        PongGameView()
    }
    
}


struct CustomController : UIViewControllerRepresentable {

    func makeUIViewController(context: UIViewControllerRepresentableContext<CustomController>) -> UIViewControllerType {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(identifier: "gameVC")
        return controller
        
    }
    func  updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<CustomController>) {
        
    }
}


