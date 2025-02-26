import SwiftUI

struct WeekPlanner: View {
    
    @State private var isMenuPresented = false
    @State private var isCreateNewPlanPresented = false
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var backgroundColor = Color.green
    @State private var title = "New Plan"
    @State private var note = "This is a plan."
    @State private var isTomorrowPreviewPresented = true
    @State private var selectedButton: ButtonType = .tomorrowPreview
    @State private var navigateToHome = false
    
    enum ButtonType {
        case tomorrowPreview, weeklyTasks
    }
    
    func getTomorrowDate() -> String {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: tomorrow)
    }
    
    func getFirstAndLastDayOfNextWeek() -> (String, String) {
        let today = Date()
        let calendar = Calendar.current
        
        let currentWeekday = calendar.component(.weekday, from: today)
        let daysToNextMonday = (8 - currentWeekday) % 7
        let firstDayOfNextWeek = calendar.date(byAdding: .day, value: daysToNextMonday, to: today)!
        let lastDayOfNextWeek = calendar.date(byAdding: .day, value: 6, to: firstDayOfNextWeek)!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        
        let firstDateStr = formatter.string(from: firstDayOfNextWeek)
        let lastDateStr = formatter.string(from: lastDayOfNextWeek)
        
        return (firstDateStr, lastDateStr)
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
                    
                    Text("WEEK PLANNER")
                        .font(.custom("Arial", size: 30))
                        .multilineTextAlignment(.center)
                        .italic()
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 10)
                        .padding(.leading, 60)
                    
                    Spacer()
                }
                .frame(height: 70)
                .background(Color(hue: 0.336, saturation: 0.33, brightness: 0.999))
                .foregroundColor(.white)
                
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
                    
                    HStack {
                        // Tomorrow Preview Button
                        Button(action: {
                            self.selectedButton = .tomorrowPreview
                            self.isTomorrowPreviewPresented = true
                        }) {
                            Text("Tomorrow Preview")
                                .font(.custom("Arial", size: 20))
                                .foregroundColor(self.selectedButton == .tomorrowPreview ? .black : .white)
                                .frame(width: 180, height: 50)
                                .background(self.selectedButton == .tomorrowPreview ? Color.green : Color.gray)
                                .clipShape(Capsule())
                        }
                        .padding(.trailing, 10)
                        
                        // Weekly Tasks Button
                        Button(action: {
                            self.selectedButton = .weeklyTasks
                            // Switch to Weekly Tasks view
                            self.isTomorrowPreviewPresented = false // Hide tomorrow preview
                        }) {
                            Text("Weekly Tasks")
                                .font(.custom("Arial", size: 20))
                                .foregroundColor(self.selectedButton == .weeklyTasks ? .black : .white)
                                .frame(width: 180, height: 50)
                                .background(self.selectedButton == .weeklyTasks ? Color.green : Color.gray)
                                .clipShape(Capsule())
                        }
                        .padding(.leading, 10)
                    }
                    .padding(.top, 20)
                    
                    if self.selectedButton == .tomorrowPreview{
                        HStack {
                            Text(getTomorrowDate())
                                .font(.custom("Arial", size: 25))
                                .italic()
                                .foregroundColor(Color(hue: 1.0, saturation: 0.221, brightness: 0.577))
                                .padding(.top, 20)
                                .padding(.leading, 15)
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
                                        .padding(.leading, 50)
                                    }
                                        .padding(.top, 20)
                                }
                            .padding(.top, 10)
                    }
                    
                    if self.selectedButton == .weeklyTasks {
                        HStack {
                            let (firstDay, lastDay) = getFirstAndLastDayOfNextWeek()
                            VStack(alignment: .leading) {
                                Text("From \(firstDay)")
                                    .font(.custom("Arial", size: 20))
                                    .foregroundColor(Color(hue: 1.0, saturation: 0.221, brightness: 0.577))
                                
                                Text("To \(lastDay)")
                                    .font(.custom("Arial", size: 20))
                                    .foregroundColor(Color(hue: 1.0, saturation: 0.221, brightness: 0.577))
                            }
                            .padding(.leading, 40)
                            
                            Spacer()
                            
                            NavigationLink(destination: CreateNewWeekPlan(
                                isPresented: $isCreateNewPlanPresented,
                                startDate: startDate,
                                endDate: endDate,
                                backgroundColor: backgroundColor,
                                title: title
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
                        .padding(.top, 20)
                    }
                    
                    Spacer()
                }
                .background(
                    NavigationLink(destination: ContentView(), isActive: $navigateToHome) {
                            EmptyView()
                        }
                )
                .background(Color.white)
            }
        }
    }
}

struct WeekPlanner_Previews: PreviewProvider {
    static var previews: some View {
        WeekPlanner()
    }
}
