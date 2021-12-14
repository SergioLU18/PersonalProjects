//
//  GameView.swift
//  App09-Game
//
//  Created by Alumno on 01/11/21.
//

import SwiftUI
import SpriteKit


struct MyVariables {
    static var width = window.frame.width
    static var height = window.frame.height
}

var window = UIWindow(frame: UIScreen.main.bounds)
struct BallGameView: View {
    
    @Environment(\.presentationMode) var presentationMode

    @State var scene: SKScene = BallGameScene(.constant(0))
    @State var score: Int = 0
    @State var isLoading: Bool = false
    
 

    
    var body: some View {
        
        
        ZStack {
            
            
            SpriteView(scene: scene)
                .frame(width: window.bounds.height, height: window.bounds.width * 1.1)
            VStack {
                HStack {
                    VStack {
                        Text("\(score)")
                            .font(.body)
                            .foregroundColor(.black)
                        
                    }
                    .padding(.leading,0.47 * MyVariables.height)
                    .padding(.top,0.23 * MyVariables.width)
                    Spacer()
                    VStack {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                            
                        } label: {
                            Image(systemName: "x.circle.fill")
                                .foregroundColor(.red)
                                .font(.custom("Open 24 Display St", size: 23))
                                .padding(.top,10)
                                .padding(.trailing,10)
                        }
                    }
                    .padding(.trailing,20)
                    .padding(.top, 20)
                }
                Spacer()
            }
            
            
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                
                AppDelegate.orientationLock = UIInterfaceOrientationMask.landscapeRight
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
                UIViewController.attemptRotationToDeviceOrientation()
                
                scene = BallGameScene($score)
                scene.scaleMode = .aspectFit
                scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                scene.size = CGSize(width: window.frame.height, height: window.frame.width)
                
            }
            .onDisappear {
                scene.removeAllActions()
                scene.removeAllChildren()
               
                AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                UIViewController.attemptRotationToDeviceOrientation()
            }
            if isLoading{
                LoadingView()
            }
        }.onAppear{
            load()
        }
        
        
    }
    func load(){
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            isLoading = false
        }
        
        
    }
    
    
}
struct BallGameView_Previews: PreviewProvider {
    static var previews: some View {
        BallGameView()
    }
    
}

struct LoadingView: View{
    var body: some View{
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .red))
                .scaleEffect(3)
        }
    }
}
