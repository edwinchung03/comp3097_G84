import SwiftUI

struct Must_do: View {
    
    @State private var isMenuPresented = false
    @State private var navigateToWeekPlanner = false
    @State private var navigateToHome = false
    @State private var isCreateNewRoutine = false
    
    @FetchRequest(
        entity: Routine.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Routine.title, ascending: true)]
    ) private var routines: FetchedResults<Routine>
    
    func colorFromHex(_ hex: String?) -> Color {
        guard let hex = hex, hex.hasPrefix("#"), hex.count == 7 else {
            return Color.gray
        }
        let scanner = Scanner(string: hex)
        scanner.currentIndex = hex.index(after: hex.startIndex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        return Color(
            red: Double((rgbValue >> 16) & 0xFF) / 255.0,
            green: Double((rgbValue >> 8) & 0xFF) / 255.0,
            blue: Double(rgbValue & 0xFF) / 255.0
        )
    }
    

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: {
                        self.isMenuPresented.toggle()
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                    }
                    
                    Text("MUST-DO")
                        .font(.custom("Arial", size: 40))
                        .multilineTextAlignment(.trailing)
                        .italic()
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 10)
                        .padding(.leading, 120)
                    
                    Spacer()
                }
                .frame(height: 70)
                .background(Color(hue: 0.336, saturation: 0.33, brightness: 0.999))
                .foregroundColor(.white)

                // Menu
                if isMenuPresented {
                    VStack {
                        Button("HOME") {
                            self.navigateToHome = true
                            self.isMenuPresented = false
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hue: 0.336, saturation: 0.33, brightness: 0.999))
                        .foregroundColor(.black)
                        
                        Button("WEEK PLANNER") {
                            self.isMenuPresented = false
                            self.navigateToWeekPlanner = true
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hue: 0.336, saturation: 0.33, brightness: 0.999))
                        .foregroundColor(.black)
                        
                        Button("MUST-DO") {
                            self.isMenuPresented = false
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hue: 0.336, saturation: 0.33, brightness: 0.999))
                        .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color(hue: 0.336, saturation: 0.33, brightness: 0.999))
                    .transition(.move(edge: .leading))
                }

                // Main content, placed at the top
                VStack(alignment: .leading) {
                    Text("Plan With Me")
                        .font(.custom("Arial", size: 40))
                        .italic()
                        .fontWeight(.bold)
                        .foregroundColor(Color(hue: 0.406, saturation: 0.421, brightness: 0.966))
                        .frame(maxWidth: .infinity)
                        .edgesIgnoringSafeArea(.all)
                        .padding(.top, 40)
                        .background(Color.white)
                    
                    Button(action: {
                        self.isCreateNewRoutine = true
                    }){
                        Text("Add a Routine")
                            .font(.title)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .background(Color(hue: 0.468, saturation: 0.294, brightness: 0.642))
                            .cornerRadius(10)
                            .padding(.top, 20)
                            .padding(.horizontal, 20)
                    }
                    
                }
                .padding(.top, 10)
                
                VStack(alignment: .leading){
                    Text("Your routine")
                        .font(.headline)
                        .padding(.top, 20)
                        .padding(.leading, 130)
                    
                    List{
                        ForEach(routines, id: \.self){ routine in
                            VStack(alignment: .leading) {
                                Text(routine.title ?? "No title")
                                    .font(.headline)
                                Text(routine.frequency ?? "Every day")
                                    .font(.subheadline)
                            }
                            .padding()
                            .background(colorFromHex(routine.backgroundColor))
                            .cornerRadius(10)
                            .shadow(radius: 2)
                        }
                    }
                }
                Spacer()
                
                .background(
                    NavigationLink(destination: ContentView(), isActive: $navigateToHome) {
                            EmptyView()
                        }
                )
                .background(
                    NavigationLink(destination: WeekPlanner(), isActive: $navigateToWeekPlanner) {
                            EmptyView()
                    }
                )
                .sheet(isPresented: $isCreateNewRoutine){
                    CreateNewRoutine(isPresented: $isCreateNewRoutine, backgroundColor: Color.green, title: "")
                }
            }
            .padding(.top, 0)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct Must_do_Previews: PreviewProvider {
    static var previews: some View {
        Must_do()
    }
}
