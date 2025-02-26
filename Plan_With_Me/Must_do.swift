import SwiftUI

struct Must_do: View {
    
    @State private var isMenuPresented = false
    @State private var navigateToWeekPlanner = false
    @State private var navigateToHome = false
    @State private var isCreateNewRoutine = false
    @State private var backgroundColor = Color.green
    @State private var title = "New Plan"
    @State private var frequency = "Every Week"

    var body: some View {
        NavigationView {
            VStack {
                // Header with menu button and title
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
                        .padding(.top, 20)
                        .background(Color.white)
                    
                    NavigationLink(destination: CreateNewRoutine(
                        isPresented: $isCreateNewRoutine,
                        backgroundColor: backgroundColor,
                        title: title,
                        frequency: frequency
                    )) {
                        Text("Add a Routine")
                            .font(.title)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .background(Color(hue: 0.468, saturation: 0.294, brightness: 0.642))
                            .cornerRadius(10)
                            .padding(.top, 20)
                            .padding(.horizontal, 20)
                    }
                    
                    Spacer() // This will ensure that the content stays at the top
                }
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
            }
            .padding(.top, 0) // Remove any default padding at the top of the VStack
        }
    }
}

struct Must_do_Previews: PreviewProvider {
    static var previews: some View {
        Must_do()
    }
}
