import SwiftUI
import SpriteKit

struct GameViewController: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var scene: SKScene = GhostGameScene()
    
    @State var isLoading: Bool = false
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .frame(width: 926, height: 444)
            VStack {
                HStack {
                    Spacer()
                    VStack {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "x.circle.fill")
                                .foregroundColor(.red)
                                .font(.largeTitle)
                                .padding(40)
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
                scene = GhostGameScene()
                scene.scaleMode = .aspectFit
                scene.size = CGSize(width: 926, height: 444)
                scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
               
            }
            .onDisappear {
                AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                UIViewController.attemptRotationToDeviceOrientation()
                scene.removeAllChildren()
                scene.removeAllActions()
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
            isLoading = false
        }
    }

        
    }
    

struct GameViewController_Previews: PreviewProvider {
    static var previews: some View {
        GameViewController(scene: SKScene())
    }
}

