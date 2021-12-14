import SwiftUI
import SpriteKit

struct FlappyGameView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var scene: SKScene = FlappyGameScene()
    @State var isLoading: Bool = false
    
    var body: some View {
        
        ZStack {
            SpriteView(scene: scene)
                .frame(width: 444, height: 926)
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
                    .padding(.top, 50)
                }
                Spacer()
            }.onAppear{
                scene = FlappyGameScene()
                scene.scaleMode = .aspectFill
                scene.size = CGSize(width: 444, height: 926)
                scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            }
            if isLoading{
                LoadingView()
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
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

struct FlappyGameView_Previews: PreviewProvider {
    static var previews: some View {
        GameViewController(scene: SKScene())
    }
}


