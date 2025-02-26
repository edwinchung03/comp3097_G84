import SwiftUI

struct ContentView: View {
    @State private var isCreateNewPlanPresented = false
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var backgroundColor = Color.green
    @State private var title = "New Plan"
    @State private var note = "This is a plan."
    @State private var isMenuPresented = false
    @State private var navigateToWeekPlanner = false

    func getCurrentDateTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: Date())
    }

    func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm:ss a"
        return formatter.string(from: Date())
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

                    Text("HOME")
                        .font(.custom("Arial", size: 40))
                        .multilineTextAlignment(.center)
                        .italic()
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 10)
                        .padding(.leading, 150)

                    Spacer()
                }
                .frame(height: 70)
                .background(Color(hue: 0.336, saturation: 0.33, brightness: 0.999))
                .foregroundColor(.white)

                if isMenuPresented {
                    VStack {
                        Button("HOME") {
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


                VStack(alignment: .leading) {
                    Text("Plan With Me")
                        .font(.custom("Arial", size: 40))
                        .italic()
                        .fontWeight(.bold)
                        .foregroundColor(Color(hue: 0.406, saturation: 0.421, brightness: 0.966))
                        .frame(maxWidth: .infinity)
                        .edgesIgnoringSafeArea(.all)
                        .padding(.top, 40.0)
                        .background(Color.white)
                    
                    Text(getCurrentDateTime())
                        .font(.custom("Arial", size: 25))
                        .italic()
                        .foregroundColor(Color(hue: 1.0, saturation: 0.221, brightness: 0.577))
                        .padding(.leading, 40)
                        .padding(.top, 20)

                    HStack {
                        Text(getCurrentTime())
                            .font(.custom("Arial", size: 25))
                            .italic()
                            .foregroundColor(Color(hue: 1.0, saturation: 0.221, brightness: 0.577))
                            .padding(.leading, 40)

                        Spacer()

                        NavigationLink(destination: CreateNewPlan(
                            isPresented: $isCreateNewPlanPresented,
                            startDate: startDate,
                            endDate: endDate,
                            backgroundColor: backgroundColor,
                            title: title,
                            note: note
                        )) {
                            Text("+")
                                .font(.title)
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(Color(hue: 0.406, saturation: 0.421, brightness: 0.966))
                                .clipShape(Circle())
                                .padding(.trailing, 40)
                        }
                    }
                    .padding(.top, 10)
                }

                Spacer()
            }
            .background(
                NavigationLink(destination: WeekPlanner(), isActive: $navigateToWeekPlanner) {
                        EmptyView()
                    }
            )
            .background(Color.white)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
